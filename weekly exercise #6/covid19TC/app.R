
library(shiny)
library(tidyverse)

covid19 <- read_csv("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv")

ui <- fluidPage(
    selectInput(inputId = "state 1", 
                label = "State 1:", 
                choices = covid19,
                selected = "Minnesota"),
    selectInput(inputId = "state 2", 
                label = "State 2:", 
                choices = covid19,
                selected = "Massachusetts"),
    selectInput(inputId = "state 3", 
                label = "State 3:", 
                choices = covid19,
                selected = "California"),
    sliderInput(inputId = "Season", 
                label = "Seasons:",
                min = 2012, 
                max = 2019, 
                value = c(2013,2019),
                sep = ""),
    submitButton(text = "Create plot"),
    plotOutput(outputId = "timeplot")
)

server <- function(input, output) {
   # output$timeplot <- renderPlot({
     #   babynames %>% 
       #     filter(name == input$name, 
      #             sex == input$sex) %>% 
       #     ggplot() +
       #     geom_line(aes(x = year, y = n)) +
        #    scale_x_continuous(limits = input$years) +
         #   theme_minimal()
 #   })
}

shinyApp(ui = ui, server = server)
