## ----include=FALSE-------------------------------------------------------
knitr::opts_chunk$set(comment="")
if(grepl("windows", tolower(Sys.info()[["sysname"]])))
  knitr::opts_chunk$set(comment="", error =TRUE)

## ----message=FALSE-------------------------------------------------------
library(jsonld)
library(jsonlite)
library(magrittr)
library(codemetar)
library(purrr)
library(dplyr)
library(printr)
library(tibble)

## ------------------------------------------------------------------------
write_codemeta("codemetar", "codemeta.json")

## ------------------------------------------------------------------------
frame <- system.file("schema/frame_schema.json", package="codemetar")

meta <- 
  jsonld_frame("codemeta.json", frame) %>%
  fromJSON(FALSE) %>% getElement("@graph") %>% getElement(1)

## ------------------------------------------------------------------------
authors <- 
lapply(meta$author, 
       function(author) 
         person(given = author$given, 
                family = author$family, 
                email = author$email,
                role = "aut"))
year <- meta$datePublished
if(is.null(year)) 
  year <- format(Sys.Date(), "%Y")
bibitem <- 
 bibentry(
     bibtype = "Manual",
     title = meta$name,
     author = authors,
     year = year,
     note = paste0("R package version ", meta$version),
     url = meta$URL,
     key = meta$identifier
   )

cat(format(bibitem, "bibtex"))

bibitem

## ------------------------------------------------------------------------
download.file("https://github.com/codemeta/codemetar/raw/master/inst/notebook/ropensci.json",
              "ropensci.json")

## ------------------------------------------------------------------------
frame <- system.file("schema/frame_schema.json", package="codemetar")

corpus <- 
    jsonld_frame("ropensci.json", frame) %>%
    fromJSON(simplifyVector = FALSE) %>%
    getElement("@graph") 

## ------------------------------------------------------------------------
## deal with nulls explicitly by starting with map
pkgs <- map(corpus, "name") %>% compact() %>% as.character()

# keep only those with package identifiers (names)
keep <- map_lgl(corpus, ~ length(.x$identifier) > 0)
corpus <- corpus[keep]

## now we can just do
all_pkgs <- map_chr(corpus, "name")
head(all_pkgs)

## ------------------------------------------------------------------------
## 60 unique maintainers
map_chr(corpus, c("maintainer", "familyName")) %>% unique() %>% length()

## Mostly Scott
map_chr(corpus, c("maintainer", "familyName")) %>% 
  as_tibble() %>%
  group_by(value) %>%
  tally(sort=TRUE)

## ------------------------------------------------------------------------
## number of co-authors ... 
map_int(corpus, function(r) length(r$author)) %>% 
  as_tibble() %>%
  group_by(value) %>%
  tally(sort=TRUE)

## ------------------------------------------------------------------------
## Contributors isn't used as much...
map_int(corpus, function(r) length(r$contributor)) %>% 
  as_tibble() %>%
  group_by(value) %>%
  tally(sort=TRUE)


## ------------------------------------------------------------------------
map_int(corpus, function(r) length(r$softwareRequirements))  %>% 
  as_tibble() %>%
  group_by(value) %>%
  tally(sort=TRUE)

## ------------------------------------------------------------------------
corpus %>%
map_df(function(x){
  ## single, unboxed dep
  if("name" %in% names(x$softwareRequirements))
    dep <- x$name
  else if("name" %in% names(x$softwareRequirements[[1]]))
    dep <- map_chr(x$softwareRequirements, "name")
  else { ## No requirementsß
    dep <- NA
  }
  
  tibble(identifier = x$identifier, dep = dep)
}) -> dep_df


dep_df %>%
group_by(dep) %>% 
  tally(sort = TRUE)


## ------------------------------------------------------------------------
dep_frame <- '{
  "@context": "https://raw.githubusercontent.com/codemeta/codemeta/master/codemeta.jsonld",
  "@explicit": "true",
  "name": {}
}'
jsonld_frame("ropensci.json", dep_frame) %>% 
  fromJSON() %>% 
  getElement("@graph") %>%
  filter(type == "SoftwareApplication") %>%
  group_by(name) %>% 
  tally(sort = TRUE)
  
#  summarise(count(name))

## ----include = FALSE-----------------------------------------------------
unlink("ropensci.json")
unlink("codemeta.json")

