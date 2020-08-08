
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

if (file.exists(".env")) {
  load_dot_env(here(".env")) 
} else if(
  nchar(Sys.getenv("LAXURY_USER")) > 0 &
  nchar(Sys.getenv("LAXURY_PASS")) > 0
) {} else stop("set environment variables LAXURY_USER(login user name) and LAXURY_PASS(password).")

load_bills()
r <- here("R/plumber.R") %>% plumb()
r$run(port = 8000, host = "0.0.0.0")
