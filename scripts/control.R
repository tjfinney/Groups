# control.R
# T. J. Finney, 2012-07-30.
message("Make a data matrix of random binary states.")

# Set parameters.
message("Output data matrix: ", out <- "../data/eg4b.csv")
message("Number of cases: ", R <- 151)
message("Number of variables: ", C <- 503)
message("Required mean distance: ", d <- 0.159)
# Set writing mode: [1] write results; [2] do not write results.
message("Write mode: ", write <- c(TRUE, FALSE)[2])

# Script

# Calculate probability of success.
prob <- (1 + (1 - 2*d)^0.5)/2

# Create data matrix.
rowNames <- paste("R", 1:R, sep="")
colNames <- paste("V", 1:C, sep="")
dataMatrix <- matrix(data=NA, nrow=R, ncol=C, dimnames=list(rowNames, colNames))
for (r in 1:R) {
  dataMatrix[r,] <- rbinom(C, 1, prob) + 1
}

# Write results.
if (write) {
  message("Write: ", out)
  write.csv(dataMatrix, out)
} else {
  message("Would write: ", out)
}