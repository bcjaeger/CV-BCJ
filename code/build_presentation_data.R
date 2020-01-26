
library(tidyverse)
library(glue)
library(scholar)

scholar_id = '4IKD_roAAAAJ&hl=en&oi=ao'

# Use google ID to get all scholar info
cites_by_pub <- get_publications(scholar_id) %>%
  as_tibble() %>% 
  select(ID = pubid, cites = cites) %>% 
  mutate(ID = as.character(ID))

pres <- read_csv("data/manual/BCJ_Presentations.csv") %>% 
  left_join(cites_by_pub, by = "ID") %>% 
  select(-ID) %>% 
  mutate(
    section = 'presentations',
    in_resume = FALSE,
    # bolden my name
    author = gsub(
      pattern = 'BC Jaeger',
      replacement = '**BC Jaeger**',
      x = author,
      fixed = TRUE
    ),
    # fix dot dots 
    #  I can't write dot dot dot manually
    #  b/c excel autoformats it
    author = gsub(
      pattern = '..',
      replacement = '...',
      x = author,
      fixed = TRUE
    ),
    cites = if_else(is.na(cites), 0, cites),
    title = glue("[{title}]({link})"),
    journal = paste0("*",journal,"*"),
    author = glue("{author} <br/> {journal}, {number}"),
    description_1 = glue("Citations: {cites}"),
    date = as.Date(date, format = '%m/%d/%Y'),
    year = lubridate::year(date)
  ) %>% 
  rename(
    subtitle = author,
    end = year
  )

pres %>% 
  select(
    section,
    in_resume,
    title,
    subtitle,
    end,
    description_1
  ) %>% 
  write_csv('data/output/BCJ_Presentations.csv')
