
weekly_API_key <- ""

library(dplyr)
library(readr)
# note that currently all sheets are not being dlownload for the same default period.
# the api-key has the default date built into it. see if you can change it

# each api-key has data range built as param period_a=M<last-date-of-month>
library(lubridate)
weeks_to_analyse <- ymd("20170101") + weeks(0:108) 
weeks_to_analyse <- gsub("-", "", weeks_to_analyse)
# IBM gives incomplete weekly data if year end falls in the middle of the week
# hence new year starts have to have their own weeks
weeks_to_analyse[110] <- "20180101"
weeks_to_analyse[111] <-"20190101"

get_weekly_report <- function(API_key, week) {
  # default api key is for a fixed month. needs changing to req'd month
  new_api_key <- gsub(pattern = "period_a=W\\d{8}", replacement = paste0("period_a=W", week), API_key)
  report_name <- read_csv(new_api_key)
  # add month and segment information to report to create new factors
  report_name$week <- lubridate::ymd(week)
  report_name
}

weekly_list <- lapply(weeks_to_analyse, function(week) {get_weekly_report(weekly_API_key, week = week)}) 

# convert entire list into a dataframe
weekly_df <- bind_rows(weekly_list)

# next step is to remove all rows that have Site Alias as Total
weekly_df <- weekly_df %>% 
  filter(`Site ID` != "Total")

write_csv(weekly_df, "weekly_metrics_20170101_20180127.csv")
# saveRDS(final_df, file = "df_sep17_to_aug18_session_distribution_newssites" )
# write.csv(final_df, file = "df_sep17_to_aug18_session_distribution_newssites.csv", row.names = FALSE)
