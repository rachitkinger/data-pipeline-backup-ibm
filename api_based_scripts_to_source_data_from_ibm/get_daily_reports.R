
daily_API_key <- "https://de.digitalanalytics.ibmcloud.com/cxa/da/explore/public/reports?clientId=50630000&username=Rachit.Kinger&userAuthKey=e852b08e-31f2-4b23-88e7-74687f4c6092&language=en_US&reportId=1359265&rType=FLAT&viewID=adhoc&period_a=D20190211&format=CSV&fileName=50630000_Daily_Top_Line_Metrics_by_most_used_dimensions_-_Newsbrands_2-12-2019-0652.csv"

library(dplyr)
library(readr)
# note that currently all sheets are not being dlownload for the same default period.
# the api-key has the default date built into it. see if you can change it

# each api-key has data range built as param period_a=M<last-date-of-month>
library(lubridate)
days_to_analyse <- ymd("20170101") + days(0:(365*2+41)) # till 2019-02-11
days_to_analyse <- gsub("-", "", days_to_analyse)

get_daily_report <- function(API_key, date) {
  # default api key is for a fixed month. needs changing to req'd month
  new_api_key <- gsub(pattern = "period_a=D\\d{8}", replacement = paste0("period_a=D", date), API_key)
  report_name <- read_csv(new_api_key)
  # add month and segment information to report to create new factors
  report_name$date <- lubridate::ymd(date)
  report_name
}

daily_list <- lapply(days_to_analyse, function(date) {get_weekly_report(daily_API_key, date)}) 

# convert entire list into a dataframe
daily_df <- bind_rows(daily_list)

# next step is to remove all rows that have Site Alias as Total
daily_df <- daily_df %>% 
  filter(`Site ID` != "Total")

write_csv(daily_df, "daily_metrics_20170101_20180211.csv")
# saveRDS(final_df, file = "df_sep17_to_aug18_session_distribution_newssites" )
# write.csv(final_df, file = "df_sep17_to_aug18_session_distribution_newssites.csv", row.names = FALSE)