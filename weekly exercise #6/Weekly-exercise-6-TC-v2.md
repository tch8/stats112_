---
title: 'Weekly Exercises #6'
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
library(tidyverse)    
library(gardenR)       
library(lubridate)   
library(openintro)     
library(maps)          
library(ggmap)        
library(gplots)      
library(RColorBrewer)  
library(sf)           
library(ggthemes)     
library(plotly)        
library(gganimate)     
library(gifski)        
library(transformr)   
library(shiny)         
library(patchwork)     
library(gt)            
library(rvest)         
library(robotstxt)
library(paletteer)
theme_set(theme_minimal())
```


```r
# Lisa's garden data
data("garden_harvest")

#COVID-19 data from the New York Times
covid19 <- read_csv("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv")
```

## Put your homework on GitHub!

Go [here](https://github.com/llendway/github_for_collaboration/blob/master/github_for_collaboration.md) or to previous homework to remind yourself how to get set up. 

Once your repository is created, you should always open your **project** rather than just opening an .Rmd file. You can do that by either clicking on the .Rproj file in your repository folder on your computer. Or, by going to the upper right hand corner in R Studio and clicking the arrow next to where it says Project: (None). You should see your project come up in that list if you've used it recently. You could also go to File --> Open Project and navigate to your .Rproj file. 

[github folder link](https://github.com/tch8/stats112_/tree/main/weekly%20exercise%20%236)

[md file link](https://github.com/tch8/stats112_/blob/main/weekly%20exercise%20%236/Weekly-exercise-6-TC-v2.md)

[shiny app folder on github](https://github.com/tch8/stats112_/tree/main/weekly%20exercise%20%236/covid19TC)

## Instructions

* Put your name at the top of the document. 

* **For ALL graphs, you should include appropriate labels.** 

* Feel free to change the default theme, which I currently have set to `theme_minimal()`. 

* Use good coding practice. Read the short sections on good code with [pipes](https://style.tidyverse.org/pipes.html) and [ggplot2](https://style.tidyverse.org/ggplot2.html). **This is part of your grade!**

* **NEW!!** With animated graphs, add `eval=FALSE` to the code chunk that creates the animation and saves it using `anim_save()`. Add another code chunk to reread the gif back into the file. See the [tutorial](https://animation-and-interactivity-in-r.netlify.app/) for help. 

* When you are finished with ALL the exercises, uncomment the options at the top so your document looks nicer. Don't do it before then, or else you might miss some important warnings and messages.

## Your first `shiny` app 

  1. This app will also use the COVID data. Make sure you load that data and all the libraries you need in the `app.R` file you create. Below, you will post a link to the app that you publish on shinyapps.io. You will create an app to compare states' cumulative number of COVID cases over time. The x-axis will be number of days since 20+ cases and the y-axis will be cumulative cases on the log scale (`scale_y_log10()`). We use number of days since 20+ cases on the x-axis so we can make better comparisons of the curve trajectories. You will have an input box where the user can choose which states to compare (`selectInput()`) and have a submit button to click once the user has chosen all states they're interested in comparing. The graph should display a different line for each state, with labels either on the graph or in a legend. Color can be used if needed. 
  
[Shiny App](https://tch8.shinyapps.io/Covid19AppTC/?_ga=2.86719581.411906802.1625020589-1339200620.1624630560)
  
  
## Warm-up exercises from tutorial

  2. Read in the fake garden harvest data. Find the data [here](https://github.com/llendway/scraping_etc/blob/main/2020_harvest.csv) and click on the `Raw` button to get a direct link to the data. 
  

```r
fakegarden_harvest <- read_csv("https://raw.githubusercontent.com/llendway/scraping_etc/main/2020_harvest.csv")
```
  
  3. Read in this [data](https://www.kaggle.com/heeraldedhia/groceries-dataset) from the kaggle website. You will need to download the data first. Save it to your project/repo folder. Do some quick checks of the data to assure it has been read in appropriately.


```r
grocery_data <- read_csv("Groceries_dataset.csv")
```

  4. CHALLENGE(not graded): Write code to replicate the table shown below (open the .html file to see it) created from the `garden_harvest` data as best as you can. When you get to coloring the cells, I used the following line of code for the `colors` argument:
  

```r
garden_harvest %>% 
  filter (vegetable %in% c("beans", "carrots", "tomatoes")) %>% 
  mutate(month = month(date, label = TRUE, abbr = TRUE)) %>% 
  group_by(variety) %>% 
  mutate(weight_lbs = weight * 0.00220462, 
         totweight = sum(weight_lbs),
         variety = str_to_title(variety),
         vegetable = str_to_title(vegetable)) %>%
  group_by(variety, month) %>% 
  select(vegetable, variety, month, totweight) %>% 
  distinct() %>% 
  tibble(Variety = variety,
         Vegetable = vegetable,
         "Total Weight" = totweight, 
         Month = month) %>% 
  gt(rowname_col = "Variety",
     groupname_col = "Vegetable") %>%
  row_group_order(groups = c("Beans", "Carrots", "Tomatoes")) %>%
  cols_hide(c("vegetable", "variety", "month", "totweight")) %>% 
  fmt_number(columns = vars(c("Total Weight")), decimals = 2) %>% 
  tab_header(title = "Total Weight (in Lbs) of Vegetable Varieties") %>% 
  tab_options(row_group.font.weight = "bold") %>% 
  summary_rows(groups = TRUE, 
              columns = vars(c("Total Weight")),
               fns = list(Sum = "sum"),
               formatter = fmt_number) %>% 
  cols_align(align = "right", columns = TRUE) %>%
  data_color(columns = vars(c("Total Weight")),
             colors = scales::col_numeric(
               palette = paletteer::paletteer_d(
                 palette = "RColorBrewer::YlGn") %>% 
                 as.character(),
               domain = NULL))
