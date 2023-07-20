# Load required libraries
library(shiny)
library(shinyWidgets)
library(dplyr)

# UI part of the Shiny app
ui <- fluidPage(
  titlePanel("Leaderboard"),
  
  # Sidebar layout for filtering
  sidebarLayout(
    sidebarPanel(
      selectInput("metric", "Sort by:", 
                  choices = c("Username", "Happiness", "Budget", "Population", "Homelessness", "Employment"),
                  selected = "Username"),
      hr(),
      actionButton("refreshBtn", "Refresh Leaderboard")
    ),
    
    # Output layout for displaying the leaderboard table
    mainPanel(
      tableOutput("leaderboardTable")
    )
  )
)

# Server part of the Shiny app
server <- function(input, output) {
  # Function to fetch and sort leaderboard data based on the selected metric
  getSortedLeaderBoard <- function(metric) {
    gamevariantid <- YOUR_GAMEVARIANT_ID # Replace with the game variant ID you want to use
    leaderboard_data <- getLeaderBoard(gamevariantid)
    sorted_leaderboard <- switch(
      metric,
      "Username" = arrange(leaderboard_data, playername),
      "Happiness" = arrange(leaderboard_data, desc(happiness)),
      "Budget" = arrange(leaderboard_data, desc(budget)),
      "Population" = arrange(leaderboard_data, desc(population)),
      "Homelessness" = arrange(leaderboard_data, desc(homelessness)),
      "Employment" = arrange(leaderboard_data, desc(employment))
    )
    return(sorted_leaderboard)
  }
  
  # Function to render the leaderboard table based on the selected metric
  output$leaderboardTable <- renderTable({
    getSortedLeaderBoard(input$metric)
  })
  
  # Refresh the leaderboard on button click
  observeEvent(input$refreshBtn, {
    output$leaderboardTable <- renderTable({
      getSortedLeaderBoard(input$metric)
    })
  })
}

# Run the Shiny app
shinyApp(ui, server)
