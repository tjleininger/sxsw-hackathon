palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
          "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))
library(RCurl)
shinyServer(function(input, output, session) {
  
  # Get input bands from text input
#   output$artistsChosen <- renderText({ input$artists })
  
  
  colNames <- c('Artist','Song.Title','Dist','ISRC','Segment','Tempo')
  colNames2 <- c('Order','Artist','Song.Title','Tempo')
  
  emptyFlag <- TRUE
  emptyPlaylist <- read.table('empty_playlist.txt',sep='\t',header=F,quote="",skip=1,
      col.names=colNames2)
  
  # Get Artists
  getArtists <- reactive({ 
    input$artists
  })
  
  # Get My Results action button
  actionButton <- reactive({ 
    input$action 
  })
  
  # will get this data
  inputDifficulty <- reactive({
    input$difficulty
  })
  
  # Pace plot
  bpm <- read.csv('http://10.20.6.61:8080/getsteps',header=F)[-1,3]
  time.bpm <- seq(0,30,l=length(bpm))
  output$pacePlot <- renderPlot({
    par(mfrow=c(1,2))
    if(actionButton()>0){
      url2 <- paste('http://10.20.6.61:8080/getplaylist/',curlEscape(getArtists()),sep='')
      masterPlaylist <- read.table(url2,sep='\t',skip=1,
                                   header=F,quote="",col.names=colNames)
      masterPlaylist$Order <- 1:nrow(masterPlaylist)
      tempos <- masterPlaylist$Tempo
      ylim <- c(0, max(bpm,tempos))
      plot(time.bpm,bpm,type='l',xlab='Minutes', ylab='Pace', main='Your Pace',
           ylim=ylim, col='firebrick2',cex.lab=1.3, cex.main=1.8, lwd=2)
      barplot(tempos,xlab='Song Order',ylab='Tempo', main='Your Playlist',
          col=c('darkcyan','firebrick2','darkgoldenrod1'), names.arg=1:length(tempos),
          cex.lab=1.3, cex.main=1.8)
    } else {
      ylim <- c(0, max(bpm))
      plot(time.bpm,bpm,type='l',xlab='Minutes', ylab='Pace', main='Your Pace',
          ylim=ylim, col='firebrick2',cex.lab=1.3, cex.main=1.8, lwd=2)
      plot.new();
#       box(); title('Your Playlist',cex.main=1.8); 
#           mtext('Song Order',side=1,cex=1.3); mtext('Tempo',side=2,cex=1.3)
    }
  }, height=300,width=600)
  
  # Playlist Display - http://shiny.rstudio.com/gallery/datatables-options.html
  myOptions <- list(paging = FALSE, searching=FALSE)

getPlaylist <- function(action){
  if (actionButton()==0) {
    return(emptyPlaylist)
  } else {
    url2 <- paste('http://10.20.6.61:8080/getplaylist/',curlEscape(getArtists()),sep='')
    masterPlaylist <- read.table(url2,sep='\t',skip=1,
       header=F,quote="",col.names=colNames)
    masterPlaylist$Order <- 1:nrow(masterPlaylist)
    return(masterPlaylist[,c(7,1,2,6)])   
  }
}
output$playlist <- renderDataTable(getPlaylist(actionButton()), options = myOptions)


})