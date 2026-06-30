#' Draw a swatch of an amino-acid colour scheme
#'
#' Renders the 20 residue colours of a scheme as a row of labelled swatches
#' using base graphics. Useful for a quick visual check or for the README
#' example. Each swatch is labelled with the residue letter (redundant coding),
#' echoing the recommendation to pair colour with the letter.
#'
#' @param scheme Scheme id (see [aa_schemes()]). Defaults to `"typical"`.
#' @param border Colour of the swatch borders. Defaults to `"grey20"`.
#' @param label If `TRUE` (default), draw the residue letter on each swatch.
#'
#' @return Invisibly, the named colour vector that was plotted.
#'
#' @export
#' @examples
#' op <- par(no.readonly = TRUE)
#' plot_aa_palette("typical")
#' par(op)
plot_aa_palette <- function(scheme = "typical", border = "grey20", label = TRUE) {
  scheme <- .aa_match_scheme(scheme)
  pal <- aa_palette(scheme)
  n <- length(pal)
  info <- aa_scheme_info(scheme)

  op <- graphics::par(mar = c(2, 1, 3, 1))
  on.exit(graphics::par(op), add = TRUE)

  graphics::plot.new()
  graphics::plot.window(xlim = c(0, n), ylim = c(0, 1))
  graphics::rect(
    xleft = seq_len(n) - 1, ybottom = 0,
    xright = seq_len(n), ytop = 1,
    col = unname(pal), border = border
  )
  if (isTRUE(label)) {
    # Choose a readable text colour from the swatch luminance.
    rgb <- grDevices::col2rgb(unname(pal))
    lum <- 0.299 * rgb[1, ] + 0.587 * rgb[2, ] + 0.114 * rgb[3, ]
    txt <- ifelse(lum > 140, "black", "white")
    graphics::text(
      x = seq_len(n) - 0.5, y = 0.5,
      labels = names(pal), col = txt, font = 2
    )
  }
  graphics::mtext(info$label, side = 3, line = 1, font = 2)
  invisible(pal)
}
