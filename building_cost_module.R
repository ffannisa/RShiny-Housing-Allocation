# building_cost_module.R

# Define the module UI
buildingCostModuleUI <- function(id) {
  ns <- NS(id)
  tagList(
    ### use uiOutput
    column(2, 
           div(id = ns("building_cost_box"), class = "custom-value-box5",
               tags$div(class = "value-box-value", uiOutput(ns("building_cost_value_output"))),
               tags$div(class = "value-box-title", "Building Cost")
           )
    )
  )
}

# Define the module server
buildingCostModule <- function(input, output, session, values) {
  # Reactive function to get the building cost
  building_cost_value <- reactive({
    return(values$building_cost)
  })
  
  # Update the value box with the building cost
  output$building_cost_box <- renderUI({
    tagList(
      tags$div(class = "value-box-value", building_cost_value()),
      tags$div(class = "value-box-title", "Building Cost")
    )
  })
}
