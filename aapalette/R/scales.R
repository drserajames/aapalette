# ggplot2 discrete scales keyed on residue letters.
#
# These are thin wrappers around ggplot2::scale_*_manual(), so ggplot2 is only
# needed when the scales are actually used (it is in Suggests, not Imports).

# Build the named colour vector used by the manual scales: the 20 residues plus
# the unknown and gap defaults, so that data containing X/B/Z/J or gaps still
# resolves to a sensible colour.
.aa_scale_values <- function(scheme) {
  aa_palette(scheme, include_unknown = TRUE, include_gap = TRUE)
}

#' ggplot2 colour and fill scales for amino-acid residues
#'
#' Discrete manual scales that map residue letters to the colours of an
#' AApalette scheme. Residue values are matched by their one-letter code;
#' unknown/ambiguous codes (`X`, `B`, `Z`, `J`) and gap symbols (`-`, `.`) use
#' the documented defaults. The `na.value` also defaults to the unknown colour,
#' so unmatched levels degrade gracefully.
#'
#' `scale_color_aa()` is an alias of `scale_colour_aa()` (American spelling).
#'
#' @param scheme Scheme id (see [aa_schemes()]). Defaults to `"typical"`.
#' @param ... Further arguments passed to [ggplot2::scale_colour_manual()] or
#'   [ggplot2::scale_fill_manual()] (for example `name`, `breaks`, `guide`).
#' @param na.value Colour used for values not present in the palette. Defaults
#'   to the unknown/ambiguous colour (`#BEBEBE`).
#'
#' @return A ggplot2 scale object.
#'
#' @examplesIf requireNamespace("ggplot2", quietly = TRUE)
#' library(ggplot2)
#' df <- data.frame(
#'   residue = factor(c("A", "C", "D", "E", "K", "R")),
#'   x = 1:6, y = 1
#' )
#' ggplot(df, aes(x, y, colour = residue)) +
#'   geom_point(size = 8) +
#'   scale_colour_aa("typical")
#' @name scale_aa
#' @export
scale_colour_aa <- function(scheme = "typical", ..., na.value = NULL) {
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("ggplot2 is required for scale_colour_aa(); please install it.",
         call. = FALSE)
  }
  if (is.null(na.value)) na.value <- as.character(.aa_defaults()$unknown_XBZJ)
  ggplot2::scale_colour_manual(
    values = .aa_scale_values(scheme),
    na.value = na.value,
    ...
  )
}

#' @rdname scale_aa
#' @export
scale_color_aa <- function(scheme = "typical", ..., na.value = NULL) {
  scale_colour_aa(scheme = scheme, ..., na.value = na.value)
}

#' @rdname scale_aa
#' @export
scale_fill_aa <- function(scheme = "typical", ..., na.value = NULL) {
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("ggplot2 is required for scale_fill_aa(); please install it.",
         call. = FALSE)
  }
  if (is.null(na.value)) na.value <- as.character(.aa_defaults()$unknown_XBZJ)
  ggplot2::scale_fill_manual(
    values = .aa_scale_values(scheme),
    na.value = na.value,
    ...
  )
}
