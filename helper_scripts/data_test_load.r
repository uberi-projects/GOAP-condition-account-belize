# data_test_load.r

## Source scripts ------------------------
source("helper_scripts/packages_load.r")

## Read test data ------------------------
df_test_sites <- read_excel("data_dummy/Dummy data_OA_Benthic Data Template.xlsx", sheet = 5, nas = "NA")
df_test_benthic_cover <- read_excel("data_dummy/Dummy data_OA_Benthic Data Template.xlsx", sheet = 6, nas = "NA")
df_test_recruits <- read_excel("data_dummy/Dummy data_OA_Benthic Data Template.xlsx", sheet = 7,  nas = "NA")
df_test_invertebrates <- read_excel("data_dummy/Dummy data_OA_Benthic Data Template.xlsx", sheet = 8,  nas = "NA")
df_test_organisms <- read_excel("data_dummy/Dummy data_OA_Benthic Data Template.xlsx", sheet = 3,  nas = "NA")