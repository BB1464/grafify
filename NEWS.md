---
output:
  html_document: default
  pdf_document: default
---
# Release notes:

Full reference to all functions available at [`grafify` GitHub pages](https://ashenoy-cmbi.github.io/grafify/index.html). There are also updates within all `plot_` functions, which are a `facet` argument, and log-transformations with axis tick marks.

# grafify v3.0.0

## Major updates 

This is a major update for `grafify`, which now provides wrappers for basic generalised additive models (`gam`) through the [`mgcv` package](https://CRAN.R-project.org/package=mgcv). There are a more `plot_` functions, a `grafify` theme for `ggplot` objects, and simple data wrangling before plotting.  

## Major additions

1. Fit generalised additive models (gam) and get ANOVA tables with two new functions: `ga_model` and `ga_anova`. These are mainly for time-series analyses or where an assumption of linear relationship between predictor and outcomes is absent straight lines are not appropriate. Factor-wise smooths are fit with the `by` argument in `mgcv`, without or with a random factor. Random factors are also allowed with smooth  `re` smooth. See documentation for `mgcv` [smooths](https://noamross.github.io/gams-in-r-course/). Model diagnostics can be done with `plot_qq_gam` and `plot_qq_model`. Example data included as  `data_zooplankton` is from [Lathro RC, 2000](http://dx.doi.org/10.6073/pasta/ec3d0186753985147d4f283252388e05). 

2. All `plot_` functions now have two major updates:

a. Log-transformation of axes: Axes can be transformed with `log10` or `log2` with `LogYTrans` and `LogXTrans` arguments. X axis transformations are only available for `plot_xy_CatGroup` and `plot_xy_NumGroup`. With `log10` transformation, log-ticks will also appear. Default axes limits and labels should work in most cases, but if needed, three additional arguments are available: `LogYBreaks`, `LogYLimits` and `LogYLabels` (and respective ones for the X axis). 
b. `facet` argument to add another variable to created faceted plots with the `facet_wrap` layer in `ggplot2`. A related argument `facet_scales` can be used to set Y or X axis scales on faceted panels.

3. New plot functions:

a. `plot_befafter_box` is a new before-after plot function that includes a box and whisker plot to show data distribution in addition to lines joining matched data. In addition, both `plot_befafter_colour` and `plot_befafter_shapes` offer a box and whiskers summary of data.

b. `plot_lm_predict` and `plot_gam_predict` can be used to plot observed (raw) data and predicted data from fitted linear models.

c. `plot_logscales` is a function to easily perform "log10" or "log2" transformation on X or Y axes of any `ggplot2` object along with log-ticks.

4. Table manipulations:

a. `table_x_reorder` is a function to reorder levels within a categorical variable. This uses `factor` from base R `stats` package to convert a column into a factor and reorders it based on a user-provided vector of group names.

b. `table_summary` is a wrapper around `aggregate` (base R) function, which gives mean, median, SD, and counts grouped by one or more variables. 

5. A `grafify` theme for `ggplot2`: `theme_grafify` is a modification of `theme_classic` for making publication-ready `grafify`-like graphs easily when using `ggplot2`.

## Minor changes

Much of the code has been edited and cleaned up. Among the main change is dropping unnecessary double curly brackets `{{ }}` within `plot_` wrappers.

# grafify v2.3.0

The main motivation behind this update was to simplify the package by reducing the number of exported functions. So some features that were previously in separate functions have been made available more easily via an additional argument to existing functions (e.g. single colour function (`plot_..._sc`) now offered in respective `plot_` function with a new argument (see below). This has uncluttered the namespace of `grafify`. Most of the other additions are related to colour schemes.

## Major additions

1. A new `SingleColour` argument has been added to two-variables `plot_` functions to generate graphs with a single colour along the X-axis aesthetic. This means the 8 `plot_..._sc` functions introduced in v1.5.0 are deprecated, but this feature is still retained in existing `plot_` functions. This option also added to `plot_3d_` functions for plots of one-way ANOVA data.

2. Four new colourblind-friendly categorical colour schemes (chosen from [cols4all](https://github.com/mtennekes/cols4all) package):

- `fishy`, `kelly`, `r4`, `safe` 

3. Four new quantitative schemes for continuous or divergent colours.

- sequential/continuous: `blue_conti`, `grey_conti` 
- divergent: `OrBl_div`, `PrGn_div`

All schemes also available through `scale_fill..` and `scale_colour_...` calls to be used on any `ggplot2` object.

4. `scale_fill_grafify` and `scale_colour_grafify` (or `scale_color_grafify`) have been rewritten. These have two new arguments that offer features previously in `scale_fill_grafify2`/`scale_colour_grafify2`/ `scale_color_grafify_c` and `scale_fill_grafify_c`/`scale_colour_grafify_c`/ `scale_color_grafify_C` scale functions. These 6 functions are now deprecated to reduce exported namespace. 

The new arguments are `discrete` (logical T/F) to select discrete or continuous palettes, and `ColSeq` (logical T/F) to pick sequential or distant colours from a chosen palette.

## Minor changes & bug fixes

1. Fixed the error in legend title in one-way ANOVA plots with `plot_3d_` that incorrectly referred to `xcol` and `shapes` arguments. 
2. Fixed the error that led to depiction of different shapes in `plot_3d_scatterviolin` as compared to the other two `plot_3d_` functions.
2. `posthoc_Trends...` functions rewritten with `stats::model.frame()` to get model data frame as this is a more flexible method.
3. Order of colours in `light`, `bright` and `muted` schemes changed slightly for better separation of colours when next to each other.
4. The `jitter` setting in `plot_scaltter_` is set to `0.2` so the graph as plotted with jitter by default.  
5. The default colour scheme for all graphs is now `okabe_ito` (the `all_grafify` palette is  was just a concatenation of all palettes without real basis in good visualisation). Use one of the other palettes if more than 8 colours are needed (e.g. `kelly`, which has 20 discreet colours).

# grafify v2.2.0

## New features

`plot_3d_scatterviolin` and `plot_4d_scatterviolin` for one-way or two-way ANOVA design data to plot scatter plots with violins with box and whiskers. 

## Minor fixes

`plot_qqmodel` no longer relies on `broom.mixed`; instead uses `rstudent` from the base `stats` package to generate studentized residuals from a model.

# grafify v2.1.0

## New features

New experimental functions to compare slopes of linear regression via `posthoc_Trends_Pairwise`, `posthoc_Trends_Levelwise` and `posthoc_Trends_vsRef`.

## Minor fixes

Minor changes to `plot_qqmodel` and `plot_qqline` to fix some OS-specific errors. QQ plots by default will have `ok_orange` colour within symbols when only one level is present within `group`. Both functions now use `geom_qq` and `geom_qq_line` (instead of `stat_qq` and `stat_qq_line`) internally.

# grafify v2.0.0

This is a major update with some new features, bugfixes, and further cleaning up of code with consistent names of arguments in preparation for CRAN submission. Some previous code may not work because of renaming of some arguments for grouping variables in `plot_` functions. But older arguments are retained with deprecation warnings in most cases, so old code should largely work.

## New features

  a. `plot_` functions have a new argument `ColSeq` (logical TRUE/FALSE) that picks colours sequentially from palette chosen by `ColPal` when `TRUE` (default). If set to `FALSE`, the most distant colours are chosen, as already implemented in `scale_..._grafify2` functions.
  b. Violin plots get a major face-lift with a box-whiskers plot on top of the violin. This gives a clearer picture of data and dispersion than the default quantile lines in `geom_violin`. They also get new arguments to set thickness of lines (`bvthick`) and transparency of boxplots (`b_alpha`).
  c. There are new functions for fitting linear models with varying slopes and intercepts. These are `mixed_model_slopes` and `mixed_anova_slopes`.
  d. A function for comparing slopes of linear fits `posthoc_Trends` implements the `emmeans::emtrends` call.  
  e. Most `plot_` functions now have the `...` argument forwarding dots for advanced users to add arguments to `ggplot` geometries where necessary.
  f. New `plot_grafify_palette` function that helps quickly visualise colours in palettes along with their names and hexcodes.
  g. `plot_bar_sd` and `plot_bar_sd_sc` have a new argument `bthick` to adjust the thickness of lines of the bars.

## Bug fixes

  a. Distribution plots: the The `Group` grouping argument in `plot_density`, `plot_histogram` and `plot_qqline` is now called `group` for consistency with other `plot_` functions.
  c. The `Factor` argument in post-hoc comparisons functions (`posthoc_Pairwise`, `posthoc_vsRes`, and `posthoc_Levelwise`) renamed as `Fixed_Factor` to be consistent with `mixed_model`, `simple_model`, `mixed_anova` and `simple_anova` functions.
  d. The `plot_3d_scatterbar` and `plot_3d_scatterbox` now correctly plot one-way ANOVA designs with randomised blocks with `shapes` mapped to levels of the random factor, and `xcol` as the grouping factor as originally intended but incorrectly implemented. This complements `plot_4d_scatterbar` and `plot_4d_scatterbox` which take two grouping factors and a random factor.
  e. Examples in help files have arguments explicitly labelled to make them easier to follow.
  f. `groups` in before-after plots is now called `match` as it is a bit more informative when showing matched data. 
  g. For consistency, the argument for controlling opacity in distribution plots is renamed `c_alpha` in `plot_density` and `plot_histogram` (for colour opacity of colours under the density curve or histogram); opacity of symbols in `plot_qqline` is still called `s_alpha`.


# grafify v1.5.1

This update fixes and cleans up code to remove all errors, warnings and notes from `devtools::check()`. All previous code should still work. 

 a. The main update is that `broom.mixed::augment` is used to get model residuals than the `fortify` method as this will be deprecated soon. The `broom.mixed` package therefore required. 
 b. The way ANOVA table is generated no longer relies on an internal function from `lmerTest`, but instead forces a mixed model object as `lmerModLmerTest` object to get F and P values in ANOVA tables from the `stats::anova` call.
 c. The `magrittr` package is required for internal use of pipes (`%>%`).
 d. Much of the code for `simple_model` and `mixed_model` was cleaned up so that model outputs are as close to objects generated by native calls to `lm` or `lmer`.
 e. Several internal functions related to the colour palettes have now been exported as this was easier.
 f. The `make_1w_rb_data` and `make_2w_rb_data` functions have been updated to have consistent factor and level names.

# grafify v1.5.0

## Major fixes 

1. New graph types

This version has 8 new `plot_` functions ending in `_sc` for plotting data with two variables wherein the X variable is plotted in a single colour. This contrasts existing versions that plot the X variable with multiple colours chosen from the `all_grafify` palette. This is convenient when there are too many groups on the X axis and multiple colours are not necessary.

2. Plotting Q-Q plot of model residuals

`plot_qqmodel` will plot a diagnostic Q-Q plot of a simple linear model (generated with `simple_model` or `lm`) or mixed effects linear model (generated with `mixed_model` or `lmer`) in a single step.

## Minor fixes

Fixed a typo in `posthoc_Levelwise` where the `adjust` argument was not being correctly passed on to `emmeans`.


# grafify v1.4.1

This version "breaks" a few arguments from v0.3.1, therefore is v1.4.1. Specifically, opacity for both symbols and bars/boxes/violins can be set using `s_alpha` and `b_alpha` or `v_alpha`, respectively; previously, only bars/boxes/violin opacity could be set with a single `alpha` parameter. Old code with just `alpha` will no longer work, sorry! There are also new graph types and arguments for ANOVAs as below.

## Major fixes 

1. New graph types
   
    a. `plot_density` and `plot_histogram` for smooth density or histogram plots through `geom_density` and `geom_histogram` respectively.
    b. two new plot types `plot_scatterbox` and `plot_scatterviolin` that complement the `plot_dot...` versions and instead use `geom_point` with `position_jitter`. These versions are useful when a large number of data points are needed to be plotted.
    
1. Updates 

      a. `simple_anova` where the table also has Mean SS.
      b. `mixed_anova` now has two new arguments, one to change method for Df calculation and second to get type I or III SS (default is type II).
      c. `jitter` argument added to `plot_3d..` and `plot_4d..` functions for consistency with other scatter plots.
      d. `bwid` argument (for adjusting width of bars) added to `plot_scatterbar_sd` for consistency.

# grafify v0.3.1

Bug fixes in `mixed_model` and `simple_model` which now correctly lists the data used in the call field. 

# grafify v0.3.0

1. A new `plot_4d_scatterbar` function which is like `plot_4d_scatterbox` but plots bar and SD. So there are now two `plot_3d_` and `plot_4d_` functions.
2. Text on X-axis on all graphs can be rotated from 0-90 using `TextXAngle` argument to prevent overlap. 
3. `plot_dot_` functions now have `dotthick` option to set stroke thickness. This is similar to `symthick` for scatter/jitter plots.
4. Using `facet_wrap` or `facet_grid` will not draw a box around panel text (unlike the default in `theme_classic()`).
5. `plot_3d_` and `plot_4d_` functions draw symbols in black colour. 

# grafify v0.2.1:

1. Bug fixes in `plot_3d_scatterbar` and `plot_3d_scatterbox`, which now correctly use the "shapes" variable to fill colour of bars/boxes and shape of the symbols; symbols are depicted in black.
2. `simple_anova` generates type II ANOVA table through `car::Anova()`, so the `car` package is now a dependency. v0.1.0 and v0.2.0 generated type I ANOVA table through `stats::anova()`. 

# grafify v0.2.0:

1. the main difference from v0.1.0 is that all `plot_` functions apply the `all_grafify` colour scheme by default (see `plot_` vignettes on how to change colours)
2. two new types of graphs are possible with two quantitative X-Y plots with a third variable that is either numeric (`plot_xy_NumGroup`) or categorical (`plot_xy_CatGroup`).
3. there are two new continuous colour schemes (`scale_fill_grafify_c` and `scale_colour_grafify_c`), based on [Paul Tol's variant](https://personal.sron.nl/~pault/#sec:sequential) of YlOrBl scheme.

### Minor changes

1. `plot_befafter...` functions have a new logical TRUE/FALSE argument called `boxplot` to additionally show a box and whisker plot to show data distribution.


# grafify v0.1.0

First release. 
