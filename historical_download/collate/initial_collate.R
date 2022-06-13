# this is the script that collates all existing files

# read in old files

# read in 2020-e2022
dam_2020 <- read.csv('data/Sunapee_NHDESDB_2020.csv')
dam_2021 <- read.csv('data/Sunapee_NHDESDB_2021.csv')
dam_e2022 <- read.csv('data/Sunapee_NHDESDB_e2022.csv')

#get last date for first run of action
lastday = as.Date(format(as.POSIXct(last(dam_e2022$datetime), tz = 'UTC'), '%Y-%m-%d'))
dam_e2022 <- dam_e2022 %>% 
  mutate(datetime = as.POSIXct(datetime, tz = 'UTC')) %>% 
  filter(datetime <= as.POSIXct(paste(lastday, '00:00', sep = ' '), tz = 'UTC')) %>% 
  mutate(datetime = as.character(datetime))

# collate 

dam_20_22 <- full_join(dam_2020, dam_2021) %>% 
  full_join(., dam_e2022)

write.csv(dam_20_22, 'data/Sunapee_NHDESDB_historical_raw.csv', row.names = F)
