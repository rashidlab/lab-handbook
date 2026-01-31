# =============================================================================
# Globals Loader
# =============================================================================
# Centralized configuration loading with caching and fallback defaults.
#
# Usage:
#   source("R/globals_loader.R")
#   config <- load_globals()
#   config$analysis$alpha
# =============================================================================

# Cache environment (avoids repeated file reads)
.globals_cache <- new.env(parent = emptyenv())

#' Find globals.yml path
#'
#' Searches for globals.yml in standard locations.
#'
#' @return Character path to globals.yml
find_globals_path <- function() {
  candidates <- c(
    "config/globals.yml",
    "globals.yml",
    "../config/globals.yml",
    file.path(Sys.getenv("PROJECT_ROOT", "."), "config/globals.yml")
  )

  for (path in candidates) {
    if (file.exists(path)) {
      return(normalizePath(path, winslash = "/"))
    }
  }

  warning("globals.yml not found, using hardcoded defaults")
  return(NULL)
}

#' Get hardcoded defaults
#'
#' Fallback configuration when globals.yml is missing.
#'
#' @return List with default configuration
get_hardcoded_defaults <- function() {
  list(
    project = list(
      name = "UNKNOWN",
      version = "0.0.0",
      seed = 2024
    ),
    analysis = list(
      alpha = 0.05,
      n_bootstrap = 1000,
      max_iter = 2000,
      tolerance = 1e-6
    ),
    simulation = list(
      n_reps_low = 500,
      n_reps_med = 2000,
      n_reps_high = 10000
    ),
    bo = list(
      n_init = 40,
      n_iter = 80,
      budget_total = 120
    ),
    computing = list(
      local = list(workers = 4, memory_gb = 16),
      slurm = list(partition = "general", workers = 20)
    ),
    diagnostics = list(
      thresholds = list(
        boundary_rate_max = 0.30,
        validation_rate_min = 0.50,
        feasibility_rate_min = 0.30,
        convergence_improvement_min = 0.05
      )
    ),
    output = list(
      results = "results/",
      figures = "figures/",
      logs = "logs/"
    )
  )
}

#' Load global configuration
#'
#' Loads configuration from globals.yml with caching.
#'
#' @param force_reload Logical, if TRUE bypasses cache
#' @param globals_path Optional explicit path to globals.yml
#'
#' @return List with configuration
#' @export
load_globals <- function(force_reload = FALSE, globals_path = NULL) {
  # Resolve path
  resolved_path <- if (is.null(globals_path)) {
    find_globals_path()
  } else {
    globals_path
  }

  # Check cache
  cache_key <- if (!is.null(resolved_path)) {
    normalizePath(resolved_path, winslash = "/", mustWork = FALSE)
  } else {
    "DEFAULTS"
  }

  if (!force_reload && exists(cache_key, envir = .globals_cache)) {
    return(get(cache_key, envir = .globals_cache))
  }

  # Load config
  config <- if (!is.null(resolved_path) && file.exists(resolved_path)) {
    message("Loading config from: ", resolved_path)
    yaml::read_yaml(resolved_path)
  } else {
    message("Using hardcoded defaults")
    get_hardcoded_defaults()
  }

  # Merge with defaults (ensures all keys exist)
  defaults <- get_hardcoded_defaults()
  config <- merge_config(defaults, config)

  # Cache and return
  assign(cache_key, config, envir = .globals_cache)
  config
}

#' Merge configuration lists recursively
#'
#' @param base Base configuration (defaults)
#' @param override Override configuration
#' @return Merged configuration
merge_config <- function(base, override) {
  if (!is.list(base) || !is.list(override)) {
    return(override)
  }

  for (name in names(override)) {
    if (name %in% names(base) && is.list(base[[name]]) && is.list(override[[name]])) {
      base[[name]] <- merge_config(base[[name]], override[[name]])
    } else {
      base[[name]] <- override[[name]]
    }
  }

  base
}

#' Get parameter bounds
#'
#' @param config Configuration list (or NULL to load)
#' @param type Bounds type (e.g., "default", "single_arm")
#' @return List of bounds
get_bounds <- function(config = NULL, type = "default") {
  if (is.null(config)) config <- load_globals()

  bounds <- config$bounds[[type]]
  if (is.null(bounds)) {
    warning("Bounds type '", type, "' not found, using default")
    bounds <- config$bounds$default
  }

  bounds
}

#' Get constraints
#'
#' @param config Configuration list (or NULL to load)
#' @return List of constraints
get_constraints <- function(config = NULL) {
  if (is.null(config)) config <- load_globals()
  config$constraints
}

#' Get computing settings
#'
#' @param config Configuration list (or NULL to load)
#' @param mode "local" or "slurm"
#' @return List of computing settings
get_computing <- function(config = NULL, mode = "local") {
  if (is.null(config)) config <- load_globals()
  config$computing[[mode]]
}

#' Clear configuration cache
#'
#' Forces next load_globals() to re-read from file.
#' @export
clear_globals_cache <- function() {
  rm(list = ls(envir = .globals_cache), envir = .globals_cache)
  message("Globals cache cleared")
}
