message('Downloading data from NH DES Dam Bureau from ', start, ' through ', end)

# 'fill out' the form based on developer tools (look in Network tab, Payload for form data) ----

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

