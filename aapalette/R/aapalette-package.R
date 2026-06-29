#' aapalette: Amino-Acid Colour Palettes for Sequence Visualisation
#'
#' A curated set of amino-acid colour palettes, loaded from a single bundled
#' JSON source of truth (`inst/extdata/aa_palettes.json`) so that the R, Python
#' and Jalview siblings stay consistent.
#'
#' Three new palettes come from the AApalette project: `hue` (normal vision),
#' `redgreen` (red-green colour-vision deficiency) and `tritan` (tritanopia).
#' Seven attributed community-standard schemes are also provided: `clustal`,
#' `zappo`, `taylor`, `lesk`, `cinema`, `rasmol` and `shapely`.
#'
#' @section Colour-vision caveat:
#' No 20-colour palette is safe for all deficiencies at once; for robust figures
#' pair colour with the residue letter (redundant coding). The `min_deltaE`
#' values reported by [aa_scheme_info()] are CIEDE2000 minima.
#'
#' @section Key functions:
#' \itemize{
#'   \item [aa_schemes()] - list the available schemes and their metadata.
#'   \item [aa_palette()] - get a residue -> hex named vector for one scheme.
#'   \item [aa_scheme_info()] - metadata for one scheme.
#'   \item [scale_colour_aa()] / [scale_fill_aa()] - ggplot2 discrete scales.
#'   \item [plot_aa_palette()] - draw a swatch of a scheme.
#' }
#'
#' @keywords internal
"_PACKAGE"
