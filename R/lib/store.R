
origin_tag <- "2019-05"

store_bill <- function(bill) {
  if (exists("bills"))
    bills <<- bind_rows(bill, bills) %>% distinct()
  else
    bills <<- bill
  
  here("data/bills.RData") %>% save(bills, file = .)
}

add_dict <- function(name) {
  dict <<- bind_rows(dict, tibble(name = name))
  here("data/dict.Rdata") %>% save(dict, file = .)
}

init_bills <- function() {
  origin_tag %>% 
    tag2no() %>% 
    sequence() %>% print %>% 
    map(~ get_bill(.) %>% store_bill)
}

init_dict <- function() {
  dict <<- tibble(name = character())
}

find_bill <- function(.tag) {
  update_bills()
  bills %>% filter(tag %in% .tag)
}

update_bills <- function() {
  stored_tag <- bills$tag %>% max
  if (stored_tag != latest_tag())
    tag2no(stored_tag) %>% 
    magrittr::subtract(1) %>%
    sequence() %>% 
    map(~ get_bill(.) %>% store_bill)
}
