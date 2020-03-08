
latest_tag <- function() {
  origin_day <- ymd_h(paste(origin_tag, 17, 09))
  candidate_days <- origin_day + months(1:20)
  latest_day <- candidate_days[which(candidate_days > now()) %>% min - 1]
  return(format(latest_day, "%Y-%m"))
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