palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
          "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))
library(RCurl)
shinyServer(function(input, output, session) {
  
  # Get input bands from text input
#   output$artistsChosen <- renderText({ input$artists })
  
  # Get My Results action button
  output$value <- renderText({ 
    input$action 
    # read from read.csv('http://10.21.14.157:8080/getcsv')
    # and read.csv('http://10.21.14.157:8080/getplaylist/band1,band2')
  })
  
  
  emptyFlag <- TRUE
  emptyPlaylist <- read.table('empty_playlist.txt',sep='\t',skip=1,header=F,quote="",col.names=colNames)
  
  myCSV <- reactive({
    colNames <- c('Index','Speed','Artist','Song Title','Tempo','Popularity')
    if(input$action>0){
      emptyFlag <- FALSE
      masterPlaylist <- read.table('Example.txt',sep='\t',skip=1,
        header=F,quote="",col.names=colNames)
      for(spd in c('slow','moderate','fast')){
        ind <- which(masterPlaylist$Speed==spd)
        masterPlaylist$Order[ind] <- 1:length(ind)
      }      
    } else {
      emptyFlag <- TRUE
      emptyPlaylist <- read.table('empty_playlist.txt',sep='\t',skip=1,header=F,quote="",col.names=colNames)
    }
  })
  
  # will get this data
  
  inputDifficulty <- reactive({
    input$difficulty
  })
  
  # Playlist Display - http://shiny.rstudio.com/gallery/datatables-options.html
  myOptions <- list(paging = FALSE, searching=FALSE)
  if (emptyFlag) {
    output$playlist <- renderDataTable({
      emptyPlaylist[,c(7,3,4,6)]
    }, options = myOptions)
  } else {
    output$playlist <- renderDataTable({
      masterPlaylist[masterPlaylist$Speed==inputDifficulty(),c(7,3,4,6)]
    }, options = myOptions)   
  }
  # Pace plot
  cadence <- cumsum(rgamma(100,1,1))
  output$pacePlot <- renderPlot({
    par(mfrow=c(1,2))
    ind <- masterPlaylist$Speed==inputDifficulty()
    tempos <- masterPlaylist$Tempo[ind]
    ylim <- c(0, max(cadence,tempos))
    plot(cadence,type='l',xlab='Minutes',ylab='Pace', main='Your Pace', ylim=ylim)
    barplot(tempos,xlab='Song Order',ylab='Tempo', main='Selected Playlist',col=c('red','yellow'),
            names.arg=1:length(tempos))
  }, height=300,width=600)
})