#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)

data = read.csv("../../Data/word_cloud.csv",header = T, sep = ",", row.names = 1)
names = as.vector(data$name, mode = 'character')
mylist = as.list(data$name)
names(mylist) = data$name

    
# Define UI for application that draws a histogram
shinyUI(
    fluidPage(theme = shinytheme("spacelab"), navbarPage("STAT628 Module 3",   
                         
     # Application title                         
    tabPanel('Word Cloud', icon = icon("cloud"),   
        # Sidebar with a slider input for number of bins
        sidebarLayout(
            sidebarPanel(
                selectizeInput("selection", 
                            "Please select or enter your business name:",
                            choices = mylist,
                            selected = "Nora",
                            options = NULL),
                actionButton("update", "Change"),
                sliderInput("freq",
                            "Minimum Frequency:",
                            min = 1,  max = 50, value = 15),
                sliderInput("max",
                            "Maximum Number of Words:",
                            min = 1,  max = 300,  value = 100)
            ),
            # Show a plot of the generated distribution
            mainPanel(
                plotOutput("plot")
            )
        )
    ),
    
    tabPanel("User Feedback", icon = icon("heart"),   
             
    ),
    
    tabPanel("Contact Info", icon = icon("id-card"),   
             
    )
)))
