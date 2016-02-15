#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("The Consumer Price Index and Inflation in USA"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
        helpText("Shows historical Consumer Price Index as well as Inflation rate based on ", 
        a(href="http://www.bls.gov/cpi/data.htm", "Bureau of Labor Statistics"), ".",
        "Data downloaded in realtime"),
        checkboxInput('showPanel0', 'Show details on app', FALSE),
        conditionalPanel(condition = 'input.showPanel0',
                         wellPanel(
                             h5("About app"),
                             helpText("This app allow you quickly visualize Consumer Price Index (", strong("CPI"), ") data available from Bureau of Labor Statistics",
                                      "It is also calculate inflation rate based on CPI.",
                                      "You have ability to see inflation rate as well as CPI year over year or month over month",
                                      "Ability to caclulate regression and draw regression line with standard error"),
                             h5("About Caclulating inflation"),
                             helpText("Inflation calculated as following:",br(),
                                      "inf% = 100*( (CPI[end_of_period]/CPI[start_of_period]) - 1)"),
                             h5("About Data Freshness"),
                             helpText("Data published on 20th of each months. App automatically download data from BLS site"
                             ),
                             h5("References"),
                             helpText("[1]", a(href="http://www.bls.gov/cpi/data.htm", "Bureau of Labor Statistics"), br(),
                                      "[2]", a(href="http://www.bls.gov/data/inflation_calculator.htm", "Inflation Calculator"), br(),
                                      "[3]", a(href="http://www.bls.gov/cpi/factsheets.htm", "Consumer Price Index Factsheet")
                             ))),
                         sliderInput("year", "Select years range", 1947, 2016, value = c(1980, 2016)),
        helpText("Full range of data available is 1947-present day"), 
        
        checkboxInput('showPanel1',  'Show help on filter', FALSE),
        conditionalPanel(condition = 'input.showPanel1',
                         wellPanel(
                             h5("Level of details"),
                             helpText(strong("Year over Year")," - Pickup only December data for each year in range"), 
                             helpText(strong("Month over Month")," - Pickup monthly data"),
                             h5("Regression line"),
                             helpText("If checked - appropriate regression model is calculated and line with standard error range will be ploted")
                         )
        ),
        selectInput("type", 
                    label = "Choose a level of details to display for CPI",
                    choices = c("Year over Year", "Month over Month"),
                    selected = "Year over Year"),
        
        checkboxInput(inputId = "cpi_lm",
                      label = strong("Show CPI regression line"),
                      value = FALSE),
        
        selectInput("type_inflation", 
                    label = "Choose a level of details to display for Inflation",
                    choices = c("Year over Year", "Month over Month"),
                    selected = "Month over Month"),
        checkboxInput(inputId = "inflation_lm",
                      label = strong("Show inflation regression line"),
                      value = FALSE)
    ),

    
        
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("distPlot"),
       plotOutput("inflationPlot")
    )
  )
))
