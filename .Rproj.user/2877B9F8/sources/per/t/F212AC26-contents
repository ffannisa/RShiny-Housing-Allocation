
#checkExistingUsername<- function (username){
  # username: string
  # check if this username is already in use
  # return TRUE or FALSE
#}

#stripSQLKeywords<-function(username){
  # The system shall strip the Player Name and password of SQL keywords
  # return the stripped username
#}

#createUser<-function(username,password){
  #create a user with this username and password
  # return either "success" or string with error message
#}

#login<-function(username,password){
  # check that the username and password is correct
  # return either "success" or string with error message
#}


#findLatestStatistics<- function(username){
  # finds the latest game data for the username: year, happiness, budget, population, homelessness, employment
  # return data.frame with columns: year, happiness, budget, population, homelessness, employment
#}

#findLandUse<- function(username){
  # finds the land use for the username and puts it into a dataframe
  # return data.frame with columns: grid_number, type, remaining_lease
#}


checkExistingUsername <- function(username) {
  # Check if this username is already in use in the database
  conn <- getAWSConnection()
  query <- sqlInterpolate(conn, "SELECT COUNT(*) as count FROM player WHERE username = ?id", id = username)
  result <- dbGetQuery(conn, query)
  dbDisconnect(conn)
  
  if (result$count[1] > 0) {
    return(TRUE)  # Username already exists
  } else {
    return(FALSE) # Username does not exist
  }
}

stripSQLKeywords <- function(input_string) {
  # The system shall strip the Player Name and password of SQL keywords
  # Replace any SQL keywords or dangerous characters from the input_string
  
  # List of SQL keywords and dangerous characters to be removed
  sql_keywords <- c("SELECT", "INSERT", "UPDATE", "DELETE", "DROP", "CREATE", "ALTER", "TABLE", "DATABASE", ";", "--", "#", "/*", "*/")
  
  # Remove SQL keywords and dangerous characters from the input_string using gsub
  for (keyword in sql_keywords) {
    input_string <- gsub(keyword, "", input_string, ignore.case = TRUE)
  }
  
  # Return the sanitized input_string
  return(input_string)
}



createUser <- function(username, password) {
  # Create a user with the given username and password in the database
  # First, check if the username is already in use
  if (checkExistingUsername(username)) {
    return("Username already exists. Please choose a different username.")
  }
  
  # Strip SQL keywords from the username (Optional, depending on your security requirements)
  username <- stripSQLKeywords(username)
  
  # Now, create the user with the sanitized username and password
  conn <- getAWSConnection()
  query <- createNewPlayerQuery(conn, username, password)
  tryCatch(
    {
      dbExecute(conn, query)  # Execute the SQL query to insert the new user
      dbDisconnect(conn)
      return("success")  # User created successfully
    },
    error = function(e) {
      dbDisconnect(conn)
      return(paste("Error creating user:", e$message))  # Return error message on failure
    }
  )
}


login <- function(username, password) {
  # Check that the username and password is correct in the database
  conn <- getAWSConnection()
  query <- sqlInterpolate(conn, "SELECT COUNT(*) as count FROM player WHERE username = ?id1 AND password = ?id2;", id1 = username, id2 = password)
  result <- dbGetQuery(conn, query)
  dbDisconnect(conn)
  
  if (result$count[1] > 0) {
    return("success")  # Login successful
  } else { 
    return("Incorrect username or password.")  # Login failed
  }
}



getAWSConnection <- function(){
  conn <- dbConnect(
    drv = RMySQL::MySQL(),
    dbname = "student034",
    host = "database-1.ceo4ehzjeeg0.ap-southeast-1.rds.amazonaws.com",
    username = "student034",
    password = "!YNSD2qQH*-6")
  conn
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


