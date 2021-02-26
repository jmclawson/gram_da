library(tibble)
library(dplyr)
#' Start a lesson from the gramda package.
#'
#' @return A list of available lessons
#' @examples lesson()
lesson <- function() {
  the.lessons <- learnr::available_tutorials("gramda")[[2]]

  print(learnr::available_tutorials("gramda"))

  the.choice <- readline(prompt="Enter the lesson number you'd like to begin with: ")

  bad.entry <- the.choice %>%
    as.numeric() %>%
    suppressWarnings() %>%
    is.na

  if(bad.entry) {
    message("Please enter only a number.")
  } else {
    the.choice <- the.choice %>% as.numeric()
    if (the.choice == 0) {
      message("Nice try, but that wasn't one of the options. Please try again.")
    }
    else if (the.choice>length(the.lessons)) {
      message("That lesson isn't yet ready. Please update the gramda package or check back later.")
    } else {
      message("The lesson will open in your web browser. When you're finished there and would like to return to functionality in this R Studio window, hit the 'Interrupt R' button in the top-right corner of this console. (The button looks like a stop sign.)")
      learnr::run_tutorial(the.lessons[the.choice], "gramda")
    }
  }
}
