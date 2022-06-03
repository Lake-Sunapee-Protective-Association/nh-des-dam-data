message('Collating and formatting data.')

# format and pivot
# concatenate and save ----
dam_download <- full_join(airtemp_out_flat, elev_out_flat) %>% 
  full_join(., flow_out_flat) %>% 
  full_join(., precip_out_flat)

#convert each column to character from a list
dam_download <- dam_download %>% 
  mutate_at(vars(all_of(colnames(dam_download))),
            ~as.character(.))

#give new column names
names(dam_download) <- c('data_status', 'location', 'parameter', 'date', 'value')

#format parameter name
dam_download <- dam_download %>% 
  mutate(parameter = case_when(parameter == "TEMPERATURE (HOUR) [DEGF]" ~ 'airTemperature_degF',
                               parameter == "OBSERVED LAKE ELEVATION (HOUR) [FT]" ~ 'lakeElevation_ft',
                               parameter == "OBSERVED FLOW (HOUR) [CFS]" ~ 'outflow_cfs',
                               parameter == "PRECIPITATION INCREMENT (HOUR) [IN]" ~ 'precipitation_in')) %>% 
  mutate(datetime = as.POSIXct(date, tz = 'UTC', format = '%m/%d/%Y %I:%M:%S %p')) %>% 
  select(datetime, parameter, value) %>% 
  pivot_wider(names_from = 'parameter')

# open historical file
dam_hist <- read.csv('data/Sunapee_NHDESDB_historical_raw.csv') %>% 
  mutate(datetime = as.POSIXct(datetime, tz = 'UTC')) %>% 
  mutate_at(vars(airTemperature_degF,lakeElevation_ft, outflow_cfs, precipitation_in),
            ~ as.character(.))

# join files; eliminate dupes
dam_hist_add <- full_join(dam_hist, dam_download)

dam_hist_add <- dam_hist_add[!duplicated(dam_hist_add),] %>% 
  arrange(datetime)

# write new .csv
message('Saving updated file.')
write.csv(dam_hist_add, 'data/Sunapee_NHDESDB_historical_raw.csv', row.names = F)
