
shared_bill <- function(bill, .dict = dict) {
  bill %>% filter(.dict$name %>% map_dfc(~ str_detect(..2, ..1), name) %>% rowSums %>% as.logical)
}

personal_bill <- function(bill, .dict = dict) {
  bill %>% filter(.dict$name %>% map_dfc(~ str_detect(..2, ..1), name) %>% rowSums %>% magrittr::not())
}
