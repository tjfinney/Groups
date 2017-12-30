# MVA-PAM-MSW.R
# T. J. Finney, 2012-01-10.
message("Mean Silhouette Width...")

# Set parameters.
message("Input distance matrix (as CSV file): ", input <- "../dist/eg3a.4of4.csv")
message("Output directory: ", out_dir <- "../msw/")
# Set writing mode: [1] TRUE = write results; [2] FALSE = do not write results.
message("Write mode: ", write <- (c(TRUE, FALSE))[2])

# Script

# Read table.
input.frame <- read.csv(input, row.names=1)

# Prepare to produce results.
# Convert distance matrix to a distance object.
input.dist <- as.dist(input.frame)
#  Shut down open graphics devices.
graphics.off()

# Calculate silhouette widths.
require(cluster)
N <- dim(input.frame)[1]
x <- 1:(N - 1)
y <- vector()
for (n in x) {
  y[n] <- pam(input.dist, n)$silinfo$avg.width
}

# Do summary.
print(round(y, digits=3))
par(bg="white")
plot(x, y, main=NULL, xlab="no. of groups", ylab="mean silhouette width")

# Write results.
if (write) {
  parts <- unlist(strsplit(input, "/"))
  out <- sub("csv", "png", paste(c(out_dir, parts[length(parts)]), collapse=""))
  dev.print(png, file=out, width=540, height=540)
}

# Clean up.
#rm(list=ls(all=TRUE))

