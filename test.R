# Verify core packages can load
required_packages <- c("tidyverse", "eurostat", "countrycode")
sapply(required_packages, function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) stop("Missing package: ", pkg)
})

# Verify data files exist
data_files <- c(
  "data/stack-overflow-developer-survey-2023.zip",
  "data/estat_earn_ses_annual_filtered_en.csv"
)
if (!all(file.exists(data_files))) {
  stop("Missing data files: ", paste(data_files[!file.exists(data_files)], collapse = ", "))
}

cat("All R checks passed!\n")