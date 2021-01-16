# Define Server for app that gives results on AB test
server <- function(input, output) {
  #reactively calculate results on the test
  testresults <- shiny::reactive({
    #depending on the test selected calculate the test results
    if (input$test_type=="one-sample") {
      shiny::validate(shiny::need(input$variable_1_selected!="","Please select a Variable X1"))
      x1 <- get(as.character(input$variable_1_selected))
      set.seed(3)
      abtest::t_test_one_sample(x1,input$m0,clt=input$clt_par)
    } else if (input$test_type=="two-sample") {
      shiny::validate(shiny::need(input$variable_1_selected!="","Please select a Variable X1"),
                      shiny::need(input$variable_2_selected!="","Please select a Variable X2"))
      x1 <- get(as.character(input$variable_1_selected))
      x2 <- get(as.character(input$variable_2_selected))
      set.seed(3)
      abtest::t_test_two_sample(x1,x2,clt = input$clt_par)
    }

  })

  #plot output
  output$distPlot <- shiny::renderPlot({
    testresult <- testresults()
    suppressMessages(print(testresult$plot))
  })

  #text output
  output$summary <- shiny::renderPrint({
    testresult <- testresults()
    print(testresult$result[1])
  })


}
