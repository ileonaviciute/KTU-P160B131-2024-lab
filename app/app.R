library(tidyverse)
library(ggplot2)
library(shiny)
ui <- fluidPage(
  titlePanel("Veiklos kodas 467300"),
  sidebarLayout(
    sidebarPanel(
      selectizeInput("Kodas",
                     "Pasirinkite įmonę",
                     choices=NULL)
    ),
    
    mainPanel(
      plotOutput("plot")
    )
  )
)

server <- function(input, output,session) {
  data<-read.csv("../data/467300.csv")
  names(data)=c("1","2","3","pavadinimas","5","6","7","Menesis","VidAtl","10","11","12","13")
  updateSelectizeInput(session,"Kodas",choices=data$pavadinimas,server=TRUE)
  output$plot<-renderPlot(
    data%>%
      filter(pavadinimas==input$Kodas)%>%
      ggplot(aes(x=ym(Menesis),y=VidAtl))+
      geom_point()+
      geom_line()+
      theme_classic()+labs(x="Menuo",y="Vidutinis atlyginimas")
  )
}


shinyApp(ui = ui, server = server)