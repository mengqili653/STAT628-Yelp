#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tm)
library(wordcloud)
library(memoise)
library(DT)
library(tidyverse)
library(dplyr)
source("global.R")

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    # Define a reactive expression for the document term matrix
    terms <- reactive({
      validate(
        need(input$selection1 %in% mylist, "Please enter a valid shop name")
      )
        # Change when the "update" button is pressed...
        input$update1
        # ...but not for anything else
        isolate({
            withProgress({
                setProgress(message = "Processing corpus...")
                getTermMatrix(input$selection1)
            })
        })
    })
  
    # Make the wordcloud drawing predictable during a session
    wordcloud_rep <- repeatable(wordcloud)
    
    
    output$plot <- renderPlot({
      v <- terms()
      wordcloud_rep(names(v), v, scale=c(6,0.5),
                    min.freq = input$freq, max.words=input$max,
                    rot.per = input$rotation,
                    colors=brewer.pal(15, "Dark2"))
    }, width = 700,
    height = 700)
    
    
    terms2 <- reactive({
      validate(
        need(input$selection2 %in% mylist, "Please enter a valid shop name")
      )
      # Change when the "update" button is pressed...
      input$update2
      # ...but not for anything else
      isolate({
        withProgress({
          setProgress(message = "Processing data")
          sentiment %>% filter(name == input$selection2) %>%  distinct() %>% filter(score >= 5) %>% mutate(score = round(score, 1)) %>% arrange(desc(score, ratio))%>% select(word, score)
        })
      })
    })
    
    terms3 <- reactive({
      validate(
        need(input$selection2 %in% mylist, "Please enter a valid shop name")
      )
      # Change when the "update" button is pressed...
      input$update2
      # ...but not for anything else
      isolate({
        withProgress({
          setProgress(message = "Processing data")
          sentiment %>% filter(name == input$selection2) %>%  distinct() %>% filter(score < 5) %>% mutate(score = round(score, 1)) %>% arrange(score)%>% select(word, score)
        })
      })
    })
    
    output$view1 <- DT::renderDataTable({
      v <- terms2()
      DT::datatable(v)
    })
    
    output$view2 <- DT::renderDataTable({
      v <- terms3()
      DT::datatable(v)
    })
    
    
    
    output$text6 <- renderText({ 
      "The author and maintainer of this app is Chenhao Fang. Please contact throught cfang45@wisc.edu if you encountered any bugs." 
    })
    output$text7 <- renderText({ 
      "For source code of this app, please check https://github.com/mengqili653/STAT628-Yelp/tree/main/shiny " 
    })
})
    
    

