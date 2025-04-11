library(shiny)
library(jsonlite)
library(dplyr)
library(stringr)
library(DT)

ui <- fluidPage(
  titlePanel("DMPOnline Special category checker"),
  fileInput("jsonfile", "Upload a JSON File", accept = ".json"),
  DTOutput("matches")
)