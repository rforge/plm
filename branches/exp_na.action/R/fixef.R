## see function within_intercept to get overall intercept for FE models, 
## which is related to the fixef method

fixef.plm <- function(object, effect = NULL,
                      type = c("level", "dfirst", "dmean"),
                      .vcov = NULL, ...){
  model.effect <- describe(object, "effect")
  if (is.null(effect)){
    effect <- ifelse(model.effect == "time", "time", "individual")
  }
  else{
    if (!effect %in% c("individual", "time")) stop("wrong effect argument")
    if (model.effect != "twoways" && model.effect != effect) stop("wrong effect argument")
  }
    
  type <- match.arg(type)
  mf <- model.frame(object)
  if (!is.null(object$call)){
    if (describe(object, "model") != "within")
      stop("fixef is relevant only for within models")
  }
  formula <- formula(object)
  data <- model.frame(object)
  
  # For procedure to get the individual/time effects by muliplying the within
  # estimates with the between-ed data, see Wooldridge (2010), Econometric Analysis 
  # of Cross Section and Panel Data, 2nd ed., pp. 308-309, formula (10.58)
  #
  #   NB: this does not seem to give the correct result in the two-ways unbalanced case,
  #       all other cases work (twoways/balanced; oneway(ind/time)/balanced/unbalanced)
  
  Xb <- model.matrix(formula, data, rhs = 1, model = "between", effect = effect)
  yb <- pmodel.response(formula, data, model = "between", effect = effect)
  # the between model may contain time independent variables, the
  # within model doesn't. So select the relevant elements using nw
  # (names of the within variables)
  nw <- names(coef(object))
  fixef <- yb - as.vector(tcrossprod(coef(object), Xb[, nw, drop = FALSE]))
#  bet <- plm.between(formula, data, effect = effect)
  # Lignes suivantes inutiles ??????????
  ## bet <- plm.fit(formula, data, model = "between", effect = effect)
  ## bet$args <- list(model = "between", effect = effect)
  ## sigma2 <- deviance(bet) / df.residual(bet)
  
  
  # use robust vcov if supplied
  if (!is.null(.vcov)) {
    if (is.matrix(.vcov))   vcov <- .vcov[nw, nw]
    if (is.function(.vcov)) vcov <- .vcov(object)[nw, nw]
  } else {
    vcov <- vcov(object)[nw, nw]
  }
  
  nother <- switch(effect,
                    "individual" = pdim(object)$Tint$Ti,
                    "time"       = pdim(object)$Tint$nt)
  s2 <- deviance(object) / df.residual(object)
  if (type != "dfirst"){
    sefixef <- sqrt(s2 / nother + apply(Xb[, nw, drop = FALSE],1,function(x) t(x) %*% vcov %*% x))
  }
  else{
    Xb <- t(t(Xb[-1, ]) - Xb[1, ])
    sefixef <- sqrt(s2 * (1 / nother[-1] + 1 / nother[1])+
                    apply(Xb[, nw, drop = FALSE],1,function(x) t(x) %*% vcov %*% x))
  }
  fixef <- switch(type,
                  "level"  = fixef,
                  "dfirst" = fixef[2:length(fixef)] - fixef[1],
                  "dmean"  = fixef - mean(fixef)
                  )
  structure(fixef, se = sefixef, class = "fixef", type = type, df.residual = df.residual(object))
}


print.fixef <- function(x, digits = max(3, getOption("digits") - 2),
                        width = getOption("width"), ...){
  
  # prevent attributs from being printed
  attr(x,"se") <- attr(x,"type") <- attr(x,"class") <- attr(x, "df.residual") <- NULL
  print.default(x)
}


summary.fixef <- function(object, ...){
  se <- attr(object, "se")
  df.res <- attr(object, "df.residual")
  tvalue <- (object) / se
  # was: res <- cbind(object, se, zvalue, (1 - pnorm(abs(zvalue))) * 2)
  res <- cbind(object, se, tvalue, (2 * pt(abs(tvalue), df = df.res, lower.tail = FALSE)))
  # see for distribution and degrees of freedom
  #   Greene (2003, 5th ed.), p.  288     (formula 13-7) 
  # = Greene (2012, 7th ed.), pp. 361-362 (formula 11-19)
  colnames(res) <- c("Estimate", "Std. Error", "t-value", "Pr(>|t|)")
  class(res) <- "summary.fixef"
  res
}

print.summary.fixef <- function(x, digits = max(3, getOption("digits") - 2), width = getOption("width"), ...){
  printCoefmat(x, digits = digits)
}

fixef.pggls <- fixef.plm

