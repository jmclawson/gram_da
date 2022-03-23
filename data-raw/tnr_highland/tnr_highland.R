## Load some libraries

library(tidyverse)
library(janitor)

# Download data linked from https://portcitycatrescue.org/local-tnr-programs/?fbclid=IwAR03VSRHenJi5pKhwK-kvDKW4ZdWuHrRSe_1eNc-vjMn5UJ5bNMAI_Q55HU
# Latest data on Google Sheets from March 2022
tnr_csv <- "TNR Feral Cats of Highland LOG 2021 - Sheet1.csv"

tnr_highland <- read_csv(tnr_csv) |>
  clean_names() |>
  mutate(
    location = case_when(
      location == "^" ~ as.character(NA),
      TRUE ~ location),
    date_trapped = as.Date(date_trapped, "%m/%d/%y"),
    eartip = case_when(
      eartip == "Yes" ~ TRUE,
      TRUE ~ FALSE),
    sex = factor(sex),
    trapper_name = case_when(
      trapper_name == "James Aulds" ~ "JA",
      trapper_name == "Lindsey Simpson" ~ "LS",
      trapper_name == "Christina Coker" ~ "CC",
      trapper_name == "Kaitlin Chance" ~ "KC",
      trapper_name == "Julia Foley Bey" ~ "JB",
      TRUE ~ trapper_name),
    color_markings = color_markings |>
      {\(x) gsub("Tab\\b","Tabby",x)}() |>
      {\(x) gsub("Grey","Gray",x)}() |>
      {\(x) gsub("B&W","Black and White",x)}() |>
      {\(x) gsub("cat","",x)}() |>
      {\(x) gsub(" $","",x)}()) |>
  fill(location) |>
  select(-photo)

# View it
# View(feral)

write_csv(tnr_highland, "tnr_highland.csv")
save(tnr_highland,file="data/tnr_highland.rda")

