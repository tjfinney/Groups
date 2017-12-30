# MVA-MCA.R
# T. J. Finney, 2012-11-07.
message("Multiple Correspondence Analysis...")
message("* Cases with undefined variables are dropped prior to analysis")

# Set parameters.
message("Input data matrix: ", input <- "../data/eg3a.1of4.csv")
message("Output directory: ", out.dir <- "../mca/")
# Set writing mode: [1] = write results; [2] = do not write results.
message("Write mode: ", write <- c(TRUE, FALSE)[2])

# Read input.
#input.df <- read.csv(input, row.names=1, colClasses="factor")
input.df <- read.csv(input, row.names=1, colClasses="character")

# Drop cases with undefined variables (i.e. NAs).
#input.df <- as.data.frame(lapply(na.omit(input.df), factor))
input.df <- na.omit(input.df)
for (c in 1:ncol(input.df)) { input.df[,c] <- as.factor(input.df[,c]) }

# Perform MCA.
require(MASS)
out.mca <- mca(input.df)

# Produce plot.
graphics.off()
par(bg="white")
biplot(out.mca$rs, out.mca$cs, xlab="component 1", ylab="component 2")

# Do summary.
message("Witness coordinates:")
print(out.mca$rs)
message("Reading coordinates:")
print(out.mca$cs)

# Write results.
parts <- unlist(strsplit(input, "/"))
parts <- unlist(strsplit(parts[length(parts)], "\\."))
length(parts) <- length(parts) - 1
out.name <- paste(c(out.dir, paste(parts, collapse="."), ".png"), collapse="")
if (write) {
  message("Write: ", out.name)
  dev.print(png, file=out.name, width=1000, height=600)
} else {
  message("Would write: ", out.name)
}

# Clean up.
#rm(list=ls(all=TRUE))
