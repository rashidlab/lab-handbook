```
my-trial/
├── .gitignore
├── R/  # Trial design functions
│   └── load_lab_config.R  # Config loader helper
├── README.md
├── _targets.R  # Trial simulation pipeline
├── calibration/  # Calibration studies
├── config/
│   ├── branding.yml  # Shared branding config (symlink)
│   ├── lab.yml  # Shared lab config (symlink)
│   └── load_lab_config.R  # Shared config loader (symlink)
├── design/  # Trial design specifications
│   ├── adaptive/  # Adaptive features
│   ├── interim/  # Interim analysis rules
│   └── priors/  # Prior specifications
├── docs/  # Project documentation
├── protocol/  # Design documentation
├── sap/  # Statistical Analysis Plan
└── simulations/
    ├── R/  # Simulation code
    ├── config/
    │   └── trial-scenarios.yml  # Trial scenario definitions
    ├── results/  # Operating characteristics (gitignored)
    └── scripts/  # Slurm job scripts
```
