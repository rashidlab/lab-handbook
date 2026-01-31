# Local Configuration Management

Switch between quick (development) and full (production) configurations without modifying tracked files.

## Quick Start

```bash
# Switch to quick mode (for development)
./local_config/setup.sh --quick

# Switch to full mode (for production)
./local_config/setup.sh --full

# Check current mode
./local_config/setup.sh --status

# Restore original configs
./local_config/setup.sh --restore
```

## How It Works

1. **Backup**: Original config files are backed up to `.config_backup/`
2. **Symlink**: Config files in project root become symlinks to mode-specific versions
3. **Track**: Current mode stored in `.current_mode`

## Directory Structure

```
local_config/
├── setup.sh              # Mode switching script
├── README.md             # This file
├── quick/                # Quick mode configs
│   └── config/
│       └── settings.yml  # Fast settings for testing
└── full/                 # Full mode configs
    └── config/
        └── settings.yml  # Production settings
```

## Adding New Config Files

1. Add the file path to `CONFIG_FILES` array in `setup.sh`:
   ```bash
   CONFIG_FILES=(
       "config/settings.yml"
       "config/my_new_config.yml"  # Add new file
   )
   ```

2. Create mode-specific versions:
   ```bash
   cp config/my_new_config.yml local_config/quick/config/
   cp config/my_new_config.yml local_config/full/config/
   # Edit each version with appropriate settings
   ```

## Quick vs Full Comparison

| Setting | Quick | Full | Rationale |
|---------|-------|------|-----------|
| `n_reps` | 100 | 10000 | Verify logic vs. publication quality |
| `bo_n_iter` | 20 | 100 | Test pipeline vs. full optimization |
| `workers` | 4 | 8 | Fast iteration vs. max throughput |
| `validation` | false | true | Skip expensive checks during dev |

## Git Integration

Add to `.gitignore`:
```
.config_backup/
.current_mode
```

The `local_config/` directory IS tracked (contains mode definitions).
Symlinked config files appear as changes but point to tracked mode files.

## Best Practices

1. **Always start in quick mode** for development
2. **Switch to full mode** only for final validation
3. **Run `--status`** before submitting jobs to verify mode
4. **Commit mode-specific changes** to the appropriate `local_config/<mode>/` directory
