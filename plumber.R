
#* @get /bill
function(no = 1) {
  no <- as.integer(no)
  bill <- get_bill(no)
  return(bill)
}
