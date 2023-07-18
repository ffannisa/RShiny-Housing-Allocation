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

