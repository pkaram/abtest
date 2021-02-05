#'Runs AB test shiny app
#'
#'Shiny App as a tool to perform AB test
#'
#'@return web app
#'@export
runshinyapp <- function() {
  appDir <- system.file("shiny_apps", "webapp", package = "abtest")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `abtest`.", call. = FALSE)
  }
  shiny::runApp(appDir,display.mode = 'normal')
}
