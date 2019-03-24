# refer to scripts in folder 'api_based_scripts...' to
# build each of the below functions based on frequency of report

load_packages <- function() {
  library(googlesheets)
  library(readr)
  library(dplyr)
  library(lubridate)
  library(stringr)
}
suppressPackageStartupMessages(load_packages())

# download report details using googlesheets via OAuth authentication
gs_auth()
ss <- gs_title("Reports identified for back-up")
report_details <- gs_read(ss, ws = "report_details")
# in case above command fails 
# becuase someone has changed the name of the sheet
# use the below back-up commands which works with document key
# ss_backup <- gs_key("1lAfyijkUGc_cvC01VhgMHTwsOxWMQyoavujcHi27SXE")
# report_details <- gs_read(ss_backup, ws = "report_details")

get_daily_dates <- function(start_period, end_period) {
  diff <- interval(start_period, end_period)
  diff <- as.period(diff, unit = "day")
  dates <- start_period + 0:diff$day
  dates <- gsub("-", "", dates)
  dates <- paste0("D", dates)
  return(dates)
}

get_weekly_dates <- function(start_period, end_period) {
  diff <- interval(start_period, end_period)
  diff <- as.period(diff, unit = "day")
  num_of_weeks <- diff$day%/%7
  dates <- start_period + weeks(0:num_of_weeks)
  # IBM gives incomplete weekly data if year end falls in the middle of the week
  # hence new year starts have to have their own weeks
  dates <- append(dates, c(ymd("2018-01-01"), ymd("2019-01-01")))
  dates <- gsub("-", "", dates)
  dates <- paste0("W", dates)
  return(dates)
}

get_monthly_dates <- function(start_period, end_period) {
  dates <- start_period %m+% months(0:24)
  dates <- gsub("-", "", dates)
  dates <- paste0("M", dates)
  return(dates)
}

get_period <- function(start_period, end_period, frequency) {
  # returns vector of all periods that can be inserted into api link
  
  dates <- case_when(
    frequency == "daily" ~ get_daily_dates(start_period, end_period),
    frequency == "weekly" ~ get_weekly_dates(start_period, end_period),
    frequency == "monthly" ~ get_monthly_dates(start_period, end_period)
  )
  return(dates)  
}

get_modified_api <- function(period, original_api) {
  # return api valid for that period
}
get_raw_report <- function(api_modified) {
  # return dataframe of raw downloaded report
}
get_clean_report <- fuction(raw_report, frequency, unit_of_analysis) {
  # returns clean report
  # remove totals
  # convert to date format
  # remove bounce rate integer
  # convert average time on page to seconds
  # break down top_second_category into two categories
  # add columns for
    # site url
    # site group/segment
    # report frequency (daily, weekly, monthly)
    # report unit of analysis (pageviews, unique visitors, etc.)
    # report name as per google sheet
}
save_report <- function(clean_report, report_name, unit_of_analysis, frequency, period) {
  # saves report in csv format
}

for(i in 1:nrow(report_details)) {
  report_name <- report_details$report_name[i]
  frequency <- report_details$frequency[i]
  unit_of_analysis <- report_details$unit_of_analysis[i]
  start_period <- report_details$start_period[i]
  end_period <- report_details$end_period[i]
  original_api <- report_details$original_api[i]
  
  report_periods <- get_period(start_period, end_period, frequency)
  
  for(period in report_periods){
    modified_api <- get_modified_api(period, original_api)
    raw_report <- get_raw_report(modified_api)
    clean_report <- get_clean_report(raw_report, frequency, unit_of_analysis)
    save_report(clean_report, report_name, unit_of_analysis, frequency, period)
  }
}
