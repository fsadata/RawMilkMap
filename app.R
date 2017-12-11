# Raw milk producers - updated with NI boundaries

# Current version

library(leaflet)
library(shiny)
library(dplyr)
library(tmap)
library(tmaptools)
library(rgdal)

ui <- fluidPage(
  titlePanel("Raw Milk Producers in the UK"),
  leafletOutput("rawmilkmap", height = 800, width= 600),
  p('This map was made by the data science team (datascience@food.gov.uk)', style='font-size: 80%')
)

rawmilkdata <- read.csv("Raw Milk ProducersUpdated 8_12_17.csv")
laboundarieswithNI <- readOGR("Local_Authority_Districts_December_2016_Super_Generalised_Clipped_Boundaries_in_the_UK.shp")
laboundarieswithNI <- spTransform(laboundarieswithNI, CRS("+init=epsg:4326"))

server <- function(input, output){
  
  output$rawmilkmap <- renderLeaflet({
    rawmilkmap <- leaflet(data = rawmilkdata) %>%
      setView(lng = -2.9616976, lat = 54.415864, zoom = 6) %>%
      addTiles() %>%
      addPolygons(data = laboundarieswithNI, color = "black", weight = 1, smoothFactor = 0.5,
                  opacity = 0.5, fillOpacity = 0, popup = laboundarieswithNI@data$lad16nm,
                  highlightOptions = highlightOptions(color = "navy", weight = 2, bringToFront = FALSE)) %>%
      addCircleMarkers(
        radius = 6,
        color = "red",
        stroke = FALSE, fillOpacity = 1,
        label = ~as.character(Name)
      )
  })
  options(shiny.sanitize.errors = FALSE)
}

shinyApp(ui = ui, server = server)
