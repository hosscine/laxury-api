FROM rocker/tidyverse

RUN R -e "install.packages(c('pacman', 'plumber', 'dotenv', 'here'))"
COPY R/ R/
COPY .env /
COPY data/dict.RData data/

EXPOSE 8000

CMD ["Rscript", "R/start.R"]
