#' List the available amino-acid colour schemes
#'
#' Returns a data frame describing the ten bundled schemes: the three new
#' AApalette palettes (`hue`, `redgreen`, `tritan`) and the seven attributed
#' community-standard schemes (`clustal`, `zappo`, `taylor`, `lesk`, `cinema`,
#' `rasmol`, `shapely`).
#'
#' @return A data frame with one row per scheme and columns `id`, `label`,
#'   `kind`, `vision` and `source`. The rows are in the order the schemes appear
#'   in the bundled JSON.
#'
#' @seealso [aa_palette()] to obtain the colours, [aa_scheme_info()] for the
#'   full metadata of a single scheme.
#' @export
#' @examples
#' aa_schemes()
aa_schemes <- function() {
  schemes <- .aa_data()$schemes
  ids <- names(schemes)
  pull <- function(field) {
    vapply(
      schemes,
      function(s) {
        v <- s[[field]]
        if (is.null(v)) NA_character_ else as.character(v)
      },
      character(1)
    )
  }
  data.frame(
    id = ids,
    label = pull("label"),
    kind = pull("kind"),
    vision = pull("vision"),
    source = pull("source"),
    stringsAsFactors = FALSE,
    row.names = NULL
  )
}

#' Get the colour palette for one scheme
#'
#' Returns a named character vector mapping residue letters to uppercase hex
#' colours, in the canonical residue order
#' `A C D E F G H I K L M N P Q R S T V W Y`. Optionally appends the documented
#' defaults for unknown/ambiguous codes and for gaps.
#'
#' @param scheme Scheme id (see [aa_schemes()]). Defaults to `"hue"`, the
#'   recommended palette for normal vision.
#' @param include_unknown If `TRUE`, append the unknown/ambiguous colour under
#'   the names `X`, `B`, `Z`, `J` (all the same `#BEBEBE` by default).
#' @param include_gap If `TRUE`, append the gap colour under the names `-` and
#'   `.` (both `#FFFFFF` by default).
#'
#' @details
#' The classical schemes colour residues by property group, so several residues
#' share a colour; every one of the 20 standard residues is nonetheless assigned
#' a colour. Unknown codes (`X`, `B`, `Z`, `J`) and gaps (`-`, `.`) are handled
#' identically across the R, Python and Jalview siblings via the `defaults`
#' block of the bundled JSON.
#'
#' @return A named character vector of hex colours.
#'
#' @seealso [aa_color()] / [aa_colour()] to look up colours for an arbitrary
#'   sequence (including lower-case, unknown and gap symbols).
#' @export
#' @examples
#' aa_palette("hue")
#' aa_palette("clustal", include_unknown = TRUE, include_gap = TRUE)
aa_palette <- function(scheme = "hue",
                       include_unknown = FALSE,
                       include_gap = FALSE) {
  scheme <- .aa_match_scheme(scheme)
  residues <- .aa_residues()
  colors <- .aa_data()$schemes[[scheme]]$colors

  pal <- vapply(residues, function(r) as.character(colors[[r]]), character(1))
  names(pal) <- residues

  defaults <- .aa_defaults()
  if (isTRUE(include_unknown)) {
    unknown <- rep(as.character(defaults$unknown_XBZJ), length(.aa_unknown_codes))
    names(unknown) <- .aa_unknown_codes
    pal <- c(pal, unknown)
  }
  if (isTRUE(include_gap)) {
    gap <- rep(as.character(defaults$gap), length(.aa_gap_codes))
    names(gap) <- .aa_gap_codes
    pal <- c(pal, gap)
  }
  pal
}

#' Metadata for a single scheme
#'
#' @param scheme Scheme id (see [aa_schemes()]).
#'
#' @return A list with elements `id`, `label`, `kind`, `vision`, `source`, and -
#'   where present in the source data - `min_deltaE` (a named list of CIEDE2000
#'   minima per vision type), `names` (per-residue colour names) and `note`.
#'
#' @export
#' @examples
#' info <- aa_scheme_info("hue")
#' info$label
#' info$min_deltaE
aa_scheme_info <- function(scheme) {
  scheme <- .aa_match_scheme(scheme)
  s <- .aa_data()$schemes[[scheme]]
  out <- list(
    id = scheme,
    label = s$label,
    kind = s$kind,
    vision = s$vision,
    source = s$source
  )
  if (!is.null(s$min_deltaE)) out$min_deltaE <- s$min_deltaE
  if (!is.null(s$names)) out$names <- s$names
  if (!is.null(s$note)) out$note <- s$note
  out
}

#' Recommended schemes by vision type
#'
#' @return A named character vector with elements `normal`, `red_green_cvd` and
#'   `tritan_cvd`, giving the scheme id recommended for each.
#' @export
#' @examples
#' aa_recommended()
aa_recommended <- function() {
  rec <- .aa_data()$recommended
  unlist(rec)
}

#' Look up colours for residues in a sequence
#'
#' Vectorised residue -> hex lookup that accepts lower-case letters (treated as
#' upper-case), unknown/ambiguous codes (`X`, `B`, `Z`, `J` -> `#BEBEBE`) and
#' gap symbols (`-`, `.` -> `#FFFFFF`). Any other unrecognised symbol also falls
#' back to the unknown colour.
#'
#' @param residues Character vector of one-letter residue codes (e.g. the result
#'   of `strsplit(seq, "")`).
#' @param scheme Scheme id (see [aa_schemes()]). Defaults to `"hue"`.
#'
#' @return A character vector of hex colours, the same length as `residues`.
#'
#' @export
#' @examples
#' aa_colour(strsplit("ACDXacd-", "")[[1]])
aa_colour <- function(residues, scheme = "hue") {
  scheme <- .aa_match_scheme(scheme)
  pal <- aa_palette(scheme)
  defaults <- .aa_defaults()
  up <- toupper(as.character(residues))

  out <- unname(pal[up])
  # Gaps.
  out[up %in% .aa_gap_codes] <- as.character(defaults$gap)
  # Anything still unmatched (unknown/ambiguous codes and stray symbols).
  out[is.na(out)] <- as.character(defaults$unknown_XBZJ)
  out
}

#' @rdname aa_colour
#' @export
aa_color <- function(residues, scheme = "hue") {
  aa_colour(residues, scheme = scheme)
}