```

<!--html_preserve--><div id="opqfnredhq" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#opqfnredhq .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#opqfnredhq .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#opqfnredhq .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#opqfnredhq .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#opqfnredhq .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#opqfnredhq .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#opqfnredhq .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#opqfnredhq .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#opqfnredhq .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#opqfnredhq .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#opqfnredhq .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#opqfnredhq .gt_group_heading {
  padding: 8px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: bold;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
}

#opqfnredhq .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: bold;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#opqfnredhq .gt_from_md > :first-child {
  margin-top: 0;
}

#opqfnredhq .gt_from_md > :last-child {
  margin-bottom: 0;
}

#opqfnredhq .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#opqfnredhq .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 12px;
}

#opqfnredhq .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#opqfnredhq .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#opqfnredhq .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#opqfnredhq .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#opqfnredhq .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#opqfnredhq .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#opqfnredhq .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#opqfnredhq .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#opqfnredhq .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#opqfnredhq .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#opqfnredhq .gt_left {
  text-align: left;
}

#opqfnredhq .gt_center {
  text-align: center;
}

#opqfnredhq .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#opqfnredhq .gt_font_normal {
  font-weight: normal;
}

#opqfnredhq .gt_font_bold {
  font-weight: bold;
}

#opqfnredhq .gt_font_italic {
  font-style: italic;
}

#opqfnredhq .gt_super {
  font-size: 65%;
}

#opqfnredhq .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 65%;
}
</style>
<table class="gt_table">
  <thead class="gt_header">
    <tr>
      <th colspan="3" class="gt_heading gt_title gt_font_normal gt_bottom_border" style>Total Weight (in Lbs) of Vegetable Varieties</th>
    </tr>
    
  </thead>
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1"></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">Total Weight</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">Month</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr class="gt_group_heading_row">
      <td colspan="3" class="gt_group_heading">Beans</td>
    </tr>
    <tr><td class="gt_row gt_left gt_stub">Bush Bush Slender</td>
<td class="gt_row gt_right" style="background-color: #BCE395; color: #000000;">22.13</td>
<td class="gt_row gt_right">Jul</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Bush Bush Slender</td>
<td class="gt_row gt_right" style="background-color: #BCE395; color: #000000;">22.13</td>
<td class="gt_row gt_right">Aug</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Classic Slenderette</td>
<td class="gt_row gt_right" style="background-color: #FCFED4; color: #000000;">3.60</td>
<td class="gt_row gt_right">Aug</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Chinese Red Noodle</td>
<td class="gt_row gt_right" style="background-color: #FFFFE3; color: #000000;">0.78</td>
<td class="gt_row gt_right">Aug</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Classic Slenderette</td>
<td class="gt_row gt_right" style="background-color: #FCFED4; color: #000000;">3.60</td>
<td class="gt_row gt_right">Sep</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Bush Bush Slender</td>
<td class="gt_row gt_right" style="background-color: #BCE395; color: #000000;">22.13</td>
<td class="gt_row gt_right">Sep</td></tr>
    <tr>
      <td class="gt_row gt_stub gt_right gt_summary_row gt_first_summary_row">Sum</td>
      <td class="gt_row gt_right gt_summary_row gt_first_summary_row">74.38</td>
      <td class="gt_row gt_right gt_summary_row gt_first_summary_row">&mdash;</td>
    </tr>
    <tr class="gt_group_heading_row">
      <td colspan="3" class="gt_group_heading">Carrots</td>
    </tr>
    <tr><td class="gt_row gt_left gt_stub">King Midas</td>
<td class="gt_row gt_right" style="background-color: #FCFED1; color: #000000;">4.10</td>
<td class="gt_row gt_right">Jul</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Dragon</td>
<td class="gt_row gt_right" style="background-color: #FCFED1; color: #000000;">4.11</td>
<td class="gt_row gt_right">Jul</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Bolero</td>
<td class="gt_row gt_right" style="background-color: #F7FCBA; color: #000000;">8.29</td>
<td class="gt_row gt_right">Jul</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Bolero</td>
<td class="gt_row gt_right" style="background-color: #F7FCBA; color: #000000;">8.29</td>
<td class="gt_row gt_right">Aug</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Dragon</td>
<td class="gt_row gt_right" style="background-color: #FCFED1; color: #000000;">4.11</td>
<td class="gt_row gt_right">Aug</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Greens</td>
<td class="gt_row gt_right" style="background-color: #FFFFE5; color: #000000;">0.37</td>
<td class="gt_row gt_right">Aug</td></tr>
    <tr><td class="gt_row gt_left gt_stub">King Midas</td>
<td class="gt_row gt_right" style="background-color: #FCFED1; color: #000000;">4.10</td>
<td class="gt_row gt_right">Sep</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Bolero</td>
<td class="gt_row gt_right" style="background-color: #F7FCBA; color: #000000;">8.29</td>
<td class="gt_row gt_right">Sep</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Dragon</td>
<td class="gt_row gt_right" style="background-color: #FCFED1; color: #000000;">4.11</td>
<td class="gt_row gt_right">Sep</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Bolero</td>
<td class="gt_row gt_right" style="background-color: #F7FCBA; color: #000000;">8.29</td>
<td class="gt_row gt_right">Oct</td></tr>
    <tr><td class="gt_row gt_left gt_stub">King Midas</td>
<td class="gt_row gt_right" style="background-color: #FCFED1; color: #000000;">4.10</td>
<td class="gt_row gt_right">Oct</td></tr>
    <tr>
      <td class="gt_row gt_stub gt_right gt_summary_row gt_first_summary_row">Sum</td>
      <td class="gt_row gt_right gt_summary_row gt_first_summary_row">58.14</td>
      <td class="gt_row gt_right gt_summary_row gt_first_summary_row">&mdash;</td>
    </tr>
    <tr class="gt_group_heading_row">
      <td colspan="3" class="gt_group_heading">Tomatoes</td>
    </tr>
    <tr><td class="gt_row gt_left gt_stub">Grape</td>
<td class="gt_row gt_right" style="background-color: #7CC87B; color: #000000;">32.39</td>
<td class="gt_row gt_right">Jul</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Big Beef</td>
<td class="gt_row gt_right" style="background-color: #ACDD8E; color: #000000;">24.99</td>
<td class="gt_row gt_right">Jul</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Bonny Best</td>
<td class="gt_row gt_right" style="background-color: #ADDD8E; color: #000000;">24.92</td>
<td class="gt_row gt_right">Jul</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Cherokee Purple</td>
<td class="gt_row gt_right" style="background-color: #DDF1A6; color: #000000;">15.71</td>
<td class="gt_row gt_right">Jul</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Better Boy</td>
<td class="gt_row gt_right" style="background-color: #72C376; color: #000000;">34.01</td>
<td class="gt_row gt_right">Jul</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Amish Paste</td>
<td class="gt_row gt_right" style="background-color: #004529; color: #FFFFFF;">65.67</td>
<td class="gt_row gt_right">Jul</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Mortgage Lifter</td>
<td class="gt_row gt_right" style="background-color: #A4D98A; color: #000000;">26.33</td>
<td class="gt_row gt_right">Jul</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Old German</td>
<td class="gt_row gt_right" style="background-color: #A1D889; color: #000000;">26.72</td>
<td class="gt_row gt_right">Jul</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Jet Star</td>
<td class="gt_row gt_right" style="background-color: #DFF2A7; color: #000000;">15.02</td>
<td class="gt_row gt_right">Jul</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Bonny Best</td>
<td class="gt_row gt_right" style="background-color: #ADDD8E; color: #000000;">24.92</td>
<td class="gt_row gt_right">Aug</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Brandywine</td>
<td class="gt_row gt_right" style="background-color: #DDF2A6; color: #000000;">15.65</td>
<td class="gt_row gt_right">Aug</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Cherokee Purple</td>
<td class="gt_row gt_right" style="background-color: #DDF1A6; color: #000000;">15.71</td>
<td class="gt_row gt_right">Aug</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Amish Paste</td>
<td class="gt_row gt_right" style="background-color: #004529; color: #FFFFFF;">65.67</td>
<td class="gt_row gt_right">Aug</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Black Krim</td>
<td class="gt_row gt_right" style="background-color: #DCF1A5; color: #000000;">15.81</td>
<td class="gt_row gt_right">Aug</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Grape</td>
<td class="gt_row gt_right" style="background-color: #7CC87B; color: #000000;">32.39</td>
<td class="gt_row gt_right">Aug</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Old German</td>
<td class="gt_row gt_right" style="background-color: #A1D889; color: #000000;">26.72</td>
<td class="gt_row gt_right">Aug</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Better Boy</td>
<td class="gt_row gt_right" style="background-color: #72C376; color: #000000;">34.01</td>
<td class="gt_row gt_right">Aug</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Volunteers</td>
<td class="gt_row gt_right" style="background-color: #1B7C40; color: #FFFFFF;">51.61</td>
<td class="gt_row gt_right">Aug</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Mortgage Lifter</td>
<td class="gt_row gt_right" style="background-color: #A4D98A; color: #000000;">26.33</td>
<td class="gt_row gt_right">Aug</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Big Beef</td>
<td class="gt_row gt_right" style="background-color: #ACDD8E; color: #000000;">24.99</td>
<td class="gt_row gt_right">Aug</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Jet Star</td>
<td class="gt_row gt_right" style="background-color: #DFF2A7; color: #000000;">15.02</td>
<td class="gt_row gt_right">Aug</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Volunteers</td>
<td class="gt_row gt_right" style="background-color: #1B7C40; color: #FFFFFF;">51.61</td>
<td class="gt_row gt_right">Sep</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Old German</td>
<td class="gt_row gt_right" style="background-color: #A1D889; color: #000000;">26.72</td>
<td class="gt_row gt_right">Sep</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Brandywine</td>
<td class="gt_row gt_right" style="background-color: #DDF2A6; color: #000000;">15.65</td>
<td class="gt_row gt_right">Sep</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Cherokee Purple</td>
<td class="gt_row gt_right" style="background-color: #DDF1A6; color: #000000;">15.71</td>
<td class="gt_row gt_right">Sep</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Amish Paste</td>
<td class="gt_row gt_right" style="background-color: #004529; color: #FFFFFF;">65.67</td>
<td class="gt_row gt_right">Sep</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Jet Star</td>
<td class="gt_row gt_right" style="background-color: #DFF2A7; color: #000000;">15.02</td>
<td class="gt_row gt_right">Sep</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Mortgage Lifter</td>
<td class="gt_row gt_right" style="background-color: #A4D98A; color: #000000;">26.33</td>
<td class="gt_row gt_right">Sep</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Grape</td>
<td class="gt_row gt_right" style="background-color: #7CC87B; color: #000000;">32.39</td>
<td class="gt_row gt_right">Sep</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Big Beef</td>
<td class="gt_row gt_right" style="background-color: #ACDD8E; color: #000000;">24.99</td>
<td class="gt_row gt_right">Sep</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Better Boy</td>
<td class="gt_row gt_right" style="background-color: #72C376; color: #000000;">34.01</td>
<td class="gt_row gt_right">Sep</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Bonny Best</td>
<td class="gt_row gt_right" style="background-color: #ADDD8E; color: #000000;">24.92</td>
<td class="gt_row gt_right">Sep</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Black Krim</td>
<td class="gt_row gt_right" style="background-color: #DCF1A5; color: #000000;">15.81</td>
<td class="gt_row gt_right">Sep</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Amish Paste</td>
<td class="gt_row gt_right" style="background-color: #004529; color: #FFFFFF;">65.67</td>
<td class="gt_row gt_right">Oct</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Mortgage Lifter</td>
<td class="gt_row gt_right" style="background-color: #A4D98A; color: #000000;">26.33</td>
<td class="gt_row gt_right">Oct</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Jet Star</td>
<td class="gt_row gt_right" style="background-color: #DFF2A7; color: #000000;">15.02</td>
<td class="gt_row gt_right">Oct</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Old German</td>
<td class="gt_row gt_right" style="background-color: #A1D889; color: #000000;">26.72</td>
<td class="gt_row gt_right">Oct</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Big Beef</td>
<td class="gt_row gt_right" style="background-color: #ACDD8E; color: #000000;">24.99</td>
<td class="gt_row gt_right">Oct</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Volunteers</td>
<td class="gt_row gt_right" style="background-color: #1B7C40; color: #FFFFFF;">51.61</td>
<td class="gt_row gt_right">Oct</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Grape</td>
<td class="gt_row gt_right" style="background-color: #7CC87B; color: #000000;">32.39</td>
<td class="gt_row gt_right">Oct</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Black Krim</td>
<td class="gt_row gt_right" style="background-color: #DCF1A5; color: #000000;">15.81</td>
<td class="gt_row gt_right">Oct</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Better Boy</td>
<td class="gt_row gt_right" style="background-color: #72C376; color: #000000;">34.01</td>
<td class="gt_row gt_right">Oct</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Bonny Best</td>
<td class="gt_row gt_right" style="background-color: #ADDD8E; color: #000000;">24.92</td>
<td class="gt_row gt_right">Oct</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Brandywine</td>
<td class="gt_row gt_right" style="background-color: #DDF2A6; color: #000000;">15.65</td>
<td class="gt_row gt_right">Oct</td></tr>
    <tr><td class="gt_row gt_left gt_stub">Cherokee Purple</td>
<td class="gt_row gt_right" style="background-color: #DDF1A6; color: #000000;">15.71</td>
<td class="gt_row gt_right">Oct</td></tr>
    <tr>
      <td class="gt_row gt_stub gt_right gt_summary_row gt_first_summary_row">Sum</td>
      <td class="gt_row gt_right gt_summary_row gt_first_summary_row">1,312.29</td>
      <td class="gt_row gt_right gt_summary_row gt_first_summary_row">&mdash;</td>
    </tr>
  </tbody>
  
  
</table>
</div><!--/html_preserve-->

  5. Create a table using `gt` with data from your project or from the `garden_harvest` data if your project data aren't ready.
  

```r
tab1 <- garden_harvest %>% 
  filter (vegetable %in% c("lettuce", "kale", "spinach", "swiss chard")) %>% 
  group_by(variety) %>% 
  mutate(weight_lbs = weight * 0.00220462, 
         totweight = sum(weight_lbs),
         variety = str_to_title(variety),
         vegetable = str_to_title(vegetable)) %>%
  tibble(Variety = variety,
         Vegetable = vegetable,
         "Total Weight" = totweight) %>% 
  select(Variety, Vegetable, "Total Weight") %>% 
  distinct() %>% 
  gt(rowname_col = "Variety",
     groupname_col = "Vegetable") %>% 
  tab_header(title = "Total Weight (in Lbs) of Vegetable Varieties",
             subtitle = md("For Lettuce, Kale, Spinach, and Swiss Chard")) %>% 
  tab_footnote(
    footnote = "Weight is in Pounds.",
    locations = cells_column_labels(
      columns = vars("Total Weight"))) %>% 
  tab_options(row_group.background.color = "#BEDAE0",
              row_group.font.weight = "bold") %>% 
  as_raw_html()

