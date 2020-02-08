library(rvest)
library(tidyverse)
library(magrittr)
library(dotenv)
library(assertthat)
library(jsonlite)

get_new_session <- function() {
  agent_str <- paste("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_2)",
                     "AppleWebKit/537.36 (KHTML, like Gecko)",
                     "Chrome/71.0.3578.98 Safari/537.36")
  agent <- httr::user_agent(agent_str)
  login_page <- html_session("https://myluxurycard.co.jp", agent)
  login_form <- html_form(login_page) %>% 
    extract2(1) %>% 
    set_values(webMemberId = Sys.getenv("LAXURY_USER"), webMemberPass=Sys.getenv("LAXURY_PASS"))
  
  session <- submit_form(login_page, login_form)
  return(session)
}

get_session_recycle <- function() {
  exists("session")
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

get_bill <- function(session, no = 1) {
  assertthat::assert_that(is.session(session))
  if (lubridate::now() - session$response$date > lubridate::dminutes(10))
    session <- get_new_session()
  
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
    filter(date != "")
  
  return(list(
    date = invoice_date,
    invoice = invoice
  ))
}
