manager_change_comparison <- function(df, change_index){
    
    ## Find the maximum five games for the old and new manager
    if(nrow(df[1:change_index - 1, ]) < 5){
        lower_game_set <- 1:(change_index - 1)
    } else{
        lower_game_set <- (change_index - 5):(change_index - 1)
    }
    
    if(nrow(df[change_index:nrow(df), ]) < 5){
        upper_game_set <- (change_index):nrow(df)
    } else{
        upper_game_set <- (change_index):(change_index + 4)
    }
    
    ids <- c(rep('manager_prev_avg_pts', length(lower_game_set)), 
             rep('manager_new_avg_pts', length(upper_game_set)))
    
    df <- df[c(lower_game_set, upper_game_set),] %>% 
        mutate(id = ids) %>% 
        group_by(team, id) %>% summarise(points_mu_max_5_games = mean(points)) %>% 
        spread(id, points_mu_max_5_games) %>%
        ungroup()
    
    return(df)
}

club_ssn_data <- function(ssn, club, df){
    
    df_test <- df %>%  
        filter(team_1 == club | team_2 == club, season == ssn) %>%
        mutate(
            manager = ifelse(team_1 == club, manager_1, manager_2),
            manager_change = manager != lag(manager),
            team = club,
            result = case_when(
                (team_1 == club) & (team_1_score > team_2_score) ~ 'W',
                (team_2 == club) & (team_1_score < team_2_score) ~ 'W',
                (team_1 == club) & (team_1_score < team_2_score) ~ 'L',
                (team_2 == club) & (team_1_score > team_2_score) ~ 'L',
                TRUE ~ 'D'
            ),
            points = case_when(result == 'W' ~ 3, result == 'L' ~ 0, TRUE ~ 1)
        )
    
    change_indices = which(df_test$manager_change == TRUE)
    mc <- paste(df_test$manager, lag(df_test$manager), sep = ' -> ')[df_test$manager_change == TRUE]
    mc <- mc[!is.na(mc)]
    
    df_test_report <- map_df(change_indices, manager_change_comparison, df = df_test) %>%
        # I had to recreate the team variable since map_df destroyed it
        mutate(team = club, season = ssn, manager_change = mc)
    
    return(df_test_report)
    
}

# A simple helper function to generate every combination of season and club
ssn_clubs_combinations <- function(ssn, df){
    
    clubs_in_ssn <- c(
        df %>% filter(season == ssn) %>% pull(team_1), 
        df %>% filter(season == ssn) %>% pull(team_2)) %>% 
        unique()
    
    result <- expand.grid(ssn, clubs_in_ssn)
    return(result)
}
