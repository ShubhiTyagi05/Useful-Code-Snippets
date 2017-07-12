library(ggmap)
# create vector of place names
Sys.setlocale(category = "LC_ALL", locale = "Polish")
options("encoding" = "native.enc")
places_names <- read.csv("Town3.csv",sep=",",encoding="Polish",stringsAsFactors=FALSE)

#  places_names<- read.csv("Town.csv",stringsAsFactors = FALSE,encoding = "UTF-8")
places_names<-as.vector(places_names$Complete)

# geocode place names
places_lat <- geocode(places_names, source="google")$lat
places_lon <- geocode(places_names, source="google")$lon

# create a data frame to store all variables
places_df <- data.frame(names = places_names,
                        lat = places_lat,
                        lon = places_lon)

#Write to CSV file
write.csv(places_df,"Lat-Lon-Address.csv")

# calculate geodesic distance with gdist() from Imap package

# load Imap
#install.packages("Imap")
library(Imap)

# create an empty list
dist_list <- list()

# iterate through data frame placing calculated distance next to place place names
for (i in 1:nrow(places_df)) {
  
  dist_list[[i]] <- gdist(lon.1 = places_df$lon[i], 
                          lat.1 = places_df$lat[i], 
                          lon.2 = places_df$lon, 
                          lat.2 = places_df$lat, 
                          units="km")
  
}

# view results as list
dist_list


#Extracting IDs for Colnames, Rownames
ids<- read.csv("ID.csv")
ids<- as.vector(ids$id)

# unlist results and convert to a "named" matrix format
dist_mat <- sapply(dist_list, unlist)

colnames(dist_mat) <- ids

rownames(dist_mat) <- ids

# view results as matrix
dist_mat

#Writing lat lon to file
write.csv(places_df,"Lat-Lon-CompleteAddress.csv")
write.csv(dist_mat,"Distance_Matrix-Town.csv")


#####
placee <- geocode("Plonsk",source = "google")
#Plotting coordinates on world map
library(rworldmap)
library(rworldxtra)
newmap <- getMap(resolution = "high")
plot(newmap, xlim = c(-20, 59), ylim = c(35, 71), asp = 1)
points(placee$lon, placee$lat, col = "red", cex = .6)
