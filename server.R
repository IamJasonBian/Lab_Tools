library(shiny)
library(rsconnect)


# Define server logic to read selected file ----
server <- function(input, output) {
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("Visualization-", Sys.Date(), ".html", sep="")
    },
    content = function(file) {
      # Close the file connection
      file.copy("test_success_8.html", file)
    },
    contentType = "html_output"
  )
  
  output$contents <- renderTable({
    
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, head of that data file by default,
    # or all rows if selected, will be shown.
    
    req(input$file1)
    
    # when reading semicolon separated files,
    # having a comma separator causes `read.csv` to error
    tryCatch(
      {
        df <- read.csv(input$file1$datapath,
                       header = input$header,
                       sep = input$sep,
                       quote = input$quote)
      },
      error = function(e) {
        # return a safeError if a parsing error occurs
        stop(safeError(e))
      }
    )
    
    if(input$disp == "head") {
      return(head(df))
    }
    else {
      return(df)
    }
    
  })
  
  get_data<-reactive({
  
    print("working get data")
    check<-function(x){is.null(x) || x==""}
    if(check(input$file1)) return()
    
    print(head(input$file1))
    obj<- read.csv(input$file1$datapath,
                                header = input$header,
                                sep = input$sep,
                                quote = input$quote)
    
    return(obj)
    
  })
  
  observeEvent(input$do, {
    
    xyz <- get_data()
    
    print(head(xyz))
    
    # Load the svgViewR package
    library(svgViewR)
    
    n_ID <- length(unique(xyz$eventID))
    ID_array <- unique(xyz$eventID)
    
    #List for each unique ID
    point_list <- vector(mode = "list", length = n_ID)
    
    #initialize arrays an of x, y, and z, for all eventIDs
    arr_x <- array(numeric())
    arr_y <- array(numeric())
    arr_z <- array(numeric())
    
    arr_size <- array(numeric())
    
    for(i in 1:n_ID){
      
      point_list[[i]] <- subset(xyz, eventID == ID_array[i])
      arr_size <- rbind(arr_size, nrow(point_list[[i]]))
      
      arr_x <- rbind(arr_x, point_list[[i]]$x[1])
      arr_y <- rbind(arr_y, point_list[[i]]$y[1])
      arr_z <- rbind(arr_z, point_list[[i]]$z[1])
    }
    
    #Create initial point cloud
    points3d <- cbind(arr_x, arr_y, arr_z)
    
    #Log initial point cloud
    print(head(points3d))
    
    # Set number of iterations
    n_iter <- max(arr_size)

    # Create animated point array
    points3da <- array(points3d, dim=c(dim(points3d), n_iter))
    

    
    # Expand points by time series
    for(iter in 0:(n_iter-1)){
      
      #initialize arrays an of x, y, and z, for all eventIDs
      arr_x <- array(numeric())
      arr_y <- array(numeric())
      arr_z <- array(numeric())
      
      for(i in 1:n_ID){
      arr_x <- rbind(arr_x, point_list[[i]]$x[iter])
      arr_y <- rbind(arr_y, point_list[[i]]$y[iter])
      arr_z <- rbind(arr_z, point_list[[i]]$z[iter])
      }
      
      points3da[, , iter] <- cbind(arr_x, arr_y, arr_z)
    }
    
    print(list.files())
    
    # Open a connection to .html file
    svg.new(file='test_success_8.html')
    
    
    # Add points to file
    svg.points(points3da, col="red")
    
    
    # Add coordinate axis planes around the points
    svg_frame <- svg.frame(points3da)
    
    svg.close(quiet = FALSE)
    print(list.files())
    browseURL("test_success_8.html")
    
  })
  
}