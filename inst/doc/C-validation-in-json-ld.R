## ----message=FALSE-------------------------------------------------------
library(jsonld)
library(jsonlite)
library(magrittr)
library(codemetar)

## ----include=FALSE-------------------------------------------------------
knitr::opts_chunk$set(comment="")
if(grepl("windows", tolower(Sys.info()[["sysname"]])))
  knitr::opts_chunk$set(comment="", error =TRUE)

## ------------------------------------------------------------------------
codemeta <- 
'
{
  "@context": "https://doi.org/10.5063/schema/codemeta-2.0",
  "@type": "SoftwareSourceCode",
  "name": "codemetar: Generate CodeMeta Metadata for R Packages",
  "datePublished":" 2017-05-20",
  "version": 1.0,
  "author": [
    {
      "@type": "Person",
      "givenName": "Carl",
      "familyName": "Boettiger",
      "email": "cboettig@gmail.com",
      "@id": "http://orcid.org/0000-0002-1642-628X"
    }],
  "maintainer":  {"@id": "http://orcid.org/0000-0002-1642-628X"}
}
'

## ------------------------------------------------------------------------
jsonld::jsonld_compact(codemeta, "https://doi.org/10.5063/schema/codemeta-2.0")

## ------------------------------------------------------------------------
frame <- '{
  "@context": "https://doi.org/10.5063/schema/codemeta-2.0",
  "@explicit": "true",
  "@type": "Person",
  "givenName": {},
  "familyName": {}
}'

meta <- 
  jsonld_frame(codemeta, frame)  %>%
  fromJSON(codemeta, simplifyVector = FALSE) %>% 
  getElement("@graph") 

meta[[1]]

## ----error=TRUE----------------------------------------------------------
meta <- fromJSON(codemeta, simplifyVector = FALSE) 
paste("For complaints, email", meta$maintainer$email)

## ------------------------------------------------------------------------
meta$maintainer

## ------------------------------------------------------------------------
frame <- '{
  "@context": "https://doi.org/10.5063/schema/codemeta-2.0",
  "@embed": "@always"
}'


meta <- 
  jsonld_frame(codemeta, frame) %>%
  fromJSON(codemeta, simplifyVector = FALSE) %>% 
  getElement("@graph") %>% getElement(1)

## ------------------------------------------------------------------------
paste("For complaints, email", meta$maintainer$email)

## ------------------------------------------------------------------------
codemeta <- 
'
{
  "@context": "https://purl.org/codemeta/2.0",
  "@type": "SoftwareSourceCode",
  "name": "codemetar: Generate CodeMeta Metadata for R Packages",
  "buildInstructions": { 
      "@value": "Just install this package using devtools::install_github", 
      "@type": "Text"
  }
}
'

## ------------------------------------------------------------------------
meta <-
  jsonld_frame(codemeta, '{"@context": "https://purl.org/codemeta/2.0"}') %>% 
  fromJSON(codemeta, simplifyVector = FALSE) %>%  
  getElement("@graph") %>% getElement(1)    

## above is same as compacting:
#jsonld_compact(codemeta, "https://doi.org/10.5063/schema/codemeta-2.0") %>% 
#  fromJSON(codemeta, simplifyVector = FALSE)

meta$buildInstructions


## ------------------------------------------------------------------------
names(meta)
meta["codemeta:buildInstructions"]

