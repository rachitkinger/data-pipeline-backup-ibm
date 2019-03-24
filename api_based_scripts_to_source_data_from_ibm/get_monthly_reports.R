library(dplyr)
library(readr)
monthly_API_key <- "https://de.digitalanalytics.ibmcloud.com/cxa/da/explore/public/reports?clientId=50630000&username=Rachit.Kinger&userAuthKey=e852b08e-31f2-4b23-88e7-74687f4c6092&language=en_US&reportId=1359167&rType=FLAT&viewID=adhoc&period_a=M20170101&format=CSV&fileName=50630000_Monthly-_Top_Line_Metrics_by_most_used_dimensions_-_Newsbrands_2-12-2019-0620.csv"
# note that currently all sheets are not being dlownload for the same default period.
# the api-key has the default date built into it. see if you can change it

# each api-key has data range built as param period_a=M<last-date-of-month>
library(lubridate)
months_to_analyse <- ymd("20170101") %m+% months(0:24) 
months_to_analyse <- gsub("-", "", months_to_analyse)



get_monthly_report <- function(API_key, month) {
  # default api key is for a fixed month. needs changing to req'd month
  new_api_key <- gsub(pattern = "period_a=M\\d{8}", replacement = paste0("period_a=M", month), API_key)
  report_name <- read_csv(new_api_key)
  # add month and segment information to report to create new factors
  report_name$month <- lubridate::ymd(month)
  report_name
}

monthly_list <- lapply(months_to_analyse, function(month) {get_monthly_report(monthly_API_key, month = month)}) 

# convert entire list into a dataframe
monthly_df <- bind_rows(monthly_list)

# next step is to remove all rows that have Site Alias as Total
monthly_df <- monthly_df %>% 
  filter(`Site ID` != "Total")

write_csv(monthly_df, "monthly_metrics_20170101_20180101.csv")
# saveRDS(final_df, file = "df_sep17_to_aug18_session_distribution_newssites" )
# write.csv(final_df, file = "df_sep17_to_aug18_session_distribution_newssites.csv", row.names = FALSE)
