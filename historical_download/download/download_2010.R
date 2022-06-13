# this is the initial download of data to 'catch up' with files on hand. 

library(tidyverse)
library(httr)

# 'fill out' the form based on developer tools (look in Network tab, Payload for form data) ----
start = '01/01/2010'
end = '01/01/2011'
nhdes_web = 'https://www4.des.state.nh.us/rivertraksearch/api/Search/'

## for elev data ----
elev_result <- POST(
  url = nhdes_web,
  encode = 'form',
  body = list(
    stationName = "SUNAPEE LK",
    measTypeNum = "453",
    stationParameter = 'OBSERVED LAKE ELEVATION (HOUR) [FT]',
    startDate = start,
    endDate = end
  )
) 

#save result content as output file
elev_out <- content(elev_result)

#collapse the list of lists into a df
elev_out_flat = do.call(rbind, elev_out)
elev_out_flat = as.data.frame(elev_out_flat)

if(nrow(elev_out_flat) > 0){
  message('Download of lake elevation data successful.')
} else{
  message('Download of lake elevation data failed.')
}



# concatenate and save ----
dam_2010 <- elev_out_flat

#convert each column to character from a list
dam_2010 <- dam_2010 %>% 
  mutate_at(vars(all_of(colnames(dam_2010))),
            ~as.character(.))

#give new column names
names(dam_2010) <- c('data_status', 'location', 'parameter', 'date', 'value')

#format parameter name
dam_2010 <- dam_2010 %>% 
  mutate(parameter = case_when(parameter == "TEMPERATURE (HOUR) [DEGF]" ~ 'airTemperature_degF',
                               parameter == "OBSERVED LAKE ELEVATION (HOUR) [FT]" ~ 'lakeElevation_ft',
                               parameter == "OBSERVED FLOW (HOUR) [CFS]" ~ 'outflow_cfs',
                               parameter == "PRECIPITATION INCREMENT (HOUR) [IN]" ~ 'precipitation_in')) %>% 
  mutate(datetime = as.POSIXct(date, tz = 'UTC', format = '%m/%d/%Y %I:%M:%S %p')) %>% 
  select(datetime, parameter, value) %>% 
  pivot_wider(names_from = 'parameter')
         
write.csv(dam_2010, 'data/sunapee_NHDESDB_2010.csv', row.names = F)
