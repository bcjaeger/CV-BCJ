
library(dlstats)
library(scholar)
library(tidyverse)
library(glue)

my_packages <- c("r2glmm", "obliqueRSF", "tibbleOne")

linked_packages <- c(
  r2glmm = "[r2glmm](https://cran.r-project.org/web/packages/r2glmm/index.html)",
  obliqueRSF = "[obliqueRSF](https://cran.r-project.org/web/packages/obliqueRSF/index.html)",
  tibbleOne = "[tibbleOne](https://bcjaeger.github.io/tibbleOne/)"
)

git_repos <- c(
  r2glmm = "[GitHub Repository with ReadMe](https://github.com/bcjaeger/r2glmm)",
  obliqueRSF = "[GitHub Repository with ReadMe](https://github.com/bcjaeger/obliqueRSF)",
  tibbleOne = "[Github Repository with ReadMe](https://github.com/bcjaeger/tibbleOne)"
)

scholar_id = '4IKD_roAAAAJ&hl=en&oi=ao'

pkg_r2glmm <- c(
  "Package ‘r2glmm’" = 'r2glmm', 
  "R2glmm: computes R squared for mixed (multilevel) models" = 'r2glmm', 
  "r2glmm: Computes R squared for mixed (multilevel) models (LMMs and GLMMs)" = 'r2glmm'
)

pkg_orsf <- c()
pkg_tibbleOne <- c()
pkg_pubs <- c(pkg_r2glmm, pkg_orsf, pkg_tibbleOne)

pub_stats <- get_publications(scholar_id) %>%
  as_tibble() %>% 
  filter(title %in% names(pkg_pubs)) %>% 
  mutate(title = recode(title, !!!pkg_pubs)) %>% 
  group_by(title) %>% 
  select(title, cites) %>% 
  summarise_all(sum) %>% 
  ungroup() %>% 
  mutate(title = as.character(title))

my_stats <- cran_stats(my_packages) 

start_years <- my_stats %>% 
  group_by(package) %>% 
  arrange(start) %>% 
  slice(1) %>% 
  pull(start) %>% 
  lubridate::year()

# start_years <- c(start_years, 2019)
# my_packages <- c(my_packages, 'tibbleOne')

sub_titles <- tibble(
  title = factor(my_packages, levels = my_packages),
  start = start_years,
  subtitle = c(
    "Compute model and semi-partial R-squared for mixed models",
    "Fit and interpret oblique random survival forests",
    "Convenient framework to tabulate participant characteristics."
  )
)

bcj_packages <- my_stats %>% 
  group_by(package) %>% 
  summarise(
    total_downloads = format(sum(downloads),big.mark=','),
    last_check = max(end)
  ) %>% 
  rename(title = package) %>% 
  right_join(sub_titles, by = 'title') %>%
  left_join(pub_stats, by = 'title') %>% 
  mutate(
    title = linked_packages,
    section = 'r_packs',
    cites = if_else(is.na(cites), 0, cites),
    description_1 = git_repos,
    description_2 = glue(
      "Total downloads as of {last_check}: {total_downloads}"
    ),
    description_3 = glue(
      "Total citations: {cites}"
    ),
    in_resume = FALSE,
    location = NA,
    end = start
  ) %>% 
  select(-c(total_downloads, last_check, cites))


all_package_summary <- my_stats %>% 
  summarise(
    total_downloads = format(sum(downloads),big.mark=','),
    last_check = max(end)
  ) %>% 
  glue_data("R package downloads: {total_downloads}")

# bcj_packages$description_2[3] <- ""

write_csv(bcj_packages, 'data/output/BCJ_Rpacks.csv')
write_rds(all_package_summary, 'data/inline/bcj_rstats_dl.rds')

