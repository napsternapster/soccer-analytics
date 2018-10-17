library(hexSticker)
library(magick)

imgurl <- image_read('Capture.png')

#https://s-media-cache-ak0.pinimg.com/originals/e0/f7/37/e0f737957bbbd8d0496d855a2a1ffe12.png
#imgurl <- "http://i.imgur.com/pI3LpUF.png"

sticker(imgurl, 
        package = "goals ~ poisson(lambda = 1.4)", 
        p_color = 'black',
        p_size = 8, 
        s_x = 1, 
        s_y = .75, 
        s_width = 1,
        s_height = 1,
        h_fill = 'white',
        h_color = 'black',
        spotlight = F,
        filename="./imgfile.png")