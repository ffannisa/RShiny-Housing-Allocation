#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

passwordModal <- function(failed = FALSE) {
  modalDialog(
    title = "Create a New Player!",
    textInput("registerUsername", "Enter your desired Player Name:"),
    passwordInput("registerPassword", "Enter a new password:"),
    passwordInput("registerPasswordConfirmation", "Confirm by re-entering the new password:"),
    if (failed)
      div(tags$b("The passwords do not match. Try again.", style = "color: red;")),
    
    footer = tagList(
      modalButton("Cancel"),
      actionButton("registerButton", "OK")
    )
  )
}

loginModal <- function(failed = FALSE) {
  modalDialog(
    title = "Login",
    textInput("loginUsername", "Enter your assigned Player Name:"),
    passwordInput("loginPassword", "Enter your password:"),
    if (failed)
      div(tags$b("There is no registered player with that name and password. Try again or re-register.", style = "color: red;")),
    
    footer = tagList(
      modalButton("Cancel"),
      actionButton("loginButton", "OK")
    )
  )
}
