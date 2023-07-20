library(stringr)

#References
#https://shiny.rstudio.com/reference/shiny/latest/modalDialog.html
#https://shiny.rstudio.com/reference/shiny/0.14/passwordInput.html
#https://shiny.rstudio.com/articles/sql-injections.html
#https://shiny.rstudio.com/reference/shiny/0.14/renderUI.html

##Modified the passwordModal function to include an input field for the PlayerName. 
##Additionally, we'll modify the createNewPlayerQuery function to handle the insertion of both PlayerName and password into the database.


#Generate, or re-generate, HTML to create modal dialog for Password creation
passwordModal <- function(failed = FALSE) {
  modalDialog(
    title = "Create a New Player!",
    textInput("playername", "Enter your desired Player Name:"),
    passwordInput("password1", "Enter a new password:"),
    passwordInput("password2", "Confirm by re-entering the new password:"),
    "If successful, you will be assigned a Player Name to go with this password.",
    if (failed)
      div(tags$b("The passwords do not match. Try again.", style = "color: red;")),
    
    footer = tagList(
      modalButton("Cancel"),
      actionButton("passwordok", "OK")
    )
  )
}


getPlayerPassword <- function(playername) {
  conn <- getAWSConnection()
  query <- sqlInterpolate(conn, "SELECT password FROM LeaderPlayer WHERE playername = ?id", id = playername)
  result <- dbGetQuery(conn, query)
  dbDisconnect(conn)
  if (nrow(result) == 1) {
    return(result$password[1])
  } else {
    return(NULL)
  }
}

loginModal <- function(failed = FALSE) {
  modalDialog(
    title = "Login",
    textInput("playername", "Enter your assigned Player Name:"),
    passwordInput("password3", "Enter your password:"),
    if (failed)
      div(tags$b("There is no registered player with that name and password. Try again or re-register.", style = "color: red;")),
    
    footer = tagList(
      modalButton("Cancel"),
      actionButton("loginok", "OK")
    )
  )
}

getAWSConnection <- function(){
  conn <- dbConnect(
    drv = RMySQL::MySQL(),
    dbname = "student065",
    host = "database-1.ceo4ehzjeeg0.ap-southeast-1.rds.amazonaws.com",
    username = "student065",
    password = "dYUQMnMv73+H")
  conn
}


getPlayerID <- function(playername,password){

  #open the connection
  conn <- getAWSConnection()
  #password could contain an SQL insertion attack
  #Create a template for the query with placeholders for playername and password
  querytemplate <- "SELECT * FROM LeaderPlayer WHERE playername=?id1 AND password=?id2;"
  query<- sqlInterpolate(conn, querytemplate,id1=playername,id2=password)
  print(query) #for debug
  result <- dbGetQuery(conn,query)
  # If the query is successful, result should be a dataframe with one row
  if (nrow(result)==1){
    playerid <- result$playerid[1]
  } else {
    print(result) #for debugging
    playerid <- 0
  }
  #print(result)
  #print(playerid)
  #Close the connection
  dbDisconnect(conn)
  # return the playerid
  playerid
}

getRandomPlayerName <- function(conn){
  #Given a connection, call the View 'LeaderRandomName' and return the resulting name
  result <- dbGetQuery(conn,"SELECT * FROM LeaderRandomName")
  # result should be a dataframe with a single row and a column named 'playername'
  playername <- result$playername[1]
  # To test what happens when there is a duplicate entry, we can override the random result
  #playername <- "SophisticatedImaginaryZoo" # This matches an existing player in my database
  playername
}

createNewPlayerQuery <- function(conn,playername,password){
  #password could contain an SQL insertion attack
  #Create a template for the query with placeholder for  password
  querytemplate <- "INSERT INTO LeaderPlayer (playername,password) VALUES (?id1,?id2);"
  query<- sqlInterpolate(conn, querytemplate,id1=playername,id2=password)
}

