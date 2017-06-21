# Loops optimization in R
# H. Achicanoy
# CIAT, 2017

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= #
# Loops optimization
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= #

options(warn = -1); options(scipen = 999); rm(list = ls())

suppressMessages(library(nycflights13))

data("flights")
View(flights)

##### Objective: CALCULATE TOTAL AIR TIME PER MONTH

### Common "for" loop

month_list <- 1:12 # Input
air_time_month <- c() # Output

system.time(expr = {
  
  for(i in 1:length(month_list)){ # Iterate by month
    
    flights_filtered <- flights[flights$month == month_list[i],] # Subset by month
    air_time_month[i] <- sum(flights_filtered$air_time, na.rm = T) # Sum air time per month
    
  }
  
})
air_time_month
# PLEASE LOOK THE NUMBER OF OBJECTS CREATED ON THE GLOBAL ENVIRONMENT



### Common "for" loop a little better

rm(list=setdiff(ls(), "flights"))

month_list <- 1:12 # Input
air_time_month <- rep(NA, length(month_list)) # Output

system.time(expr = {
  
  for(i in 1:length(month_list)){ # Iterate by month
    
    flights_filtered <- flights[flights$month == month_list[i],] # Subset by month
    air_time_month[i] <- sum(flights_filtered$air_time, na.rm = T) # Sum air time per month
    rm(flights_filtered)
    gc(reset = T)
    
  }
  rm(i, month_list)
  
})
air_time_month
# PLEASE LOOK THE NUMBER OF OBJECTS CREATED ON THE GLOBAL ENVIRONMENT



### lapply alternative

rm(list=setdiff(ls(), "flights"))

month_list <- 1:12 # Input

system.time(expr = {
  
  air_time_month <- unlist(lapply(1:length(month_list), function(i){
    
    flights_filtered <- flights[flights$month == month_list[i],] # Subset by month
    air_time_month <- sum(flights_filtered$air_time, na.rm = T) # Sum air time per month
    return(air_time_month)
    
  }))
  rm(month_list)
  
})
air_time_month <- data.frame(month = 1:12, air_time_month = air_time_month)
# PLEASE LOOK THE NUMBER OF OBJECTS CREATED ON THE GLOBAL ENVIRONMENT



### dplyr alternative

rm(list=setdiff(ls(), "flights"))

suppressMessages(library(dplyr))

system.time(expr = {
  
  air_time_month <- flights %>% group_by(month) %>% summarize(air_time_month = sum(air_time, na.rm = T))
  
})
# PLEASE LOOK THE NUMBER OF OBJECTS CREATED ON THE GLOBAL ENVIRONMENT