tab1
```

<!--html_preserve--><table style="font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif; display: table; border-collapse: collapse; margin-left: auto; margin-right: auto; color: #333333; font-size: 16px; font-weight: normal; font-style: normal; background-color: #FFFFFF; width: auto; border-top-style: solid; border-top-width: 2px; border-top-color: #A8A8A8; border-right-style: none; border-right-width: 2px; border-right-color: #D3D3D3; border-bottom-style: solid; border-bottom-width: 2px; border-bottom-color: #A8A8A8; border-left-style: none; border-left-width: 2px; border-left-color: #D3D3D3;">
  <thead style="">
    <tr>
      <th colspan="2" style="background-color: #FFFFFF; text-align: center; border-bottom-color: #FFFFFF; border-left-style: none; border-left-width: 1px; border-left-color: #D3D3D3; border-right-style: none; border-right-width: 1px; border-right-color: #D3D3D3; color: #333333; font-size: 125%; font-weight: initial; padding-top: 4px; padding-bottom: 4px; border-bottom-width: 0; font-weight: normal;" style>Total Weight (in Lbs) of Vegetable Varieties</th>
    </tr>
    <tr>
      <th colspan="2" style="background-color: #FFFFFF; text-align: center; border-bottom-color: #FFFFFF; border-left-style: none; border-left-width: 1px; border-left-color: #D3D3D3; border-right-style: none; border-right-width: 1px; border-right-color: #D3D3D3; color: #333333; font-size: 85%; font-weight: initial; padding-top: 0; padding-bottom: 4px; border-top-color: #FFFFFF; border-top-width: 0; border-bottom-style: solid; border-bottom-width: 2px; border-bottom-color: #D3D3D3; font-weight: normal;" style>For Lettuce, Kale, Spinach, and Swiss Chard</th>
    </tr>
  </thead>
  <thead style="border-top-style: solid; border-top-width: 2px; border-top-color: #D3D3D3; border-bottom-style: solid; border-bottom-width: 2px; border-bottom-color: #D3D3D3; border-left-style: none; border-left-width: 1px; border-left-color: #D3D3D3; border-right-style: none; border-right-width: 1px; border-right-color: #D3D3D3;">
    <tr>
      <th style="color: #333333; background-color: #FFFFFF; font-size: 100%; font-weight: normal; text-transform: inherit; border-left-style: none; border-left-width: 1px; border-left-color: #D3D3D3; border-right-style: none; border-right-width: 1px; border-right-color: #D3D3D3; vertical-align: bottom; padding-top: 5px; padding-bottom: 6px; padding-left: 5px; padding-right: 5px; overflow-x: hidden; text-align: left;" rowspan="1" colspan="1"></th>
      <th style="color: #333333; background-color: #FFFFFF; font-size: 100%; font-weight: normal; text-transform: inherit; border-left-style: none; border-left-width: 1px; border-left-color: #D3D3D3; border-right-style: none; border-right-width: 1px; border-right-color: #D3D3D3; vertical-align: bottom; padding-top: 5px; padding-bottom: 6px; padding-left: 5px; padding-right: 5px; overflow-x: hidden; text-align: right; font-variant-numeric: tabular-nums;" rowspan="1" colspan="1">Total Weight<sup style="font-style: italic; font-weight: normal; font-size: 65%;">1</sup></th>
    </tr>
  </thead>
  <tbody style="border-top-style: solid; border-top-width: 2px; border-top-color: #D3D3D3; border-bottom-style: solid; border-bottom-width: 2px; border-bottom-color: #D3D3D3;">
    <tr style="">
      <td colspan="2" style="padding: 8px; color: #333333; background-color: #BEDAE0; font-size: 100%; font-weight: bold; text-transform: inherit; border-top-style: solid; border-top-width: 2px; border-top-color: #D3D3D3; border-bottom-style: solid; border-bottom-width: 2px; border-bottom-color: #D3D3D3; border-left-style: none; border-left-width: 1px; border-left-color: #D3D3D3; border-right-style: none; border-right-width: 1px; border-right-color: #D3D3D3; vertical-align: middle;">Lettuce</td>
    </tr>
    <tr><td style="padding-top: 8px; padding-bottom: 8px; padding-left: 5px; padding-right: 5px; margin: 10px; border-top-style: solid; border-top-width: 1px; border-top-color: #D3D3D3; border-left-style: none; border-left-width: 1px; border-left-color: #D3D3D3; border-right-style: none; border-right-width: 1px; border-right-color: #D3D3D3; vertical-align: middle; overflow-x: hidden; color: #333333; background-color: #FFFFFF; font-size: 100%; font-weight: initial; text-transform: inherit; border-right-style: solid; border-right-width: 2px; padding-left: 12px; text-align: left;">Reseed</td>
<td style="padding-top: 8px; padding-bottom: 8px; padding-left: 5px; padding-right: 5px; margin: 10px; border-top-style: solid; border-top-width: 1px; border-top-color: #D3D3D3; border-left-style: none; border-left-width: 1px; border-left-color: #D3D3D3; border-right-style: none; border-right-width: 1px; border-right-color: #D3D3D3; vertical-align: middle; overflow-x: hidden; text-align: right; font-variant-numeric: tabular-nums;">0.09920790</td></tr>
    <tr><td style="padding-top: 8px; padding-bottom: 8px; padding-left: 5px; padding-right: 5px; margin: 10px; border-top-style: solid; border-top-width: 1px; border-top-color: #D3D3D3; border-left-style: none; border-left-width: 1px; border-left-color: #D3D3D3; border-right-style: none; border-right-width: 1px; border-right-color: #D3D3D3; vertical-align: middle; overflow-x: hidden; color: #333333; background-color: #FFFFFF; font-size: 100%; font-weight: initial; text-transform: inherit; border-right-style: solid; border-right-width: 2px; padding-left: 12px; text-align: left;">Farmer's Market Blend</td>
<td style="padding-top: 8px; padding-bottom: 8px; padding-left: 5px; padding-right: 5px; margin: 10px; border-top-style: solid; border-top-width: 1px; border-top-color: #D3D3D3; border-left-style: none; border-left-width: 1px; border-left-color: #D3D3D3; border-right-style: none; border-right-width: 1px; border-right-color: #D3D3D3; vertical-align: middle; overflow-x: hidden; text-align: right; font-variant-numeric: tabular-nums;">3.80296950</td></tr>
    <tr><td style="padding-top: 8px; padding-bottom: 8px; padding-left: 5px; padding-right: 5px; margin: 10px; border-top-style: solid; border-top-width: 1px; border-top-color: #D3D3D3; border-left-style: none; border-left-width: 1px; border-left-color: #D3D3D3; border-right-style: none; border-right-width: 1px; border-right-color: #D3D3D3; vertical-align: middle; overflow-x: hidden; color: #333333; background-color: #FFFFFF; font-size: 100%; font-weight: initial; text-transform: inherit; border-right-style: solid; border-right-width: 2px; padding-left: 12px; text-align: left;">Tatsoi</td>
<td style="padding-top: 8px; padding-bottom: 8px; padding-left: 5px; padding-right: 5px; margin: 10px; border-top-style: solid; border-top-width: 1px; border-top-color: #D3D3D3; border-left-style: none; border-left-width: 1px; border-left-color: #D3D3D3; border-right-style: none; border-right-width: 1px; border-right-color: #D3D3D3; vertical-align: middle; overflow-x: hidden; text-align: right; font-variant-numeric: tabular-nums;">2.89466606</td></tr>
    <tr><td style="padding-top: 8px; padding-bottom: 8px; padding-left: 5px; padding-right: 5px; margin: 10px; border-top-style: solid; border-top-width: 1px; border-top-color: #D3D3D3; border-left-style: none; border-left-width: 1px; border-left-color: #D3D3D3; border-right-style: none; border-right-width: 1px; border-right-color: #D3D3D3; vertical-align: middle; overflow-x: hidden; color: #333333; background-color: #FFFFFF; font-size: 100%; font-weight: initial; text-transform: inherit; border-right-style: solid; border-right-width: 2px; padding-left: 12px; text-align: left;">Mustard Greens</td>
<td style="padding-top: 8px; padding-bottom: 8px; padding-left: 5px; padding-right: 5px; margin: 10px; border-top-style: solid; border-top-width: 1px; border-top-color: #D3D3D3; border-left-style: none; border-left-width: 1px; border-left-color: #D3D3D3; border-right-style: none; border-right-width: 1px; border-right-color: #D3D3D3; vertical-align: middle; overflow-x: hidden; text-align: right; font-variant-numeric: tabular-nums;">0.05070626</td></tr>
    <tr><td style="padding-top: 8px; padding-bottom: 8px; padding-left: 5px; padding-right: 5px; margin: 10px; border-top-style: solid; border-top-width: 1px; border-top-color: #D3D3D3; border-left-style: none; border-left-width: 1px; border-left-color: #D3D3D3; border-right-style: none; border-right-width: 1px; border-right-color: #D3D3D3; vertical-align: middle; overflow-x: hidden; color: #333333; background-color: #FFFFFF; font-size: 100%; font-weight: initial; text-transform: inherit; border-right-style: solid; border-right-width: 2px; padding-left: 12px; text-align: left;">Lettuce Mixture</td>
<td style="padding-top: 8px; padding-bottom: 8px; padding-left: 5px; padding-right: 5px; margin: 10px; border-top-style: solid; border-top-width: 1px; border-top-color: #D3D3D3; border-left-style: none; border-left-width: 1px; border-left-color: #D3D3D3; border-right-style: none; border-right-width: 1px; border-right-color: #D3D3D3; vertical-align: middle; overflow-x: hidden; text-align: right; font-variant-numeric: tabular-nums;">4.74875148</td></tr>
    <tr style="">
      <td colspan="2" style="padding: 8px; color: #333333; background-color: #BEDAE0; font-size: 100%; font-weight: bold; text-transform: inherit; border-top-style: solid; border-top-width: 2px; border-top-color: #D3D3D3; border-bottom-style: solid; border-bottom-width: 2px; border-bottom-color: #D3D3D3; border-left-style: none; border-left-width: 1px; border-left-color: #D3D3D3; border-right-style: none; border-right-width: 1px; border-right-color: #D3D3D3; vertical-align: middle;">Spinach</td>
    </tr>
    <tr><td style="padding-top: 8px; padding-bottom: 8px; padding-left: 5px; padding-right: 5px; margin: 10px; border-top-style: solid; border-top-width: 1px; border-top-color: #D3D3D3; border-left-style: none; border-left-width: 1px; border-left-color: #D3D3D3; border-right-style: none; border-right-width: 1px; border-right-color: #D3D3D3; vertical-align: middle; overflow-x: hidden; color: #333333; background-color: #FFFFFF; font-size: 100%; font-weight: initial; text-transform: inherit; border-right-style: solid; border-right-width: 2px; padding-left: 12px; text-align: left;">Catalina</td>
<td style="padding-top: 8px; padding-bottom: 8px; padding-left: 5px; padding-right: 5px; margin: 10px; border-top-style: solid; border-top-width: 1px; border-top-color: #D3D3D3; border-left-style: none; border-left-width: 1px; border-left-color: #D3D3D3; border-right-style: none; border-right-width: 1px; border-right-color: #D3D3D3; vertical-align: middle; overflow-x: hidden; text-align: right; font-variant-numeric: tabular-nums;">2.03486426</td></tr>
    <tr style="">
      <td colspan="2" style="padding: 8px; color: #333333; background-color: #BEDAE0; font-size: 100%; font-weight: bold; text-transform: inherit; border-top-style: solid; border-top-width: 2px; border-top-color: #D3D3D3; border-bottom-style: solid; border-bottom-width: 2px; border-bottom-color: #D3D3D3; border-left-style: none; border-left-width: 1px; border-left-color: #D3D3D3; border-right-style: none; border-right-width: 1px; border-right-color: #D3D3D3; vertical-align: middle;">Kale</td>
    </tr>
    <tr><td style="padding-top: 8px; padding-bottom: 8px; padding-left: 5px; padding-right: 5px; margin: 10px; border-top-style: solid; border-top-width: 1px; border-top-color: #D3D3D3; border-left-style: none; border-left-width: 1px; border-left-color: #D3D3D3; border-right-style: none; border-right-width: 1px; border-right-color: #D3D3D3; vertical-align: middle; overflow-x: hidden; color: #333333; background-color: #FFFFFF; font-size: 100%; font-weight: initial; text-transform: inherit; border-right-style: solid; border-right-width: 2px; padding-left: 12px; text-align: left;">Heirloom Lacinto</td>
<td style="padding-top: 8px; padding-bottom: 8px; padding-left: 5px; padding-right: 5px; margin: 10px; border-top-style: solid; border-top-width: 1px; border-top-color: #D3D3D3; border-left-style: none; border-left-width: 1px; border-left-color: #D3D3D3; border-right-style: none; border-right-width: 1px; border-right-color: #D3D3D3; vertical-align: middle; overflow-x: hidden; text-align: right; font-variant-numeric: tabular-nums;">5.94586014</td></tr>
  </tbody>
  
  <tfoot>
    <tr style="color: #333333; background-color: #FFFFFF; border-bottom-style: none; border-bottom-width: 2px; border-bottom-color: #D3D3D3; border-left-style: none; border-left-width: 2px; border-left-color: #D3D3D3; border-right-style: none; border-right-width: 2px; border-right-color: #D3D3D3;">
      <td colspan="2">
        <p style="margin: 0px; font-size: 90%; padding: 4px;">
          <sup style="font-style: italic; font-weight: normal; font-size: 65%;">
            <em>1</em>
          </sup>
           
          Weight is in Pounds.
          <br />
        </p>
      </td>
    </tr>
  </tfoot>
</table><!--/html_preserve-->
  
  6. Use `patchwork` operators and functions to combine at least two graphs using your project data or `garden_harvest` data if your project data aren't read.
  

```r
#new dataset with most recent date for each Variety 
garden_mostrecent_cumsum <- garden_harvest %>%
  filter (vegetable %in% c("lettuce", "kale", "spinach", "swiss chard")) %>% 
  mutate (weight_lb = weight * 0.00220462) %>% 
  group_by (variety, date) %>% 
  summarize (total_weight = sum(weight_lb)) %>%
  mutate (cum_sum_weight = cumsum(total_weight),
          variety = str_to_title(variety),
          date_mr = max(date)) %>% 
  filter(date == date_mr)

