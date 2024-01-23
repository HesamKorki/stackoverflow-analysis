# Stack Overflow Survey 2023 Analysis
**Author: Hesam Korki**

### Live Product

The **final product** is available via [this link](https://hesamkorki.github.io/stackoverflow-analysis/).


### Setup

If you're using macOS or a common Linux distribution, the only thing you need to do is to run the `setup.sh` script:

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
