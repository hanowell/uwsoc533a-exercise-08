# Exercise 8 data collection: All data for Chile in 1992
# Source: Human Fertility and Mortality Databases

## Load packages ----
library(dplyr)
library(HMDHFDplus)

## Age-specific fertility rates ----
CHLasfrRR <- HMDHFDplus::readHFDweb(
  CNTRY = "CHL",
  item = "asfrRR",
  username = keyring::key_list("human-fertility-database")$username,
  password = keyring::key_get(
    service = "human-fertility-database",
    username = keyring::key_list("human-fertility-database")$username
  )
) %>%
  dplyr::filter(Year == 1992) %>%
  dplyr::select(-Year)
saveRDS(CHLasfrRR, "data/CHLasfrRR.rds")

## Period life tables ----

### Males ----
mltper_5x1 <- HMDHFDplus::readHMDweb(
  CNTRY = "CHL",
  item = "mltper_5x1",
  username = keyring::key_list("human-mortality-database")$username,
  password = keyring::key_get(
    service = "human-mortality-database",
    username = keyring::key_list("human-mortality-database")$username
  )
) %>%
  dplyr::filter(Year == 1992) %>%
  dplyr::rename(x = Age) %>%
dplyr::select(-Year, -OpenInterval)
saveRDS(mltper_5x1, "data/mltper_5x1.rds")

### Females ----
fltper_5x1 <- HMDHFDplus::readHMDweb(
  CNTRY = "CHL",
  item = "fltper_5x1",
  username = keyring::key_list("human-mortality-database")$username,
  password = keyring::key_get(
    service = "human-mortality-database",
    username = keyring::key_list("human-mortality-database")$username
  )
) %>%
  dplyr::filter(Year == 1992) %>%
  dplyr::rename(x = Age) %>%
  dplyr::select(-Year, -OpenInterval)
saveRDS(fltper_5x1, "data/fltper_5x1.rds")
