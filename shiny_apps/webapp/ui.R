# Define UI for app that gives results on AB test
ui <- shiny::fluidPage(
  shiny::titlePanel("AB test tool"),
  # Sidebar layout with input and output definitions
  shiny::sidebarLayout(
    # Sidebar panel for inputs
    shiny::sidebarPanel(
      # Input: Numeric input for mean to be compared
      shiny::numericInput(inputId = "m0",
                         label = "Value to Compare",
                         min = -2,
                         max = 2,
                         value = 0.2)

    ),
    # Main panel for displaying outputs
    shiny::mainPanel(
      shiny::verbatimTextOutput("summary"),
      # Output: Histogram
      shiny::plotOutput(outputId = "distPlot")
    )
  )
)
