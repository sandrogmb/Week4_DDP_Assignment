require(shiny)
require(dplyr)
require(ggplot2)
#database kaggle cancer personlised medicine
train_var<-read.csv("training_variants")
train_var<-mutate(train_var, Class=as.factor(Class))

#genes identified in proteomes in breast cancer samples
proteome<-read.csv("PAM50_proteins.csv")
names(proteome)[1]<-"Gene"
#definisco i vettori con i deversi tipi di geni nei due db
a1<-levels(proteome$Gene)
b1<-levels(train_var$Gene)
c1<-(match(levels(proteome$Gene), levels(train_var$Gene)))
matchingGenes<-as.data.frame(b1[c1])
matchingGenes<-na.omit(matchingGenes)
names(matchingGenes)<-"Gene"


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
    # Return the requested dataset ----
    datasetInput <- reactive({
        switch(input$dataset,
               "Breast Cancer" = proteome,
               "Different Type of Cancers"= train_var,
               "Matching Genes"= matchingGenes)
    })
    
    output$df<-renderPrint({
        input$dataset
    })
    
    # Generate a summary of the dataset ----
    output$str <- renderPrint({
        dataset <- datasetInput()
        str(dataset)
        
    })
    
    output$summary <- renderPrint({
        dataset <- datasetInput()
        
        summary(dataset)
    })
    
    
    output$mytable1 <- renderTable({
        head(proteome, n = input$obs)
    })
    output$mytable2 <- renderTable({
        head(train_var, n = input$obs)
        
    })
    output$mytable3 <- renderTable({
        head(matchingGenes, n = input$obs)
    })
    
    output$Variations <- renderTable({
        train_var%>%filter(input$Gene==train_var$Gene)%>%select(Variation)
    })
    
    output$Classes <- renderTable({
        train_var%>%filter(input$Gene==train_var$Gene)%>%select(Class)
    })
  
})
