
library(dlstats)
library(tidyverse)
library(glue)

my_packages <- c("r2glmm", "obliqueRSF")

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

my_stats <- cran_stats(my_packages) 

start_years <- my_stats %>% 
  group_by(package) %>% 
  arrange(start) %>% 
  slice(1) %>% 
  pull(start) %>% 
  lubridate::year()

start_years <- c(start_years, 2019)
my_packages <- c(my_packages, 'tibbleOne')

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
  mutate(
    title = linked_packages,
    section = 'r_packs',
    description_1 = git_repos,
    description_2 = glue(
      "Total downloads as of {last_check}: {total_downloads}"
    ),
    in_resume = FALSE,
    location = NA,
    end = start
  ) %>% 
  select(-c(total_downloads, last_check))


all_package_summary <- my_stats %>% 
  summarise(
    total_downloads = format(sum(downloads),big.mark=','),
    last_check = max(end)
  ) %>% 
  glue_data("R package downloads: {total_downloads}")

bcj_packages$description_2[3] <- ""

write_csv(bcj_packages, 'data/output/BCJ_Rpacks.csv')
write_rds(all_package_summary, 'data/inline/bcj_rstats_dl.rds')

