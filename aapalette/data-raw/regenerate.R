# Regeneration / provenance note
# ================================
#
# The single source of truth for every colour in this package is the JSON file
#
#     ../aa_palettes.json        (the project-root copy)
#
# which is bundled verbatim into the installed package at
#
#     inst/extdata/aa_palettes.json
#
# The package reads that bundled JSON at run time (see R/data.R); there is NO
# generated R/sysdata.rda derived object to keep in sync. To update the
# palettes, edit the upstream aa_palettes.json (NOT the hex values in any R
# code) and re-copy it here. NEVER edit hex values by hand.
#
# This script simply refreshes the bundled copy from the project-root source and
# sanity-checks it, so the three sibling packages (aapalette / pyaapalette /
# jalaapalette) all ship byte-identical colour data.

src <- "../aa_palettes.json"          # project-root source of truth
dst <- "inst/extdata/aa_palettes.json" # bundled copy used by the package

if (!file.exists(src)) {
  stop("Source of truth not found: ", src,
       "\nRun this script from the package root.")
}

file.copy(src, dst, overwrite = TRUE)
message("Copied ", src, " -> ", dst)

# Sanity check: every scheme must have 20 valid 6-digit hex colours.
data <- jsonlite::fromJSON(dst, simplifyVector = FALSE)
residues <- unlist(data$residues)
stopifnot(length(residues) == 20L)
hex_ok <- function(x) grepl("^#[0-9A-Fa-f]{6}$", x)

for (id in names(data$schemes)) {
  cols <- data$schemes[[id]]$colors
  missing <- setdiff(residues, names(cols))
  if (length(missing)) {
    stop("Scheme '", id, "' is missing residues: ",
         paste(missing, collapse = ", "))
  }
  bad <- residues[!vapply(residues, function(r) hex_ok(cols[[r]]), logical(1))]
  if (length(bad)) {
    stop("Scheme '", id, "' has invalid hex for: ",
         paste(bad, collapse = ", "))
  }
}
message("OK: ", length(data$schemes), " schemes x ", length(residues),
        " residues, all valid 6-digit hex.")
