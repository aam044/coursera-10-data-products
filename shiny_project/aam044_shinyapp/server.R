#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
require(ggplot2)
require(readr)
library(shiny)
library(readr)
library(ggplot2)

cpi_data <- read_tsv(
    file="http://download.bls.gov/pub/time.series/cu/cu.data.1.AllItems",
    skip=0)

cpi_data<-cpi_data[cpi_data$series_id=='CUSR0000SA0',]

# Define server logic required to draw a plots
shinyServer(function(input, output) {
   
  output$distPlot <- renderPlot({
      minyear <- input$year[1]
      maxyear <- input$year[2]    

      if (input$type == 'Year over Year')
      {
          df <- cpi_data[cpi_data$period=='M12' & cpi_data$year>=minyear & cpi_data$year<=maxyear,]
          coeff <- 1
      }
      
      if (input$type == 'Month over Month')
      {
          df <- cpi_data[cpi_data$year>=minyear & cpi_data$year<=maxyear,]
          df$year <- df$year*100+ as.numeric(substr(df$period,2,3))*100/13
          coeff <- 100
      }
      
            
    p <- ggplot( data = df, aes_string( "year", "value" )) + 
        geom_point() +
        labs(title = "Consumer Price Indexes History", x = "Time", y = "Consumer Price Index") 
    
    if (input$cpi_lm)
    {
        p <- p + geom_smooth(color="red", span=3)
    }

    if (round((maxyear-minyear)/20,0)==0)
    {
        npoints <- max(maxyear-minyear,1)
    }
    else
    {
        npoints <- 20
    }
    p <- p + scale_y_continuous(breaks = round( seq(min(df$value),max(df$value), by = round((-min(df$value)+max(df$value))/20,1)),1)) 
    p <- p + scale_x_continuous(breaks = round(seq(minyear,maxyear, by = round((maxyear-minyear)/npoints,0))*coeff,1), labels=round(seq(minyear,maxyear, by = round((maxyear-minyear)/npoints,0)),1)) 
    
    print(p)
    
    
  })

  output$inflationPlot <- renderPlot({
      
      # generate bins based on input$bins from ui.R
      #cpi_data$inflation <- diff(cpi_data$value)*100/cpi_data$value
      minyear <- input$year[1]
      maxyear <- input$year[2] 
      if (input$type_inflation == 'Year over Year')
      {
          df <- cpi_data[cpi_data$period=='M12' & cpi_data$year>=minyear & cpi_data$year<=maxyear,]
          coeff <- 1
      }

      if (input$type_inflation == 'Month over Month')
      {
          df <- cpi_data[cpi_data$year>=minyear & cpi_data$year<=maxyear,]
          df$year <- df$year*100+ as.numeric(substr(df$period,2,3))*100/13
          coeff <- 100
      }
      
    df$inflation <- append(0.00, 100*(tail(df$value, -1) - head(df$value, -1))/head(df$value, -1))

      #cpi_data$inflation <- ave(cpi_data$value, cpi_data$year, FUN = function(x) 100*(1 - x/x[1]))
      p <- ggplot( data = df, aes_string( "year", "inflation" )) + 
          geom_point() +
          labs(title = "Inflation rate", x = "Time", y = "Percent")  

    if (input$inflation_lm)
      {
          p <- p + geom_smooth()
      }
      #p <- p + geom_smooth(method=lm)
      p <- p + geom_hline(yintercept=0, color="black") 

      if (round((maxyear-minyear)/20,0)==0)
      {
          npoints <- max(maxyear-minyear,1)
      }
      else
      {
          npoints <- 20
      }
      
      p <- p + scale_y_continuous(breaks = round( seq(min(df$inflation),max(df$inflation), by = round((-min(df$inflation)+max(df$inflation))/20,1)),1)) 
      p <- p + scale_x_continuous(breaks = round(seq(minyear,maxyear, by = round((maxyear-minyear)/npoints,0))*coeff,1), labels=round(seq(minyear,maxyear, by = round((maxyear-minyear)/npoints,0)),1)) 
      
      p
  })
  
})
