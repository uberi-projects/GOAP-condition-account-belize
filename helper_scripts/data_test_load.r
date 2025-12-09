# data_test_load.r

## Source scripts ------------------------
source("helper_scripts/packages_load.r")

## Read test data ------------------------
df_test_sites <- read_excel("data_dummy/Dummy_data_OA_Benthic Data Template.xlsx", sheet = 5, na = "NA")
df_test_benthic_cover <- read_excel("data_dummy/Dummy_data_OA_Benthic Data Template.xlsx", sheet = 6, na = "NA")
df_test_recruits <- read_excel("data_dummy/Dummy_data_OA_Benthic Data Template.xlsx", sheet = 7, na = "NA")
df_test_invertebrates <- read_excel("data_dummy/Dummy_data_OA_Benthic Data Template.xlsx", sheet = 8, na = "NA")
df_test_organisms <- read_excel("data_dummy/Dummy_data_OA_Benthic Data Template.xlsx", sheet = 3, na = "NA")
df_test_substrate <- read_excel("data_dummy/Dummy_data_OA_Benthic Data Template.xlsx", sheet = 2, na = "NA")
df_test_coral_community <- read_excel("data_dummy/Dummy_data_OA_Coral Data Template.xlsx", sheet = 6, na = "NA")
df_test_fish <- read_excel("data_dummy/Dummy_data_OA_Relief Data Template.xlsx", sheet = 3, na = "NA")
