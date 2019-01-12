# conda-tools

helper tools for conda environment

## conda-env-compare.pl

If you have something working in one conda environment, but not another, it helps to be able to compare the differences between installed packages in each of them. This script does the job.

This program compares 2 given conda environments (by name) and prints out 3 tables:
1. Different version numbers
2. Packages in one env but not the other
3. Packages with the same versions

All packages regardless of whether they were installed by pip or conda get accounted for via `conda list`. An indication of the source and conda/channel are provided.

It tries hard to normalize package names and version numbers, as they can vary between pip and conda package versions. Version numbers don't follow the same system, so they are compared as strings after being normalized.

Example:

```
conda-env-compare.pl good-env bad-env
```

Tested to work with conda 4.5.12

Troubleshooting: make sure:
1. you have 'conda activate YOURENVNAME' setup working
2. you can run: conda list -n YOURENVNAME
