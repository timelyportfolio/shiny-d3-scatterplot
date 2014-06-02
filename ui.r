#R and Shiny adaptation of http://bl.ocks.org/4063663

reactiveSvg <- function (outputId) 
{
  HTML(paste("<div id=\"", outputId, "\" class=\"shiny-scatterplot-output\"><svg /></div>", sep=""))
}


shinyUI(
  fluidPage(theme = "simplex.bootstrap.min.css",
    tags$head(tags$link(rel = "icon", type = "image/png", href = "favicon.png")),

    fluidRow(
      column(1,
             titlePanel(title=h1("ScattRplot"), windowTitle="ScattRplot")
             ),
      column(width=1, offset=10,
             tags$img(src="logoUMR_fdbleu_cadretransparent.png", width="150px",  style="padding:10px;")
      )
    ),
    fluidRow(
      checkboxInput(inputId='showsettings', value=TRUE, label=h4("Display Settings"))
    ),
    conditionalPanel(
      condition= "input.showsettings == true",
      fluidRow(
        column(2, fileInput('fileInput','Choose CSV File',multiple=FALSE)),
        column(1, checkboxInput('header', 'Header', TRUE)),
        column(1, radioButtons('sep', 'Separator',c(Comma=',',Semicolon=';',Tab='\t'),',')),
        column(1, radioButtons('dec', 'Decimal', c(Comma=',', Point='.'), '.')),
        column(1, radioButtons('quote', 'Quote',c(None='','Double Quote'='"','Single Quote'="'"),'"')),
        column(6, selectInput('columnSelection', label="Columns to display", choices=colnames(mtcars), selected=colnames(mtcars)[1:4],multiple=TRUE))
        ),
      fluidRow(column(2, checkboxInput(inputId="logscale", label="Log scale ?", value=FALSE)))
      ),
    fluidRow(
      column(6,
        includeHTML("scatterplot.js"),
        reactiveSvg(outputId = "scatterplot")),
      column(6,
        dataTableOutput(outputId="outputTable"),
        downloadButton(outputId='downloadTable', label='Download selection')
      )
    ),
    fluidRow(
      column(12,
             HTML("Created by <a href=\"http://www.parisgeo.cnrs.fr/spip.php?article6416&lang=en\">Robin Cura</a>, for the <a href=\"http://www.parisgeo.cnrs.fr\">UMR Géographie-cités</a>"),
             tags$br(),
             HTML("Published under <a href=\"http://www.gnu.org/licenses/agpl-3.0.html\">A-GPL v3 licence</a>. Code available on <a href=\"https://github.com/RCura/ScattRplot\">Github</a>")
             )
    )
  )
)