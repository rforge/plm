\name{plm}
\alias{plm}
\alias{has.intercept}
\alias{print.panelmodel}
\alias{plot.plm}

\title{Panel Data Estimators}

\description{
Linear models for panel data estimated using the \code{lm} function on transformed data.
}

\usage{
plm(formula, data, subset, na.action, effect = c("individual", "time", "twoways"),
    model = c("within", "random", "ht", "between", "pooling", "fd"),
    random.method = c("swar", "walhus", "amemiya", "nerlove", "kinla"),
    random.dfcor = NULL,
    inst.method = c("bvk", "baltagi", "am", "bmc"), restrict.matrix = NULL,
    restrict.rhs = NULL, index = NULL, ...)
\method{print}{panelmodel}(x,digits=max(3, getOption("digits") - 2), 
  width = getOption("width"),...)
\method{plot}{plm}(x, dx = 0.2, N = NULL, seed = 1,
    within = TRUE, pooling = TRUE, between = FALSE, random = FALSE, ...)
}

\arguments{
  \item{formula}{a symbolic description for the model to be estimated,}
  \item{x}{an object of class \code{"plm"},}
  \item{data}{a \code{data.frame},}
  \item{subset}{see \code{\link{lm}},}
  \item{na.action}{see \code{\link{lm}},}
  \item{effect}{the effects introduced in the model, one of
  \code{"individual"}, \code{"time"}, or \code{"twoways"},}
  \item{model}{one of \code{"pooling"}, \code{"within"},
    \code{"between"}, \code{"random",} \code{"fd"}, or \code{"ht"},}
  \item{random.method}{method of estimation for the variance components
    in the random effects model, one of \code{"swar"} (default),
  \code{"amemiya"}, \code{"walhus"}, or \code{"nerlove"},}
  \item{random.dfcor}{a numeric vector of length 2 indicating which degree of
    freedom should be used,}
  \item{inst.method}{the instrumental variable transformation: one of
    \code{"bvk"}, \code{"baltagi"}, \code{"am"}, or \code{"bmc"},}
  \item{index}{the indexes,}
  \item{restrict.matrix}{a matrix which defines linear restrictions on
    the coefficients,}
  \item{restrict.rhs}{the right hand side vector of the linear
    restrictions on the coefficients,}
  \item{digits}{number of digits for printed output,}
  \item{width}{the maximum length of the lines in the printed output,}
  \item{dx}{the half--length of the individual lines for the plot
    method (relative to x range),}
  \item{N}{the number of individual to plot,}
  \item{seed}{the seed which will lead to individual selection,}
  \item{within}{if \code{TRUE}, the within model is plotted,}
  \item{pooling}{if \code{TRUE}, the pooling model is plotted,}
  \item{between}{if \code{TRUE}, the between model is plotted,}
  \item{random}{if \code{TRUE}, the random effect model is plotted,}
  \item{\dots}{further arguments.}
}

\details{
\code{plm} is a general function for the estimation of linear panel
models. It supports the following estimation methods: pooled OLS
(\code{model = "pooling"}), fixed effects (\code{"within"}), random
effects (\code{"random"}), first--differences (\code{"fd"}), and between
(\code{"between"}). It supports unbalanced panels and two--way effects
(although not with all methods).

For random effects models, four estimators of the transformation
parameter are available by setting \code{random.method} to one of \code{"swar"} (Swamy and Arora (1972)) (default),
\code{"amemiya"} (Amemiya (1971)), \code{"walhus"} (Wallace and Hussain (1969)), or \code{"nerlove"} (Nerlove (1971)).

Instrumental variables estimation is obtained using two--part formulas,
the second part indicating the instrumental variables used. This can be
a complete list of instrumental variables or an update of the first
part. If, for example, the model is \code{y ~ x1 + x2 + x3}, with
\code{x1} and \code{x2} endogenous and \code{z1} and \code{z2} external
instruments, the model can be estimated with:

\itemize{
  \item \code{formula=y~x1+x2+x3 | x3+z1+z2},
  \item \code{formula=y~x1+x2+x3 | .-x1-x2+z1+z2}.
}

Balestra and Varadharajan-Krishnakumar's or Baltagi's method is used if
\code{inst.method="bvk"} or if \code{inst.method="baltagi"}, respectively.
  
The Hausman--Taylor estimator is computed if \code{model = "ht"}.
}

