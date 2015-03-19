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
  headerPanel('Playlists For Your Run (by Micro Band)'),
  fluidRow(
      sidebarPanel(
        
        # Artist input
        textInput("artists", label = h4("Tell us some artists you like"), 
                  value = "", placeholder = "Coldplay, U2")
        ,
#         textOutput("artistsChosen"),
        h3(''),
        # action button
        actionButton("action", label = "Get recommendations")
# ,        
#         textOutput("value"),
#         hr(),
#         selectInput('difficulty', label='Select run difficulty',
#                     choices=list('Slow'='slow','Moderate'='moderate','Fast'='fast'),
#                     selected='moderate')
      )
      
      , mainPanel(
        plotOutput('pacePlot')
      )
  ),
  
  fluidRow(
    # add player here
    
  ),
  fluidRow(
    column(1),
    column(10,h3('Your suggested playlist:')),
    column(1)
    ),
  fluidRow(
    column(8, align="center",
      dataTableOutput(outputId="playlist")
    ),
    column(4,
       strong("Preview with  "),
       img(src = "http://upload.wikimedia.org/wikipedia/commons/4/4b/Rdio.svg", 
           height = 48, width = 48),
       p('Coming in version 2.0!')
    )
  ),


  fluidRow(
    column(12,
      "Powered by    ",
      img(src = "http://www.microsoft.com/microsoft-band/assets/img/ms-band-logo.png?v=031815", 
          height = 30),
      "                 ",
      img(src = "http://mms.businesswire.com/media/20140312005920/en/407064/21/MusicGraph_logo_BW.jpg", 
          height = 120)
#       , "              "
#       , img(src = "http://upload.wikimedia.org/wikipedia/commons/4/4b/Rdio.svg", 
#           height = 32)
      )
    )
  
  
))