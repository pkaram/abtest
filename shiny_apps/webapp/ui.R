# Define UI for app that gives results on AB test
ui <- shiny::fluidPage(
  shiny::titlePanel("AB test tool"),
  # Sidebar layout with input and output definitions
  shiny::sidebarLayout(
    # Sidebar panel for inputs
    shiny::sidebarPanel(
      #Select one/two sample test
      shiny::selectInput(
        inputId = "test_type",label = "Select test type:",
        selected = "one-sample",multiple = FALSE,
        choices = c("one-sample","two-sample")
      ),

      #select variable to perform a test
      shiny::selectInput(
        inputId = "variable_1_selected", label = "Variable X1:",
         multiple = FALSE,
        choices = c("", available_variables)
      ),

      shiny::conditionalPanel(
        condition = "input.test_type=='two-sample'",
        shiny::selectInput(
          inputId = "variable_2_selected", label = "Variable X2 to Compare:",
          multiple = FALSE,
          choices = c("", available_variables)
        )
      ),

      shiny::conditionalPanel(
        condition = "input.test_type=='one-sample'",
        shiny::numericInput(inputId = "m0",
                            label = "Value to Compare",
                            min = -2,
                            max = 2,
                            value = 0.2)
      ),

      shiny::radioButtons(inputId = "variable_outcome",label = "Select Variable Outcome:",
                          selected = "continuous",
                          choices = c("continuous","dichotomous")),

      shiny::radioButtons(inputId = "clt_par",label = "Apply CLT:",
                          selected = FALSE,
                          choices = c(TRUE,FALSE))

    ),
    # Main panel for displaying outputs
    shiny::mainPanel(
      shiny::plotOutput(outputId = "distPlot"),
      shiny::verbatimTextOutput("summary")
    )
  )
)
