library(rvest)
library(tidyverse)
library(magrittr)
library(dotenv)

# ログイン状態のセッションを作る ------------------------------------------------------------
agent <- httr::user_agent("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36")

login_page <- html_session("https://myluxurycard.co.jp", agent)

login_form <- html_form(login_page)[[1]] %>% 
  set_values(webMemberId="user", webMemberPass="pass")

session <- submit_form(login_page, login_form)

# ログイン状態でスクレイピング ----------------------------------------------------
page <- session %>% 
  jump_to("https://netstation2.aplus.co.jp/netstation/MyFlowServlet?origin=GlobalNavi&event=detail_01") %>% 
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
  
 
 