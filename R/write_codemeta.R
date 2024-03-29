#' write_codemeta
#'
#' write out a codemeta.json file for a given package.  This function is
#' basically a wrapper around create_codemeta() to both create the codemeta
#' object and write it out to a JSON-LD-formatted file in one command. It can
#' also be used simply to write out to JSON-LD any existing object created with
#' `create_codemeta()`.
#'
# @includeRmd man/rmdhunks/whybother.Rmd
# @includeRmd man/rmdhunks/uptodate.Rmd
#'
#' @param pkg package path to package root, or description file
#'   (character), or a codemeta object (list)
#' @param path file name of the output, leave at default "codemeta.json"
#' @param root if pkg is a codemeta object, optionally give the path to package
#'   root. Default guess is current dir.
#' @param id identifier for the package, e.g. a DOI (or other resolvable URL)
#' @param use_filesize whether to try to estimating and adding a filesize by using
#'   `base::file.size()`. Files in `.Rbuildignore` are ignored.
#' @param force_update Update guessed fields even if they are defined in an
#'   existing codemeta.json file
#' @param use_git_hook Deprecated argument.
#' @param verbose Whether to print messages indicating opinions e.g. when
#'   DESCRIPTION has no URL. -- See \code{\link{give_opinions}};
#' and indicating the progress of internet downloads.
#' @param write_minimeta whether to also create the file schemaorg.json that
#' corresponds to the metadata Google would validate, to be inserted to a
#' webpage for SEO. It is saved as "inst/schemaorg.json" alongside `path` (by
#' default, "codemeta.json").
#' @param ...  additional arguments to \code{\link{write_json}}
#' @section Technical details:
#'  If pkg is a codemeta object, the function will attempt to update any
#'   fields it can guess (i.e. from the DESCRIPTION file), overwriting any
#'   existing data in that block. In this case, the package root directory
#'   should be the current working directory.
#'
#' When creating and writing a codemeta.json for the first time, the function
#' adds "codemeta.json" to .Rbuildignore.
#' @return writes out the codemeta.json file, and schemaorg.json if `write_codemeta`
#' is `TRUE`.
#' @export
#'
#' @examples
#' \dontrun{
#' # from anywhere in the package source directory
#' write_codemeta()
#' }
write_codemeta <- function(
  pkg = ".", path = "codemeta.json", root = ".", id = NULL, use_filesize = TRUE,
  force_update = getOption("codemeta_force_update", TRUE), use_git_hook = NULL,
  verbose = TRUE, write_minimeta = FALSE, ...
) {

  if (!missing(use_git_hook)) {
    warning("The use_git_hook argument is deprecated and ignored.")
  }

  codemeta_json <- "codemeta.json"

  stopifnot("`pkg` must be a single value" = length(pkg) == 1)
  # Things that only happen inside a package folder...
  if (pkg == ".") {
    pkg <- dot_to_package(pkg)
  }

  in_package <- length(pkg) <= 1 && is_package(pkg) && pkg %in% c(getwd(), ".")

  # ... and when the output file is codemeta.json. If path is something else
  # hopefully the user know what they are doing.
  if (in_package && path == codemeta_json) {

    use_build_ignore(codemeta_json, path = root)
    message(paste("Added", codemeta_json, "to .Rbuildignore"))
  }
  # Create or update codemeta and save to disk
  create_codemeta(pkg = pkg, root = root, use_filesize = use_filesize,
                  verbose = verbose, id = id, force_update = force_update) %>%
    jsonlite::write_json(file.path(pkg, path), pretty = TRUE, auto_unbox = TRUE, ...)

  # Create minimeta and save to disk
  if (write_minimeta) {
    if (!requireNamespace("jsonld", quietly = TRUE)) {
      stop("Package jsonld required. Please install before re-trying.")
    }
    schemaorg <- system.file("schema", "schemaorg.json",
                             package="codemetar")
   jsonld::jsonld_frame("codemeta.json", schemaorg) %>%
     jsonld::jsonld_compact('{"@context": "https://schema.org"}') %>%
     writeLines(file.path(dirname(file.path(pkg, path)), "inst", "schemaorg.json"))


  }
}
