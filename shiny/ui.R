shinyUI(fluidPage(theme = "bootstrap.css",
  headerPanel('Witty Title (by Micro Band)'),
  fluidRow(
      sidebarPanel(
        # Copy the line below to make an action button
        actionButton("action", label = "Get My Results"),
        hr(),
        selectInput('difficulty', label='Select Run Difficulty',
                    choices=list('Slow'='slow','Moderate'='moderate','Fast'='fast'),
                    selected='moderate')
      )
      
      , mainPanel(
        plotOutput('pacePlot')
      )
  ),
  
  fluidRow(
    # add player here
    
  ),
  
  fluidRow(
    # show playlist here
    mainPanel(
      dataTableOutput(outputId="playlist")
    )
  )
  
  
))