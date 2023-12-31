source("databaseFunctions.R")
source("images.R")
source("usePackages.R")
loadPkgs(c("ggplot2"))

gameCalc<-function(input,output,session,values){
  #USE CASE 1 USER REGISTRATION
  observeEvent(input$registerButton,{
    registerError<-NULL
    # check with aayush whether a blank is "" or NULL
    if (input$registerUsername==""){
      registerError<-"Empty username!"
    } else if (input$registerUsername==""){
      registerError<-"Empty password!"
    }else if (input$registerPassword!=input$registerPasswordConfirmation){
      registerError<-"Password Confirmation Does not match Password."
    } else {
      username<-stripSQLKeywords(input$registerUsername)
      password<-stripSQLKeywords(input$registerPassword)
      if (checkExistingUsername(username)){
        registerError<-"This username already exists. Choose another username"
      } else{
        response<-createUser(username,password)
        if (response!="success"){
          registerError<-paste0("Strange SQL error\n",response)
        }else{
          values$username<-username
          restart(values,FALSE)
          changeTab(session)
          removeModal()
        }
      }
    }
    print(values$username)
    print(paste0("error: ",registerError))
    if(!(is.null(registerError))){
      passwordModal(failed=TRUE)
    }
  })
  
  #USE CASE 2 LOGIN
  observeEvent(input$loginButton, {
    loginError<-NULL
    if (input$loginUsername==""){
      loginError<-"Empty username!"
    } else if (input$loginUsername==""){
      loginError<-"Empty password!"
    } else{
      username<-stripSQLKeywords(input$loginUsername)
      password<-stripSQLKeywords(input$loginPassword)
      response<-login(username,password)
      if (response!="success"){
        loginError<-paste0("Strange SQL error\n",response)
      }else{
        values$username<-username
        values$current_statistics<-findLatestStatistics(values$username)
        values$land_use<-findLandUse(values$username)
        changeTab(session)
        removeModal()
      }
    }
    print(values$username)
    print(paste0("Error: ",loginError))
    if(!(is.null(loginError))){
      passwordModal(failed=TRUE)
    }
  })
  
  
  #USE CASE 3 STRUCTURE SELECTION
  # receive input from drag and drop
  observeEvent(input$new_land_use,{
    print("new land use received")
    print(input$new_land_use)
    new_land_use<-stringr::str_split(input$new_land_use,",")
    grid_number<-as.numeric(new_land_use[[1]][1])
    if (values$land_use$type[values$land_use$grid_number==(grid_number)]!="empty" & substr(values$land_use$type[values$land_use$grid_number==(grid_number)],1,7)!="planned"){
      dialogBox("There is already something here!")
      
    }else{
      type<-paste0("planned ",new_land_use[[1]][2])
      values$land_use[values$land_use$grid_number==grid_number,]<-data.frame(grid_number=grid_number,type=type,remaining_lease=-1)
      print(values$land_use[values$land_use$grid_number==grid_number,])
      gridUpdater()
    }
  })
  
  # USE CASE 4 REVIEW GAME STATS
  observeEvent(input$tabs,{
    print(input$tabs)
    if (input$tabs=="Show Statistics!"){
      rerenderPlot(values$username)  
    }
    
  })
  rerenderPlot<-function(username){
    print("plot rerender started")
    game_data<-FindGameHistory(values$username)
    
    # population graph
    a2<-rbind(data.frame(year=game_data$year,population=game_data$population-game_data$homelessness,type="Housed Population"),
              data.frame(year=game_data$year,population=game_data$population,type="Homeless Population"),
              data.frame(year=game_data$year,population=game_data$employment,type="Employed Population")) 
    a2$type<-factor(a2$type,c("Homeless Population","Housed Population","Employed Population"))
    output$population_graph<-renderPlot({ggplot(data=a2,mapping = aes(x=year,y=population,fill=type))+
      geom_area(position="identity")+
      lims(x=c(1,NA),y=c(0,NA))+
      scale_x_continuous(breaks = function(x) unique(floor(pretty(seq(0, max(x))))))+
      labs(x="Year",y="Total Population",fill="Type")})
    
    # happy trend
    output$happy_trend_plot = renderPlot({
      # Generate a line chart with 'year' on the x-axis and 'happiness' on the y-axis
      ggplot(game_data, aes(x = year, y = happiness)) + geom_line(color='darkgreen')+
        scale_x_continuous(breaks = function(x) unique(floor(pretty(seq(0, max(x))))))
    })
    
    # budg bar
    output$budg_bar_plot = renderPlot({
      # Generate a bar chart with 'year' on the x-axis and 'budget' on the y-axis
      ggplot(game_data, aes(x = year, y = budget)) + geom_bar(stat = 'identity', fill='pink')+
        scale_x_continuous(breaks = function(x) unique(floor(pretty(seq(0, max(x))))))
    })
    
  }
  
  
  
  #USE CASE 5 SELECTION CONFIRMATION
  observeEvent(input$build,{
    if(values$current_statistics$budget <values$building_cost){
      showModal(dialogBox("You do not have enough money"))
    }else if(values$current_statistics$budget >=values$building_cost){
      print("build started successfully")
      # loop through values$land_use. Replace all to_build objects with the appropriate construction site
      values$current_statistics$budget <- values$current_statistics$budget- values$building_cost
      for (i in 1:nrow(values$land_use)){
        if (values$land_use[i,"type"]=="planned hdb_1"){
          values$land_use[i,"type"]<-"construction hdb_1"
          values$land_use[i,"remaining_lease"]<- 3
        }else if(values$land_use[i,"type"]=="planned hdb_2"){
          values$land_use[i,"type"]<-"construction hdb_2"
          values$land_use[i,"remaining_lease"]<-5
        }else if(values$land_use[i,"type"]=="planned office"){
          values$land_use[i,"type"]<-"construction office"
          values$land_use[i,"remaining_lease"]<-1
        } else if(values$land_use[i,"type"]=="planned park"){
          values$land_use[i,"type"]<-"construction park"
          values$land_use[i,"remaining_lease"]<-2
        }
        print(values$land_use[i,])
      }
      gridUpdater()
    }
  })
  
  #USE CASE 6 TIME PROGRESS
  observeEvent(input$progress, {
    progressYears<- input$time
    print(paste0("started progressing ",progressYears," years"))
    for (i in 1:progressYears){
      values$current_statistics$year<-values$current_statistics$year+1
      progressBarUpdater()
      # increase values
      values$current_statistics$happiness<-7*values$current_statistics$happiness%/%10-10*values$current_statistics$homelessness+5*values$current_statistics$employment%/%10+50*sum(values$land_use$type=="park")
      values$current_statistics$budget<-values$current_statistics$budget-100*values$current_statistics$population+1000*values$current_statistics$employment+50000*sum(values$land_use$type=="office")
      
      values$current_statistics$population<-values$current_statistics$population+values$current_statistics$population%/%10
      
      # reduce leases
      values$land_use$remaining_lease<-values$land_use$remaining_lease -1
      # checking if change is needed
      for (i in 1:25){
        if (substr(values$land_use$type[i],1,7)=="planned"){
          values$land_use$type[i]<-"empty"
          values$land_use$remaining_lease[i]<--1
        }else if (values$land_use$remaining_lease[i]==0){
          if (values$land_use$type[i]=="hdb_1" | values$land_use$type[i]=="hdb_2" | values$land_use$type[i]=="office" | values$land_use$type[i]=="park"){
            values$land_use$type[i]<-"demolition"
            values$land_use$remaining_lease[i]<-1  
          }else if (values$land_use$typ[i]=="demolition"){
            values$land_use$type[i]<-"empty"
          }else if (values$land_use$type[i]=="construction hdb_1"){
            values$land_use$type[i]<-"hdb_1"
            values$land_use$remaining_lease[i]<-99  
          }else if (values$land_use$type[i]=="construction hdb_2"){
            values$land_use$type[i]<-"hdb_2"
            values$land_use$remaining_lease[i]<-99  
          }else if (values$land_use$type[i]=="construction office"){
            values$land_use$type[i]<-"office"
            values$land_use$remaining_lease[i]<-10
          }else if (values$land_use$type[i]=="construction park"){
            values$land_use$type[i]<-"park"
            values$land_use$remaining_lease[i]<-5
          }
        }
        
      }
      gridUpdater()
      
      # update building related stats
      values$current_statistics$homelessness<-max(0,values$current_statistics$population-(200*sum(values$land_use$type=="hdb_1")+400*sum(values$land_use$type=="hdb_2")))
      values$current_statistics$employment<-min(values$current_statistics$population,50*sum(values$land_use$type=="office"))
      print(values$current_statistics)
      # saves
      print(values$land_use)
      a=SaveCurrentLanduse(cbind(username=rep(values$username,25),values$land_use))
      print(a)
      saveGameStatistics(values$username,
                         values$current_statistics$year,
                         values$current_statistics$happiness,
                         values$current_statistics$budget,
                         values$current_statistics$population,
                         values$current_statistics$homelessness,
                         values$current_statistics$employment)
      print(values$current_statistics$happiness<=0 | values$current_statistics$budget<=0)
      if (values$current_statistics$happiness<=0 | values$current_statistics$budget<=0){
        goToGameOver(FALSE, "Happiness or budget fell to 0.")
        return()
      }else if(values$current_statistics$year==999){
        goToGameOver(TRUE, "You have reached the year 999.")
        return()
      }
    }
    
  })
  
  # USE CASE 7 END GAME
  # Navigate back to the login page and close the modal
  observeEvent(input$end_game, {
    removeModal(session)
    # restart(values)
    updateNavbarPage(session, "pages", "first page")
  })
  
  # USE CASE 10 DEMOLISH
  observeEvent(input$demolish_drop,{
    print(paste0("demolish started for grid ",input$demolish_drop))
    gridnumber<-as.numeric(input$demolish_drop)
    
    # find the type. display the demolish cost
    type<-values$land_use$type[gridnumber]
    
    if (type=="empty"){
      print("nothing to delete: empty")
      return()
    }else if(substr(type,1,7)=="planned"){
      demolish_cost<-0
      demolish_time<-0
    }else if(substr(type,1,12)=="construction"){
      demolish_cost<-10000
      demolish_time<-1
    }else if(type=="hdb_1"){
      demolish_cost<-10000
      demolish_time<-3
    }else if(type=="hdb_2"){
      demolish_cost<-50000
      demolish_time<-3
    }else if(type=="office"){
      demolish_cost<-500000
      demolish_time<-2
    }else if(type=="park"){
      demolish_cost<-100000
      demolish_time<-2
    }else if(land_use=="demolition"){
      print("nothing to delete: demolition")
      return()
    }else{
      stop(paste0("Funky demolition type alert at row"))
    }
    # ask to confirm
    if(demolish_cost>0){
      values$demolish_gridnumber=gridnumber
      values$demolish_cost=demolish_cost
      values$demolish_time=demolish_time
      showModal(demolishConfirm(gridnumber,type,demolish_cost,demolish_time))
    }else{
      values$land_use$type[gridnumber]<-"empty"
      values$land_use$remaining_lease[gridnumber]<--1
      gridUpdater()
    }
  })
  # read demolishButton
  observeEvent(input$demolishButton,{
    print("demolish button started")
    values$land_use$type[values$demolish_gridnumber]<-"demolition"
    values$land_use$remaining_lease[values$demolish_gridnumber]<-values$demolish_time
    gridUpdater()
    removeModal()
  })
  
  
  # USE CASE 11 RESTART GAME
  observeEvent(input$restart,{
    # CreateLeaderboardEntry(values$username,values$current_statistics$year,values$current_statistics$happiness,values$current_statistics$budget,values$current_statistics$population,values$current_statistics$homelessness,values$current_statistics$employment)
    
    restart(values)
  })
  # observeEvent()
  
  restart<-function(values,refresh_grid=TRUE){
    print("restart started")
    # clear historic data
    delete_historic_data(values$username)
    # set default values and save
    values$current_statistics<-data.frame(year=c(1),happiness=c(50),budget=c(999999),population=c(100),homelessness=c(0),employment=c(0))
    values$land_use<-data.frame(grid_number=c(1:25),type=c("hdb_1",rep("empty",24)),remaining_lease=c(3,rep(-1,24)))
    print(values$username)
    print(values$current_statistics)
    print(values$land_use)
    if (refresh_grid){
      gridUpdater()  
    }
    a=saveGameStatistics(values$username,values$current_statistics$year,values$current_statistics$happiness,values$current_statistics$budget,values$current_statistics$population,values$current_statistics$homelessness,values$current_statistics$employment)
    print(a)
    b=SaveCurrentLanduse(cbind(username=rep(values$username,25),values$land_use))
    print(b)
  }
  
  changeTab<- function(session){
    # insert function to change tab
    updateNavbarPage(session = session,
                     inputId = "pages",
                     selected = "second_page")
    print("changed tab to Game Play")
    gridUpdater()
    
  }
  
  
  progressBarUpdater<-function(){
    print("hi u were supposed to have a progress bar ;)")
    # dialogBox("move year progress bar")
  }
  gridUpdater <- function(){
    # retrieve the values$land_use and update values$images[i]
    print("gridUpdater started")
    
    # count for planned hdb_1, hdb_2, office, park
    planned_count<-c(0,0,0,0)
    for (i in 1:25){
      land_use<-values$land_use$type[i]
      print(paste0(i," ",land_use))
      if (land_use=="empty"){
        values$images[i]<-image_empty
      }else if(land_use=="planned hdb_1"){
        planned_count[1]<-planned_count[1]+1
        values$images[i]<-image_planned_hdb1
      }else if(land_use=="planned hdb_2"){
        planned_count[2]<-planned_count[2]+1
        values$images[i]<-image_planned_hdb2
      }else if(land_use=="planned office"){
        planned_count[3]<-planned_count[3]+1
        values$images[i]<-image_planned_office
      }else if(land_use=="planned park"){
        planned_count[4]<-planned_count[4]+1
        values$images[i]<-image_planned_park
      }else if(substr(land_use,1,12)=="construction"){
        values$images[i]<-image_construction
      }else if(land_use=="hdb_1"){
        values$images[i]<-image_hdb1
      }else if(land_use=="hdb_2"){
        values$images[i]<-image_hdb2
      }else if(land_use=="office"){
        values$images[i]<-image_office
      }else if(land_use=="park"){
        values$images[i]<-image_park
      }else if(land_use=="demolition"){
        values$images[i]<-image_demolition
      }else{
        stop(paste0("Funky land use alert at row",i))
      }
      
    }
    values$building_cost<-sum(planned_count*c(10000,50000,500000,100000))
    print(paste0("building cost:",values$building_cost))
    
  }
  

  goToGameOver <- function(winning, reason) {
    print("goToGameOver Started")
    CreateLeaderboardEntry(values$username)
    if (!winning) {
      output$gameOverReason <- renderText({
        paste0(reason)
      })
      showModal(gameOverModal(FALSE))
    } else {
      output$gameOverReason <- renderText({
        paste0(reason)
      })
      showModal(gameOverModal(TRUE))
    }
  } 
  
  
}

