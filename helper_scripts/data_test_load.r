# data_test_load.r

## Source scripts ------------------------
source("helper_scripts/packages_load.r")

## Read test data ------------------------
df_test_sites <- read_excel("data_dummy/Dummy_data_OA_Benthic Data Template.xlsx", sheet = "Sites", na = "NA")
df_test_benthic_cover <- read_excel("data_dummy/Dummy_data_OA_Benthic Data Template.xlsx", sheet = "Benthic_Cover", na = "NA")
df_test_recruits <- read_excel("data_dummy/Dummy_data_OA_Benthic Data Template.xlsx", sheet = "Recruits", na = "NA")
df_test_invertebrates <- read_excel("data_dummy/Dummy_data_OA_Benthic Data Template.xlsx", sheet = "Invertebrates", na = "NA")
df_test_organisms <- read_excel("data_dummy/Dummy_data_OA_Benthic Data Template.xlsx", sheet = "Ref_Organism", na = "NA")
df_test_substrate <- read_excel("data_dummy/Dummy_data_OA_Benthic Data Template.xlsx", sheet = "Ref_Substrate", na = "NA")
df_test_coral_community <- read_excel("data_dummy/Dummy_data_OA_Coral Data Template.xlsx", sheet = "Coral_Community", na = "NA")
df_test_coralspp <- read_excel("data_dummy/Dummy_data_OA_Coral Data Template.xlsx", sheet = "Ref_Coral", na = "NA")
df_test_disease <- read_excel("data_dummy/Dummy_data_OA_Coral Data Template.xlsx", sheet = "Ref_Disease", na = "NA")
df_test_fish <- read_excel("data_dummy/Dummy_data_OA_Relief Data Template.xlsx", sheet = "Relief", na = "NA")

## Ensure time columns are properly formatted
df_test_benthic_cover$Time <- format(df_test_benthic_cover$Time, "%H:%M")
df_test_coral_community$Time <- format(df_test_coral_community$Time, "%H:%M")
