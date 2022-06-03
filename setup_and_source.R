# code to grab dam data from an HTML form on the NH DES website

#load libraries
library(tidyverse)
library(httr)
library(lubridate)

#save dates
start = format(Sys.Date() - days(3),'%m/%d/%Y') #because of how NHDES stores the data, you have to get two days to get a full 24-h period, the dupes will wash out in the collation script
end = format(Sys.Date() - days(1),'%m/%d/%Y')

nhdes_web = 'https://www4.des.state.nh.us/rivertraksearch/api/Search/'

source('download.R')
source('collate_and_save.R')

