library(tidyverse)

attach_derby_id <- function(home, away, rivalries){
  
  result <- rivalries %>%
    mutate(
      flag = map(
        rivalry, 
        function(x)
          (home %in% x) & (away %in% x)
      ) %>% unlist()
    ) %>% filter(flag) %>% pull(rivalry_id)
  
  # If the game isn't a derby game
  if(length(result) < 1){
    result <- NA
  }
  
  return(result)
  
}

calculate_derby_form <- function(df, rivalry){
  
  t1 <- rivalry$team1_match
  t2 <- rivalry$team2_match
  rivalry_indices <- which(df$rivalry_id == rivalry$rivalry_id)
  
  derby_form <- map_df(
    rivalry_indices, 
    function(rivalry_index) 
      # Add the form data to the derby match data
      cbind(
        df[rivalry_index, ] %>% 
          mutate(
            result_name = case_when(result == 'A' ~ visitor, result == 'H' ~ home, TRUE ~ result)
            ),
        form_calculator(df[1:(rivalry_index - 1),], t1, t2)
      )
  )
  
  return(derby_form)
}

form_calculator <- function(df, t1, t2){
  
  team1_form <- df %>% 
      arrange(desc(Date)) %>%
      filter((home == t1) | (visitor == t1)) %>%
      top_n(., n = 5, wt = Date) %>%
      filter(Season == max(Season)) %>%
      mutate(
    pts = case_when(
      (home == t1) & (hgoal > vgoal) ~ 3,
      (home == t1) & (hgoal < vgoal) ~ 0,
      (visitor == t1) & (hgoal > vgoal) ~ 0,
      (visitor == t1) & (hgoal < vgoal) ~ 3,
      TRUE ~ 1
    )
  ) %>% 
    summarise(form1 = round(mean(pts), 2)) %>%
    mutate(rival1 = t1)
  
  team2_form <- df %>%
      arrange(desc(Date)) %>%
      filter((home == t2) | (visitor == t2)) %>%
      top_n(., n = 5, wt = Date) %>%
      filter(Season == max(Season)) %>%
      mutate(
      pts = case_when(
        (home == t2) & (hgoal > vgoal) ~ 3,
        (home == t2) & (hgoal < vgoal) ~ 0,
        (visitor == t2) & (hgoal > vgoal) ~ 0,
        (visitor == t2) & (hgoal < vgoal) ~ 3,
        TRUE ~ 1
      )
    ) %>%
    summarise(form2 = round(mean(pts, na.rm = T), 2))  %>%
    mutate(rival2 = t2)
  
  form <- cbind(team1_form, team2_form) %>% 
    select(rival1, rival2, form1, form2) %>%
    mutate(
      form_team = case_when(form1 > form2 ~ rival1, form1 < form2 ~ rival2, TRUE ~ 'Equal')
      )
  
  return(form)
  
}