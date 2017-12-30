# hist.R
# T. J. Finney, 2011-10-15.
message("Plot a frequency histogram.")

# Set parameters.
message("Input distance matrix (as CSV file): ", input <- "../dist/eg5.csv")
message("Output directory: ", out_dir <- "../hist/")
message("Mean number of variation units (rounded): ", n_vu <- 488)
message("Number of buckets: ", n_bt <- 20)
# Set writing mode: [1] TRUE = write results; [2] FALSE = do not write results.
message("Write mode: ", write <- (c(TRUE, FALSE))[2])

# Script

# Read distance matrix.
d <- read.csv(input, row.names=1)
colnames(d) <- rownames(d)

# Get distances.
x <- as.vector(as.dist(d))

#  Shut down open graphics devices.
graphics.off()

# Do histogram for distances.
br <- seq(0, 1, length.out=(n_bt+1))
h1 <- hist(x, breaks=br, plot=FALSE)
h1$counts <- h1$counts/sum(h1$counts)
plot(h1, main=NULL, xlab="distance", ylab="relative frequency")

# Do histogram for binomial distribution.
len <- length(x)
stats <- summary(x)
p <- stats[4]
message("Estimate of p: ", sprintf("%.3f", p))
n_bin <- as.integer(n_vu)
x_bin <- seq(0, n_bin)
y_bin <- dbinom(x_bin, n_bin, p)
q_bin <- qbinom(c(0.025, 0.975), n_bin, p)/n_bin
x_bin <- x_bin/n_bin
#y_bin <- y_bin * max(h1$counts) / max(y_bin)
lines(x_bin, y_bin, col="blue")

# Do summary.

message("Summary statistics for distances:")
message("mean: ", sprintf("%.3f", stats[4]))
message("first quartile: ", sprintf("%.3f", stats[2]))
message("median: ", sprintf("%.3f", stats[3]))
message("third quartile: ", sprintf("%.3f", stats[5]))
message("Critical limits (binomial distribution, alpha = 0.05):")
message("lower: ", sprintf("%.3f", q_bin[1]))
message("upper: ", sprintf("%.3f", q_bin[2]))

# Write results.
if (write) {
  parts <- unlist(strsplit(input, "/"))
  out <- sub("csv", "png", paste(c(out_dir, parts[length(parts)]), collapse=""))
  dev.print(png, file=out, width=540, height=540)
}

# Clean up.
#rm(list=ls(all=TRUE))

