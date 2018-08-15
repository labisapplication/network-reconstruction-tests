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
a <- IOTAsigned(data, method = 'sqrt')
diag(a) <- 0  # Ignore selfcorrelation

threshold <- .95

prediction <- a
prediction[,] <- 0

prediction[a > threshold] <- 1
prediction[a < -threshold] <- -1

file <- 'data/InSilicoSize10-Yeast1_goldstandard_signed.tsv'
goldstandard <- read.csv(file, sep = '\t', header = FALSE)

c <- a
c[,] <- 0 # This ensures the right dimensions

for (i in seq_len(nrow(goldstandard))) {
  row <- goldstandard[i,]
  value <- ifelse(row[[3]] == '-', -1, 1)
  c[row[[1]], row[[2]]] <- value
}
#prediction
#c

result <- a
result[,] <- 0

library(pROC)

#roc(response=array(result), predictor=array(c))
roc(
    response=array(abs(result)),
    predictor=array(abs(c))
    )

result[prediction == c] <- 1
result
