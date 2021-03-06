---
title: 'Weekly Exercises #5'
author: "Talia C"
output: 
  html_document:
    keep_md: TRUE
    toc: TRUE
    toc_float: TRUE
    df_print: paged
    code_download: true
---





```r
library(tidyverse)     # for data cleaning and plotting
library(gardenR)       # for Lisa's garden data
library(lubridate)     # for date manipulation
library(openintro)     # for the abbr2state() function
library(palmerpenguins)# for Palmer penguin data
library(maps)          # for map data
library(ggmap)         # for mapping points on maps
library(gplots)        # for col2hex() function
library(RColorBrewer)  # for color palettes
library(sf)            # for working with spatial data
library(leaflet)       # for highly customizable mapping
library(ggthemes)      # for more themes (including theme_map())
library(plotly)        # for the ggplotly() - basic interactivity
library(gganimate)     # for adding animation layers to ggplots
library(transformr)    # for "tweening" (gganimate)
library(gifski)        # need the library for creating gifs but don't need to load each time
library(shiny)         # for creating interactive apps
library(ggimage)
theme_set(theme_minimal())
```


```r
# SNCF Train data
small_trains <- read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-02-26/small_trains.csv") 

# Lisa's garden data
data("garden_harvest")

# Lisa's Mallorca cycling data
mallorca_bike_day7 <- read_csv("https://www.dropbox.com/s/zc6jan4ltmjtvy0/mallorca_bike_day7.csv?dl=1") %>% 
  select(1:4, speed)

# Heather Lendway's Ironman 70.3 Pan Am championships Panama data
panama_swim <- read_csv("https://raw.githubusercontent.com/llendway/gps-data/master/data/panama_swim_20160131.csv")

panama_bike <- read_csv("https://raw.githubusercontent.com/llendway/gps-data/master/data/panama_bike_20160131.csv")

panama_run <- read_csv("https://raw.githubusercontent.com/llendway/gps-data/master/data/panama_run_20160131.csv")

#COVID-19 data from the New York Times
covid19 <- read_csv("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv")
```



## Instructions

* Put your name at the top of the document. 

* **For ALL graphs, you should include appropriate labels.** 

* Feel free to change the default theme, which I currently have set to `theme_minimal()`. 

