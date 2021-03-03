
bannerweb <- read.csv("~/Documents/Teaching/Grambling SU/CS 112 Big Data/bannerweb.csv") %>%
  tibble() %>%
  rename(Subject = Subj,
         Course = Crse,
         Section = Sec,
         Campus = Cmp,
         Credits = Cred,
         Capacity = Cap,
         Enrollment = Act) %>%
  mutate(Campus = case_when(
    Campus == "O" ~"Off Campus",
    Campus == "D" ~"Distance Learning",
    Campus == "M" ~"Main")) %>%
  mutate(Credits = gsub(".000", "", Credits),
         Building = Location %>%
           strsplit(" ") %>%
           sapply(`[`, 1),
         Room = Location %>%
           strsplit(" ") %>%
           sapply(`[`, 2),
         Start.Time = Time %>%
           strsplit("-") %>%
           sapply(`[`, 1),
         `End Time` = Time %>%
           strsplit("-") %>%
           sapply(`[`, 2)#,
         # Start.Numeric = Start.Time %>%
         #   strsplit(":") %>%
         #   sapply(`[`,1)
         ) %>%
  # mutate()
  mutate(Start.Numeric = case_when(
    Start.Time=="TBA" ~ as.numeric(NA),
    TRUE              ~ Start.Time %>%
      strsplit(":") %>%
      sapply(`[`,1) %>%
      as.numeric() %>%
      suppressWarnings())) %>%
  mutate(Start.Numeric = case_when(
    Start.Time=="TBA" ~ as.numeric(NA),
    grepl("pm", Start.Time)  ~ Start.Numeric + 12,
    TRUE ~ Start.Numeric
  )) %>%
  mutate(Start.Numeric = case_when(
    Start.Time=="TBA" ~ as.integer(NA),
    Start.Numeric==24  ~ 12 %>% as.integer(),
    TRUE ~ Start.Numeric %>% as.integer()
  )) %>%
  # mutate(Start.Numeric = case_when(
  #   Start.Time=="TBA" ~ as.numeric(NA),
  #   grepl(":30", Start.Time)  ~ Start.Numeric + 0.5,
  #   TRUE ~ Start.Numeric
  # )) %>%
  rename(`Starting Hour` = Start.Numeric,
         `Start Time` = Start.Time) %>%
  # mutate(Start.Numeric = case_when(
  #   is.na(Start.Numeric)           ~ Start.Numeric==NA,
  #   grepl("30", Start.Time)        ~ Start.Numeric + 0.5
  # )) %>%
  select(-c(Select, Rem, Location, Time)) %>%
  relocate(c(Building, Room, Capacity, Enrollment), .before=Days)

bannerweb[bannerweb=="TBA"] <- NA
bannerweb[bannerweb==""] <- NA

save(bannerweb,file="data/bannerweb.rda")
