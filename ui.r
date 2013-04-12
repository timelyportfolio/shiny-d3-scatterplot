#R and Shiny adaptation of http://bl.ocks.org/4063663

reactiveSvg <- function (outputId) 
{
  HTML(paste("<div id=\"", outputId, "\" class=\"shiny-network-output\"><svg /></div>", sep=""))
}


shinyUI(pageWithSidebar(
  headerPanel(title=HTML("Shiny and R adaptation of <a href = \"http://bl.ocks.org/4063663\">Mike Bostock's d3 Brushable Scatterplot</a>")),
  
  sidebarPanel(selectInput(inputId="selection",label="Select Funds",choices=sort(names(dat)[-(ncol(dat))]),multiple=TRUE),
              HTML("<br>"),
              "This example explores the relationship of various Vanguard Funds representing different exposures.  Using Mike Bostock's
               interactive d3 scatterplot example, we can more thorougly discover the relationships between these funds.  Try it out by highlighting 
               portions of the scatterplot.  To remove the selection just click outside of the selection box.",
               helpText(HTML("<br></br>Prices provided by Yahoo!Finance.<br></br>All source available on <a href = \"https://github.com/timelyportfolio/shiny-d3-scatterplot\">Github</a>"))
              ),
               
  mainPanel(
    includeHTML("scatterplot.js"),
    reactiveSvg(outputId = "scatterplot")
  )
  
  )
  
)