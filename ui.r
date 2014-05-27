#R and Shiny adaptation of http://bl.ocks.org/4063663

reactiveSvg <- function (outputId) 
{
  HTML(paste("<div id=\"", outputId, "\" class=\"shiny-network-output\"><svg /></div>", sep=""))
}


shinyUI(
  fluidPage(
    titlePanel(title="Shiny / d3.js Scatterplot", windowTitle="Scatterplot"),
    fluidRow(
      checkboxInput(inputId='showsettings', value=TRUE, label=h3("Display Settings"))
    ),
    conditionalPanel(
      condition= "input.showsettings == true",
      fluidRow(
        column(2, fileInput('fileInput','Choose CSV File',accept=c('text/csv','text/comma-separated-values,text/plain'))),
        column(1, checkboxInput('header', 'Header', TRUE)),
        column(1, radioButtons('sep', 'Separator',c(Comma=',',Semicolon=';',Tab='\t'),',')),
        column(1, radioButtons('dec', 'Decimal', c(Comma=',', Point='.'), '.')),
        column(1, radioButtons('quote', 'Quote',c(None='','Double Quote'='"','Single Quote'="'"),'"')),
        column(6, selectInput('columnSelection', label="Columns to display", choices=colnames(mtcars), selected=colnames(mtcars)[1:4],multiple=TRUE))
        )
      ),
    fluidRow(
      column(6,
        includeHTML("scatterplot.js"),
        reactiveSvg(outputId = "scatterplot")),
      column(6,
        dataTableOutput(outputId="outputTable")
      )
    )
  )
)