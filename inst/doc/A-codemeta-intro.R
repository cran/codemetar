## ----include=FALSE-------------------------------------------------------
knitr::opts_chunk$set(comment="")

## ----gh-installation, eval = FALSE---------------------------------------
#  # install.packages("devtools")
#  devtools::install_github("codemeta/codemetar")

## ------------------------------------------------------------------------
library("codemetar")

## ----example-------------------------------------------------------------
write_codemeta("testthat")

## ------------------------------------------------------------------------
write_codemeta(".")

## ----echo = FALSE--------------------------------------------------------
cat(readLines("codemeta.json"), sep="\n")

## ----include=FALSE-------------------------------------------------------
#unlink("codemeta.json")

