palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
          "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))

shinyServer(function(input, output, session) {
  
  # Get My Results action button
  output$value <- renderPrint({ input$action })
  
  # will get this data
  colNames <- c('Index','Speed','Artist','Song Title','Tempo','Popularity')
  masterPlaylist <- read.table('Example.txt',sep='\t',skip=1,header=F,quote="",col.names=colNames)
  for(spd in c('slow','moderate','fast')){
    ind <- which(masterPlaylist$Speed==spd)
    masterPlaylist$Order[ind] <- 1:length(ind)
  }
  
  inputDifficulty <- reactive({
    input$difficulty
  })
  
  # Playlist Display - http://shiny.rstudio.com/gallery/datatables-options.html
  myOptions <- list(paging = FALSE, searching=FALSE)
  output$playlist <- renderDataTable({
    masterPlaylist[masterPlaylist$Speed==inputDifficulty(),c(7,3,4,6)]
    },
    options = myOptions)   
  
  # Pace plot
  tempo <- cumsum(rgamma(100,1,1))
  output$pacePlot <- renderPlot({
    par(mfrow=c(1,2))
    plot(tempo,type='l',xlab='Minutes',ylab='Pace', main='Your Pace')
    ind <- masterPlaylist$Speed==inputDifficulty()
    tempos <- masterPlaylist$Tempo[ind]
    barplot(tempos,xlab='??',ylab='Pace', main='Selected Playlist',col='blue', names.arg=1:length(tempos))
  }, height=300,width=600)
})