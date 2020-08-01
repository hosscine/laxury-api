FROM rocker/tidyverse

COPY R/ R/ 
RUN R -e "install.packages(c('pacman', 'plumber', 'dotenv', 'here'))"

RUN Rscript R/start.R
