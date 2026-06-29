# Internal loading of the bundled JSON source of truth.
#
# The palettes live in inst/extdata/aa_palettes.json. We read that file lazily
# (on first use) and cache the parsed result in an environment, rather than
# baking a copy into R/sysdata.rda, so that the JSON remains the single,
# inspectable source of truth at run time.

.aa_cache <- new.env(parent = emptyenv())

# Path to the bundled JSON inside the installed package.
.aa_json_path <- function() {
  path <- system.file("extdata", "aa_palettes.json", package = "aapalette")
  if (!nzchar(path)) {
    stop("Could not locate aa_palettes.json in the installed package.",
         call. = FALSE)
  }
  path
}

# Parsed JSON (list), cached.
.aa_data <- function() {
  if (is.null(.aa_cache$data)) {
    .aa_cache$data <- jsonlite::fromJSON(
      .aa_json_path(),
      simplifyVector = FALSE
    )
  }
  .aa_cache$data
}

# The 20 canonical residues, in order.
.aa_residues <- function() {
  unlist(.aa_data()$residues, use.names = FALSE)
}

# Defaults block (unknown_XBZJ, gap).
.aa_defaults <- function() {
  .aa_data()$defaults
}

# Validate and normalise a scheme id; errors with the valid choices listed.
.aa_match_scheme <- function(scheme) {
  if (length(scheme) != 1L || !is.character(scheme) || is.na(scheme)) {
    stop("`scheme` must be a single scheme id (string).", call. = FALSE)
  }
  ids <- names(.aa_data()$schemes)
  if (!scheme %in% ids) {
    stop(
      sprintf(
        "Unknown scheme '%s'. Available schemes: %s.",
        scheme, paste(ids, collapse = ", ")
      ),
      call. = FALSE
    )
  }
  scheme
}

# Codes that map to the "unknown / ambiguous" default colour.
.aa_unknown_codes <- c("X", "B", "Z", "J")
# Codes that map to the "gap" default colour.
.aa_gap_codes <- c("-", ".")
