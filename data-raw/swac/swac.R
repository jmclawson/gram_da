# library(rvest)
# library(dplyr)
# library(tibble)
#
# thepage <- read_html("https://swac.org/stats.aspx?path=football&year=2019")
#
# team_names <- thepage %>%
#   html_node('#by_team') %>%
#   html_nodes("table.sidearm-table") %>%
#   html_nodes("caption") %>%
#   html_text() %>%
#   gsub(pattern = " Season Results",
#        replacement = "",
#        x = .)
#
# team_tables <- thepage %>%
#   html_node('#by_team') %>%
#   html_nodes("table.sidearm-table") %>%
#   html_table()
#
# names(team_tables) <- team_names
#
# master_table <- do.call(rbind.data.frame, team_tables) %>%
#   rownames_to_column("Team")
#
# master_table$Team <-
#   gsub("\\.[0-9]{1,2}",
#        "",
#        master_table$Team)
#
# master_table$Team <-
#   sapply(master_table$Team,
#          function(x)
#            gramda::swac$Team %>%
#            unique() %>%
#            sort() %>%
#            .[paste0("^",x,"$") %>%
#                grep(master_table$Team %>%
#                       unique() %>%
#                       sort())]) %>%
#   unname()
#
# master_table$Date <- master_table$Date %>%
#   strsplit("\n") %>%
#   sapply(`[`,1) %>%
#   as.Date(format="%m/%d/%Y")
#
# swac2019 <- gramda::swac %>%
#   left_join(master_table %>%
#               select(Team, Date, Attendance)) %>%
#   mutate(Location = factor(Location)) %>%
#   tibble() %>%
#   distinct()
#
# # swac2019 <- swac
#
# swac2019[which(swac2019$Date == "2019-11-28" &
#                  swac2019$Team=="Alabama State"),
#          "Homecoming"] <- TRUE
# swac <- swac2019
#
# swac_at_home <- swac %>% filter(Homecoming==TRUE) %>% select(Team, Stadium)
# swac$Location <- NA
# swac$Location[paste0(swac$Team, swac$Stadium) %in% paste0(swac_at_home$Team, swac_at_home$Stadium)] <- "Home"
# swac$Location[!paste0(swac$Team, swac$Stadium) %in% paste0(swac_at_home$Team, swac_at_home$Stadium)] <- "Away"
# swac$Location <- swac$Location %>% factor()
#
#
# save(swac, file = "data/swac.rda")
#
# #
# library(gganimate)
# library(gifski)
# #
# # swac %>%
# #   filter(Team == "Grambling State") %>%
# #   ggplot(mapping = aes(y = Team.Score,
# #                        x = Opponent.Score)) +
# #   geom_point(aes(color = Location)) +
# #   labs(title="Grambling's 2019 Football season")
# #
# # animae <- swac %>%
# #   filter(Team=="Grambling State") %>%
# #   ggplot(mapping = aes(y = Team.Score,
# #                        x = Opponent.Score)) +
# #   geom_abline(slope=1, intercept = 0) +
# #   annotate("text", label="  win",
# #            fontface = "bold",
# #            x=0, y=3.3, angle=40, size = 5) +
# #   annotate("text", label=" loss",
# #            fontface = "bold",
# #            x=3.3, y=0, angle=40, size = 5) +
# #   geom_path(color="gray", linetype=2) +
# #   geom_text(aes(y = Team.Score-1.95,
# #                 label = paste0("vs ", Opponent %>%
# #                                  sub(pattern = "[ ][a-zA-Z]+$",
# #                                      replacement = "",
# #                                      x=.) %>%
# #                                  gsub(pattern="Golden|Delta",
# #                                       replacement = "",
# #                                       x=.) %>%
# #                                  gsub(pattern="Prairie View A&M",
# #                                       replacement = "Prairie View",
# #                                       x=.)),
# #                 group = Date),
# #             size = 3.65,
# #             fontface = "italic") +
# #   geom_label(aes(label = paste0(Team.Score, "-",
# #                                 Opponent.Score),
# #                  fill = Location,
# #                  group = Date,
# #                  color = Location),
# #              size = 4.7,
# #              fontface = "bold") +
# #   theme_classic() +
# #   labs(y="Grambling's Score",
# #        x="Opposing Team's Score",
# #        title="After a slow start and a win streak, the 2019 season ended with a close game.",
# #        subtitle="Date: {format(frame_along,'%b %d, %Y')}",
# #        color="",
# #        fill="") +
# #   transition_reveal(along = Date) +
# #   scale_fill_manual(values = c("Away"="black", "Home"="goldenrod"),
# #                     limits = c("Home", "Away"),
# #                     labels = c("at Grambling", "Away")) +
# #   scale_color_manual(values = c("Away"="goldenrod", "Home"="black"),
# #                      limits = c("Home", "Away"),
# #                      labels = c("at Grambling", "Away")) +
# #   # scale_discrete_manual(labels = c("Away", "at Grambling")) +
# #   guides(fill = guide_legend(override.aes = aes(label = ""))) +
# #   theme(legend.position = c(0.85, 1.02),
# #         legend.direction = "horizontal",
# #         plot.title.position = "plot",
# #         legend.key = element_rect(colour=c("black",
# #                                            "goldenrod"),
# #                                   size=c(1,2))) +
# #   scale_x_continuous(expand = expansion(add=c(2.74,4)))
# #
# # animate(animae, end_pause = 30, rewind = FALSE)
# #
# # anim_save("gram2019.gif")
# #
# animae2 <- swac %>%
#   filter(Team=="Grambling State") %>%
#   mutate(Opponent = Opponent %>%
#            sub(pattern = "[ ][a-zA-Z]+$",
#                replacement = "",
#                x=.) %>%
#            gsub(pattern="Golden|Delta",
#                 replacement = "",
#                 x=.) %>%
#            gsub(pattern="Prairie View A&M",
#                 replacement = "Prairie View",
#                 x=.) %>%
#            gsub(pattern="^Southern",
#                 replacement = "Southern     ",
#                 x=.)) %>%
#   ggplot(mapping = aes(y = Team.Score - Opponent.Score,
#                        x = as.Date(Date))) +
#   geom_abline(slope=0, intercept = 0) +
#   ggplot2::annotate("text", label="win",
#            fontface = "bold",
#            x=min(swac$Date), y=2.3, size = 5, hjust = 0.5) +
#   ggplot2::annotate("text", label="loss",
#            fontface = "bold",
#            x=min(swac$Date), y=-2.3, size = 5, hjust = 0.5) +
#   geom_text(aes(label=Date %>% format("%m/%d"))) +
#   geom_line(color="gray", linetype=2) +
#   geom_label(aes(y = Team.Score - Opponent.Score-2.7,
#                 label = paste0("vs ", Opponent),
#                 group = Date),
#             size = 3.65,
#             fontface = "italic",
#             fill="white",
#             color="white") +
#   geom_label(data = swac %>%
#                filter(Team == "Grambling State",
#                       Homecoming == TRUE),
#              aes(y = Team.Score - Opponent.Score - 4.5,
#                  group = Date),
#              label = "(homecoming)",
#              size = 3.65, color = "white", fill="white",
#              fontface = "italic") +
#   geom_text(aes(y = Team.Score - Opponent.Score-2.7,
#                 label = paste0("vs ", Opponent),
#                 group = Date),
#             size = 3.65,
#             fontface = "italic") +
#   geom_text(aes(y = Team.Score - Opponent.Score-4.5,
#                 label = Homecoming %>%
#                   as.character() %>%
#                   gsub(pattern="TRUE",
#                        replacement="(homecoming)",
#                        x=.) %>%
#                   gsub(pattern="FALSE",
#                        replacement="",
#                        x=.),
#                 group = Date),
#             size = 3.65, color = "red",
#             fontface = "italic") +
#   geom_label(aes(label = paste0(Team.Score, "-",
#                                 Opponent.Score),
#                  fill = Location,
#                  group = Date,
#                  color = Location),
#              size = 4.7,
#              fontface = "bold") +
#   theme_linedraw() +
#   labs(y="point spread",
#        x="",
#        title="After a slow start and a win streak, Grambling's 2019 season ended in a close loss at the Bayou Classic.",
#        # subtitle="Date: {format(frame_along,'%b %d, %Y')}",
#        color="",
#        fill="") +
#   # transition_reveal(along = Date) +
#   scale_fill_manual(values = c("Away"="black", "Home"="goldenrod"),
#                     limits = c("Home", "Away"),
#                     labels = c("at Grambling", "Away")) +
#   scale_color_manual(values = c("Away"="goldenrod", "Home"="black"),
#                      limits = c("Home", "Away"),
#                      labels = c("at Grambling", "Away")) +
#   # scale_discrete_manual(labels = c("Away", "at Grambling")) +
#   guides(fill = guide_legend(override.aes = aes(label = ""))) +
#   theme(legend.position = c(0.86, 0.04),
#         legend.direction = "horizontal",
#         plot.title.position = "plot",
#         legend.key = element_rect(colour=c("black",
#                                            "goldenrod"),
#                                   size=c(1,2))) +
#   scale_y_continuous(
#     labels = function(y) ifelse(y > 0,
#                                 paste0("+", y),
#                                 y))
#
# animae3 <- animae2 + transition_reveal(along = Date)
#
# animate(animae3, end_pause = 30, rewind = FALSE,
#         height=6, width=8.6, units="in",
#         res=72)
# # #
# anim_save("pointspread.gif")
