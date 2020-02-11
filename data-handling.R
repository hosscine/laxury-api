
store_bill <- function(bill) {
  bills[bill$date] <<- bill$invoice
  save(bills, file = "bills.RData")
}

shared_bill <- function(bill, dict = dict) {
  bill$invoice %>%
    filter(name %>% map_lgl(~ str_detect(., dict$name) %>% any))
}

personal_bill <- function(bill, dict = dict) {
  bill$invoice %>%
    filter(name %>% map_lgl(~ str_detect(., dict$name) %>% any) %>% magrittr::not())
}

add_dict <- function(name) {
  dict <<- bind_rows(dict, tibble(name = name))
  save(dict, file = "dict.RData")
}
