# Stack Overflow Survey 2023 Analysis

**Author: Hesam Korki**

### Live Product

The **final product** is available via [this link](https://hesamkorki.github.io/stackoverflow-analysis/).

## Setup Options

#### Option 1: Using Docker (Recommended)
The easiest way to run this analysis is using Docker. This ensures you have all the required dependencies and correct environment setup.
Prerequisites:
- Git
- Docker
Install them on your machine and you will be fine reproducing this project.

The Docker image is built for both ARM and AMD so you should be fine with apple processors as well as others. This is viable thanks to the Github Action CI/CD on this repository which builds the image and pushes it to the dockerhub container registry.

1. Pull the image
   (AMD CPUs)
   ```bash
   docker pull hesamkorki/stackoverflow-analysis:main
   ```
   (ARM CPUs)
   ```bash
   docker pull hesamkorki/stackoverflow-analysis:arm
   ```
   
3. Run the docker container
   ```bash
   docker run -p 8025:8025 hesamkorki/stackoverflow-analysis
   ```
Then the you'd have the result of the analysis served on your local machine: `http://localhost:8025`



#### Option 2: Using local R environment

If you're using macOS or a common Linux distribution, and you have R development environment on your machine, the only thing you need to do is to run the `setup.sh` script:

```bash
./setup.sh
```

This script first installs the requirements of the project using renv, then tries to download the datasets and put them in the data directory.

### Manual Setup

I'm sorry if you couldn't use the script. No worries, it's easy to do manually too:

#### Install Dependencies

In your Rstudio console:

```r
renv::restore()
```

#### Data

- The Stack Overflow Survey 2023 data is publicly available please [download](https://cdn.stackoverflow.co/files/jo7n4k8s/production/49915bfd46d0902c3564fd9a06b509d08a20488c.zip/stack-overflow-developer-survey-2023.zip) it and unzip the archive file in order to extract the file called `survey_results_public.csv` and move it to the `data` directory in the root of the project.
- EU members average salary 2018: latest publicly available from [eurostat](https://ec.europa.eu/eurostat/). The precise dataset that I used should be accessible  [here](https://ec.europa.eu/eurostat/api/dissemination/sdmx/3.0/data/dataflow/ESTAT/earn_ses_annual/1.0/A.B-S_X_O.TOTAL.FT.TOTAL.T.MEAN_E_EUR.*?c[geo]=BE,BG,CZ,DK,DE,EE,IE,EL,ES,FR,HR,IT,CY,LV,LT,LU,HU,MT,NL,AT,PL,PT,RO,SI,SK,FI,SE,IS,NO,CH,UK,ME,MK,AL,RS,TR&compress=false&format=csvdata&formatVersion=2.0&c[TIME_PERIOD]=ge:2018+le:2018&lang=en&labels=name). It's named `estat_earn_ses_annual_filtered_en.csv`, please put it in the data directory

### Disclaimer

This project utilizes data from the Stack Overflow Developer Survey 2023 and Eurostat. The Stack Overflow survey data was obtained from [Stack Overflow](https://insights.stackoverflow.com/survey) and the Eurostat dataset from the [Eurostat website](https://ec.europa.eu/eurostat/). Both datasets are publicly available, and their use is subject to the terms and conditions specified by Stack Overflow and Eurostat.

- [Stack Overflow Developer Survey Terms of Service](https://stackoverflow.com/legal/terms-of-service/public)
- [Eurostat Terms of Use](https://ec.europa.eu/info/legal-notice_en)

This project and its authors do not claim ownership or endorsement by Stack Overflow or Eurostat. Any insights or findings derived from the data are the sole responsibility of the project authors.
