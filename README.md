# Belize Coral Condition Account - GOAP  <img src='www/images/UBERI_GOAP_logo.png' align="right" height="50" style="margin-top:25px;" />

The purpose of this repository is to store the associated code for the Global Ocean Accounts Partnership in Belize for the coral condition account.

## Repository Contents

This repository includes three primary scripts, each of which feeds into the following:

1. **data_restructuring.r** - ![status](https://img.shields.io/badge/status-not%20implemented-blue) - restructures data directly exported from AGRRA into the template used by GOAP. This script is automatically run when validating data or calculating indicators in this repository.

2. **data_validation.r** - ![status](https://img.shields.io/badge/status-not%20implemented-blue) - validates restructured AGRRA data for use in the GOAP project.

3. **indicator_calculation.r** -  ![status](https://img.shields.io/badge/status-not%20implemented-blue) - calculates GOAP condition account indicator values for Belize from validated and restructured AGRRA data.


In addition, there are helper R scripts, found in the helper_scripts folder:

1. **packages_load.r** - installs missing packages and loads required packages for the primary scripts.

2. **functions_define.r** - defines custom functions used in the primary scripts.

## Using the Repository

To use the repository, first you will need AGRRA data. Deposit an export of a Belize AGRRA unsummarized dataset into the data_deposit folder. If you  desire a restructured dataset, run data_restructuring.r. If you desire a validation report of the dataset, run data_validation.r. If you desire indicator calculation, run indicator_calculation.r.

<img src='www/images/GOAP_value.png' height="600" />