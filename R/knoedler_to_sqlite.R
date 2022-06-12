library(tidyverse)
library(RSQLite)
library(GPIdata2)
library(stringr)

db <- dbConnect(RSQLite::SQLite(), "normalized_knoedler.sqlite3")
load("nyc_knoedler.rda")

nyc_knoedler <- nyc_knoedler %>%
  mutate(id = row_number())

sales <- nyc_knoedler %>%
  select(title, genre, object_type, height, width, purchase_date, sale_date, purchase_price, sale_price) %>%
  mutate(id = row_number(), purchase_date = as.character(purchase_date), sale_date = as.character(sale_date)) %>%
  select(id, everything())

sales %>% dbWriteTable(db, value = ., name = "sales", append = TRUE)

nyc_knoedler_artists <- nyc_knoedler %>%
  select(sale_id = id, artists, artist_nationality) %>%
  separate(artists, into = c("artist1", "artist2", "artist3", "artist4"), sep = ";" , fill = "right") %>%
  gather(artist1:artist4, key = "number", value = "artist", na.rm = TRUE)

artists <- nyc_knoedler_artists %>%
  distinct(artist, artist_nationality) %>%
  mutate(id = row_number()) %>%
  select(id, artist, nationality = artist_nationality)

artists %>%
  dbWriteTable(db, value = ., name = "artists", append = TRUE)

nyc_knoedler_artists %>%
  left_join(select(artists, artist_id = id, artist), by = c("artist")) %>%
  select(sale_id, artist_id) %>%
  dbWriteTable(db, value = ., name = "sales_artists", append = TRUE)

collectors <- bind_rows(
  select(nyc_knoedler, collector = buyer, address = buyer_address, type = buyer_type),
  select(nyc_knoedler, collector = seller, type = seller_type)
) %>%
  distinct() %>%
  group_by(collector) %>%
  summarize(address = first(address), type = first(type)) %>%
  ungroup() %>%
  mutate(id = row_number()) %>%
  select(id, collector, address, type)

collectors %>% dbWriteTable(db, value = ., name = "collectors", append = TRUE)

nyc_knoedler %>%
  left_join(select(collectors, buyer_id = id, collector), by = c("buyer" = "collector")) %>%
  select(sale_id = id, buyer_id) %>%
  dbWriteTable(db, value = ., name = "sales_buyers", append = TRUE)

nyc_knoedler %>%
  left_join(select(collectors, seller_id = id, collector), by = c("seller" = "collector")) %>%
  select(sale_id = id, seller_id) %>%
  dbWriteTable(db, value = ., name = "sales_sellers", append = TRUE)

dbDisconnect(db)

