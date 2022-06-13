# nh-des-dam-data

This repository employs GitHub Actions to automatically submit the HTML form and retrieve lake level data from the NH DES Dam Bureau data for Lake Sunapee on a daily basis. The GH Action runs daily and is on a one day time lag. The script also collates data with the historical record back to Jan 2020. All data are considered preliminary, per the NHDES website. Additionally, there is a data file containing historical data in the same format from April 2010-Decemeber 2019. 

The repository is managed by B. Steele (steeleb@caryinstitute.org). 

Data attribution:
NH Department of Environmental Services, Dam Bureau. See notes below regarding data. 

## Scripts

### GH Actions Workflow

GH Actions runs the 'setup_and_source.R' script, which sources the 'download.R' and 'collate_and_save.R' scripts, in that order. Downloaded data are concatenated into the file 'Sunapee_NHDESDB_historical_raw.csv' which is stored in the data folder. 

### Previous Data Download and Processing

Data from January 2020 through June 2022 were downloaded and processed in the scripts 'download_2020.R', 'download_2021.R', and 'download_e2022.R', these scripts are located in the folder 'historical_download/download'. The initial collation of these files was completed in the script 'collate/initial_collation.R'

Data from April 2010 through December 2019 were downloaded and processed in the scripts 'download_YYYY.R', where YYYY is the year of data downloaded. These files were collated to create the file 'Sunapee_NHDESDB_historical_raw_2010-2019.csv'. Note that flow data, precipitation, and air temperature only go back to 2016. 

Daily average lake level data from late December 1982 through December 2010 were harmonized in the script 'harmonize/early_record_harmonize.R'. The lake level data is realtively consistent, but the outflow data are quite spotty from the late '90s. Lake elevation was calculated from the reported lake depth at the dam, per the metadata in the original file from the NH DES Dam Bureau. Note these are purported to be daily averages and no metadata is available on processing steps by the NH DES Dam Bureau. Output file is 'data/Sunapee_NHDESDB_dailyhistorical_raw_1981-2010.csv'. 

No cross referencing has been completed in any of the 3 output files and only basic QAQC to remove obvious errors from the earliest record (1982-2010) has been completed.

## Metadata from the NH DES website
source: https://www4.des.state.nh.us/rti_home/station_information_display.asp?WID=westbasins&ID=SUNNH&NAME=Sunapee+Lake&FULLPOND=Full+Lake+=+10.50+ft.+Local+=+1093.15+ft.+above+sea+level


Sunapee Lake Dam is located at the western end of at Sunapee Harbor, approximately 1/4 mile east of the intersection of NH routes 11 and 103.

The following parameters are currently being measured at this site:

Sunapee Lake Stage (Lake Elevation)
Precipitation ** (see notes about station below)
Air Temperature ** (see notes about station below)

Summer Operations
The lake level is maintained as close to the full summer recreation level as possible, as meteorological conditions and minimum flow requirements allow. Full summer recreation level is 10.5 on the gage at Sunapee Harbor, which corresponds to an elevation of 1093.15.

Seasonal Fall Drawdown
Drawdown begins on or near Columbus Day.  The lake is drawn down 2.5 feet (elev. 1090.65) below the summer recreation level, and full drawdown is generally reached by February or March in most years. The drawdown is accomplished by opening the gates at the dam.

Spring Refill
Lake is refilled to the full summer recreation level between March and June 1st as the snowpack melts and spring rains occur.   

Note: Water levels generally fluctuate in response to precipitation, snowmelt, drought or other meteorological conditions. Target water levels are maintained by the adjustment of flows at the dam in response to these conditions.

This meteorological station is operated and maintained by the New Hampshire Department of Environmental Services (DES). Most data relayed by satellite or other telemetry have received little or no review. Inaccuracies in the data may be present because of instrument malfunctions or physical changes at the measurement site, including backwater effects due to ice formation. Although the data presented herein is intended to be an accurate representation of actual conditions, it is presented for informational purposes only and the user is cautioned to use it at his/her own risk.   
