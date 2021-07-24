library(shiny)
library(rsconnect)

# Define UI for data upload app ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("3D Spatial Visualization"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Select a file ----
      fileInput("file1", "Choose CSV File",
                multiple = FALSE,
                accept = c("text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv")),
      
      # Horizontal line ----
      tags$hr(),
      
      # Input: Checkbox if file has header ----
      checkboxInput("header", "Header", TRUE),
      
      # Input: Select separator ----
      radioButtons("sep", "Separator",
                   choices = c(Comma = ",",
                               Semicolon = ";",
                               Tab = "\t"),
                   selected = ","),
      
      # Input: Select quotes ----
      radioButtons("quote", "Quote",
                   choices = c(None = "",
                               "Double Quote" = '"',
                               "Single Quote" = "'"),
                   selected = '"'),
      
      # Horizontal line ----
      tags$hr(),
      
      # Input: Select number of rows to display ----
      radioButtons("disp", "Display",
                   choices = c(Head = "head",
                               All = "all"),
                   selected = "head"),
      
      tags$hr(),
      
      tags$p("Click Generate Visualization and then Download for a 3d Animation in html. Input files should be an csv file, sorted by time for each row, with the columns 'eventID', 'x', 'y', 'z'."),
      
      # Horizontal line ----
      tags$hr(),
      
      actionButton("do", "Generate Visualization"),
      
      # Button
      downloadButton("downloadData", label = "Download")
      
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Data file ----
      tableOutput("contents")
      
      #includeHTML('test_success_8.html')
      
    )
    
  )
)

