
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
source("requests_plot.R")

request_types = c("Bulky Items", "Dead Animal Removal", "Graffiti Removal",
                  "Electronic Waste", "Illegal Dumping Pickup", "Other",
                  "Metal/Household Appliances", "Homeless Encampment",
                  "Single Streetlight Issue", 
                  "Multiple Streetlight Issue", "Feedback", "Report Water Waste")

server <- function(input, output) {
    
    rv = reactiveValues(type = request_types, 
                        time_start = "2015-08-01", 
                        time_end = "2016-11-30",
                        cd = c("city of LA"))
    
    # if we click the buttom
    observeEvent(input$button_geo, {
        rv$type = input$types
        rv$time_start = as.POSIXct(input$daterange[1])
        rv$time_end = as.POSIXct(input$daterange[2])
    }) 

    observeEvent(input$button_cd, {
        rv$cd = input$CD
    }) 
        
    output$plot <- renderPlot(zip_plot_customized(
        request_data, rv$type, rv$time_start, rv$time_end), height = 400, width = 500)

#     output$top_zip <- renderDataTable(
#         top_zip_list(request_data, rv$type, rv$time_start, rv$time_end),
#         option = list(pageLength = 10)
#     )
        
#       output$info <- renderPrint({
#           cat("Longitude: ", input$plot_click$x)
#           cat("\n")
#           cat("Lattidude: ", input$plot_click$y)
#           cat("\n")
#           paste0("ZipCode: ", location_to_zip(input$plot_click$x, input$plot_click$y))
#                   })
      
      output$table1 <- renderTable(cd_key_stats(CD_summary, cd = rv$cd), 
                                  align = "c", rownames = TRUE, colnames = TRUE)
      
      output$table2 <- renderTable(cd_top_requests(request_data, cd = rv$cd), 
                                   align = "c", rownames = TRUE, colnames = TRUE)
    
}