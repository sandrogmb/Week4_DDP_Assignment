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




# Define UI for application that draws a histogram
shinyUI(fluidPage(
    # App title ----
    titlePanel("Genetic mutations in breast cancer"),
    p("This app allows to know which mutations are present in certain genes expressed in 
      a set of breast cancer samples."),
    p("In the table \"Breast Cancer\", we find which genes are expressed in breast cancer samples."),
    p("In the table \"Different Type of Cancers\", we find which mutations are present more frequently in certain genes in different
      kind of cancers."),
    p("In the third panel \"Matching Genes\", we can see which mutations are present in genes more frequently associated 
      with breast cancer  and their clinical classification in a scale between 1 and 9."),
    
    # Sidebar layout with a input and output definitions ----
    sidebarLayout(
        # Sidebar panel for inputs ----
        sidebarPanel(
            numericInput(inputId = "obs",
                         label = "Number of observations to view:",
                         value = 5)
        ),
        # Main panel for displaying outputs ----
        mainPanel(
            fluidRow(
                column(8, h4("Select a dataset:"))
            ),
            tabsetPanel(
                id = 'dataset',
                tabPanel("Breast Cancer", 
                         p("A list of genes and corresponding proteins
                           expressed in breast cancer. 
                           The column RefSeqProteinID contains the protein IDs."),
                         tableOutput("mytable1")),
                tabPanel("Different Type of Cancers", 
                         p("Dataset containing the description of the genetic mutations
                           that are present in different type of cancers.
                           \"Gene\" is the gene where this genetic mutation is located.
                           \"Variation\" is the aminoacid change for this mutations.
                           \"Class\" 1-9 the class this genetic mutation has been classified on"),
                         tableOutput("mytable2")),
                tabPanel("Matching Genes", 
                         p("Table that identifies which breast cancer genes are present in the other  
                           dataset \"Different Type of Cancers\"."), 
                         
                         p("At the bottom of this page, for each of this gene,
                           you can see its associated mutations and its clinical
                           classification (class 1-9)"),
                         tableOutput("mytable3"))
                )
            
                )
                ),
    
    ###############################
    
    fluidRow(
        column(3,
               h4("Dataset selected:")
        ),
        column(4,
               verbatimTextOutput("df")
        )    
    ),
    
    fluidRow(
        column(2,
               h5("Exploring data:")
        ) 
    ),
    
    fluidRow(
        column(12,
               # Output: Verbatim text for data summary ----
               verbatimTextOutput("str"),
               verbatimTextOutput("summary")
        )
    ),
    
    ##############################
    
    fluidRow(
        column(3,
               hr(),
               selectInput("Gene", "Choose a gene:",
                           choices = matchingGenes$Gene, selectize = FALSE)
               
        ),
        column(3,
               hr(),
               tableOutput("Variations")
        ),
        column(3,
               hr(),
               tableOutput("Classes")
        )
    )
            )
    
    
    
)
