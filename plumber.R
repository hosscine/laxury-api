
#* @get /bill
function(tag) {
  if (missing(tag)) tag <- latest_tag()
  bill <- find_bill(tag)
  return(bill)
}

#* @get /bill/list
function() {
  return(bills$tag %>% unique)
}

#* @get /bill/shared
function(tag) {
  if (missing(tag)) tag <- latest_tag()
  bill <- find_bill(tag) %>% shared_bill()
  return(bill)
}

#* @get /bill/personal
function(tag) {
  if (missing(tag)) tag <- latest_tag()
  bill <- find_bill(tag) %>% personal_bill()
  return(bill)
}
