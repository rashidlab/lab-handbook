```
my-paper/
├── .gitignore
├── R/  # Analysis/method functions
│   └── load_lab_config.R  # Config loader helper
├── README.md
├── _targets.R  # Pipeline with dynamic branching
├── code/  # Standalone scripts
├── config/
│   ├── branding.yml  # Shared branding config (symlink)
│   ├── lab.yml  # Shared lab config (symlink)
│   ├── load_lab_config.R  # Shared config loader (symlink)
│   └── settings.yml  # Simulation & figure parameters
├── docs/  # Project documentation
├── paper/
│   ├── figures/  # Publication figures
│   └── sections/  # Manuscript sections
├── reviews/  # Reviewer responses by round
│   └── round-1/
└── simulations/
    ├── R/  # Simulation-specific R code
    ├── config/
    │   └── scenarios.yml  # Simulation scenario definitions
    ├── results/  # Raw simulation results (gitignored)
    └── scripts/  # Slurm job scripts
```
