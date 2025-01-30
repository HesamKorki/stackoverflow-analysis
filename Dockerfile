FROM rocker/r-ver:4.3.1

# 1. Configure RSPM for binary packages --------------------------------------
RUN echo "options(repos = c(CRAN = 'https://packagemanager.posit.co/cran/__linux__/jammy/latest'))" \
    >> /usr/local/lib/R/etc/Rprofile.site

# 2. Install system dependencies ---------------------------------------------
RUN apt-get update && apt-get install -y \
    libglpk-dev \
    libxml2-dev \
    libcairo2-dev \
    libgit2-dev \
    libmysqlclient-dev \
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
    littler \
    && apt-get clean

# 3. Install R packages using binaries ---------------------------------------
RUN install2.r --error --skipinstalled --ncpus $(nproc) \
    tidyverse \
    quarto \
    eurostat \
    countrycode \
    RColorBrewer \
    ggbeeswarm \
    knitr \
    rmarkdown
# Set work directory
WORKDIR /app

# Copy Quarto project files
COPY . .
RUN apt-get install -y unzip curl
RUN curl -LO "https://cdn.stackoverflow.co/files/jo7n4k8s/production/49915bfd46d0902c3564fd9a06b509d08a20488c.zip/stack-overflow-developer-survey-2023.zip"
RUN unzip stack-overflow-developer-survey-2023.zip -d data
RUN rm stack-overflow-developer-survey-2023.zip


RUN curl -g -o data/estat_earn_ses_annual_filtered_en.csv "https://ec.europa.eu/eurostat/api/dissemination/sdmx/3.0/data/dataflow/ESTAT/earn_ses_annual/1.0/A.B-S_X_O.TOTAL.FT.TOTAL.T.MEAN_E_EUR.*?c[geo]=BE,BG,CZ,DK,DE,EE,IE,EL,ES,FR,HR,IT,CY,LV,LT,LU,HU,MT,NL,AT,PL,PT,RO,SI,SK,FI,SE,IS,NO,CH,UK,ME,MK,AL,RS,TR&compress=false&format=csvdata&formatVersion=2.0&c[TIME_PERIOD]=ge:2018+le:2018&lang=en&labels=name"


# Install Quarto
RUN QUARTO_VERSION="1.3.450" && \
    ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        QUARTO_URL="https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.tar.gz"; \
    elif [ "$ARCH" = "aarch64" ]; then \
        QUARTO_URL="https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-arm64.tar.gz"; \
    else \
        echo "Unsupported architecture: $ARCH"; exit 1; \
    fi && \
    wget "$QUARTO_URL" -O quarto.tar.gz && \
    mkdir -p /opt/quarto && \
    tar -zxvf quarto.tar.gz -C /opt/quarto --strip-components=1 && \
    rm quarto.tar.gz && \
    ln -s /opt/quarto/bin/quarto /usr/local/bin/quarto

# Verify installation
RUN quarto --version

# Render Quarto file
RUN Rscript -e "quarto::quarto_render('analysis.qmd', output_file = 'index.html')" && \
mv index.html docs/

# Serve the output
RUN apt-get install -y python3 
ENV PYTHONUNBUFFERED=1

# Expose the port and start the server
EXPOSE 8025 

CMD ["python3", "-m", "http.server", "--directory", "docs", "8025", "--bind", "0.0.0.0"]
