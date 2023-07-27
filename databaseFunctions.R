
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

#if no exisitng land use, implement default values(initial game setting)


# save land use -> land use df and username-> save onto DB

# save game statistics -> 
 
#retrieve leaderboard

library(RMySQL)

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



stripSQLKeywords <- function(username) {
  # The system shall strip the Player Name and password of SQL keywords
  # Replace any SQL keywords or dangerous characters from the username
  
  # List of SQL keywords and dangerous characters to be removed
  sql_keywords <- c("SELECT", "INSERT", "UPDATE", "DELETE", "DROP", "CREATE", "ALTER", "TABLE", "DATABASE", ";", "--", "#", "/*", "*/")
  
  # Remove SQL keywords and dangerous characters from the username using gsub
  for (keyword in sql_keywords) {
    username <- gsub(keyword, "", username, ignore.case = TRUE)
  }
  
  # Return the sanitized input_string
  return(username)
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



createNewPlayerQuery <- function(conn,username,password){
  #password could contain an SQL insertion attack
  #Create a template for the query with placeholder for  password
  querytemplate <- "INSERT INTO player (username,password) VALUES (?id1,?id2);"
  query<- sqlInterpolate(conn, querytemplate,id1=username,id2=password)
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


# TESTED
findLatestStatistics <- function(username) {
  conn <- getAWSConnection()
  
  # Query to find the latest game data for the username
  query <- sqlInterpolate(conn, "SELECT year, happiness, budget, population, homelessness, employment FROM historic_data WHERE username = ?id ORDER BY year DESC LIMIT 1;", id = username)
  
  # Execute the query and get the result
  result <- dbGetQuery(conn, query)
  
  dbDisconnect(conn)
  
  return(result)
}


# TESTED
# RMB TO UPDATE DEFAULT VALUES AFTER DISCUSSING
findLandUse <- function(username) {
  conn <- getAWSConnection()
  
  # Query to find the land use for the username
  query <- sqlInterpolate(conn, "SELECT grid_number, type, remaining_lease FROM current_land_use WHERE username = ?id;", id = username)
  
  # Execute the query and get the result
  result <- dbGetQuery(conn, query)
  
  dbDisconnect(conn)
  
  # If there are no existing land use records, implement default values (empty grid with no values)
  if (nrow(result) == 0) {
    # Create an empty grid with default values
    default_values <- data.frame(
      grid_number = 1:16,
      type = rep("Empty", 16),
      remaining_lease = rep(0, 16)
    )
    
    # Return the default values
    return(default_values)
  } else {
    # Return the result with existing land use records
    return(result)
  }
}


# WORKS BUT NEED EDIT OUTPUT, CURRENT OUTPUT IS WHETHER CAN DISCONNECT FROM DBEAVER
# PlaceHousing - This function allows a user to place a housing type on the grid.
placeHousing <- function(username, grid_number, type, remaining_lease) {
  conn <- getAWSConnection()
  
  # Check if the box is already occupied by a land use type for this user
  query_check <- sqlInterpolate(conn, "SELECT COUNT(*) as count FROM current_land_use WHERE username = ?id1 AND grid_number = ?id2;", id1 = username, id2 = grid_number)
  result_check <- dbGetQuery(conn, query_check)
  
  if (result_check$count[1] == 0) {
    # The box is not occupied, insert a new record
    query_insert <- sqlInterpolate(conn, "INSERT INTO current_land_use (username, grid_number, type, remaining_lease) VALUES (?id1, ?id2, ?id3, ?id4);", id1 = username, id2 = grid_number, id3 = type, id4 = remaining_lease)
    dbExecute(conn, query_insert)
  }
  
  dbDisconnect(conn)
  # VIVEK GPT will add this
}


# why does function return TRUE when I key in a grid no. that doesn't exist + username with no data stored on dbeaver
# able to remove structure from existing grid

# removeStructure - This function allows a user to remove an existing structure from the grid.
removeStructure <- function(username, grid_number) {
  conn <- getAWSConnection()
  
  # Delete the record from the current_land_use table for the given grid number
  query_delete <- sqlInterpolate(conn, "DELETE FROM current_land_use WHERE username = ?id1 AND grid_number = ?id2;", id1 = username, id2 = grid_number)
  dbExecute(conn, query_delete)
  
  dbDisconnect(conn)
  # change output 
}



# Vivek's AWS
# dbname = "student034",
# host = "database-1.ceo4ehzjeeg0.ap-southeast-1.rds.amazonaws.com",
# username = "student034",
# password = "!YNSD2qQH*-6"

getAWSConnection <- function(){
  conn <- dbConnect(
    drv = RMySQL::MySQL(),
    dbname = "student098",
    host = "database-1.ceo4ehzjeeg0.ap-southeast-1.rds.amazonaws.com",
    username = "student098",
    password = "C4Z!RZuJfRq5")
  conn
}

