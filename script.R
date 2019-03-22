
get_period <- function(start_period, end_period, frequency) {
  # returns vector of all periods that can be inserted into api link
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
save_report <- function(clean_report, report_name, period) {
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
    save_report(clean_report, report_name, period)
  }
}