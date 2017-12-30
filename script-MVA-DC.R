# MVA-DC.R
# T. J. Finney, 2010-08-02.
message("Divisive Clustering...")

# Set parameters.
message("Input distance matrix (as CSV file): ", input <- "../dist/eg3a.1of4.cop-bo.csv")
message("Output directory for DC result: ", dir <- "../dc/")
# Set writing mode: [1] write results; [2] do not write results.
message("Write mode: ", write <- c(TRUE, FALSE)[2])

# Script

# Read table.
distances <- read.csv(input, row.names=1)
colnames(distances) <- rownames(distances)

# Prepare to produce results.
# Convert distance matrix to a distance object.
distances <- as.dist(distances)
#  Shut down open graphics devices.
graphics.off()

# Perform DC analysis.
require(cluster)
DC <- diana(distances)
message("Divisive coefficient: ", round(DC$dc, digits = 2))
par(bg="white")
plot(DC, which=2, main="", cex=0.6)

# Cut tree at a particular height.
#height <- round(mean(as.vector(distances)), digits = 3)
height <- 0.2
message("Cut tree at this height: ", height)
cut <- cutree(as.hclust(DC), h=height)
print(cut)
# Use which(cut==N) to get members of branch N.

# Write results.
parts <- unlist(strsplit(input, "/"))
parts <- unlist(strsplit(parts[length(parts)], "\\."))
length(parts) <- length(parts) - 1
output <- paste(c(dir, paste(parts, collapse="."), ".png"), collapse="")
if (write) {
  message("Write: ", output)
  dev.print(png, file=output, width=1000, height=600)
} else {
  message("Would write: ", output)
}

# Clean up.
#rm(list=ls(all=TRUE))
