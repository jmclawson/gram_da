
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
         End.Time = Time %>%
           strsplit("-") %>%
           sapply(`[`, 2)) %>%
  select(-c(Select, Rem, Location, Time)) %>%
  relocate(c(Building, Room), .before=Days)

bannerweb[bannerweb=="TBA"] <- NA
bannerweb[bannerweb==""] <- NA

save(file="../data/bannerweb.rda")
