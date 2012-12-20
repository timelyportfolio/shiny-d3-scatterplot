#enter any requires/library here
require(quantmod)
#require(PerformanceAnalytics)

shinyServer(function(input, output) {
  #use the structure from trestletechnology example to load data
  data <- reactive(function(){
    getSymbols(c('VBMFX','VFINX','VDMIX','VEIEX'))
    #combine date from xts and coredata to get a data.frame in the format best for JSON pass in Shiny
    prices <- na.omit(merge(to.monthly(VBMFX)[,6],to.monthly(VFINX)[,6],to.monthly(VDMIX)[,6],to.monthly(VEIEX)[,6]))
    returns <- prices / lag(prices, k=1) - 1
    returns[1,] <- 0
    data <- cbind(coredata(returns),format(index(returns),"%Y-%m-%d"))
    #name columns same as the example
    colnames(data) <- c('VBMFX','VFINX','VDMIX','VEIEX','Date')
    data
  })
  
  output$scatterplot <- reactive(function() { data() })
})