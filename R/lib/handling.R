
shared_bill <- function(bill, .dict = dict) {
  target_rows <- .dict$name %>% 
    map(~ str_detect(bill$name, .)) %>% 
    unlist() %>% 
    matrix(ncol = nrow(.dict)) %>% 
    rowSums() %>% 
    as.logical()
  
  filter(bill, target_rows)
}

personal_bill <- function(bill, .dict = dict) {
  target_rows <- .dict$name %>% 
    map(~ str_detect(bill$name, .)) %>% 
    unlist() %>% 
    matrix(ncol = nrow(.dict)) %>% 
    rowSums() %>% 
    magrittr::not()
  
  filter(bill, target_rows)
}
