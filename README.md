# conda-tools

helper tools for conda environment

See also [other tools in my toolbox](https://github.com/stas00/toolbox).

## conda-env-compare.pl

If you have something working in one conda environment, but not another, it helps to be able to compare the differences between installed packages in each of them. This script does the job.

This program compares 2 given conda environments (by name) and prints out 3 tables:
1. Packages with different version numbers
2. Packages in one env but not the other
3. Packages with the same versions

All packages regardless of whether they were installed by pip or conda get accounted for via `conda list`. An indication of the source and conda/channel are provided.

It tries hard to normalize package names and version numbers, as they can vary between pip and conda package versions. Version numbers don't follow the same system, so they are compared as strings after being normalized.

Example:

```
conda-env-compare.pl work25 work36
```
Output, truncated for brevity:
```
Comparing installed packages in environments: work27 and work36


********************************************** Match: Differ **********************************************
                       environment       work27       work36                  work27                  work36
                      package name      version      version                  source                  source
------------------------------------------------------------------------------------------------------------
                         ipykernel       4.10.0        5.1.0         py27_0/anaconda py36h39e3cac_0/anaconda
                            python       2.7.15        3.6.8     h9bab390_6/anaconda     h0371630_0/anaconda


********************************************** Match: Missing **********************************************
                       environment       work27       work36                  work27                  work36
                      package name      version      version                  source                  source
------------------------------------------------------------------------------------------------------------
                         backports          1.0                      py27_1/anaconda                        
                     backports-abc          0.5                      py27_0/anaconda                        
backports.shutil-get-terminal-size        1.0.0                      py27_2/anaconda                        
[...]

*********************************************** Match: Same ***********************************************
                       environment       work27       work36                  work27                  work36
                      package name      version      version                  source                  source
------------------------------------------------------------------------------------------------------------
                            bleach        3.1.0        3.1.0         py27_0/anaconda         py36_0/anaconda
                   ca-certificates     2018.3.7     2018.3.7              0/anaconda              0/anaconda
                           certifi   2018.11.29   2018.11.29         py27_0/anaconda         py36_0/anaconda
                         decorator        4.3.0        4.3.0         py27_0/anaconda         py36_0/anaconda
                       entrypoints        0.2.3        0.2.3         py27_2/anaconda         py36_2/anaconda
[...]
                              zlib       1.2.11       1.2.11     h7b6447c_3/anaconda     h7b6447c_3/anaconda
```

Tested to work with conda 4.5.12

Troubleshooting: make sure:
1. you have `conda activate YOURENVNAME` setup working
2. you can run: `conda list -n YOURENVNAME`
