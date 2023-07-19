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