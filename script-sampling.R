# sampling.R
# T. J. Finney, 2012-08-14.
message("Illustrate sampling error.")

# Set parameters.
message("Input data matrix (as CSV file): ", input <- "../data/eg4a.csv")
message("alpha value: ", alpha <- 0.05)
cases <- c("1", "13")
message("Cases compared: ", paste(cases, collapse=" "))
message("Places compared: ", n <- 400)

# Script

# Read data matrix.
dataFrame <- read.csv(input, row.names=1)

# Select cases to compare.
c1 <- dataFrame[match(cases[1], row.names(dataFrame)), ]
c2 <- dataFrame[match(cases[2], row.names(dataFrame)), ]

# Drop variables where either case has NA.
drop <- unique(c(names(c1)[is.na(c1)], names(c2)[is.na(c2)]))
c1 <- c1[!(names(c1) %in% drop)]
c2 <- c2[!(names(c2) %in% drop)]

# Select variables to compare.
vars <- sample(names(c1), n, replace=FALSE)

# Select places for selected cases.
places1 <- c1[vars]
places2 <- c2[vars]

# Calculate the distance estimate and confidence interval.
distEstimate <- sum(places1 != places2)/n
confInterval <- qbinom(c(alpha/2, 1 - alpha/2), n, distEstimate)/n

# Do summary.

message("Distance estimate: ", sprintf("%1.3f", distEstimate))
CI <- sprintf("%1.3f", confInterval)
message("Confidence interval: [", CI[1], ", ", CI[2], "]")


# Clean up.
#rm(list=ls(all=TRUE))

