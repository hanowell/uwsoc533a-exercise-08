# Exercise 8 data collection: All data for Chile in 1992
# Source: Human Fertility and Mortality Databases

## Load packages ----
library(dplyr)
library(HMDHFDplus)

## Age-specific fertility rates ----
CHLasfrRR <- HMDHFDplus::readHFDweb(
  CNTRY = "CHL",
  item = "birthsRR",
  username = keyring::key_list("human-fertility-database")$username,
  password = keyring::key_get(
    service = "human-fertility-database",
    username = keyring::key_list("human-fertility-database")$username
  )
) %>%
  dplyr::filter(Year == 1992) %>%
  dplyr::select(Age, Total) %>%
  dplyr::rename(births = Total) %>%
  dplyr::left_join(
    HMDHFDplus::readHFDweb(
      CNTRY = "CHL",
      item = "exposRR",
      username = keyring::key_list("human-fertility-database")$username,
      password = keyring::key_get(
        service = "human-fertility-database",
        username = keyring::key_list("human-fertility-database")$username
      )
    ) %>%
      dplyr::filter(Year == 1992) %>%
      dplyr::select(Age, Exposure)
  ) %>%
  dplyr::filter(Age %>% dplyr::between(15, 49)) %>%
  dplyr::mutate(
    Age = Age %>%
      cut(breaks = seq(15, 50, 5), right = FALSE, labels = seq(15, 45, 5)) %>%
      as.character() %>%
      as.integer()
  ) %>%
  dplyr::with_groups(
    Age, summarize_at, .vars = vars(births, Exposure), .funs = sum
  ) %>%
  dplyr::mutate(ASFR = births / Exposure) %>%
  dplyr::select(Age, ASFR)
saveRDS(CHLasfrRR, "data/CHLasfrRR.rds")

## Person-years
Population5 <- HMDHFDplus::readHMDweb(
  CNTRY = "CHL",
  item = "Population5",
  username = keyring::key_list("human-mortality-database")$username,
  password = keyring::key_get(
    service = "human-mortality-database",
    username = keyring::key_list("human-mortality-database")$username
  )
) %>%
  dplyr::filter(Year == 1992) %>%
  dplyr::select(Age, Female1)
saveRDS(Population5, "data/Population5.rds")

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
  dplyr::select(-Year, -OpenInterval)
saveRDS(fltper_5x1, "data/fltper_5x1.rds")
