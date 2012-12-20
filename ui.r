#R and Shiny adaptation of http://bl.ocks.org/4063318

reactiveSvg <- function (outputId) 
{
  HTML(paste("<div id=\"", outputId, "\" class=\"shiny-network-output\"><svg /></div>", sep=""))
}


shinyUI(pageWithSidebar(
  headerPanel(title=HTML("Shiny and R adaptation of <a href = \"http://bl.ocks.org/4063318\">Mike Bostock's d3 Brushable Scatterplot</a>")),
  sidebarPanel(
               helpText(HTML("All source available on <a href = \"https://github.com/timelyportfolio/shiny-d3-scatterplot\">Github</a>"))
              ),
               
  mainPanel(
    includeHTML("scatterplot.js"),
    reactiveSvg(outputId = "scatterplot")
  )
  
  )
  
)