#!/usr/bin/env Rscript
# =============================================================================
# Consistency Validation Script
# =============================================================================
# Validates that manuscript claims match code and configuration.
#
# Usage:
#   Rscript scripts/validate_consistency.R [--quick|--full] [--fix]
#
# Options:
#   --quick   Only check config values (fast, ~2 seconds)
#   --full    Check all categories (thorough, ~10-30 seconds)
#   --fix     Attempt to auto-fix simple mismatches (experimental)
#   --report  Generate HTML report of all checks
#
# Exit codes:
#   0 = All checks passed
#   1 = Validation errors found
#   2 = Registry file not found or malformed
# =============================================================================

suppressPackageStartupMessages({
  library(yaml)
  library(stringr)
  library(purrr)
  library(cli)
})

# =============================================================================
# Configuration
# =============================================================================

REGISTRY_PATH <- "config/consistency_registry.yml"
VERBOSE <- TRUE

args <- commandArgs(trailingOnly = TRUE)
MODE <- if ("--quick" %in% args) "quick" else "full"
FIX_MODE <- "--fix" %in% args
REPORT_MODE <- "--report" %in% args

# =============================================================================
# Helper Functions
# =============================================================================

#' Read nested YAML value by path
#' @param data Parsed YAML list
#' @param path Dot-separated path (e.g., "diagnostics.thresholds.alpha")
read_yaml_path <- function(data, path) {
  parts <- str_split(path, "\\.")[[1]]
  result <- data
  for (part in parts) {
    if (is.null(result[[part]])) {
      return(NULL)
    }
    result <- result[[part]]
  }
  result
}

#' Apply transform expression to value
#' @param value Numeric value
#' @param transform Character expression (e.g., "x * 100")
apply_transform <- function(value, transform = NULL) {
  if (is.null(transform) || transform == "") {
    return(value)
  }
  x <- value
  eval(parse(text = transform))
}

#' Extract value from file using regex pattern
#' @param file_path Path to file
#' @param pattern Regex pattern with capture group
extract_from_file <- function(file_path, pattern) {
  if (!file.exists(file_path)) {
    return(list(found = FALSE, error = paste("File not found:", file_path)))
  }

  content <- readLines(file_path, warn = FALSE) %>% paste(collapse = "\n")
  matches <- str_match_all(content, pattern)[[1]]

  if (nrow(matches) == 0) {
    return(list(found = FALSE, error = "Pattern not found in file"))
  }

  # Return first capture group
  list(
    found = TRUE,
    value = matches[1, 2],
    all_matches = matches[, 2],
    n_matches = nrow(matches)
  )
}

#' Extract function default parameter value
#' @param file_path Path to R file
#' @param func_name Function name
#' @param param_name Parameter name
extract_function_default <- function(file_path, func_name, param_name) {
  if (!file.exists(file_path)) {
    return(list(found = FALSE, error = paste("File not found:", file_path)))
  }

  content <- readLines(file_path, warn = FALSE) %>% paste(collapse = "\n")

  # Pattern to match function definition and extract default

# This is a simplified pattern - may need adjustment for complex cases
  pattern <- sprintf(
    '%s\\s*<-\\s*function\\s*\\([^)]*%s\\s*=\\s*([^,\\)]+)',
    func_name, param_name
  )

  matches <- str_match(content, pattern)

  if (is.na(matches[1])) {
    return(list(found = FALSE, error = "Function or parameter not found"))
  }

  default_val <- str_trim(matches[2])

  # Try to evaluate if it's a simple numeric
  numeric_val <- tryCatch(
    eval(parse(text = default_val)),
    error = function(e) default_val
  )

  list(found = TRUE, value = numeric_val, raw = default_val)
}

# =============================================================================
# Validation Functions
# =============================================================================

