library(tidyverse)
library(readxl)


datadir = 'C:/Users/steeleb/Dropbox/Lake Sunapee/monitoring/DES_sunapee_dam_data/historical_water_level_data/original_data_from_DES/'
dumpdir = 'C:/Users/steeleb/Documents/GitHub/nh-des-dam-data/data/'

hist <- read_xls(file.path(datadir, 'Sunapee Historical Data (1982-2010).xls'),
                 col_names = c(NULL, 'date', 'damDepth_ft', 'lakeElevation_average_ft', 'gage_elec', 
                               'river_stage_ft', 'outflow_average_cfs', 'level_change_ft', 'change_storage_cfs', 
                               'estinfl_cfs', 'strdwtr_cfs', 'memo', 'time', 'est', 'este'),
                 col_types = c('date', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric',
                               'numeric', 'numeric', 'numeric', 'text', 'text', 'text', 'text'),
                 skip = 3)

hist_select <- hist %>% 
  mutate(damDepth_ft = case_when(damDepth_ft == 0 ~ NA_real_,
                                 damDepth_ft > 100 ~ NA_real_,
                                 damDepth_ft < 5 ~ NA_real_, 
                                 TRUE ~ damDepth_ft),
         lakeElevation_average_ft = damDepth_ft + 1082.65)

ggplot(hist_select, aes(x = date, y = lakeElevation_average_ft))+
  geom_line()

ggplot(hist_select, aes(x = date, y = outflow_average_cfs))+
  geom_point()

hist_select <- hist_select %>% 
  select(date, lakeElevation_average_ft, outflow_average_cfs) %>% 
  mutate(date = as.Date(date))

write.csv(hist_select, file.path(dumpdir, 'Sunapee_NHDESDB_dailyhistorical_raw_1981-2010.csv'))
