

library(tidyverse)
library(glue)

grants <- read_csv("data/source/BCJ_Grants.csv") %>%
  as_tibble(.name_repair = 'universal') %>%
  select(
    title = Project.Title,
    subtitle = PI.Name,
    description_1 = Primary.Sponsor,
    description_2 = Project.Status,
    grant_num = Sponsor.Award.Number,
    date_processed = Processed.Date
  ) %>%
  arrange(desc(date_processed)) %>%
  mutate(
    section = 'grants',
    subtitle = gsub(
      pattern = 'Jaeger, Byron C.',
      replacement = '**Jaeger, Byron C.**',
      x = subtitle,
      fixed = TRUE
    ),
    subtitle = glue("*Primary Investigator:* {subtitle}"),
    in_resume = FALSE,
    description_1 = glue("*Submitted to* {description_1}"),
    end = lubridate::year(date_processed),
    description_2 = if_else(
      condition = !is.na(grant_num),
      true = glue("{description_2}, {grant_num}"),
      false = description_2
    )
  ) %>%
  select(
    section,
    in_resume, 
    title, 
    subtitle,
    starts_with("descr"),
    end
  )

write_csv(grants, 'data/output/BCJ_Grants.csv')