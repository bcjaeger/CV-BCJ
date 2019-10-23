
library(scholar)
library(tidyverse)
library(glue)

scholar_id = '4IKD_roAAAAJ&hl=en&oi=ao'

# Use google ID to get scholar info
cites_by_pub <- get_publications(scholar_id) %>%
  as_tibble() %>% 
  select(ID = pubid, cites) %>% 
  mutate(ID = as.character(ID)) 

pubs <- read_csv("data/manual/BCJ_Publications.csv") %>% 
  left_join(cites_by_pub, by = "ID") %>% 
  select(-ID) %>% 
  mutate(
    cites = if_else(is.na(cites), 0, cites),
    section = 'publications',
    in_resume = FALSE,
    # bolden my name
    author = gsub(
      pattern = 'BC Jaeger',
      replacement = '**BC Jaeger**',
      x = author,
      fixed = TRUE
    ),
    author = gsub(
      pattern = '..',
      replacement = '...',
      x = author,
      fixed = TRUE
    ),
    title = glue("[{title}]({link})"),
    journal = paste0("*",journal,"*"),
    author = glue("{author} <br/> {journal}, {number}"),
    description_1 = glue("Citations: {cites}"),
    date = as.Date(date, format = '%m/%d/%Y'),
    year = lubridate::year(date)
  ) %>% 
  rename(
    subtitle = author,
    description_2 = doi,
    end = year
  )

pubs_summary <- glue("Total publications: {nrow(pubs)}")
cite_summary <- glue("Total citations: {sum(pubs$cites)}")

write_rds(pubs_summary, 'data/inline/bcj_npubs.rds')
write_rds(cite_summary, 'data/inline/bcj_ncite.rds')

pubs %>% 
  select(
    section,
    in_resume,
    title,
    subtitle,
    end,
    description_1,
    aside
  ) %>% 
  write_csv('data/output/BCJ_Publications.csv')



