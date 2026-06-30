# aapalette

<!-- aapalette logo (shields.io coloured residues) -->
![A](https://img.shields.io/static/v1?label=&message=A&color=A8E4A0&style=flat-square)![A](https://img.shields.io/static/v1?label=&message=A&color=A8E4A0&style=flat-square)![P](https://img.shields.io/static/v1?label=&message=P&color=A44DD7&style=flat-square)![A](https://img.shields.io/static/v1?label=&message=A&color=A8E4A0&style=flat-square)![L](https://img.shields.io/static/v1?label=&message=L&color=2ADB2A&style=flat-square)![E](https://img.shields.io/static/v1?label=&message=E&color=EE3B5C&style=flat-square)![T](https://img.shields.io/static/v1?label=&message=T&color=CC7228&style=flat-square)![T](https://img.shields.io/static/v1?label=&message=T&color=CC7228&style=flat-square)![E](https://img.shields.io/static/v1?label=&message=E&color=EE3B5C&style=flat-square)

Consistent, colour-vision-aware **amino-acid colour palettes** for R.

`aapalette` ships ten amino-acid colour schemes — three new colour-vision-aware
alphabets from the AApalette project plus seven attributed community-standard
schemes — all read from a single bundled `aa_palettes.json` that is the source of
truth shared with the sibling packages
[`pyaapalette`](https://github.com/drserajames/pyaapalette) (Python) and
[`jalaapalette`](https://github.com/drserajames/jalaapalette) (Jalview). The
three packages use identical scheme IDs, identical hex values, and identical
residue handling.

> **Note:** the R package source lives in the [`aapalette/`](aapalette)
> subdirectory of this repository (the repo also keeps the build artifacts and
> the shared `aa_palettes.json`). Install commands below account for this.

## Install

```r
# install.packages("remotes")
remotes::install_github("drserajames/aapalette", subdir = "aapalette")
```

or from a local checkout:

```r
R CMD INSTALL aapalette        # the package subdirectory
```

## Quick start

```r
library(aapalette)

aa_schemes()              # the 10 available schemes + metadata
aa_palette("hue")         # named vector: residue -> hex (typical-colour-vision default)
aa_palette("redgreen")    # red-green colour-blind-safe
aa_palette("tritan")      # tritanopia-safe
plot_aa_palette("hue")    # quick swatch

# ggplot2 integration
library(ggplot2)
d <- data.frame(aa = names(aa_palette("hue")), y = 1)
ggplot(d, aes(aa, y, fill = aa)) + geom_col() + scale_fill_aa("hue")
```

## The 10 schemes

**New (this project, CC-BY-4.0)** — recommended:

| ID | For |
| --- | --- |
| `hue` | typical colour vision (property-coherent, letter-mnemonic; the default) |
| `redgreen` | red-green colour-vision deficiency (deuteranopia & protanopia) |
| `tritan` | tritanopia |

**Classical (community-standard, attributed):**
`clustal`, `zappo`, `taylor`, `lesk`, `cinema`, `rasmol`, `shapely`.

See [`aapalette/README.md`](aapalette/README.md) for the full per-scheme table,
function reference, and ΔE distinguishability statistics.

## Colour-vision caveat

No 20-colour palette can be distinguished by every viewer under every deficiency
simultaneously (red-green and blue-yellow safety pull in opposite directions).
For robust figures, pair colour with the residue letter (redundant coding), as
sequence logos and alignment viewers already do. Reported ΔE values are CIEDE2000
minima.

## Attribution & licence

- The new schemes `hue`, `redgreen`, `tritan` are from the **AApalette** project
  and released **CC-BY-4.0**.
- The classical schemes are attributed to their sources (Clustal X / Jalview;
  Zappo / Jalview; Taylor 1997; Lesk; CINEMA, Parry-Smith et al. 1998; RasMol
  amino; RasMol/Jmol shapely) and are **not** relicensed.
- Code is released under the **MIT** licence; colour data under **CC-BY-4.0**.

Polychrome, Green-Armytage, and Biotite/Gecos (flower/blossom/sunset) palettes
are intentionally **not** included.
