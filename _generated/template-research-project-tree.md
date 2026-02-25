```
my-project/
├── .gitignore
├── R/  # Analysis functions
│   └── load_lab_config.R  # Config loader helper
├── README.md
├── analysis/  # Numbered analysis scripts
├── config/
│   ├── branding.yml  # Shared branding config (symlink)
│   ├── config.yml  # Project-specific parameters
│   ├── lab.yml  # Shared lab config (symlink)
│   └── load_lab_config.R  # Shared config loader (symlink)
├── data/  # Symlink to /proj/rashidlab/ (gitignored)
│   ├── external/  # External datasets
│   ├── processed/  # Cleaned data
│   └── raw/  # Original data (never modify)
├── figures/
│   ├── exploratory/  # Working figures (not tracked)
│   └── publication/  # Final figures (tracked)
├── output/  # Analysis outputs (gitignored)
├── python/  # Python modules (if needed)
└── reports/  # Quarto documents
```