* Use good coding practice. Read the short sections on good code with [pipes](https://style.tidyverse.org/pipes.html) and [ggplot2](https://style.tidyverse.org/ggplot2.html). **This is part of your grade!**

* **NEW!!** With animated graphs, add `eval=FALSE` to the code chunk that creates the animation and saves it using `anim_save()`. Add another code chunk to reread the gif back into the file. See the [tutorial](https://animation-and-interactivity-in-r.netlify.app/) for help. 



## Warm-up exercises from tutorial

### Warmup Exercise #1
  1. Choose 2 graphs you have created for ANY assignment in this class and add interactivity using the `ggplotly()` function.

#### Trout Graph from Tidy Tuesday

```r
stocked <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-06-08/stocked.csv')

fish_1 <- stocked %>%
  filter(SPECIES %in% c("BKT", "BNT", "LAT", "RBT")) %>% 
  group_by(SPECIES, YEAR) %>%
  summarize(total_stocked = sum(NO_STOCKED)) %>% 
  ggplot(mapping = aes(x = YEAR, 
                       y = total_stocked, 
                       color = SPECIES)) +
  geom_line() +
  geom_text(aes(label = SPECIES)) +
  scale_y_continuous(labels = scales::comma) + 
  scale_color_discrete(name = "species", 
                       labels = c("Brook Trout", 
                                  "Brown Trout", 
                                  "Lake Trout", 
                                  "Rainbow Trout")) + 
  labs(x = NULL, 
       y = NULL,
       title = "Total Trout Stocked in the Great Lakes Over the Years",
       caption = "Plot created by Talia C, data from Great Lakes Fishing Commission") + 
  theme(legend.position = "none") +
  transition_reveal(YEAR) 

animate(fish_1, duration = 15)
```

![](week-5-exercise-TC_files/figure-html/unnamed-chunk-1-1.gif)<!-- -->


```r
anim_save("fish_1.gif")

knitr::include_graphics("fish_1.gif")
```




#### Covid19 graph 

```r
covid19 <- read_csv("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv")

covid_1 <- covid19 %>%
  filter(state %in% c("Minnesota", "Wisconsin", "Iowa", "North Dakota", "South Dakota")) %>%
  ggplot(mapping = aes(x = date, 
                       y = cases, 
                       color = state)) +
  geom_line() + 
  geom_text(aes(label = state)) +
  scale_y_log10(labels = scales::comma) +
  labs(x = NULL, 
       y = NULL, 
       title = "Cumulative COVID-19 Cases Over Time",
       subtitle = "Date: {frame_along}",
       caption = "Plot created by Talia C, data from covid19") +
  theme(legend.position = "none") +
  transition_reveal(date)

animate(covid_1, duration = 15)
```

![](week-5-exercise-TC_files/figure-html/unnamed-chunk-3-1.gif)<!-- -->


```r
anim_save("covid_1.gif")

knitr::include_graphics("covid_1.gif")
```
  

### Warmup Exercise #2

  2. Use animation to tell an interesting story with the `small_trains` dataset that contains data from the SNCF (National Society of French Railways). These are Tidy Tuesday data! Read more about it [here](https://github.com/rfordatascience/tidytuesday/tree/master/data/2019/2019-02-26).


```r
smalltrains <- small_trains %>%
  filter(service == "International", 
         departure_station == "PARIS LYON", 
         year == "2017") %>% 
  ggplot(aes(x = num_late_at_departure, 
             y = delay_cause,
             group = arrival_station)) +
  geom_jitter() +
  labs(title = "Number of Late Departures based on Delay Cause",
       subtitle = "Station: {closest_state}",
       caption = "Plot created by Talia C, data from Small Trains",
       x = "",
       y = "") +
  theme(plot.title.position = "plot") +
  transition_states(arrival_station, 
                    transition_length = 2, 
                    state_length = 1) +
  exit_shrink() +
  enter_recolor(color = "lightblue") +
  exit_recolor(color = "lightblue")

anim_save("smalltrains.gif")
```


```r
knitr::include_graphics("smalltrains.gif")
```



## Garden data

  3. In this exercise, you will create a stacked area plot that reveals itself over time (see the `geom_area()` examples [here](https://ggplot2.tidyverse.org/reference/position_stack.html)). You will look at cumulative harvest of tomato varieties over time. You should do the following:
  * From the `garden_harvest` data, filter the data to the tomatoes and find the *daily* harvest in pounds for each variety.  
  * Then, for each variety, find the cumulative harvest in pounds.  
  * Use the data you just made to create a static cumulative harvest area plot, with the areas filled with different colors for each vegetable and arranged (HINT: `fct_reorder()`) from most to least harvested (most on the bottom).  
  * Add animation to reveal the plot over date. 

I have started the code for you below. The `complete()` function creates a row for all unique `date`/`variety` combinations. If a variety is not harvested on one of the harvest dates in the dataset, it is filled with a value of 0.


```r
garden_harvest3 <- garden_harvest %>% 
  filter(vegetable == "tomatoes") %>% 
  group_by(variety, date) %>% 
  summarize(daily_harvest_lb = sum(weight)*0.00220462) %>% 
  ungroup() %>%
  complete(variety, date, fill = list(daily_harvest_lb = 0)) %>%
  mutate(variety = fct_reorder(variety, daily_harvest_lb),
         variety = str_to_title(variety)) %>% 
  group_by(variety) %>% 
  mutate(cum_harvest_lb = cumsum(daily_harvest_lb)) %>%
  ggplot(mapping = aes(x = date,
                       y = cum_harvest_lb,
                       fill = variety)) +
  geom_area(position = "stack") +
  labs(x = "",
       y = "",
       fill = "Variety",
       title = "Cumulative Harvest in Pounds",
       subtitle = "Date: {frame_along}") +
  transition_reveal(date)

animate(garden_harvest3, duration = 30)
```

![](week-5-exercise-TC_files/figure-html/unnamed-chunk-7-1.gif)<!-- -->

```r
anim_save("garden_harvest3.gif") 
```


```r
knitr::include_graphics("garden_harvest3.gif")
```




## Maps, animation, and movement!

  4. Map my `mallorca_bike_day7` bike ride using animation! 
  Requirements:
  * Plot on a map using `ggmap`.  
  * Show "current" location with a red point. 
  * Show path up until the current point.  
  * Color the path according to elevation.  
  * Show the time in the subtitle.  
  * CHALLENGE: use the `ggimage` package and `geom_image` to add a bike image instead of a red point. You can use [this](https://raw.githubusercontent.com/llendway/animation_and_interactivity/master/bike.png) image. See [here](https://goodekat.github.io/presentations/2019-isugg-gganimate-spooky/slides.html#35) for an example. 
  * Add something of your own! And comment on if you prefer this to the static map and why or why not.
  
  I personally like the animated version better than the static version because it shows the change over time. You also feel like you are moving with the bike so it is more interactive than a regular static graph. 
  

```r
mallorca_map <- get_stamenmap(
  bbox = c(left = 2.3245, bottom = 39.4439, right = 2.7900, top = 39.7713),
  maptype = "terrain",
  zoom = 12)

bikeimage_link <- "https://raw.githubusercontent.com/llendway/animation_and_interactivity/master/bike.png"

mallorca_bike_day7 <- mallorca_bike_day7 %>% 
  mutate(image = bikeimage_link)
  
mallorca_1 <- ggmap(mallorca_map) + 
  geom_path(data = mallorca_bike_day7, 
            aes(x = lon, 
                y = lat, 
                color = ele), 
            size = 5) + 
  geom_image(data = mallorca_bike_day7,
             aes(lon, lat, image = bikeimage_link),
             size = 0.1) +
  scale_color_viridis_c(option = "magma") +
  theme_map() + 
  theme(legend.background = element_blank()) + 
  labs(title = "Mallorca Bike Day 7",
       subtitle = "Time: {frame_along}",
       color = "Elevation",
       caption = "Plot created by Talia C, data from Mallorca Bike Day 7") + 
  annotate("segment", 
           x = 2.6002, xend = 2.532277, 
           y = 39.6277, yend = 39.64312, 
           colour = "blue", 
           size = 1.5, 
           alpha = 1, 
           arrow =arrow()) +
  annotate(geom = "label", 
           y = 39.6277,
           x = 2.6002,
           label = "The Highest Hill") +
  transition_reveal(time)

animate(mallorca_1, duration = 15, end_pause = 8)
```

![](week-5-exercise-TC_files/figure-html/unnamed-chunk-9-1.gif)<!-- -->

```r
anim_save("mallorca_1.gif")
```


```r
knitr::include_graphics("mallorca_1.gif")
```

  5. In this exercise, you get to meet my sister, Heather! She is a proud Mac grad, currently works as a Data Scientist at 3M where she uses R everyday, and for a few years (while still holding a full-time job) she was a pro triathlete. You are going to map one of her races. The data from each discipline of the Ironman 70.3 Pan Am championships, Panama is in a separate file - `panama_swim`, `panama_bike`, and `panama_run`. Create a similar map to the one you created with my cycling data. You will need to make some small changes: 1. combine the files (HINT: `bind_rows()`, 2. make the leading dot a different color depending on the event (for an extra challenge, make it a different image using `geom_image()!), 3. CHALLENGE (optional): color by speed, which you will need to compute on your own from the data. You can read Heather's race report [here](https://heatherlendway.com/2016/02/10/ironman-70-3-pan-american-championships-panama-race-report/). She is also in the Macalester Athletics [Hall of Fame](https://athletics.macalester.edu/honors/hall-of-fame/heather-lendway/184) and still has records at the pool. 
  

```r
panama_map <- get_stamenmap(
  bbox = c(left = -79.58, bottom = 8.91, right = -79.48, top = 9.0),
  maptype = "terrain",
  zoom = 13)

panama_races <- bind_rows(panama_bike, panama_swim, panama_run)

#plot graph on map 
panama_12 <- ggmap(panama_map) + 
  geom_path(data = panama_races, 
            aes(x = lon, 
                y = lat),
            size = 1) + 
  geom_point(data = panama_races, 
             aes(x = lon, 
                 y = lat,
                 color = event),
             size = 3) +
  labs(x = "",
       y = "",
       color = "Event",
       title = "Heather's Triathalon Race Path in Panama",
       subtitle = "Time: {frame_along}") + 
  theme_map() + 
  theme(legend.background = element_blank(),
      legend.position = "bottom") +
  transition_reveal(time)


animate(panama_12, duration = 20, end_pause = 8)  
```

![](week-5-exercise-TC_files/figure-html/unnamed-chunk-11-1.gif)<!-- -->

```r
anim_save("panama_12.gif") 
```


```r
knitr::include_graphics("panama_12.gif")
```
  
  
  
## COVID-19 data

  6. In this exercise, you are going to replicate many of the features in [this](https://aatishb.com/covidtrends/?region=US) visualization by Aitish Bhatia but include all US states. Requirements:
 * Create a new variable that computes the number of new cases in the past week (HINT: use the `lag()` function you've used in a previous set of exercises). Replace missing values with 0's using `replace_na()`.  
  * Filter the data to omit rows where the cumulative case counts are less than 20.  
  * Create a static plot with cumulative cases on the x-axis and new cases in the past 7 days on the y-axis. Connect the points for each state over time. HINTS: use `geom_path()` and add a `group` aesthetic.  Put the x and y axis on the log scale and make the tick labels look nice - `scales::comma` is one option. This plot will look pretty ugly as is.
  * Animate the plot to reveal the pattern by date. Display the date as the subtitle. Add a leading point to each state's line (`geom_point()`) and add the state name as a label (`geom_text()` - you should look at the `check_overlap` argument).  
  * Use the `animate()` function to have 200 frames in your animation and make it 30 seconds long. 
  * Comment on what you observe.

I observe that california has the highest number of cases in the past 7 days to the total number of cases. I also notice that Texas is up there as well. In general, the cases shoot up in the beginning and then they start to level off and even decrease some. As of now they are pretty stable in one location! 


```r
covid2 <- covid19 %>% 
  group_by(state) %>% 
  mutate(lag_seven = lag(cases, 7, order_by = date, replace_na(0)),
         new_cases = cases - lag_seven) %>% 
  filter(cases >= 20) %>%
  arrange(state) %>% 
  ggplot(mapping = aes(x = log(cases),
                       y = log(new_cases))) +
  geom_path(aes(group = state)) +
  geom_point(aes(color = state, size = 1.5)) +
  geom_text(aes(label = state),
            color = "blue",
            check_overlap = FALSE) + 
  theme(legend.position = "none",
        plot.title.position = "plot",
        plot.caption.position = "plot") +
  labs(x = "",
       y = "",
       title = "Log of New Cases in the Past 7 Days vs Log of Total Cumulative Cases",
       subtitle = "Date:{frame_along}",
       caption = "Plot created by Talia C, data from COVID19 NYT") +
  transition_reveal(date)

animate(covid2, nframes = 200, duration = 30)
```

![](week-5-exercise-TC_files/figure-html/unnamed-chunk-13-1.gif)<!-- -->


```r
anim_save("covid2.gif") 

knitr::include_graphics("covid2.gif")
```
  
  
  7. In this exercise you will animate a map of the US, showing how cumulative COVID-19 cases per 10,000 residents has changed over time. This is similar to exercises 11 & 12 from the previous exercises, with the added animation! So, in the end, you should have something like the static map you made there, but animated over all the days. The code below gives the population estimates for each state and loads the `states_map` data. Here is a list of details you should include in the plot:
  
  * Put date in the subtitle.   
  * Because there are so many dates, you are going to only do the animation for all Fridays. So, use `wday()` to create a day of week variable and filter to all the Fridays.   
  * Use the `animate()` function to make the animation 200 frames instead of the default 100 and to pause for 10 frames on the end frame.   
  * Use `group = date` in `aes()`.   
  * Comment on what you see.  

In this graph I see the change in covid cases over time for each state. It is cool to see the animation and witness the colors of the states getting lighter which indicates more cases per 10,000 people. 


```r
census_pop_est_2018 <- read_csv("https://www.dropbox.com/s/6txwv3b4ng7pepe/us_census_2018_state_pop_est.csv?dl=1") %>% 
  separate(state, into = c("dot","state"), extra = "merge") %>% 
  select(-dot) %>% 
  mutate(state = str_to_lower(state))

#US states map information - coordinates used to draw borders
states_map <- map_data("state")

#data set with most recent cumulative cases of COVID-19
covid19 <- covid19 %>% 
  group_by(state, fips) %>% 
  filter(!(state %in% c("Virgin Islands", "Northern Mariana Islands", "Puerto Rico"))) %>% 
  mutate(state = str_to_lower(state),
         day = wday(date, label = TRUE, abbr = TRUE)) %>% 
  filter(day == "Fri")
  
# left join with covid19 data 
covid19cum_with_2018_pop_est <- covid19 %>% 
  left_join(census_pop_est_2018,
            by = "state") %>% 
  mutate(covid19cases_per_10000 = (cases/est_pop_2018)*10000)

# map that colors state by number of cumulative cases of COVID 19/10000
covid_ <- covid19cum_with_2018_pop_est %>% 
  ggplot() +
  geom_map(map = states_map, 
           aes(map_id = state, 
               fill = covid19cases_per_10000,
               group = date)) + 
  expand_limits(x = states_map$long, y = states_map$lat) +
  theme_map() +
  labs(title = "Covid 19 Cases Per 10,000 People Across States",
       fill = "",
       caption = "Plot Created by Talia C, data from COVID-19 NYT Data",
       subtitle = "Date: {closest_state}") + 
  theme(legend.background = element_blank(),
        plot.title.position = "plot", 
        plot.background = element_rect(fill = "lightgrey")) +
  scale_fill_continuous(labels = scales::comma) + 
  transition_states(date, transition_length = 3) 

animate(covid_, nframes = 200)
```

![](week-5-exercise-TC_files/figure-html/unnamed-chunk-15-1.gif)<!-- -->

```r
anim_save("covid_.gif")
```


```r
knitr::include_graphics("covid_.gif")
```



## Your first `shiny` app (for next week!)

NOT DUE THIS WEEK! If any of you want to work ahead, this will be on next week's exercises.

  8. This app will also use the COVID data. Make sure you load that data and all the libraries you need in the `app.R` file you create. Below, you will post a link to the app that you publish on shinyapps.io. You will create an app to compare states' cumulative number of COVID cases over time. The x-axis will be number of days since 20+ cases and the y-axis will be cumulative cases on the log scale (`scale_y_log10()`). We use number of days since 20+ cases on the x-axis so we can make better comparisons of the curve trajectories. You will have an input box where the user can choose which states to compare (`selectInput()`) and have a submit button to click once the user has chosen all states they're interested in comparing. The graph should display a different line for each state, with labels either on the graph or in a legend. Color can be used if needed. 
  
## GitHub link

  9. Below, provide a link to your GitHub page with this set of Weekly Exercises. Specifically, if the name of the file is 05_exercises.Rmd, provide a link to the 05_exercises.md file, which is the one that will be most readable on GitHub. If that file isn't very readable, then provide a link to your main GitHub page.

[Githib link to exercise 5](https://github.com/tch8/stats112_/tree/main/weekly%20exercise%20%235)
