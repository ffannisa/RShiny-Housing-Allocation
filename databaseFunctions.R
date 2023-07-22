checkExistingUsername<- function (username){
  # username: string
  # check if this username is already in use
  # return TRUE or FALSE
}

stripSQLKeywords<-function(username){
  # The system shall strip the Player Name and password of SQL keywords
  # return the stripped username
}

createUser<-function(username,password){
  #create a user with this username and password
  # return either "success" or string with error message
}

login<-function(username,password){
  # check that the username and password is correct
  # return either "success" or string with error message
}


findLatestStatistics<- function(username){
  # finds the latest game data for the username: year, happiness, budget, population, homelessness, employment
  # return data.frame with columns: year, happiness, budget, population, homelessness, employment
}

findLandUse<- function(username){
  # finds the land use for the username and puts it into a dataframe
  # return data.frame with columns: grid_number, type, remaining_lease
}



getPlayerID <- function(playername,password){
  #open the connection
  conn <- getAWSConnection()
  #password could contain an SQL insertion attack
  #Create a template for the query with placeholders for playername and password
  querytemplate <- "SELECT * FROM player WHERE username=?id1 AND password=?id2;"
  query<- sqlInterpolate(conn, querytemplate,id1=username,id2=password)
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


createNewPlayerQuery <- function(conn,username,password){
  #password could contain an SQL insertion attack
  #Create a template for the query with placeholder for  password
  querytemplate <- "INSERT INTO player (username,password) VALUES (?id1,?id2);"
  query<- sqlInterpolate(conn, querytemplate,id1=username,id2=password)
}


