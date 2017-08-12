# An rstan model for groups of related contingency tables

A multilevel binomial--beta model for groups of contingency tables implemented in rstan.


## Warning

Please note that the package is in 1) in development; and 2) mostly written for specific project (if it even works). Obviously, since it's puslished here and licensed under the GPL, you are free to use it as you please, but it is not really recommended (at this time).


## Installation

This package uses the method of rstanarm and the rstantools package to pre-build the stan
model on installation so that it won't need compiling every time the package loads.

According to my limited testing, one should be able to install the package
from R by running the following. Check DESCRIPTION to see the required
packages and versions.

```
devtools::install_github("mrtnj/multilevelcontingency", args = "--preclean")
```

*NOTE:* This involves running both bash and C++ code downloaded from this
repo. Do not do this with unknown code unless you know that it's not
malicious.
