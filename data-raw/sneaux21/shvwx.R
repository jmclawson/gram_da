library(lubridate)
get_dates <- function(start = "2021-02-13",
                      days = 6,
                      years = 5) {
  starts <- ymd(start) - years(0:years)
  dates <- c()
  dates <- sapply(starts,
                  function (x) {
                    seq.Date(ymd(x),
                             by=1,
                             length.out=days) %>%
                      c(dates)})
  return(dates)
}

dates <- get_dates() %>%
  as.Date(origin = "1970-01-01")


shvwx <- read.csv("~/Developer/gramda/data-raw/sneaux21/shvwx.csv") %>%
  # Filter out the 2 AM hour from days when the time
  # springs ahead
  filter(!grepl("2015-03-08T02|2016-03-13T02|2017-03-12T02|2018-03-11T02|2019-03-10T02|2020-03-08T02",
                DATE))

shvwx1 <- shvwx
shvwx <- shvwx1

shvwx <- shvwx %>%
  filter(!grepl("2015-03-08T02|2016-03-13T02|2017-03-12T02|2018-03-11T02|2019-03-10T02|2020-03-08T02",
                DATE)) %>%
  mutate(index=paste0(DATE,"_",STATION)) %>%
  select(-c(DATE,STATION)) %>%
  mutate_all(funs(na_if(., ""))) %>%
  select(where(~ !(all(is.na(.))))) %>%
  select(where(~ !(all(.=="")))) %>%
  # select_if(~!(all(.==""))) %>%
  mutate(DATE=index %>%
           strsplit("_") %>%
           sapply(`[`, 1),
         STATION=index %>%
           strsplit("_") %>%
           sapply(`[`, 2)) %>%
  mutate(DATE = DATE %>%
           gsub(pattern = "T",
                replacement = " ",
                x=.) %>%
           as.POSIXct()) %>%
  tibble() %>%
  filter(as.Date(DATE) %in% dates) %>%
  relocate(DATE, STATION) %>%
  select(-index)




