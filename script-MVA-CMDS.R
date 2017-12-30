# MVA-CMDS.R
# T. J. Finney, 2017-01-27.
message("Classical Multidimensional Scaling.")

# Reset.
rm(list=ls(all=TRUE))

# Set parameters.
setwd('/home/tjf2n/Keep/Writing/Groups/170127/scripts')
message("Input distance matrix (as CSV file): ", input <- "../dist/eg4a.csv")
message("Output directory for MDS result: ", outMDS <- "../cmds/")
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

# Perform MDS analysis.
MDS <- cmdscale(distances, k=3, eig=TRUE)

# Calculate R-squared.
MDS.dist <- dist(MDS$points, diag=TRUE, upper=TRUE)
MDS.summary <- summary.lm(lm(distances ~ MDS.dist))
rsq <- MDS.summary$r.squared

# Plot result
x <- MDS$points[,1]
y <- MDS$points[,2]
z <- MDS$points[,3]
require(rgl)
plot3d(x, y, z, xlab="axis 1", ylab="axis 2", zlab="axis 3", type='n', axes=TRUE, box=TRUE, sub=sprintf("R-squared = %0.2f", rsq))
text3d(x, y, z, rownames(MDS$points), col=4)
message("R-squared: ", round(rsq, digits = 2))
message("Goodness of fit: ", round(MDS$GOF[1], digits = 2))

# Write results.
parts <- unlist(strsplit(input, "/"))
parts <- unlist(strsplit(parts[length(parts)], "\\."))
length(parts) <- length(parts) - 1
name <- paste(parts, collapse=".")
if (write) {
  message("Write: ", name)
  movie3d(spin3d(rpm=10), duration=6, dir=outMDS, movie=name)
} else {
  message("Would write: ", name)
}
