## ----include=FALSE------------------------------------------------------------
knitr::opts_chunk$set(comment="")
if(grepl("windows", tolower(Sys.info()[["sysname"]])))
  knitr::opts_chunk$set(comment="", error =TRUE)

## ----cran-installation, eval = FALSE------------------------------------------
#  install.packages("codemetar")

## ----gh-installation, eval = FALSE--------------------------------------------
#  # install.packages("remotes")
#  remotes::install_github("ropensci/codemetar", ref = "dev")

## -----------------------------------------------------------------------------
codemetar::write_codemeta(find.package("codemetar"))

## ----echo = FALSE-------------------------------------------------------------
library("magrittr")
"codemeta.json" %>%
  details::details(summary = "codemetar's codemeta.json",
                   lang = "json")

## ----echo = FALSE, results='hide'---------------------------------------------
file.remove("codemeta.json")

## -----------------------------------------------------------------------------
codemetar::write_codemeta("testthat", path = "example-codemeta.json")

## ----echo = FALSE-------------------------------------------------------------
library("magrittr")
"example-codemeta.json" %>%
  details::details(summary = "testthat's basic codemeta.json",
                   lang = "json")

## ----echo = FALSE, results='hide'---------------------------------------------
file.remove("example-codemeta.json")

## ---- echo = FALSE------------------------------------------------------------
details::details(system.file("templates", "codemeta-github-actions.yml", package = "codemetar"), 
                 summary = "click here to see the workflow",
                 lang = "yaml")

