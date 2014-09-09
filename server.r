#max upload = 15 Mo
options(shiny.maxRequestSize = 15*1024^2)

shinyServer(function(input, output, session) {
  
  baseData <- reactiveValues()
  baseData$df <- mtcars
  
  observe({
    if (!is.null(input$fileInput)){
      updateColumns(session=session, columns="")
      baseData$df <- read.csv(file=input$fileInput$datapath, header=input$header, sep=input$sep, quote=input$quote, dec=input$dec, stringsAsFactor=FALSE, check.names=FALSE)
      updateColumns(session=session, columns=colnames(baseData$df[, sapply(baseData$df, is.numeric)]))
    }
  })
  
  
  output$scatterplot <- reactive({
    if (!is.null(input$columnSelection)){
      scatterData <- baseData$df
      scatterData <- as.matrix(scatterData[,input$columnSelection])
      maxPadding <- ceiling(log10(max(scatterData))) * 10
      return(list(scatterData, input$logscale, maxPadding))    
    } else {
     return()
    }    
  })
  
  output$outputTable <- renderDataTable({
    dfFilter <- input$mydata
    displayDF <- baseData$df
    displayDF <- as.data.frame(cbind(names=row.names(displayDF), displayDF))
    if (!is.null(displayDF)){
      if (is.null(dfFilter)){
        return(displayDF)
      } else {
        dfFilter[dfFilter==''] <- TRUE
        dfFilter[dfFilter=='greyed'] <- FALSE
        return(displayDF[dfFilter == TRUE,, drop=FALSE])
      }
    } else {
      return()
    }
    
  }, options = list(bPaginate = FALSE))


output$downloadTable <- downloadHandler(
  filename = "selectedData.csv",
  content = function(file) {
    dfFilter <- input$mydata
    displayDF <- baseData$df
    displayDF <- as.data.frame(cbind(names=row.names(displayDF), displayDF))
        dfFilter[dfFilter==''] <- TRUE
        dfFilter[dfFilter=='greyed'] <- FALSE
        write.table(x=(displayDF[dfFilter == TRUE,, drop=FALSE]),file=file, row.names=FALSE, fileEncoding="utf8", sep=",")
  }
)
})

updateColumns <- function(session, columns, selection=""){
  updateSelectInput(session=session, inputId="columnSelection", label="Columns to display", choices=as.vector(columns), selected=selection)
}