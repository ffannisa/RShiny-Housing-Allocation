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
  
  output$image1<-renderUI(tags$image(src=images[1],ondrop = "drop(event)", ondragover = "allowDrop(event)",width="100px",height="100px"))
  output$image2<-renderUI(tags$image(src=images[2],ondrop = "drop(event)", ondragover = "allowDrop(event)",width="100px",height="100px"))
  output$image3<-renderUI(tags$image(src=images[3],ondrop = "drop(event)", ondragover = "allowDrop(event)",width="100px",height="100px"))
  output$image4<-renderUI(tags$image(src=images[4],ondrop = "drop(event)", ondragover = "allowDrop(event)",width="100px",height="100px"))
  output$image5<-renderUI(tags$image(src=images[5],ondrop = "drop(event)", ondragover = "allowDrop(event)",width="100px",height="100px"))
  output$image6<-renderUI(tags$image(src=images[6],ondrop = "drop(event)", ondragover = "allowDrop(event)",width="100px",height="100px"))
  output$image7<-renderUI(tags$image(src=images[7],ondrop = "drop(event)", ondragover = "allowDrop(event)",width="100px",height="100px"))
  output$image8<-renderUI(tags$image(src=images[8],ondrop = "drop(event)", ondragover = "allowDrop(event)",width="100px",height="100px"))
  output$image9<-renderUI(tags$image(src=images[9],ondrop = "drop(event)", ondragover = "allowDrop(event)",width="100px",height="100px"))
  output$image10<-renderUI(tags$image(src=images[10],ondrop = "drop(event)", ondragover = "allowDrop(event)",width="100px",height="100px"))
  output$image11<-renderUI(tags$image(src=images[11],ondrop = "drop(event)", ondragover = "allowDrop(event)",width="100px",height="100px"))
  output$image12<-renderUI(tags$image(src=images[12],ondrop = "drop(event)", ondragover = "allowDrop(event)",width="100px",height="100px"))
  output$image13<-renderUI(tags$image(src=images[13],ondrop = "drop(event)", ondragover = "allowDrop(event)",width="100px",height="100px"))
  output$image14<-renderUI(tags$image(src=images[14],ondrop = "drop(event)", ondragover = "allowDrop(event)",width="100px",height="100px"))
  output$image15<-renderUI(tags$image(src=images[15],ondrop = "drop(event)", ondragover = "allowDrop(event)",width="100px",height="100px"))
  output$image16<-renderUI(tags$image(src=images[16],ondrop = "drop(event)", ondragover = "allowDrop(event)",width="100px",height="100px"))
  output$image17<-renderUI(tags$image(src=images[17],ondrop = "drop(event)", ondragover = "allowDrop(event)",width="100px",height="100px"))
  output$image18<-renderUI(tags$image(src=images[18],ondrop = "drop(event)", ondragover = "allowDrop(event)",width="100px",height="100px"))
  output$image19<-renderUI(tags$image(src=images[19],ondrop = "drop(event)", ondragover = "allowDrop(event)",width="100px",height="100px"))
  output$image20<-renderUI(tags$image(src=images[20],ondrop = "drop(event)", ondragover = "allowDrop(event)",width="100px",height="100px"))
  output$image21<-renderUI(tags$image(src=images[21],ondrop = "drop(event)", ondragover = "allowDrop(event)",width="100px",height="100px"))
  output$image22<-renderUI(tags$image(src=images[22],ondrop = "drop(event)", ondragover = "allowDrop(event)",width="100px",height="100px"))
  output$image23<-renderUI(tags$image(src=images[23],ondrop = "drop(event)", ondragover = "allowDrop(event)",width="100px",height="100px"))
  output$image24<-renderUI(tags$image(src=images[24],ondrop = "drop(event)", ondragover = "allowDrop(event)",width="100px",height="100px"))
  output$image25<-renderUI(tags$image(src=images[25],ondrop = "drop(event)", ondragover = "allowDrop(event)",width="100px",height="100px"))
  output$image10<-renderUI(tags$image(src=images[10],ondrop = "drop(event)", ondragover = "allowDrop(event)",width="100px",height="100px"))
  
  
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
      var gridId = event.target.getAttribute('id');
      Shiny.setInputValue('dropId', gridId);
    }
  ")
  
  observeEvent(input$dropId, {
    # Get the dropped element's ID
    dropId <- input$dropId
    
    # Update the grid ID with the dropped element's ID
    if (!is.null(dropId)) {
      jsCode <- paste0("$('#", dropId, "').attr('id', '",
                       input$last_click$id, "');")
      runjs(jsCode)
    }
  })
}

shinyApp(ui, server)