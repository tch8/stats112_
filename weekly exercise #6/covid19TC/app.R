
library(shiny)
library(tidyverse)

covid19 <- read_csv("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv")

state_options <- covid19 %>% 
  distinct(state) %>% 
  pull(state)

ui <- fluidPage( "COVID19 Cases App",
    selectInput(inputId = "state1", 
                label = "State 1:", 
                choices = state_options,
                selected = "Minnesota"),
    selectInput(inputId = "state2", 
                label = "State 2:", 
                choices = state_options,
                selected = "Massachusetts"),
    selectInput(inputId = "state3", 
                label = "State 3:", 
                choices = state_options,
                selected = "California"),
    submitButton(text = "Create plot"),
    plotOutput(outputId = "timeplot")
)

server <- function(input, output) {
    output$timeplot <- renderPlot({
      covid19 %>% 
        filter(cases >= 20,
               state == c(input$state1, 
                         input$state2, 
                         input$state3)) %>%
        ggplot(aes(x = date,
                   y = cases,
                   color = state)) +
        geom_line() +
        scale_y_log10() +
        labs(x = "",
             y = "",
             title = "Log of Cumulative Cases Per State over Time",
             caption = "Data from COVID 19 NY Times") +
        theme(legend.position = "none",
              plot.title.position = "plot",
              plot.caption.position = "plot")
    })
}

shinyApp(ui = ui, server = server)
