library(tidyverse)
library(here)
dependecies <- read_csv(here("Mastering_Shiny/dependecies.csv")) %>%
  pull(packages)

pacman::p_load(char = dependecies)


# First Shiny App ----

# Frontend User Interface
ui <- fluidPage(
  "Hello world!"
)

# Backend Server
server <- function(input, output, session) {
}

# Run the App
shinyApp(ui, server)


# Adding UI controls 

ui <- fluidPage(
  selectInput(inputId = "dataset", label = "Dataset", choices = ls("package:datasets")),
  verbatimTextOutput(outputId = "summary"),
  tableOutput(outputId = "table")
)

# selectInput(): input control to interact with the app (choose datasets in a multiselect box)
# verbatimTextOutput() + tableOutput() -> output controls that control where to put rendered input

shinyApp(ui, server)


# Adding behavior 

server <- function(input, output, session) {
  output$summary <- renderPrint({
    dataset <- get(input$dataset, "package:datasets")
    summary(dataset)
  })

  output$table <- renderTable({
    dataset <- get(input$dataset, "package:datasets")
    dataset
  })
}

# output$ID -> recipe for the output id (summary, table)
# render{Type} -> specific type of output: text, tables, plots

shinyApp(ui, server)

# Reducing deduplication with rective expressions 

# Code duplication: dataset <- get(input$dataset, "package:datasets")
# Solution: Reactive Expressions ->  reactive({...})
# Difference to functions: only runs the first time it´s called and then caches its results until it needs to be updated


server <- function(input, output, session) {
  # Create a reactive expression
  dataset <- reactive({
    get(input$dataset, "package:datasets")
  })

  output$summary <- renderPrint({
    # Use a reactive expression by calling it like a function
    summary(dataset())
  })

  output$table <- renderTable({
    dataset()
  })
}

shinyApp(ui, server)


# Exercices 

# Exercise 1:
# Create an app that greets the user by name.

ui <- fluidPage(
  textInput(inputId = "name", label = "What's your name?"),
  textOutput(outputId = "greeting")
)

server <- function(input, output, session) {
  output$greeting <- renderText({
    paste0("Hello ", input$name)
  })
}

shinyApp(ui, server)

# Exercise 2:
# Create an App that allows the user to set a number between 1-50
# and displays the results of multiplying this number  by factor 5.

ui <- fluidPage(
  sliderInput(inputId = "x", label = "If x is", min = 1, max = 1e3, value = 500),
  textOutput("product")
)

server <- function(input, output, session) {
  output$product <- renderText({
    paste0("Then x times 5 is ", input$x * 5, "!")
  })
}

shinyApp(ui, server)

# Exercise 3:
# Extend the app from the previous exercise to allow the user to
# set the value of the multiplier, y, so that the app yields the value of x * y.

ui <- fluidPage(
  sliderInput(
    inputId = "x",
    label = "If x is...",
    min = 1,
    max = 50,
    value = 30
  ),
  sliderInput(
    inputId = "y",
    label = "and y is...",
    min = 1,
    max = 50,
    value = 5
  ),
  textOutput(outputId = "product")
)

server <- function(input, output, session) {
  output$product <- renderText(
    paste0("... then x times y is ", input$x * input$y, "!")
  )
}

shinyApp(ui, server)

# Exercise 4:
# Take the following app which adds some additional functionality
# to the last app described in the last exercise. What’s new?
# How could you reduce the amount of duplicated code in the app by using a reactive expression.


ui <- fluidPage(
  sliderInput("x", "If x is", min = 1, max = 50, value = 30),
  sliderInput("y", "and y is", min = 1, max = 50, value = 5),
  "then, (x * y) is", textOutput("product"),
  "and, (x * y) + 5 is", textOutput("product_plus5"),
  "and (x * y) + 10 is", textOutput("product_plus10")
)

server <- function(input, output, session) {
  output$product <- renderText({
    product <- input$x * input$y
    product
  })
  output$product_plus5 <- renderText({
    product <- input$x * input$y
    product + 5
  })
  output$product_plus10 <- renderText({
    product <- input$x * input$y
    product + 10
  })
}

shinyApp(ui, server)

# Problem: product <- input$x * input$y duplicated
# Solution: Use Reactive Expression

server <- function(input, output, session) {
  product_react <- reactive({input$x * input$y}) # Reactive Expression
  
  output$product <- renderText(product_react())
  output$product_plus5 <- renderText(product_react() + 5)
  output$product_plus10 <- renderText(product_react() + 10)
}

shinyApp(ui, server)

# Exercise 5:
# Find bugs in code.

datasets <- c("economics", "faithfuld", "seals")
ui <- fluidPage(
  selectInput("dataset", "Dataset", choices = datasets),
  verbatimTextOutput("summary"),
  plotOutput("plot")
)

server <- function(input, output, session) {
  dataset <- reactive({
    get(input$dataset, "package:ggplot2")
  })
  output$summary <- renderPrint({
    summary(dataset())
  })
  output$plot <- renderPlot({
    plot(dataset())
  }, res = 96)
}

shinyApp(ui, server)




