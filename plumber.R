
#* @get /bill/
function(no = 1, tag) {
  if (missing(tag)) bill <- get_bill(as.integer(no))
  else bill <- search_bill(tag)
  return(bill)
}

#* @get /bill/list
function() {
  no <- as.integer(no)
  bill <- get_bill(no)
  return(bill)
}

#* @get /bill/shared
function(no = 1, date) {
  no <- as.integer(no)
  bill <- get_bill(no)
  return(bill)
}

#* @get /bill/personal
function(no = 1, date) {
  no <- as.integer(no)
  bill <- get_bill(no)
  return(bill)
}
