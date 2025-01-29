# Base R image
FROM rocker/r-ver:4.3.1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libglpk-dev \
    libxml2-dev \
    libcairo2-dev \
    libgit2-dev \
    default-libmysqlclient-dev \
    libpq-dev \
    libsasl2-dev \
    libsqlite3-dev \
    libssh2-1-dev \
    libxtst6 \
    libcurl4-openssl-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    unixodbc-dev \
    wget \
    && apt-get clean

# Install Quarto
# Detect the architecture and download the correct Quarto package
RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "amd64" ]; then \
        QUARTO_URL="https://quarto.org/download/latest/quarto-linux-amd64.deb"; \
    elif [ "$ARCH" = "arm64" ]; then \
        QUARTO_URL="https://quarto.org/download/latest/quarto-linux-arm64.deb"; \
    else \
        echo "Unsupported architecture: $ARCH"; exit 1; \
    fi && \
    wget "$QUARTO_URL" -O quarto.deb && \
    apt-get install -y ./quarto.deb && \
    rm quarto.deb


# Install R packages
RUN Rscript -e "install.packages(c('tidyverse', 'quarto', 'eurostat', 'countrycode', 'RColorBrewer', 'ggbeeswarm', 'knitr'))"
# COPY renv.lock ./
# RUN Rscript -e "renv::restore()"

# Set work directory
WORKDIR /app

# Copy Quarto project files
COPY . .
RUN apt-get install -y unzip curl
RUN curl -LO "https://cdn.stackoverflow.co/files/jo7n4k8s/production/49915bfd46d0902c3564fd9a06b509d08a20488c.zip/stack-overflow-developer-survey-2023.zip"
RUN unzip stack-overflow-developer-survey-2023.zip -d data
RUN rm stack-overflow-developer-survey-2023.zip


RUN curl -g -o data/estat_earn_ses_annual_filtered_en.csv "https://ec.europa.eu/eurostat/api/dissemination/sdmx/3.0/data/dataflow/ESTAT/earn_ses_annual/1.0/A.B-S_X_O.TOTAL.FT.TOTAL.T.MEAN_E_EUR.*?c[geo]=BE,BG,CZ,DK,DE,EE,IE,EL,ES,FR,HR,IT,CY,LV,LT,LU,HU,MT,NL,AT,PL,PT,RO,SI,SK,FI,SE,IS,NO,CH,UK,ME,MK,AL,RS,TR&compress=false&format=csvdata&formatVersion=2.0&c[TIME_PERIOD]=ge:2018+le:2018&lang=en&labels=name"


# Render Quarto file
RUN quarto render analysis.qmd -o index.html && \
    mv index.html docs/

# Serve the output
RUN apt-get install -y python3 
ENV PYTHONUNBUFFERED=1

# Expose the port and start the server
EXPOSE 8025 

ENTRYPOINT ["python3", "-m", "http.server", "--directory", "docs"]
CMD ["8025", "--bind", "0.0.0.0"]
