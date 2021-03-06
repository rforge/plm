\name{make.pbalanced}
\alias{make.pbalanced}
\alias{make.pbalanced.data.frame}
\alias{make.pbalanced.pdata.frame}
\alias{make.pbalanced.pseries}

\title{Make data balanced}

\description{This function makes the data balanced, i.e. each individual has the same time periods}

\usage{
\method{make.pbalanced}{pdata.frame}(x, ...)
\method{make.pbalanced}{pseries}(x, ...)
\method{make.pbalanced}{data.frame}(x, index = NULL, ...)
}

\arguments{
 \item{x}{an object of class \code{pdata.frame}, \code{data.frame}, or \code{pseries};}
 \item{index}{only relevant for \code{data.frame} interface; if \code{NULL}, the first two columns of the data.frame are 
              assumed to be the index variables; if not \code{NULL}, both dimensions ('individual', 'time') need to be 
              specified by \code{index} as character of length 2 for data frames, for further details see \code{\link{pdata.frame}},}
 \item{\dots}{further arguments.}
}

\value{
An object of the same class as the input \code{x}, i.e. a pdata.frame, data.frame or a pseries which is made balanced 
based on the index variables.
}

\details{
 (p)data.frame and pseries objects are made balanced, meaning each individual has the same time periods.
 For this, the union of available time periods over all individuals is taken (w/o \code{NA} values).
 Missing time periods for an individual are identified and corresponding rows (elements for pseries) are 
 inserted and filled with \code{NA} for the non--index variables (elements for a pseries).
 
 This means, only time periods present for at least one individual are inserted, if missing. The data are not 
 necessarily made consecutive (regularly time series with distance 1), because balancedness does not imply
 consecutiveness. For making the data consecutive (and, optionally, also balanced), use \code{\link{make.pconsecutive}}, 
 see also \bold{Examples} for a comparison of the two functions.
 
 Note: rows of (p)data.frames (elements for pseries) with \code{NA} values in individual or time index are not examined but
 silently dropped before the data are made balanced. In this case, it cannot be inferred which individual or time period is 
 meant by the missing value(s) (see also \bold{Examples}). Especially, this means: \code{NA} values in the first/last position 
 of the original time periods for an individual are dropped, which are usually meant to depict the beginning and ending of 
 the time series for that individual. Thus, one might want to check if there are any \code{NA} values in the index variables 
 before applying make.pbalanced, and especially check for \code{NA} values in the first and last position for each individual 
 in original data and, if so, maybe set those to some meaningful begin/end value for the time series.
}

\seealso{
 \code{\link{is.pconsecutive}} to check if data are consecutive; \code{\link{make.pconsecutive}} to make data consecutive 
 (and, optionally, also balanced).\cr
 \code{\link{punbalancedness}} for two measures of unbalancedness,
 \code{\link{pdim}} to check the dimensions of a 'pdata.frame' (and other objects), 
 \code{\link{pvar}} to check for individual and time variation of a 'pdata.frame' (and other objects),
 \code{\link[plm]{lag}} for lagged (and leading) values of a 'pseries' object.\cr
 \code{\link{pseries}}, \code{\link{data.frame}}, \code{\link{pdata.frame}}.
}

\author{Kevin Tappe}

\examples{
# take data and make it unbalanced
# by deletion of 2nd row (2nd time period for first individual)
data("Grunfeld", package = "plm")
nrow(Grunfeld)                            # 200 rows
Grunfeld_missing_period <- Grunfeld[-2, ]
pdim(Grunfeld_missing_period)$balanced    # check if balanced: FALSE
make.pbalanced(Grunfeld_missing_period)   # make it balanced

# more complex data:
# First, make data unbalanced (and non-consecutive) 
# by deletion of 2nd time period (year 1936) for all individuals
# and more time periods for first individual only
Grunfeld_unbalanced <- Grunfeld[Grunfeld$year != 1936, ]
Grunfeld_unbalanced <- Grunfeld_unbalanced[-c(1,4), ]
pdim(Grunfeld_unbalanced)$balanced        # FALSE
all(is.pconsecutive(Grunfeld_unbalanced)) # FALSE

g_bal <- make.pbalanced(Grunfeld_unbalanced)
pdim(g_bal)$balanced        # TRUE
unique(g_bal$year)          # all years but 1936
nrow(g_bal)                 # 190 rows
head(g_bal)                 # 1st individual: years 1935, 1939 are NA

# NA in 1st, 3rd time period (years 1935, 1937) for first individual
Grunfeld_NA <- Grunfeld
Grunfeld_NA[c(1, 3), "year"] <- NA
g_bal_NA <- make.pbalanced(Grunfeld_NA)
head(g_bal_NA)        # years 1935, 1937: NA for non-index vars
nrow(g_bal_NA)        # 200


# pdata.frame interface
pGrunfeld_missing_period <- pdata.frame(Grunfeld_missing_period)
make.pbalanced(Grunfeld_missing_period)


# pseries interface
make.pbalanced(pGrunfeld_missing_period$inv)


# comparison to make.pconsecutive
g_consec <- make.pconsecutive(Grunfeld_unbalanced)
all(is.pconsecutive(g_consec)) # TRUE
pdim(g_consec)$balanced        # FALSE
head(g_consec, 22)             # 1st individual:   no years 1935/6; 1939 is NA; 
                               # other indviduals: years 1935-1954, 1936 is NA
nrow(g_consec)                 # 198 rows

g_consec_bal <- make.pconsecutive(Grunfeld_unbalanced, balanced = TRUE)
all(is.pconsecutive(g_consec_bal)) # TRUE
pdim(g_consec_bal)$balanced        # TRUE
head(g_consec_bal)                 # year 1936 is NA for all individuals
nrow(g_consec_bal)                 # 200 rows

head(g_bal)                        # no year 1936 at all
nrow(g_bal)                        # 190 rows
}

\keyword{attribute}
