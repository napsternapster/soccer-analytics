library(dplyr)
library(visNetwork)

#http://datastorm-open.github.io/visNetwork/

setwd('C:/Users/Gordon/Desktop/_Projects/coding/paulista_network')

paulista_results <- read.csv('paulista_results_2016.csv')
paulista_table <-  read.csv('paulista_table_2016.csv')

#Just Santos
paulista_results <- paulista_results[paulista_results$Home == 'Santos'|paulista_results$Away == 'Santos',]
paulista_table <- paulista_table[(paulista_table$Group!='Group A')|(paulista_table$Team=='Santos'),]
  
paulista_table$Group <- sapply(paulista_table$Group, (function(x) paste0('Group ', x)))

nodes <- data.frame(label = paulista_table$Team, 
                    group = paulista_table$Group,
                    id = 1:nrow(paulista_table),
                    title = paulista_table$Team)

paulista_results$hid <- sapply(paulista_results$Home, 
                               (function(x) as.character(nodes[nodes$label==x,]$id)))
paulista_results$aid <- sapply(paulista_results$Away, 
                               (function(x) as.character(nodes[nodes$label==x,]$id)))

edges <- data.frame(from = paulista_results$hid,  
                    to = paulista_results$aid,  
                    value = paulista_results$Score,
                    title = paste0("Score: ", paulista_results$Score),
                    arrows = 'from')

lay.out <- c("layout_in_circle", "layout_as_star")

visNetwork(nodes,edges, main = "Paulistao 2016 Group Stage") %>%
  visIgraphLayout(layout = lay.out[2]) %>%
  visLegend() %>%  
  visInteraction(navigationButtons = T, selectConnectedEdges = T) %>%
  visOptions(highlightNearest = T, nodesIdSelection = T) #%>%
  #visSave(file = "network.html")






