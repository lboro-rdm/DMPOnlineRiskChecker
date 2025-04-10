library(shiny)
library(jsonlite)
library(dplyr)
library(stringr)
library(DT)

ui <- fluidPage(
  titlePanel("Special Category Data Scanner"),
  fileInput("jsonfile", "Upload a JSON File", accept = ".json"),
  DTOutput("matches")
)