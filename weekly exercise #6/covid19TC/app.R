
library(shiny)
library(tidyverse)
library(plotly)

covid19 <- read_csv("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv")

state_options <- covid19 %>% 
  distinct(state) %>% 
  filter(!(state %in% c("Virgin Islands", "Northern Mariana Islands", "Puerto Rico", "Guam"))) %>%
  pull(state)


ui <- fluidPage(
  titlePanel("COVID19 Cases App"),
    sidebarLayout(
      sidebarPanel(selectInput(inputId = "state1", 
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
                   submitButton(text = "Create plot")),
      mainPanel(plotlyOutput(outputId = "timeplot"))
    )
  )


server <- function(input, output) {
    output$timeplot <- renderPlotly({
      covid <- covid19 %>% 
        filter(state == c(input$state1, 
                          input$state2, 
                          input$state3)) %>%
        group_by(state) %>% 
        arrange(date) %>% 
        mutate(tfcase = cases >= 20,
               over20day = which.max(tfcase),
               days_since_20 = row_number() - over20day) %>% 
        ggplot(aes(x = days_since_20,
                   y = cases,
                   color = state)) +
        geom_line(size = 1.75,
                  alpha = 0.6) +
        scale_y_log10(labels = scales::comma) +
        labs(x = "Days Since 20+ Cases",
             y = "",
             title = "Log of Cumulative Cases over Time",
             caption = "Data from COVID 19 NY Times",
             color = "State") +
        theme(plot.title.position = "plot",
              plot.caption.position = ,
              plot.title = element_text(size = 15, face = "bold"),
              panel.background = element_rect(fill = "#D0D9D6"), 
              plot.background = element_rect(fill = "#D0D9D6"))
      
      ggplotly(covid,
               tooltip = c("x", "y"))
    })
}

shinyApp(ui = ui, server = server)
