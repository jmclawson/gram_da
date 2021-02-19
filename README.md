# gramda

Lessons and data for Grambling's DA course

## Installation
Because this package is not found on CRAN, you'll first need either the `devtools` or `remotes` package to install it. If you don't already have the `devtools` package installed, then install `remotes` with this line of code (which you can skip if you already have the package installed):

```{r}
install.packages("remotes")
```

When `remotes` is finished installing, we have just two more steps to install the `gradethis` and `gramda` packages:

```{r}
remotes::install_github("rstudio-education/gradethis")
remotes::install_github("jmclawson/gramda")
```

When asked which versions of the packages you'd like to update, choose "1: All" or "2: CRAN packages only."

## Use
Once installation is complete, the following line will get you going with one of the tutorials:

```{r}
gramda::lesson()
```
