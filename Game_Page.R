library(shiny)
library(shinyjs)

ui <- fluidPage(
  includeCSS("https://fonts.googleapis.com/css?family=PT+Sans|Autour+One|Source+Code+Pro"),
  includeCSS("css/Game_style.css"),
  
  tags$section(id = "sidebar",
               tags$div(class = "header",
                        tags$div(tags$h1("Housing Hustlers!", class = "title"))
               )
  ),
  uiOutput("a1")
)

server <- function(input, output,session) {
  observeEvent(input$test,{print(input$test)})
  image_path<-"images/house_1.png"
  image_data<-base64enc::dataURI(file=image_path,mime="image/png")
  images<-rep(image_data,25)
  output$a1<-renderUI(
    
    tags$section(id = "view",
      tags$div(id = "board",
            tags$div(id = "overlay", class = "grid-container",
                     lapply(1:25, function(i) {
                       tags$span(class = "plot", id = paste0("grid", i), ondrop = "drop(event)", ondragover = "allowDrop(event)")
                     })
            ),
            tags$div(id = "plants"),
            tags$div(id = "garden", class = "grid-container"),
            tags$div(id = "soil", class = "grid-container",
                     lapply(1:25, function(i) {
                       tags$span(class = "plot",
                                 uiOutput(paste0("image",i))
                                 )
                     })
            )
    )
  ))
  
  for (i in 1:25){
    output[[paste0("image",i)]]<-renderUI(tags$image(src=images[i],ondrop = "drop(event)", ondragover = "allowDrop(event)",width="100px",height="100px",gridId=i))
  }
  
  
  
  # observeEvent(input$changeImage,{
  #   image_path<-"images/house_1.png"
  #   image_data<-base64enc::dataURI(file=image_path,mime="image/png")
  #   output
  # })
  
  # Make the draggable element draggable
  shinyjs::runjs("
    function dragStart(event) {
      event.dataTransfer.setData('text/plain', event.target.id);
    }
    
    function allowDrop(event) {
      event.preventDefault();
    }
    
    function drop(event) {
      event.preventDefault();
      var data = event.dataTransfer.getData('text');
      event.target.appendChild(document.getElementById(data));
      var gridId = event.target.getAttribute('gridId');
      Shiny.setInputValue('dropId', gridId);
    }
  ")
  
  observeEvent(input$dropId, {
    # Get the dropped element's ID
    dropId <- input$dropId
    print(dropId)
    # 
    # # Update the grid ID with the dropped element's ID
    # if (!is.null(dropId)) {
    #   jsCode <- paste0("$('#", dropId, "').attr('id', '",
    #                    input$last_click$id, "');")
    #   runjs(jsCode)
    # }
  })
}

shinyApp(ui, server)