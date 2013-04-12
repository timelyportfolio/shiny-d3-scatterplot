#enter any requires/library here
require(PerformanceAnalytics)
require(lubridate)
data(edhec)

dat<-as.data.frame(edhec)
dat$Date<-ymd(row.names(dat))
row.names(dat)<-NULL
dat<-as.matrix(dat)

shinyServer(function(input, output) {
  #use the structure from trestletechnology example to load data
  choices <- reactive({
    dat[,c(input$selection,"Date")]
  })
  
  output$scatterplot <- reactive({ choices() })
})