#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#




library(shiny)

# Define UI for application that draws a histogram
fluidPage(
  # Add font and Game design template to use -> Nes.css
  # Link the external CSS file and fonts
  tags$head(
    tags$link(href = "https://unpkg.com/nes.css@2.3.0/css/nes.min.css", rel = "stylesheet"),
    tags$link(href = "https://fonts.googleapis.com/css?family=Press+Start+2P", rel = "stylesheet")
  ),
  
  # Link the external CSS file
  includeCSS("css/Login_style.css"),
  
  # Center the game title "Housing Hustlers" with spacing
  tags$div(
    style = "text-align: center; margin-top: 50px;",
    tags$h1("Housing Hustlers")
  ),
  
  # Add buttons for Register and Login
  div(class = "btn-align",
      actionButton("register", label = "New Player", class = "nes-btn is-primary"),    
      # Returning Player button
      actionButton("login", label = "Returning Player", class = "nes-btn is-primary")),
  
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
  
  # !!! For testing. REMOVE THIS
  ,actionButton("build", label = "Build!", class = "nes-btn is-primary"),
  actionButton("progress", label = "Progress Time!", class = "nes-btn is-primary"),
  actionButton("demolish", label = "Demolish!", class = "nes-btn is-primary"),
  actionButton("stats", label = "Show Statistics", class = "nes-btn is-primary")  
    
)
