# Description -------------------------------------------------------------
# This script creates a function that retrieves the most viewed wikipedia
# articles per country.
#
# Author: Judith Bourque
# Date: 2022-09-10
#
# Function ----------------------------------------------------------------

pageviews_top_per_country <-
  function (country = "CA",
            access = "all-access",
            year = format(Sys.Date(), "%Y"),
            month = format(Sys.Date(), "%m"),
            day = format(Sys.Date()-1, "%d"),
            user_agent = Sys.getenv("WIKIMEDIA_USER_AGENT")) {
    # Get response from API
    request_result <-
      httr::GET(
        url = paste(
          "https://wikimedia.org/api/rest_v1/metrics/pageviews/top-per-country",
          country,
          access,
          year,
          month,
          day,
          sep = "/"
        ),
        config = httr::user_agent(user_agent)
      )
    
    if(httr::http_error(request_result)){
      warning("The request failed")
    } else {
      httr::content(request_result)
    }
    
    # Parse returned text with fromJSON()
    parsed <- jsonlite::fromJSON(httr::content(request_result, as = "text"))
    
    # Create dataframe
    df_untidy <- parsed[["items"]][["articles"]][[1]]
    
    # Clean article names
    df <- df_untidy %>% 
      dplyr::mutate(
        article = gsub("_", " ", article),
        date = as.POSIXct(paste(year, month, day, sep = "-"), tz = "UTC"),
        country = country,
        access = access
      )
    
    # Return dataframe
    df
  }