
store_bill <- function(bill) {
  if (exists("bills"))
    bills <<- bind_rows(bill, bills) %>% distinct()
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
  df <- tibble(
    day = seq(tag2day(origin_tag), tag2day(latest_tag()), by = "month")
  ) %>% 
    mutate(no = day %>% length %>% sequence %>% rev)
  
  tibble(day = tag2day(tag)) %>% 
    inner_join(df, by = "day") %>% 
    pull(no)
}

tag2day <- function(tag) {
  paste(tag, 17, 09) %>% ymd_h()
}

update_bills <- function() {
  stored_tag <- bills$tag %>% max
  if (stored_tag != latest_tag())
    tag2no(stored_tag) %>% 
    magrittr::subtract(1) %>%
    sequence() %>% 
    map(~ get_bill(.) %>% store_bill)
}

latest_tag <- function() {
  origin_day <- ymd_h(paste(origin_tag, 17, 09))
  candidate_days <- origin_day + months(1:20)
  latest_day <- candidate_days[which(candidate_days > now()) %>% min - 1]
  return(format(latest_day, "%Y-%m"))
}

init_bills <- function() {
  origin_tag %>% 
    tag2no() %>% 
    sequence() %>% print %>% 
    map(~ get_bill(.) %>% store_bill)
}

origin_tag <- "2019-05"

find_bill <- function(.tag) {
  bills %>% filter(tag %in% .tag)
}