\value{
An object of class \code{c("plm","panelmodel")}.

A \code{"plm"} object has the following elements :
  
\item{coefficients}{the vector of coefficients,}
\item{vcov}{the variance--covariance matrix of the coefficients,}
\item{residuals}{the vector of residuals,}
\item{df.residual}{degrees of freedom of the residuals,}
\item{formula}{an object of class \code{'pFormula'} describing the
  model,}
\item{model}{the model frame as a \code{'pdata.frame'} containing the
  variables used for estimation: the response is in first column followed
  by the other variables, the individual and time indexes are in the 'index'
  attribute of \code{model},}
\item{ercomp}{an object of class \code{'ercomp'} providing the
 estimation of the components of the errors (for random effects models only),}
\item{na.action}{if relevant, information about handling of NAs by the 
model.frame function,}
\item{call}{the call.}

% not listed is element "assign"...
   
It has \code{print}, \code{summary} and \code{print.summary} methods.
The \code{summary} method creates an object of class \code{"summary.plm"} that 
extends the object it is run on with information about (inter alia) F statistic 
and (adjusted) R-squared of model, standard errors, t--values, and p--values of 
coefficients, (if supplied) the furnished vcov, see \code{\link[plm]{summary.plm}}
for further details.
}

\seealso{
\code{\link[plm]{summary.plm}} for further details about the associated summary method and the
"summary.plm" object both of which provide some model tests and tests of coefficients. 
\code{\link[plm]{fixef}} to compute the fixed effects for "within" models (=fixed effects models).
}

\author{Yves Croissant}

\references{
  
Amemiya, T. (1971) The estimation of the variances in a
variance--components model, \emph{International Economic Review},
\bold{12}, pp. 1--13.

Balestra, P. and Varadharajan-Krishnakumar, J. (1987) Full information
estimations of a system of simultaneous equations with error components
structure, \emph{Econometric Theory}, \bold{3}, pp. 223--246.
  
Baltagi, B.H. (1981) Simultaneous equations with error components,
\emph{Journal of Econometrics}, \bold{17}, pp. 21--49.
  
Baltagi, B.H. (2001) \emph{Econometric Analysis of Panel Data}, 2nd
ed., John Wiley and Sons.

Baltagi, B.H. (2013) \emph{Econometric Analysis of Panel Data}, 5th
ed., John Wiley and Sons.

Hausman, J.A. and Taylor W.E. (1981) Panel data and unobservable
individual effects, \emph{Econometrica}, \bold{49}, pp. 1377--1398.
 
Nerlove, M. (1971) Further evidence on the estimation of dynamic
economic relations from a time--series of cross--sections,
\emph{Econometrica}, \bold{39}, pp. 359--382.

Swamy, P.A.V.B. and Arora, S.S. (1972) The exact finite sample
properties of the estimators of coefficients in the error components
regression models, \emph{Econometrica}, \bold{40}, pp. 261--275.

Wallace, T.D. and Hussain, A. (1969) The use of error components models
in combining cross section with time series data, \emph{Econometrica},
\bold{37}(1), pp. 55--72.

}

\examples{
data("Produc", package = "plm")
zz <- plm(log(gsp) ~ log(pcap) + log(pc) + log(emp) + unemp,
          data = Produc, index = c("state","year"))
summary(zz)

# replicates some results from Baltagi (2013), table 3.1
data("Grunfeld", package = "plm")
p <- plm(inv ~ value + capital,
         data = Grunfeld, model = "pooling")

wi <- plm(inv ~ value + capital,
          data = Grunfeld, model = "within", effect = "twoways")

swar <- plm(inv ~ value + capital,
            data = Grunfeld, model = "random", effect = "twoways")
          
amemiya <- plm(inv ~ value + capital,
               data = Grunfeld, model = "random", random.method = "amemiya",
               effect = "twoways")
                
walhus <- plm(inv ~ value + capital,
              data = Grunfeld, model = "random", random.method = "walhus",
              effect = "twoways")

# summary, summary with a funished vcov, passed as matrix, 
# as function, and as function with additional argument
summary(wi)
summary(wi, .vcov = vcovHC(wi))
summary(wi, .vcov = vcovHC)
summary(wi, .vcov = function(x) vcovHC(x, method = "white2"))

}

\keyword{regression}