#first graph of data 
graph1 <- garden_harvest %>%
  filter (vegetable %in% c("lettuce", "kale", "spinach", "swiss chard")) %>% 
  mutate (weight_lb = weight * 0.00220462) %>% 
  group_by (variety, date) %>% 
  summarize (total_weight = sum(weight_lb)) %>%
  mutate (cum_sum_weight = cumsum(total_weight),
          variety = str_to_title(variety)) %>%
  ggplot (mapping = aes(x = date, 
                        y = cum_sum_weight, 
                        color = variety)) +
  geom_line() + 
  geom_text(data = garden_mostrecent_cumsum,
            aes(label = variety),
            hjust = "inward",
            angle = -2) +
  labs(x = "", 
       y = "", 
       title = "Cumulative Weight Harvested by Variety Over Time") +
  theme_minimal() + 
  theme(panel.grid.major.x = element_blank(),
        panel.grid.minor.x  = element_blank(),
        plot.title.position = "plot",
        plot.caption.position = "plot",
        legend.position = "none")


# second graph 
graph2 <- garden_harvest %>% 
  filter (vegetable %in% c("lettuce", "kale", "spinach", "swiss chard")) %>% 
  mutate (weight_lb = weight * 0.00220462,
          variety = str_to_title(variety))%>% 
  group_by(variety) %>%
  summarize(first_harvest = min(date),
            total_harvest = sum(weight_lb)) %>%
  arrange(first_harvest) %>% 
  ggplot(mapping = aes(x = first_harvest,
                       y = total_harvest,
                       color = variety)) +
  geom_point() +
  geom_text(aes(label = variety),
            hjust = "inward",
            angle = -2) +
  labs(x = "", 
       y = "", 
       title = "First Date Harvested vs, Total Amount Harvested in Pounds") +
  theme_minimal() + 
  theme(panel.grid.major.x = element_blank(),
        panel.grid.minor.x  = element_blank(),
        plot.title.position = "plot",
        plot.caption.position = "plot",
        legend.position = "none")


graph1 + plot_spacer() + graph2 +
  plot_layout(widths = 7,
              heights = 3) + 
  plot_annotation(title = "The Jungle Garden",
                  subtitle = "A look into the differences between the Varieties of Lettuce, Kale, Spinach, and Swiss Chard",
                  caption = "Plots created by Talia C, data from gardenR package")
```

![](Weekly-exercise-6-TC-v2_files/figure-html/unnamed-chunk-5-1.png)<!-- -->
