#enter any requires/library here


shinyServer(function(input, output, session) {
  
  baseData <- reactiveValues()
  baseData$df <- mtcars
  #updateColumns(session=session, columns=baseData$df, selection=colnames(baseData$df))
  
  observe({
    if (!is.null(input$fileInput)){
      baseData$df <- read.csv(file=input$fileInput$datapath, header=input$header, sep=input$sep, quote=input$quote, dec=input$dec, stringsAsFactor=FALSE)
      updateColumns(session=session, columns=baseData$df[, sapply(baseData$df, is.numeric)], selection="")
    }
  })
  
  
  output$scatterplot <- reactive({
    scatterData <- baseData$df
    print("Here we are !")
    print(input$columnSelection)
    scatterData <- as.matrix(scatterData[,input$columnSelection])
    #scatterData <- as.matrix(scatterData[, 1:4])
    return(scatterData)
    })
  
  output$outputTable <- renderDataTable({
    dfFilter <- input$mydata
    print(dfFilter)
    displayDF <- baseData$df
    print(str(displayDF))
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
})

updateColumns <- function(session, columns, selection=""){
  #print(columns)
  updateSelectInput(session=session, inputId="columnselection", label="Columns to display", choices=columns, selected=selection)
}