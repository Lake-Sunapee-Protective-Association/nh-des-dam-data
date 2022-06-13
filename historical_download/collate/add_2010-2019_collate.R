# this script adds data back to 2010, the beginning of the online hourly record

library(tidyverse)

# read in 2010-2019
dam_2010 <- read.csv('data/Sunapee_NHDESDB_2010.csv')
dam_2011 <- read.csv('data/Sunapee_NHDESDB_2011.csv')
dam_2012 <- read.csv('data/Sunapee_NHDESDB_2012.csv')
dam_2013 <- read.csv('data/Sunapee_NHDESDB_2013.csv')
dam_2014 <- read.csv('data/Sunapee_NHDESDB_2014.csv')
dam_2015 <- read.csv('data/Sunapee_NHDESDB_2015.csv')
dam_2016 <- read.csv('data/Sunapee_NHDESDB_2016.csv')
dam_2017 <- read.csv('data/Sunapee_NHDESDB_2017.csv')
dam_2018 <- read.csv('data/Sunapee_NHDESDB_2018.csv')
dam_2019 <- read.csv('data/Sunapee_NHDESDB_2019.csv')

# collate 
dam_10_19 <- full_join(dam_2010, dam_2011) %>% 
  full_join(., dam_2012) %>% 
  full_join(., dam_2013) %>% 
  full_join(., dam_2014) %>% 
  full_join(., dam_2015) %>% 
  full_join(., dam_2016) %>% 
  full_join(., dam_2017) %>% 
  full_join(., dam_2018) %>% 
  full_join(., dam_2019) 

write.csv(dam_10_19, 'data/Sunapee_NHDESDB_historical_raw_2010-2019.csv', row.names = F)
