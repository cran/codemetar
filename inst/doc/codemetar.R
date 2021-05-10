## ----include=FALSE------------------------------------------------------------
knitr::opts_chunk$set(comment="")
if(grepl("windows", tolower(Sys.info()[["sysname"]])))
  knitr::opts_chunk$set(comment="", error =TRUE)

## ----cran-installation, eval = FALSE------------------------------------------
#  install.packages("codemetar")

## ----gh-installation, eval = FALSE--------------------------------------------
#  # install.packages("remotes")
#  remotes::install_github("ropensci/codemetar", ref = "dev")

## ----echo=FALSE, eval=TRUE----------------------------------------------------
pkg <- "../.."
codemetar::write_codemeta(pkg = pkg)

## ----echo=TRUE, eval=FALSE----------------------------------------------------
#  codemetar::write_codemeta()

## ----eval = TRUE--------------------------------------------------------------
library("magrittr")
"../../codemeta.json" %>%
  details::details(summary = "codemetar's codemeta.json",
                   lang = "json")

## ----echo = FALSE, results='hide'---------------------------------------------
file.remove(file.path(pkg, "codemeta.json"))

## ---- echo = FALSE------------------------------------------------------------
details::details(system.file("templates", "codemeta-github-actions.yml", package = "codemetar"), 
                 summary = "click here to see the workflow",
                 lang = "yaml")

