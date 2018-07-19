calculate_form <- function(data, team, ref_game_index){
  
  form_summary <- data[1:ref_game_index-1,] %>% filter(
    (home==team) | (visitor==team)
  ) %>%
    mutate(
      club = team, 
      pts = ifelse(result=='D', 
                   1,
                   ifelse(((result=='H') & (home==team)) | ((result=='A') & (visitor==team)),
                          3, 
                          0)
      ) 
    ) %>%
    arrange(desc(Date)) %>% 
    top_n(5, Date) %>%
    group_by(club) %>%  
    summarise(
      pts_last_five_games = sum(pts),
      form = round(sum(pts)/15, 2)
    )
  
  return(form_summary)
}