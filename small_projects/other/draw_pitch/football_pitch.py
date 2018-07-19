import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.patches import Ellipse

x_size = 105.0
y_size = 68.0

def draw_pitch():
    #set up field    
    fig = plt.figure(figsize=(x_size/10, y_size/10))
    fig.patch.set_facecolor('#78AB46')

    axes = fig.add_subplot(1, 1, 1, axisbg='#78AB46')
    axes.xaxis.set_visible(False)
    axes.yaxis.set_visible(False)

    plt.xlim([-5,x_size+5])
    plt.ylim([-5,y_size+5])

    box_height = ((16.5*2 + 7.32)/y_size)/1.15
    box_width = (16.5/x_size)/1.15

    team_colors = {'H': 'red',
                   'A': 'white'}    

    r1 = plt.Rectangle((0.04338, 0.0641), (0.95652-0.04338), (0.9359-0.0641),
                       edgecolor="white", facecolor="none", alpha=1, transform=axes.transAxes) #pitch

    r2 = plt.Line2D([0.5, 0.5], [0.9359, 0.0641],
                    c='w', transform=axes.transAxes) #half-way line

    r3 = plt.Rectangle((0.04338, (1-box_height)/2), box_width, box_height,
                       ec='w', fc='none', transform=axes.transAxes) #penalty area

    r4 = plt.Rectangle((0.95652-box_width, (1-box_height)/2), box_width, box_height,
                       ec='w', fc='none', transform=axes.transAxes) #penalty area

    r5 = Ellipse((0.5, 0.5), 9.15*2/x_size, 9.15*2/y_size,
                                    ec='w', fc='none', transform=axes.transAxes) #middle circle

    fig.lines.extend([r1, r2, r3, r4, r5])
    
    return fig, axes