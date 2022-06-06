# this is the initial download of data to 'catch up' with files on hand. 

library(tidyverse)
library(httr)

# 'fill out' the form based on developer tools (look in Network tab, Payload for form data) ----
start = '01/01/2019'
end = '01/01/2020'
nhdes_web = 'https://www4.des.state.nh.us/rivertraksearch/api/Search/'

## for flow data ----
flow_result <- POST(
  url = nhdes_web,
  encode = 'form',
  body = list(
    stationName = "SUNAPEE LK",
    measTypeNum = "3722",
    stationParameter = 'OBSERVED FLOW (HOUR) [CFS]',
    startDate = start,
    endDate = end
  )
)

#save result content as output file
flow_out <- content(flow_result)

#collapse the list of lists into a df
flow_out_flat = do.call(rbind, flow_out)
flow_out_flat = as.data.frame(flow_out_flat)

if(nrow(flow_out_flat) > 0){
  message('Download of flow data successful.')
} else{
  message('Download of flow data failed.')
}


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


## for precip data ----
precip_result <- POST(
  url = nhdes_web,
  encode = 'form',
  body = list(
    stationName = "SUNAPEE LK",
    measTypeNum = "2667",
    stationParameter = 'PRECIPITATION INCREMENT (HOUR) [IN]',
    startDate = start,
    endDate = end
  )
) 

#save result content as output file
precip_out <- content(precip_result)

#collapse the list of lists into a df
precip_out_flat = do.call(rbind, precip_out)
precip_out_flat = as.data.frame(precip_out_flat)

if(nrow(precip_out_flat) > 0){
  message('Download of precipitation data successful.')
} else{
  message('Download of precipitation data failed.')
}

## for air temp data ----
airtemp_result <- POST(
  url = nhdes_web,
  encode = 'form',
  body = list(
    stationName = "SUNAPEE LK",
    measTypeNum = "2671",
    stationParameter = 'TEMPERATURE (HOUR) [DEGF]',
    startDate = start,
    endDate = end
  )
) 

#save result content as output file
airtemp_out <- content(airtemp_result)

#collapse the list of lists into a df
airtemp_out_flat = do.call(rbind, airtemp_out)
airtemp_out_flat = as.data.frame(airtemp_out_flat)

if(nrow(airtemp_out_flat) > 0){
  message('Download of air temperature data successful.')
} else{
  message('Download of air temperature data failed.')
}

# concatenate and save ----
dam_2019 <- full_join(airtemp_out_flat, elev_out_flat) %>% 
  full_join(., flow_out_flat) %>% 
  full_join(., precip_out_flat)

#convert each column to character from a list
dam_2019 <- dam_2019 %>% 
  mutate_at(vars(all_of(colnames(dam_2019))),
            ~as.character(.))

#give new column names
names(dam_2019) <- c('data_status', 'location', 'parameter', 'date', 'value')

#format parameter name
dam_2019 <- dam_2019 %>% 
  mutate(parameter = case_when(parameter == "TEMPERATURE (HOUR) [DEGF]" ~ 'airTemperature_degF',
                               parameter == "OBSERVED LAKE ELEVATION (HOUR) [FT]" ~ 'lakeElevation_ft',
                               parameter == "OBSERVED FLOW (HOUR) [CFS]" ~ 'outflow_cfs',
                               parameter == "PRECIPITATION INCREMENT (HOUR) [IN]" ~ 'precipitation_in')) %>% 
  mutate(datetime = as.POSIXct(date, tz = 'UTC', format = '%m/%d/%Y %I:%M:%S %p')) %>% 
  select(datetime, parameter, value) %>% 
  pivot_wider(names_from = 'parameter')
         
write.csv(dam_2019, 'data/sunapee_NHDESDB_2019.csv', row.names = F)
