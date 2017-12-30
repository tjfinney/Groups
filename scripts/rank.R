# rank.R
# T. J. Finney, 2017-06-22
message("Rank witnesses by distance from a reference.")
message("Asterisked distances are statistically significant (alpha = 0.05).")

# Reset
rm(list=ls(all=TRUE))

# Set parameters
message("Distance matrix: ", dist.name <- "../dist/eg3a.4of4.csv")
message("Counts matrix: ", counts.name <- "../dist/eg3a.4of4.counts.csv")
message("Reference witness: ", ref <- "032")

# Read inputs
dist.mx <- read.csv(dist.name, row.names=1)
counts.mx <- read.csv(counts.name, row.names=1)
# Make ranked list
# Use mean of all distances as mean of row may be skewed
p <- mean(as.dist(dist.mx))
counts = unlist(counts.mx[rownames(counts.mx)==ref])
ref.fr = dist.mx[rownames(dist.mx)==ref]
ref.fr[2] <- qbinom(0.025, counts, p)/counts
ref.fr[3] <- qbinom(0.975, counts, p)/counts
ref.fr[4] <- (ref.fr[1] < ref.fr[2]) | (ref.fr[1] > ref.fr[3])
ref.fr[5] <- row.names(ref.fr)
ranked <- ref.fr[order(ref.fr[1]),]
ranked <- subset(ranked, rownames(ranked) != ref)
parts <- apply(ranked, 1, function(r) {
  # apply() somehow converts TRUE to " TRUE"
  test <- as.logical(gsub("[[:space:]]", "", r[4]))
  sprintf("%s (%s)%s", r[5], r[1], if (test) "*" else "")
})
# Print ranked list
message(paste(parts, collapse="; "))
