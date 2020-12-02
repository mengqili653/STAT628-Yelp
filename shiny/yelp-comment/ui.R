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
library(memoise)
source("global.R")

    
# Define UI for application that draws a histogram
shinyUI(
    fluidPage(theme = shinytheme("spacelab"), navbarPage("STAT628 Module 3",   
                         
     # Application title                         
    tabPanel('Word Cloud', icon = icon("cloud"),   
        # Sidebar with a slider input for number of bins
        sidebarLayout(
            sidebarPanel(
                selectizeInput("selection1", 
                            "Please select or enter your business name:",
                            choices = mylist,
                            selected = "Nora",
                            options = NULL),
                actionButton("update1", "Change"),
                hr(),
                sliderInput("freq",
                            "Minimum Frequency:",
                            min = 1,  max = 50, value = 15),
                sliderInput("max",
                            "Maximum Number of Words:",
                            min = 1,  max = 300,  value = 100),
                sliderInput("rotation", "Rotation:",
                            min = 0.0, max = 1.0, value = 0.35),
            ),
            # Show a plot of the generated distribution
            mainPanel(
                plotOutput("plot")
            )
        )
    ),
    
    tabPanel("User Feedback", icon = icon("heart"),   
         sidebarLayout(
           sidebarPanel(
             selectizeInput("selection2", 
                            "Please select or enter your business name:",
                            choices = mylist,
                            selected = "Nora",
                            options = ),
             hr(),
             actionButton("update2", "Change"),
           ),
           # Show a plot of the generated distribution
           mainPanel(
             h3("What customers like in your bakery"),
             DT::dataTableOutput("view1"),
             h3("What you should improve in your bakery"),
             DT::dataTableOutput("view2"),
           )
         )
             
    ),
    
    tabPanel("Contact Info", icon = icon("id-card"),   
             textOutput("text6"),
             textOutput("text7"),
    )
)))
