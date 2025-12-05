# data_test_load.r

## Source scripts ------------------------
source("helper_scripts/packages_load.r")

## Read test data ------------------------
df_test_sites <- read_excel("data_dummy/Dummy data_OA_Benthic Data Template.xlsx", sheet = 5)
df_test_benthic_cover <- read_excel("data_dummy/Dummy data_OA_Benthic Data Template.xlsx", sheet = 6)
df_test_recruits <- read_excel("data_dummy/Dummy data_OA_Benthic Data Template.xlsx", sheet = 7)
df_test_invertebrates <- read_excel("data_dummy/Dummy data_OA_Benthic Data Template.xlsx", sheet = 8)
