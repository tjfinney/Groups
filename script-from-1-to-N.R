# from-1-to-N.R
# T. J. Finney, 2012-04-07.
message("Chop a data matrix into N roughly equal slices by variables.")

# Set parameters.
message("Input data matrix (as CSV file): ", input <- "../data/eg3a.csv")
message("Output directory for slices: ", dir <- "../data/")
message("Number of slices: ", n <- 4)
# Set writing mode: [1] write results; [2] do not write results.
message("Write mode: ", write <- c(TRUE, FALSE)[1])

# Script

# Read distance matrix.
data <- read.csv(input, row.names=1)
nc <- ncol(data)

# Make array of chunk sizes.
quotient <- nc %/% n
remainder <- nc %% n
chunks <- rep(quotient, times=n)
chunks[n] <- chunks[n] + remainder

# Make slices.
slices <- list()
labels <- list()
for (i in 1:n) {
  first <- (i - 1) * quotient + 1
  last <- first + chunks[i] - 1
  slices[[i]] <- data[, first:last]
  labels[[i]] <- paste(c(i, "of", n), collapse="")
}

# Write output.
parts <- unlist(strsplit(input, "/"))
parts <- unlist(strsplit(parts[length(parts)], "\\."))
for (i in 1:n) {
  output <- paste(c(dir, parts[1], ".", labels[[i]], ".", parts[2]), collapse="")
  if (write)  {
    message("Write ", output)
    write.csv(slices[[i]], output)
  } else {
    message("Would write ", output)
  }
}

# Clean up.
#rm(list=ls(all=TRUE))
