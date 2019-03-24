## Backing up IBM DA data   

IBM DA contract expires on 31-03-2019. This project downloads required data for business continuity purposes.  

Note that this does not backup all the raw data. It backs up all required reports for the time period for which they are available (Jan-2017 to Mar-2019). These are reports that include top line metrics like pageviews, unique visitors, etc which can be broken down my dimensions that we tend to use most often at JPIMedia. These reports are daily, weekly and monthly reports.  

To look at all the reports that are actually downloaded by this script visit [this Google Sheet](https://docs.google.com/spreadsheets/d/1lAfyijkUGc_cvC01VhgMHTwsOxWMQyoavujcHi27SXE/edit?usp=sharing) (owner of sheet: Ben Haynes ben.haynes@jpimedia.co.uk).  

The script was run on a Google VM instance using the R version 3.5.3. with the following required packages:  

1. readr  
2. dplyr  
3. lubridate  
4. stringr  
5. googlesheets

The data was downloaded onto a Google Cloud Storage bucket gs://ibm_da_backup  

Each report was downloaded as a csv file.  



