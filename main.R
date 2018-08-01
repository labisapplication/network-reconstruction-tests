args = commandArgs(trailingOnly = TRUE)

if (length(args) == 0) {
  cat("Dataset not passed!\n")
  quit(save = "no", status = 1)
}

source('iota/IOTA.R')
library('igraph', warn.conflicts = FALSE)

filename <- args[1]
cat(paste("Processing file", filename, "\n"))

data <- read.csv(filename, sep = '\t')

# Transpose data
data <- t(data)

# Normalize data
tmp <- data - apply(data, 1, min, na.rm = TRUE)
data <- tmp / apply(tmp, 1, max, na.rm = TRUE)

# Run IOTA
a <- IOTA(data, method = 'sqrt')
diag(a) <- 0  # Ignore selfcorrelation

threshold <- .93

up.regulated <- graph.adjacency(a > threshold)
down.regulated <- graph.adjacency(a < -threshold)

result <- rbind(
                cbind(get.edgelist(up.regulated), "+"),
                cbind(get.edgelist(down.regulated), "-")
                )

basename <- unlist(strsplit(filename, "/"))[2]

write.table(result, file = paste0("results/", basename),
            quote = FALSE, sep = '\t',
            col.names = FALSE, row.names = FALSE)

# TODO: get this working
# source('iota/iota_subroutines.R')

# rmax <- 1000
# alpha <- .99
# w <- 2

# a <- IOTA(data, rmax, alpha, w)
