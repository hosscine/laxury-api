
load_bills <- function() {
  if (here("data/bills.RData") %>% file.exists) {
    here("data/bills.RData") %>% load(envir = .GlobalEnv)
    update_bills()
  }
  else init_bills()
  
  if (here("data/dict.RData") %>% file.exists)
    here("data/dict.RData") %>% load(envir = .GlobalEnv)
  else init_dict()
}
