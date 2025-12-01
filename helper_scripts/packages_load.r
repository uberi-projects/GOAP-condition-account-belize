# packages_load.r

## Check required packages ------------------------
options(repos = c(CRAN = "https://cran.rstudio.com/"))
required_packages <- c("tidyverse", "knitr", "readxl")
install_if_missing <- function(package) {
    if (!requireNamespace(package, quietly = TRUE)) {
        install.packages(package)
    }
}
invisible(lapply(required_packages, install_if_missing))

## Attach packages ------------------------
library(tidyverse)
library(knitr)
library(readxl)
