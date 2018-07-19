library(dplyr)
library(markdown)
library(irlba)
library(igraph)
library(visNetwork)

paulista_results <- read.csv('paulista_results_2016.csv')
paulista_table <-  read.csv('paulista_table_2016.csv')
teams <- c('All', as.character(paulista_table$Team))

server <- function(input, output) {
  
  output$network <- renderVisNetwork({
    
    team <- input$select
    
    if(team=='All'){
      paulista_r <- paulista_results
      paulista_t <- paulista_table
      lay.out <- "layout_in_circle"
    }
    else{
      paulista_r <- paulista_results[paulista_results$Home == team|paulista_results$Away == team,]
      paulista_t <- paulista_table[(paulista_table$Group!=as.character(paulista_table[paulista_table$Team==team, ]$Group))|(paulista_table$Team==team),]
      temp.row <- paulista_t[paulista_t$Team==team,]
      paulista_t[paulista_t$Team==team,] <- paulista_t[1,]
      paulista_t[1,] <- temp.row
      lay.out <- "layout_as_star"
    }
    
    paulista_t$Group <- sapply(paulista_t$Group, (function(x) paste0('Group ', x)))
    
    nodes <- data.frame(label = paulista_t$Team, 
                        group = paulista_t$Group,
                        id = 1:nrow(paulista_t),
                        title = paulista_t$Team)
    
    paulista_r$hid <- sapply(paulista_r$Home, 
                             (function(x) as.character(nodes[nodes$label==x,]$id)))
    paulista_r$aid <- sapply(paulista_r$Away, 
                             (function(x) as.character(nodes[nodes$label==x,]$id)))
    
    edges <- data.frame(from = paulista_r$hid,  
                        to = paulista_r$aid,  
                        value = paulista_r$Score,
                        title = paste0("Matchday: ", paulista_r$Round, "<br>Home: ", paulista_r$Home, "<br>Away: ", paulista_r$Away, "<br>Score: ", paulista_r$Score),
                        arrows = 'from')
    
    visNetwork(nodes,edges, main = "Paulistao 2016 Group Stage") %>%
      visIgraphLayout(layout = lay.out) %>%
      visLegend() %>%  
      visInteraction(navigationButtons = T, selectConnectedEdges = T) %>%
      visOptions(highlightNearest = T, nodesIdSelection = T)
  })
}

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      includeMarkdown("app_intro.md")
    ), #end sidebarPanel
    mainPanel(
      selectInput("select", label = h3("Select Network"), 
                  choices = teams, 
                  selected = 'All'),
      visNetworkOutput("network")
      ) #end mainPanel
  ) #end sidebarLayout
) # end fluidPage

shinyApp(ui = ui, server = server)