registerPlayer <- function(password){
  #open the connection
  conn <- getAWSConnection()
  playername <- getRandomPlayerName(conn)
  query <- createNewPlayerQuery(conn,playername,password)
  print(query) #for debug
  # This query could fail to run properly so we wrap it in a loop with tryCatch()
  success <- FALSE
  iter <- 0
  MAXITER <- 5
  while(!success & iter < MAXITER){
    iter <- iter+1
    tryCatch(
   
      {  # This is not a SELECT query so we use dbExecute
        result <- dbExecute(conn,query)
        print(result)
        success <- TRUE
      }, error=function(cond){print("registerPlayer: ERROR")
                              print(cond)
                              # The query failed, likely because of a duplicate playername
                              playername <- getRandomPlayerName(conn)
                              query <- createNewPlayerQuery(conn,playername,password) }, 
        warning=function(cond){print("registerPlayer: WARNING")
                                print(cond)},
      finally = {print(paste0("Iteration ",iter," done."))
                }
    )
  } # end while loop
  # This may not have been successful
  if (!success) playername = NULL
  #Close the connection
  dbDisconnect(conn)
  playername
}

ui <- fluidPage(
  
  # Add font and Game design template to use -> Nes.css
  # Link the external CSS file and fonts
  tags$head(
    tags$link(href = "https://unpkg.com/nes.css@2.3.0/css/nes.min.css", rel = "stylesheet"),
    tags$link(href = "https://fonts.googleapis.com/css?family=Press+Start+2P", rel = "stylesheet")
  ),
  
  # Link the external CSS file
  includeCSS("Login_style.css"),
  
  # Center the game title "Housing Hustlers" with spacing
  tags$div(
    style = "text-align: center; margin-top: 50px;",
    tags$h1("Housing Hustlers")
  ),
  
  # Add buttons for Register and Login
  div(class = "btn-align",
      actionButton("register", tags$button(type = "button", class = "nes-btn is-primary", "New Player")),
      actionButton("login", tags$button(type = "button", class = "nes-btn is-primary", "Returning Player"))
  ),
  
  # Add some spacing
  tags$br(),
  tags$br(),
  
  # Add the loggedInAs div and center its content at the bottom
  div(id = "loggedInAsWrapper",
      style = "text-align: center;",
      htmlOutput("loggedInAs")
  ),
  
  # Apply CSS to center the entire page
  style = "display: flex; flex-direction: column; justify-content: space-between; align-items: center; height: 100vh;"
)

server <- function(input, output, session) {
  # reactiveValues object for storing items like the user password
  vals <- reactiveValues(password = NULL,playerid=NULL,playername=NULL,gamevariantid=1,score=NULL)
  
  #Fire some code if the user clicks the Register button
  observeEvent(input$register, {
    showModal(passwordModal(failed=FALSE))
  })
  # Fire some code if the user clicks the passwordok button
  observeEvent(input$passwordok, {
    # Check that password1 exists and it matches password2
    if (str_length(input$password1) >0 && (input$password1 == input$password2)) {
      #store the password and close the dialog
      vals$password <- input$password1
      print(vals$password) # for debugging
      #vals$playername = registerPlayer(vals$password) - CHANGED
      vals$playername <- input$playername
      if (!is.null(vals$playername)){
          vals$playerid <- getPlayerID(vals$playername,vals$password)
      }
      print(vals$playerid) # for debugging
      removeModal()
    } else {
      showModal(passwordModal(failed = TRUE))
    }
  })
  #Fire some code if the user clicks the Login button
  observeEvent(input$login, {
    showModal(loginModal(failed=FALSE))
  })
  # Fire some code if the user clicks the loginok button
  observeEvent(input$loginok, {
    # Get the playerID and check if it is valid
    playerid <- getPlayerID(input$playername,input$password3)
    if (playerid>0) {
      #store the playerid and playername and close the dialog
      vals$playerid <- playerid
      #print(vals$playerid) # for debugging
      vals$playername <- input$playername
      #print(vals$playername) # for debugging
      removeModal()
    } else {
      showModal(loginModal(failed = TRUE))
    }
  })
  
  # React to successful login
  output$loggedInAs <- renderUI({
    if (is.null(vals$playername))
      "Not logged in yet."
    else
      vals$playername
  })
  
  observeEvent(input$playgame, {
    vals$score = as.integer(runif(1,min=0,max=100))
    print(vals$score)
  })
  
}

shinyApp(ui, server)