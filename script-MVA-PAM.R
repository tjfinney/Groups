# MVA-PAM.R
# T. J. Finney, 2010-08-02.
message("Partitioning Around Medoids...")

# Set parameters.
message("Input distance matrix (as CSV file): ", input <- "../dist/eg3a.1of4.cop-bo.csv")
message("Output directory for PAM result: ", outPAM <- "../pam/")
message("Number of clusters for optimal partitioning: ", k <- 5)
# Set writing mode: TRUE = write results; FALSE = do not write results.
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

# Perform PAM analysis.
require(cluster)
#require(fpc)
PAM <- pam(distances, k)
#PAM <- pamk(distances)
#dev.new()
#par(bg="white")
# Comment out following line if plot causes error.
#plot(PAM, which=1, labels=2, main="", cex=0.8)

# Do summary.
message("Medoids and associated clusters:")
for (i in 1:k) {
  message(PAM$medoids[i], ": ", paste(names(PAM$clustering[PAM$clustering == i]), collapse=" "))
}
message("Mean silhouette width:")
print(round(PAM$silinfo$avg.width, digits=3))
message("Poorly classified witnesses (worst last):")
sil.widths <- sort(PAM$silinfo$widths[,3], decreasing=TRUE)
message(paste(names(sil.widths[sil.widths < 0]), collapse=" "))

# Write results.
if (write) {
  parts <- unlist(strsplit(input, "/"))
  parts <- unlist(strsplit(parts[length(parts)], "\\."))
  length(parts) <- length(parts) - 1
  name <- paste(parts, collapse=".")
  outPAM <- paste(c(outPAM, name), collapse="")
  outPAM <- paste(c(outPAM, k, "png"), collapse=".")
  dev.print(png, file=outPAM, width=720, height=720)
}
