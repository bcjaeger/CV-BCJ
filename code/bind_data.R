
scripts <- list.files('code/', pattern = 'build', full.names = TRUE)

for (script in scripts) source(script)

dats_to_bind <- list.files(
  path = "data/output/", 
  pattern = '.csv',
  full.names = TRUE
) %>% 
  map(read_csv) %>% 
  map(mutate, end = as.character(end)) %>% 
  bind_rows()

# BCJ.csv is the file I manage by hand
# dats_to_bind are (somewhat) automated

bcj <- read_csv('data/BCJ.csv') %>% 
  bind_rows(dats_to_bind)
