# The authoritative checks required by the shared brief:
#   (a) load the bundled JSON,
#   (b) every scheme has 20 valid 6-digit hex colours,
#   (c) the package's palettes equal the JSON exactly.

# Independent re-read of the bundled JSON (do not go through the package API,
# so the comparison is meaningful).
raw <- jsonlite::fromJSON(
  system.file("extdata", "aa_palettes.json", package = "aapalette"),
  simplifyVector = FALSE
)

EXPECTED_IDS <- c("hue", "redgreen", "tritan", "clustal", "zappo",
                  "taylor", "lesk", "cinema", "rasmol", "shapely")
CANONICAL_RESIDUES <- c("A", "C", "D", "E", "F", "G", "H", "I", "K", "L",
                        "M", "N", "P", "Q", "R", "S", "T", "V", "W", "Y")
HEX6 <- "^#[0-9A-F]{6}$"

test_that("bundled JSON has the expected residues and schemes", {
  expect_identical(unlist(raw$residues), CANONICAL_RESIDUES)
  expect_setequal(names(raw$schemes), EXPECTED_IDS)
  expect_length(raw$schemes, 10L)
})

test_that("aa_schemes() lists the ten schemes with metadata", {
  s <- aa_schemes()
  expect_s3_class(s, "data.frame")
  expect_setequal(s$id, EXPECTED_IDS)
  expect_true(all(nzchar(s$label)))
  expect_true(all(nzchar(s$source)))
})

test_that("every scheme has 20 valid 6-digit hex colours (uppercase)", {
  for (id in EXPECTED_IDS) {
    pal <- aa_palette(id)
    expect_named(pal, CANONICAL_RESIDUES, info = id)
    expect_length(pal, 20L)
    expect_true(all(grepl(HEX6, pal)), info = id)
  }
})

test_that("package palettes equal the JSON exactly", {
  for (id in EXPECTED_IDS) {
    pal <- aa_palette(id)
    json_cols <- vapply(
      CANONICAL_RESIDUES,
      function(r) as.character(raw$schemes[[id]]$colors[[r]]),
      character(1)
    )
    names(json_cols) <- CANONICAL_RESIDUES
    expect_identical(pal, json_cols, info = id)
  }
})

test_that("residue order is canonical", {
  expect_identical(names(aa_palette("hue")), CANONICAL_RESIDUES)
  expect_identical(names(aa_palette("shapely")), CANONICAL_RESIDUES)
})

test_that("unknown and gap defaults match the JSON", {
  pal <- aa_palette("hue", include_unknown = TRUE, include_gap = TRUE)
  unk <- toupper(as.character(raw$defaults$unknown_XBZJ))
  gap <- toupper(as.character(raw$defaults$gap))
  expect_equal(unname(pal[c("X", "B", "Z", "J")]), rep(unk, 4))
  expect_equal(unname(pal[c("-", ".")]), rep(gap, 2))
})

test_that("aa_colour handles lower-case, unknown, gap and stray symbols", {
  cols <- aa_colour(strsplit("ACDXacd-.?", "")[[1]], "hue")
  hue <- aa_palette("hue")
  unk <- as.character(raw$defaults$unknown_XBZJ)
  gap <- as.character(raw$defaults$gap)
  expect_equal(cols[1], unname(hue["A"]))   # A
  expect_equal(cols[4], unk)                # X -> unknown
  expect_equal(cols[5], unname(hue["A"]))   # a -> A
  expect_equal(cols[8], gap)                # - -> gap
  expect_equal(cols[9], gap)                # . -> gap
  expect_equal(cols[10], unk)               # ? -> unknown fallback
  # aa_color() is an exact alias.
  expect_identical(aa_color(c("a", "x"), "zappo"),
                   aa_colour(c("a", "x"), "zappo"))
})

test_that("aa_scheme_info exposes label/source/vision and extras where present", {
  hue <- aa_scheme_info("hue")
  expect_equal(hue$label, raw$schemes$hue$label)
  expect_equal(hue$source, raw$schemes$hue$source)
  expect_equal(hue$vision, raw$schemes$hue$vision)
  expect_false(is.null(hue$min_deltaE))
  expect_false(is.null(hue$names))
  # A classical scheme has no min_deltaE / names.
  clustal <- aa_scheme_info("clustal")
  expect_null(clustal$min_deltaE)
  expect_null(clustal$names)
})

test_that("aa_recommended matches the JSON recommendations", {
  rec <- aa_recommended()
  expect_equal(unname(rec["normal"]), "hue")
  expect_equal(unname(rec["red_green_cvd"]), "redgreen")
  expect_equal(unname(rec["tritan_cvd"]), "tritan")
})

test_that("unknown scheme ids error informatively", {
  expect_error(aa_palette("nope"), "Unknown scheme")
  expect_error(aa_scheme_info("nope"), "Unknown scheme")
})

test_that("ggplot2 scales build when ggplot2 is available", {
  skip_if_not_installed("ggplot2")
  expect_s3_class(scale_colour_aa("hue"), "Scale")
  expect_s3_class(scale_color_aa("hue"), "Scale")
  expect_s3_class(scale_fill_aa("redgreen"), "Scale")
})

test_that("plot_aa_palette returns the palette invisibly", {
  tmp <- tempfile(fileext = ".pdf")
  grDevices::pdf(tmp)
  on.exit({ grDevices::dev.off(); unlink(tmp) }, add = TRUE)
  res <- plot_aa_palette("tritan")
  expect_named(res, CANONICAL_RESIDUES)
})
