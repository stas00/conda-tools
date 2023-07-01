# conda-tools

helper tools for conda environment

- [conda cheat-sheet](./conda.txt) - various solutions to conda usage

## conda-env-compare.pl

If you have something working in one conda environment, but not the other, it helps to be able to compare the differences between installed packages in each of them. This script does the job.

This program compares 2 given conda environments (by name) and prints out 3 tables:
1. Packages with different version numbers
2. Packages in one env but not the other
3. Packages with the same versions

All packages, regardless of whether they were installed by pip or conda, get accounted for via `conda list`. An indication of the source and conda/channel are provided.

The program tries hard to normalize package names and version numbers, as they can vary between pip and conda package versions. Version numbers don't follow the same system, so they are compared as strings after being normalized.

Example:

```
./conda-env-compare.pl py38-pt113 py38-pt20
```

Output, truncated for brevity:
```
Comparing installed packages in environments: py38-pt113 and py38-pt20

**************************** Match: Differ *********************************************
 environment    py38-pt113     py38-pt20              py38-pt113               py38-pt20
package name       version       version                  source                  source
----------------------------------------------------------------------------------------
certificates     2022.12.7     2023.1.10  ha878542_0/conda-forge     h06a4308_0/anaconda
     certifi     2020.11.8     2022.12.7             pypi_0/pypi py38h06a4308_0/anaconda
       [...]
    networkx         2.8.8        3.0rc1             pypi_0/pypi             pypi_0/pypi
       wheel        0.37.1        0.38.4   pyhd3eb1b0_0/anaconda py38h06a4308_0/anaconda
          xz         5.2.8        5.2.10     h5eee18b_0/anaconda     h5eee18b_1/anaconda


*************************** Match: Missing *********************************************
 environment    py38-pt113     py38-pt20              py38-pt113               py38-pt20
package name       version       version                  source                  source
----------------------------------------------------------------------------------------
     absl-py         1.3.0                           pypi_0/pypi
  accelerate   0.17.0.dev0                           pypi_0/pypi
      addict         2.4.0                           pypi_0/pypi
       [...]
        zipp        3.11.0                           pypi_0/pypi
   zstandard        0.19.0                           pypi_0/pypi
        zstd         1.5.2                   ha4553b6_0/anaconda


***************************** Match: Same **********************************************
 environment    py38-pt113     py38-pt20              py38-pt113               py38-pt20
package name       version       version                  source                  source
----------------------------------------------------------------------------------------
libgcc-mutex           0.1           0.1           main/anaconda           main/anaconda
openmp-mutex           5.1           5.1          1_gnu/anaconda          1_gnu/anaconda
       [...]
        zlib        1.2.13        1.2.13     h5eee18b_0/anaconda     h5eee18b_0/anaconda

```

Tested to work with conda 4.11.0

### Troubleshooting

Make sure:
1. you have `conda activate YOURENVNAME` setup working
2. you can run: `conda list -n YOURENVNAME`
