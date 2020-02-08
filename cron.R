library(cronR)

cmd <- cron_rscript("./scraping.R")

cron_add(cmd, frequency = 'minutely', id = 'job1', description = 'Bill data crawler')
