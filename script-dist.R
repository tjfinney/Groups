# dist.R
# T. J. Finney, 2017-06-22.
message("Make distance and counts matrices from a data matrix.")
message("The counts matrix says how many passages are defined for each witness combination.")

# Set parameters.
message("Input data matrix: ", input <- "../data/eg3a.csv")
message("Output directory: ", out.dir <- "../dist/")
message("Minimum tolerable limit of mutually defined passages: ", tolerable <- 15)
message("Reference witness: ", ref <- "")
# Set writing mode: [1] = write results; [2] = do not write results.
message("Write mode: ", write <- c(TRUE, FALSE)[1])

# Functions

# reduce(frame, limit, name)
# * Reduce a frame of counts by removing one object at a time.
# * This is recursive. On every iteration:
#   * Identify objects with the least count.
#   * Sort these by their total counts (ascending).
#   * Drop the first one that is not the named object.
# * Recursion ends when the least count is not less than the limit.
#
# frame: A square data frame of named objects. Cell values are counts.
# limit: The lower limit of counts.
# save: The name of one object to save. (Use "" if no such object.)
# Return: A data frame where no cell value is less than the lower limit.

reduce <- function(frame, limit, save) {
  # Test for end condition.
  least <- min(frame)
  if (least >= limit) { frame } else {
    # List objects with least counts.
    x <- vector()
    for (c in 1:ncol(frame)) { x[c] <- least %in% frame[,c] }
    # Identify object to drop, excluding ref.
    counts <- diag(as.matrix(frame))
    drop <- names(sort(counts[x]))
    drop <- subset(drop, drop != save)[1]
    message(drop, " dropped")
    keep <- names(frame) != drop
    reduce(frame[keep, keep], limit, save)
  }
}

# Read data matrix.
input.fr <- read.csv(input, row.names=1, colClasses="character")

# Make frame for names and counts.
names <- rownames(input.fr)
counts <- vector()
for (r in 1:nrow(input.fr)) { counts[r] <- sum(!is.na(input.fr[r,])) }
names.fr <- cbind(names, counts)

# Drop witnesses without enough passages.
message("Drop witnesses without enough passages:")
message(paste(names[counts < tolerable], collapse=" "))
keep <- counts >= tolerable
input.fr <- subset(input.fr, keep)
names.fr <- subset(names.fr, keep)

# Check ref. witness.
names <- names.fr[,"names"]
if ((ref != "") & !(ref %in% names)) {
  stop("Reference witness does not have enough defined passages.", call.=FALSE)
}

# Make counts frame.
counts.fr <- data.frame(row.names=names)
R <- length(names)
for (r in 1:R) {
  for (c in 1:r) {
    counts.fr[r, c] <- counts.fr[c, r] <- sum( !is.na(input.fr[r,]) & !is.na(input.fr[c,]) )
  }
}
colnames(counts.fr) <- names

# Drop witnesses without enough mutually defined passages.
# The reference witness must be retained.
message("Drop remaining witnesses until limit satisfied:")
counts.fr <- reduce(counts.fr, tolerable, ref)
keep <- rownames(input.fr) %in% rownames(counts.fr)
input.fr <- subset(input.fr, keep)

# Construct distance matrix.
require(cluster)
for (c in 1:ncol(input.fr)) { input.fr[,c] <- as.factor(input.fr[,c]) }
dist.matrix <- as.matrix(daisy(input.fr))
message("Mean distance: ", round(mean(dist.matrix), digits = 3))

# Construct list of counts.
counts.matrix <- as.matrix(counts.fr)
message("Mean number of passages (rounded): ", round(mean(counts.matrix)))

# Write results.
parts <- c(
  sub(".csv", "", sub(".*/", "", input)),
  if (ref == "") NULL else ref
)
name <- paste(parts, collapse=".")
dist.name <- paste(c(out.dir, name, ".csv"), collapse="")
counts.name <- paste(c(out.dir, name, ".counts.csv"), collapse="")
if (write) {
  message("Write ", dist.name)
  write.csv(round(dist.matrix, digits=3), dist.name)
  message("Write ", counts.name)
  write.csv(counts.matrix, counts.name)
} else {
  message("Would write ", dist.name)
  message("Would write ", counts.name)
}

# Clean up.
#rm(list=ls(all=TRUE))
