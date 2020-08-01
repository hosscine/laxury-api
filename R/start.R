
if (!require("pacman")) install.packages("pacman")
pacman::p_load(
  tidyverse,
  plumber,
  rvest,
  magrittr,
  dotenv,
  lubridate,
  here,
  jsonlite,
  assertthat
)

here("R/lib") %>% list.files(pattern = "*.R") %>% here("R/lib", .) %>% map(source)

if (file.exists(".env")) load_dot_env()

load_bills()
r <- here("R/plumber.R") %>% plumb()
r$run(port=8000)