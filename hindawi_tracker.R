library(tidyverse)
library(rvest)


hindawi_journals<-read_html("https://www.hindawi.com/journals/")

journal_title<-hindawi_journals%>%
  html_nodes(".sc-gzOgki")%>%
  html_text2()

data<-hindawi_journals%>%
  html_nodes(".sc-hwwEjo")%>%
  html_text2()

value<-hindawi_journals%>%
  html_nodes(".sc-kPVwWT")%>%
  html_text2()

data_values<-data.frame(data=data,values=value)%>%
  mutate(bin_apc=ifelse(data=="APC",1,0))%>%
  mutate(bin_apc2=cumsum(bin_apc))%>%
  mutate(bin_apc2=ifelse(bin_apc2==0,1,bin_apc2))%>%  #put 1s instead of 0s in first rows
  mutate(journal=journal_title[bin_apc2])%>%
  select(journal, data, values,-bin_apc,-bin_apc2)

dir.create("data") 

write.csv(data_values,row.names = FALSE,paste0("data/report",Sys.Date(),".csv"))
