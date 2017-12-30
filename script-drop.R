# drop.R
# T. J. Finney, 2010-07-12.
message("Drop empty rows from a data matrix.")

# Set parameters.
message("Input directory and file name: ", input <- "../data/eg5.csv")
message("Output directory and file name: ", output <- "../data/eg5.csv")

# Script

# Read data matrix into a data frame.
readings <- read.csv(input, row.names=1)

# Drop witnesses without any variation units.
R <- nrow(readings)
x <- logical()
for (r in 1:R) { x[r] <- (sum(!is.na(readings[r,])) > 0) }
if (sum(!x) > 0) {
  message("Drop witnesses without any variation units:")
  cat(rownames(readings)[!x], "\n")
}
readings <- readings[x,]

# Write result.
write.csv(readings, output)
