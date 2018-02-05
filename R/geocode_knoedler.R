library(tidyverse)
library(ggmap)

# Code for geocoding addresses - results now saved in R/geocoded._addresses.rda
#
# buyer_addresses <- knoedler_buyers %>%
#   count(buy_auth_addr)
#
# pb <- progress_estimated(nrow(buyer_addresses))
#
# gc_addresses <- map(buyer_addresses$buy_auth_addr, function(x) {
#   safe_geocode <- safely(geocode)
#   safe_geocode(x, source = "dsk", output = "more")
# })
#
# addresses <- gc_addresses %>%
#   map("result") %>%
#   map_df(function(x) {
#     if  (is.data.frame(x)) {
#       x
#     } else {
#       data.frame(lon = NA_real_)
#     }
#   })
#
# geocoded_addresses <- bind_cols(buyer_addresses, addresses)
#
# save(geocoded_addresses, file = "geocoded_addresses.rda")

load("R/geocoded_addresses.rda")
load("R/imputed_k.rda")

nyc_addresses <- geocoded_addresses %>%
  filter(type == "street_address", locality %in% c("New York", "Brooklyn")) %>%
  mutate(coordinates = paste(lat, lon, sep = ","))

nyc_knoedler <- example_imputed_k %>%
  inner_join(nyc_addresses, by = c("sale_buyer_address" = "buy_auth_addr")) %>%
  mutate(
    seller = case_when(
      purchase_seller_names != "NEW" ~ purchase_seller_names,
      TRUE ~ purchase_seller_uid
    ),
    buyer = case_when(
      sale_buyer_names != "NEW" ~ sale_buyer_names,
      TRUE ~ sale_buyer_uid
  )) %>%
  select(
    title,
    genre,
    object_type,
    height,
    width,
    area,
    seller,
    buyer,
    sale_buyer_address,
    coordinates,
    purchase_date = imp_purchase_date,
    sale_date = imp_sale_date,
    purchase_price = expense_amount,
    sale_price = revenue_amount
  )

write_csv(nyc_knoedler, path = "nyc_knoedler.csv", na = "")

