#!/bin/bash

# Install R dependencies using renv
echo "Installing R dependencies..."
Rscript -e 'if (!requireNamespace("renv", quietly = TRUE)) install.packages("renv", repos = "https://cloud.r-project.org"); renv::restore()'

# Create data directory if it doesn't exist
mkdir -p data

# Download and unzip Stack Overflow Survey 2023 data
echo "Downloading Stack Overflow Survey 2023 data..."
curl -LO "https://cdn.stackoverflow.co/files/jo7n4k8s/production/49915bfd46d0902c3564fd9a06b509d08a20488c.zip/stack-overflow-developer-survey-2023.zip"
unzip stack-overflow-developer-survey-2023.zip -d data
rm stack-overflow-developer-survey-2023.zip

# Download Eurostat dataset
echo "Downloading Eurostat dataset..."
curl -g -o data/estat_earn_ses_annual_filtered_en.csv "https://ec.europa.eu/eurostat/api/dissemination/sdmx/3.0/data/dataflow/ESTAT/earn_ses_annual/1.0/A.B-S_X_O.TOTAL.FT.TOTAL.T.MEAN_E_EUR.*?c[geo]=BE,BG,CZ,DK,DE,EE,IE,EL,ES,FR,HR,IT,CY,LV,LT,LU,HU,MT,NL,AT,PL,PT,RO,SI,SK,FI,SE,IS,NO,CH,UK,ME,MK,AL,RS,TR&compress=false&format=csvdata&formatVersion=2.0&c[TIME_PERIOD]=ge:2018+le:2018&lang=en&labels=name"

echo "Script completed successfully!"