# Define Server for app that gives results on AB test
server <- function(input, output) {
  #reactively calculate results on the test
  testresults <- shiny::reactive({
    set.seed(3)
    x1 <- rnorm(1000)
    z1 <- t_test_one_sample(x,input$m0)
  })

  #plot output
  output$distPlot <- shiny::renderPlot({
    testresult <- testresults()
    suppressMessages(print(testresult$plot))
  })

  #text output
  output$summary <- shiny::renderPrint({
    testresult <- testresults()
    print(testresult$result)
  })

}
