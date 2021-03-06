library(ggplot2)

ggplot() +
  geom_rect(aes(xmin = 0, xmax = 100, ymin = 0, ymax = 100), fill = NA, colour = "#000000", size = 1) +
  geom_rect(aes(xmin = 0, xmax = 50, ymin = 0, ymax = 100), fill = NA, colour = "#000000", size = 1) +
  geom_rect(aes(xmin = 17, xmax = 0, ymin = 21, ymax = 79), fill = NA, colour = "#000000", size = 1) +
  geom_rect(aes(xmin = 0, xmax = 17, ymin = 0, ymax = 21), fill = NA, colour = "#000000", size = 1) +
  geom_rect(aes(xmin = 0, xmax = 17, ymin = 100, ymax = 79), fill = NA,colour = "#000000", size = 1) +
  geom_rect(aes(xmin = 83, xmax = 100, ymin = 21, ymax = 79), fill = NA, colour = "#000000", size = 1) +
  geom_rect(aes(xmin=100, xmax=83, ymin=0, ymax=21), fill= NA, colour = "#000000", size=1) + 
  geom_rect(aes(xmin = 17, xmax = 83, ymin = 36.8, ymax = 63.2), fill = NA, colour = "#000000", size = 1) +
  geom_rect(aes(xmin = 17, xmax = 83, ymin = 79, ymax = 63.2), fill = NA, colour = "#000000", size = 1) +
  geom_rect(aes(xmin = 17, xmax = 83, ymin = 36.8, ymax = 21), fill = NA, colour = "#000000", size = 1) +
  geom_rect(aes(xmin=100, xmax=83, ymin=100, ymax=79), fill= NA, colour = "#000000", size=1) + 
  geom_rect(aes(xmin = 17, xmax = 31.2, ymin = 0, ymax = 21), fill = NA, colour = "#000000", size = 1) +
  geom_rect(aes(xmin = 17, xmax = 31.2, ymin = 100, ymax = 79), fill = NA, colour = "#000000", size = 1) +
  geom_rect(aes(xmin = 83, xmax = 68.8, ymin = 100, ymax = 79), fill = NA, colour = "#000000", size = 1) +
  geom_rect(aes(xmin = 83, xmax = 68.8, ymin = 0, ymax = 21), fill = NA, colour = "#000000", size = 1)