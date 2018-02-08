## ----include=FALSE-------------------------------------------------------
knitr::opts_chunk$set(comment="")

## ----message=FALSE-------------------------------------------------------
library("codemetar")
library("magrittr")
library("jsonlite")
library("jsonld")
library("httr")
library("readr")

## ------------------------------------------------------------------------
ex <-
'{
"@context":{
  "shouter": "http://schema.org/name",
  "txt": "http://schema.org/commentText"
},
"shouter": "Jim",
"txt": "Hello World!"
}'

## ------------------------------------------------------------------------
bighash_context <- 
'{
"@context":{
  "user": "http://schema.org/name",
  "comment": "http://schema.org/commentText"
}
}'

## ------------------------------------------------------------------------
jsonld_expand(ex) %>%
  jsonld_compact(context = bighash_context)

## ----eval = FALSE--------------------------------------------------------
#  repo_info <- gh::gh("/repos/:owner/:repo", owner = "ropensci", repo = "EML")

## ----include = FALSE-----------------------------------------------------
## Actually, we'll use a chached copy and not eval the above chunk to avoid a `gh` dependency:
repo_info <- read_json(system.file("examples/github_format.json", package = "codemetar"))

## ------------------------------------------------------------------------
repo_info %>% toJSON()

## ------------------------------------------------------------------------
github_meta <- crosswalk(repo_info, "GitHub")
github_meta

## ------------------------------------------------------------------------
codemeta_validate(github_meta)

## ------------------------------------------------------------------------
crosswalk(repo_info, "GitHub", "Zenodo") %>%
drop_context()

## ------------------------------------------------------------------------
package.json <- read_json(
"https://raw.githubusercontent.com/heroku/node-js-sample/master/package.json")
package.json

## ------------------------------------------------------------------------
crosswalk(package.json, "NodeJS")

