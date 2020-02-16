
store_bill <- function(bill) {
  if (exists(bills))
    bills <<- bind_rows(bills, bill) %>% distinct()
  else
    bills <<- bill

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

tag2no <- function(tag) {
  
}

update_bills <- function() {
  
}

latest_tag <- function() {
  origin_day <- ymd_h(paste(origin_tag, 17, 09))
  candidate_days <- origin_day + months(1:20)
  latest_day <- candidate_days[which(candidate_days > now()) %>% min - 1]
  return(format(latest_day, "%Y-%m"))
}

origin_tag <- "2019-05"

find_bill <- function(tag) {
  bills
}
