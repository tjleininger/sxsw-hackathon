textInput <- function (inputId, label, value = "", placeholder = NULL) 
{
  if (is.null(placeholder)) {
    tagList(label %AND% tags$label(label, `for` = inputId), tags$input(id = inputId, 
                                                                       type = "text", value = value))
  } else {
    tagList(label %AND% tags$label(label, `for` = inputId), tags$input(id = inputId, 
                                                                       type = "text", value = value, placeholder = placeholder))
  }
}

environment(textInput) <- environment(sliderInput)
shinyUI(fluidPage(theme = "bootstrap.css",
  headerPanel('Plan Your Run (by Micro Band)'),
  fluidRow(
      sidebarPanel(
        
        # Artist input
        textInput("artists", label = h4("Tell us some artists/bands you like"), 
                  value = "", placeholder = "Coldplay, U2")
        ,
#         textOutput("artistsChosen"),
        hr(),
        # action button
        actionButton("action", label = "Get recommendations"),        
        textOutput("value"),
        hr(),
        selectInput('difficulty', label='Select run difficulty',
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
    column(8, align="center",
      dataTableOutput(outputId="playlist")
    ),
    column(4,
      h2("Rdio player")
    )
  )
  
  
))