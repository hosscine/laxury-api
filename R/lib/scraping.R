
get_new_session <- function() {
  agent_str <- paste("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_2)",
                     "AppleWebKit/537.36 (KHTML, like Gecko)",
                     "Chrome/71.0.3578.98 Safari/537.36")
  load_dot_env()
  
  agent <- httr::user_agent(agent_str)
  login_page <- html_session("https://myluxurycard.co.jp", agent)
  login_form <- html_form(login_page) %>% 
    extract2(1) %>% 
    set_values(webMemberId = Sys.getenv("LUXURY_USER"), webMemberPass=Sys.getenv("LUXURY_PASS"))
  
  session <- submit_form(login_page, login_form)
  return(session)
}

get_session_recycle <- function(force = FALSE) {
  if (!exists("session") | force) 
    session <<- get_new_session()
  else if (session$response$date - lubridate::now() < -minutes(30))
    session <<- get_new_session()
  return(session)
}

get_bill_url <- function(no) {
  assertthat::assert_that(assertthat::is.number(no))
  assertthat::assert_that(no >= 1 && no < 100)
  
  no_pad <- stringr::str_pad(no, 2, pad = "0")
  url <- paste0("https://netstation2.aplus.co.jp/netstation/MyFlowServlet?origin=",
                ifelse(no == 1, "GlobalNavi&event=detail_", "UseDetail&event=detail_"),
                no_pad)
  return(url)
}

get_bill <- function(no = 1) {
  session <- get_session_recycle()
  url <- get_bill_url(no)
  
  page <- session %>% 
    jump_to(url) %>% 
    read_html()
  
  invoice_date <- page %>%
    html_nodes(".title-lv2") %>%
    extract(2) %>%
    html_text() %>%
    stringr::str_split("　") %>%
    extract2(1) %>%
    extract(1) %>%
    lubridate::ymd()
  
  invoice <- page %>%
    html_node("table") %>%
    html_table(fill = TRUE) %>%
    as_tibble() %>%
    tail(-2) %>%
    head(-5) %>% 
    set_names(c("date", "name", "pay", "spacies", "times", "monthly_times", "monthly_pay", "note")) %>% 
    select(date, name, pay) %>% 
    filter(date != "") %>% 
    mutate(tag = str_sub(invoice_date, 1, 7)) %>% 
    mutate(pay = str_remove(pay, ",") %>% as.integer) %>% 
    mutate(date = ymd(date)) %>% 
    select(tag, date, pay, name)
  
  return(invoice)
}
