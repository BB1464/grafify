#' Model from a linear mixed effects model with varying slopes
#'
#' There are four related functions for mixed effects analyses: \code{mixed_model}, \code{mixed_anova}, \code{mixed_model_slopes}, and \code{mixed_anova_slopes}.
#'
#' This function uses \code{\link[lme4]{lmer}} to fit a linear mixed effect model and provides the model object, which could be used for post-hoc comparisons. The model object is converted to class `lmerModLmerTest` object by \code{\link[lmerTest]{as_lmerModLmerTest}}.
#' It requires a data table, one dependent variable (Y_value), one or more independent variables (Fixed_Factor).  Exactly one random factor (Random_Factor) and Slope_Factor should be provided.
#' This function is related to \code{\link{mixed_anova_slopes}}. 
#' Output of this function can be used with \code{\link{posthoc_Pairwise}}, \code{\link{posthoc_Levelwise}} and \code{\link{posthoc_vsRef}}, or with \code{\link[emmeans]{emmeans}}.
#'
#' More than one fixed factors can be provided as a vector (e.g. c("A", "B")). A full model with interaction term is fitted with one term each for varying slopes and intercepts. 
#' This means when \code{Y_value = Y, Fixed_factor = c("A", "B"), Slopes_Factor = "S", Random_factor = "R"} are entered as arguments, these are passed on as \code{Y ~ A*B + (S|R)} (which is equivalent to \code{Y ~ A + B + A:B + (S|R)}).
#' In this experimental implementation, random slopes and intercepts are fitted (\code{(Slopes_Factor|Random_Factor)}). Only one term each is allowed for `Slopes_Factor` and `Random_Factor`.
#'
#' @param data a data table object, e.g. data.frame or tibble.
#' @param Y_value name of column containing quantitative (dependent) variable, provided within "quotes".
#' @param Fixed_Factor name(s) of categorical fixed factors (independent variables) provided as a vector if more than one or within "quotes".
#' @param Slopes_Factor name of factor to allow varying slopes on. 
#' @param Random_Factor name(s) of random factors to allow random intercepts; to be provided as a vector when more than one or within "quotes".
#' @param ... any additional arguments to pass on to \code{\link[lme4]{lmer}} if required.
#'
#' @return This function returns an S4 object of class "lmerModLmerTest".
#' @export mixed_model_slopes
#' @importFrom lme4 lmer
#' @importFrom lmerTest as_lmerModLmerTest
#' @importFrom stats as.formula
#'
#' @examples
#' #two fixed factors as a vector, 
#' #exactly one slope factor and random factor
#' mod <- mixed_model_slopes(data = data_2w_Tdeath,
#' Y_value = "PI",
#' Fixed_Factor = c("Genotype", "Time"),
#' Slopes_Factor = "Time",
#' Random_Factor = "Experiment")
#' #get summary
#' summary(mod)

mixed_model_slopes <- function(data, Y_value, Fixed_Factor, Slopes_Factor, Random_Factor, ...){
  Y <- substitute(Y_value)
  d <- substitute(data)
  ifelse(length(Fixed_Factor) == 1,
         Facs <- paste0(Fixed_Factor, collapse = ""),
         Facs <- paste0(Fixed_Factor, collapse = "*"))
  if (length(Slopes_Factor) > 1) stop("Only one term for Slopes_Factor allowed; more than 1 supplied")
  ifelse((length(Random_Factor) == 1),
         RFacs <- paste0("(", Slopes_Factor, "|", Random_Factor, ")"),
         stop("Only 1 random factor allowed; more than 1 supplied"))
  
  fo <- as.formula(paste(Y,
                         paste(paste(Facs, collapse = ""),
                               paste(RFacs, collapse = ""),
                               sep = "+"),
                         sep = " ~ "))
  call1 <- paste0("lmer(formula = ", 
                  deparse1(fo), 
                  ", data = ", 
                  deparse1(d), 
                  ", ...)")
  mod1 <- eval(parse(text = call1))
  mod1 <- as_lmerModLmerTest(mod1)
  mod1
}