#' Validate config value claims
validate_config_values <- function(claims, errors) {
  if (length(claims) == 0 || (length(claims) == 1 && length(claims[[1]]) == 0)) {
    cli_alert_info("No config value claims defined")
    return(errors)
  }

  for (claim in claims) {
    cli_h3(claim$id)

    # Get authoritative value from source
    source_file <- claim$source$file
    if (!file.exists(source_file)) {
      errors <- c(errors, sprintf("[%s] Source file not found: %s", claim$id, source_file))
      cli_alert_danger("Source file not found: {source_file}")
      next
    }

    source_data <- read_yaml(source_file)
    source_value <- read_yaml_path(source_data, claim$source$path)

    if (is.null(source_value)) {
      errors <- c(errors, sprintf("[%s] Path not found in %s: %s",
                                   claim$id, source_file, claim$source$path))
      cli_alert_danger("Path not found: {claim$source$path}")
      next
    }

    transformed_value <- apply_transform(source_value, claim$source$transform)
    cli_alert_info("Source value: {source_value} (transformed: {transformed_value})")

    # Check each manuscript location
    for (loc in claim$manuscript_locations) {
      result <- extract_from_file(loc$file, loc$pattern)

      if (!result$found) {
        cli_alert_warning("{loc$file}: Pattern not found")
        next
      }

      manuscript_value <- as.numeric(result$value)

      if (is.na(manuscript_value)) {
        cli_alert_warning("{loc$file}: Could not parse '{result$value}' as number
")
        next
      }

      if (abs(manuscript_value - transformed_value) > 0.001) {
        errors <- c(errors, sprintf(
          "[%s] MISMATCH in %s: manuscript says %s, config says %s",
          claim$id, loc$file, manuscript_value, transformed_value
        ))
        cli_alert_danger("{loc$file}: {manuscript_value} != {transformed_value}")
      } else {
        cli_alert_success("{loc$file}: {manuscript_value} matches")
      }
    }

    # Check code defaults if specified
    if (!is.null(claim$code_defaults)) {
      for (code_def in claim$code_defaults) {
        result <- extract_function_default(
          code_def$file,
          code_def$function,
          code_def$param
        )

        if (!result$found) {
          cli_alert_warning("Could not extract default from {code_def$file}::{code_def$function}")
          next
        }

        code_value <- apply_transform(result$value, code_def$transform %||% claim$source$transform)

        if (abs(code_value - transformed_value) > 0.001) {
          errors <- c(errors, sprintf(
            "[%s] Code default mismatch: %s::%s = %s, config = %s",
            claim$id, code_def$file, code_def$function, code_value, transformed_value
          ))
          cli_alert_danger("Code default: {code_value} != {transformed_value}")
        } else {
          cli_alert_success("Code default: {code_value} matches")
        }
      }
    }
  }

  errors
}

#' Validate method claims
validate_method_claims <- function(claims, errors) {
  if (length(claims) == 0 || (length(claims) == 1 && length(claims[[1]]) == 0)) {
    cli_alert_info("No method claims defined")
    return(errors)
  }

  for (claim in claims) {
    cli_h3(claim$id)

    # Check manuscript locations
    for (loc in claim$manuscript_locations) {
      result <- extract_from_file(loc$file, loc$pattern)

      if (!result$found) {
        cli_alert_warning("{loc$file}: Method pattern not found")
        next
      }

      found_method <- result$value

      if (!is.null(loc$expected)) {
        if (!str_detect(found_method, fixed(loc$expected, ignore_case = TRUE))) {
          errors <- c(errors, sprintf(
            "[%s] Method mismatch in %s: found '%s', expected '%s'",
            claim$id, loc$file, found_method, loc$expected
          ))
          cli_alert_danger("{loc$file}: '{found_method}' != expected '{loc$expected}'")
        } else {
          cli_alert_success("{loc$file}: Found expected method '{found_method}'")
        }
      } else {
        cli_alert_info("{loc$file}: Found method '{found_method}'")
      }
    }

    # Verify in code
    if (!is.null(claim$verification)) {
      v <- claim$verification

      if (v$type == "code_grep") {
        if (!file.exists(v$file)) {
          cli_alert_warning("Verification file not found: {v$file}")
          next
        }

        content <- readLines(v$file, warn = FALSE) %>% paste(collapse = "\n")

        if (str_detect(content, v$pattern)) {
          cli_alert_success("Code verification: pattern found in {v$file}")
        } else {
          errors <- c(errors, sprintf(
            "[%s] Code verification failed: pattern '%s' not found in %s",
            claim$id, v$pattern, v$file
          ))
          cli_alert_danger("Pattern not found in code: {v$pattern}")
        }
      }
    }
  }

  errors
}

#' Validate results provenance
validate_provenance <- function(claims, errors) {
  if (length(claims) == 0 || (length(claims) == 1 && length(claims[[1]]) == 0)) {
    cli_alert_info("No provenance claims defined")
    return(errors)
  }

  for (claim in claims) {
    cli_h3(claim$id)

    # Check data file exists
    data_file <- claim$data_source$file
    if (!file.exists(data_file)) {
      errors <- c(errors, sprintf("[%s] Data file not found: %s", claim$id, data_file))
      cli_alert_danger("Data file not found: {data_file}")
      next
    }

    cli_alert_success("Data file exists: {data_file}")

    # Check required columns
    if (!is.null(claim$data_source$required_columns)) {
      # Try to read just the header
      header <- tryCatch({
        if (str_detect(data_file, "\\.csv$")) {
          names(read.csv(data_file, nrows = 1))
        } else if (str_detect(data_file, "\\.rds$")) {
          names(readRDS(data_file))
        } else {
          NULL
        }
      }, error = function(e) NULL)

      if (!is.null(header)) {
        required <- claim$data_source$required_columns
        missing <- setdiff(required, header)

        if (length(missing) > 0) {
          errors <- c(errors, sprintf(
            "[%s] Missing columns in %s: %s",
            claim$id, data_file, paste(missing, collapse = ", ")
          ))
          cli_alert_danger("Missing columns: {paste(missing, collapse = ', ')}")
        } else {
          cli_alert_success("All required columns present")
        }
      }
    }

    # Check generation script exists
    if (!is.null(claim$generation_script)) {
      if (!file.exists(claim$generation_script)) {
        cli_alert_warning("Generation script not found: {claim$generation_script}")
      } else {
        cli_alert_success("Generation script exists: {claim$generation_script}")
      }
    }
  }

  errors
}

# =============================================================================
# Main Execution
# =============================================================================

main <- function() {
  cli_h1("Consistency Validation")
  cli_alert_info("Mode: {MODE}")
  cli_alert_info("Registry: {REGISTRY_PATH}")
  cat("\n")

  # Load registry
  if (!file.exists(REGISTRY_PATH)) {
    cli_alert_danger("Registry file not found: {REGISTRY_PATH}")
    cli_alert_info("Create one from the template in lab-handbook/project-consistency/templates/")
    quit(status = 2)
  }

  registry <- tryCatch(
    read_yaml(REGISTRY_PATH),
    error = function(e) {
      cli_alert_danger("Failed to parse registry: {e$message}")
      quit(status = 2)
    }
  )

  errors <- character(0)

  # Config values (always run)
  cli_h2("Config Values")
  errors <- validate_config_values(registry$config_values, errors)

  # Method claims (full mode only)
  if (MODE == "full") {
    cat("\n")
    cli_h2("Method Claims")
    errors <- validate_method_claims(registry$method_claims, errors)

    cat("\n")
    cli_h2("Results Provenance")
    errors <- validate_provenance(registry$results_provenance, errors)
  }

  # Summary
  cat("\n")
  cli_h1("Summary")

  if (length(errors) == 0) {
    cli_alert_success("All consistency checks passed!")
    quit(status = 0)
  } else {
    cli_alert_danger("{length(errors)} consistency error(s) found:")
    cat("\n")
    for (err in errors) {
      cli_alert_danger(err)
    }
    quit(status = 1)
  }
}

# Run if executed directly
if (!interactive()) {
  main()
}
