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

leaderboardModal <- function(failed = FALSE) {
  choice <- c("happiness", "budget", "employment", "homelessness", "population")
  names(choice) <- c("Happiness", "Budget", "Employment", "Homelessness", "Population")
  
  modalDialog(
    title = "Leaderboard",
    size=c("l"),
    selectInput("leaderboard_table", "Choose leaderboard:", choices = choice),
    
    # Wrap your table output in a div that allows for scrolling
    div(style = 'overflow-x: scroll', tableOutput(outputId = "leaderboard_table"))
  )
}



dialogBox<- function(t="abababababa"){
  modalDialog(
    t,
    easyClose = TRUE
  )
}

demolishConfirm<- function(gridnumber,type,demolish_cost,demolish_time){
  
  modalDialog(
    title = paste0("Confrim Demolish ",type,"?"),
    paste0("Demolition cost: ", demolish_cost),
    tags$br(),
    paste0("Time to demolish: ",demolish_time),
    footer = tagList(
      modalButton("Cancel"),
      actionButton("demolishButton", "Confirm")
    )
  )
}

gameOverModal <- function(winning, reason = "") {
  modalDialog(
    title = "Game Over",
    if (winning) {
      "Congratulations, you've won the game!"
    } else {
      "Sorry, you've lost the game!"
    },
    verbatimTextOutput("gameOverReason"),  # This will display the game over reason
    footer = tagList(
      actionButton("end_game", "End Game", class="nes-btn is-error"),
      actionButton("leaderboard", "Show Leaderboard", class="nes-btn is-warning")
    )
  )
}



