library(shiny)
library(Hmisc)
library(googleVis)
require(data.table)

validStates <- unlist(Cs(AL,AK,AZ,NM,AR,CA,MN,CO,CT,NY,DE,DC,VA,FL,GA,HI,ID,IL,IN,TN,MI,IA,KS,MO,KY,LA,ME,MD,MA,MS,MT,NE,NV,NH,NJ,NC,ND,OH,WV,OK,OR,PA,RI,SC,SD,TX,UT,VT,WA,WI,WY,AS,GU,MP,PR,FM,PW,VI,MH))
df <- read.csv("data/MERGED2013_PP_short.csv", na.strings = c("NULL", "PrivacySuppressed"))
df$SAT_MTVR_75 <- df$SATVR75 + df$SATMT75
      
shinyServer(
      function(input, output) {
            homeStateStr <- reactive ({
                  tmpStr <- toupper(substr(gsub("\\s", "", input$homestate), 1, 2))
                  ifelse(tmpStr %in% validStates, tmpStr, "INVALID")
            })
            output$homeState <- renderPrint(homeStateStr())
            
            tmplist <- reactive(unlist(strsplit(gsub("\\s", "", toupper(input$states)), ',')))
            listofstates <- reactive(
                  if(length(tmplist()) < 1)  validStates else tmplist()
                  )
            listofvalidstates <- reactive(listofstates()[listofstates() %in% validStates])
            listofprograms <- reactive(sapply(input$degree, function(x){paste(input$field,x,sep="")}))
            dfshort <- reactive({
                  selmatrix <- data.frame(df[,listofprograms()])
                  selunion <- apply(selmatrix,1,max)
                  program_filter <- ( (selunion > 0) & !is.na(selunion) & 
                                           (df$SAT_MTVR_75 < input$SAT) & 
                                           !is.na(df$SAT_MTVR_75) )
                  tdf <- df[program_filter,]
                  instate_filter <- ( (tdf$STABBR == homeStateStr()) &
                                            !is.na(tdf$TUITIONFEE_IN) &
                                            (tdf$TUITIONFEE_IN < input$TuitionInState) )
                  tmpdf <- data.frame(matrix(ncol = ncol(tdf), nrow = 0))
                  colnames(tmpdf) <- names(tdf)
                  if(sum(instate_filter) > 0) {
                        tmpdfinstate <- tdf[instate_filter,]
                        tmpdfinstate$Tuition <- tmpdfinstate$TUITIONFEE_IN
                        tmpdfinstate$InState <- 1
                        tmpdf <- tmpdfinstate
                  }
                  
                  outofstate_filter <- ( (tdf$STABBR %in% listofvalidstates()) &
                                              (tdf$STABBR != homeStateStr()) &
                                              !is.na(tdf$TUITIONFEE_OUT) &
                                              (tdf$TUITIONFEE_OUT < input$TuitionOutState))
                  if(sum(outofstate_filter) > 0) {
                        tmpdfoutofstate <- tdf[outofstate_filter,]
                        tmpdfoutofstate$Tuition <- tmpdfoutofstate$TUITIONFEE_OUT
                        tmpdfoutofstate$InState <- 0
                        tmpdf <- rbind(tmpdfoutofstate, tmpdf)
                  }
                  tmpdf$STABBR <- factor(tmpdf$STABBR)
                  tmpdf
            })
            
            output$numSchools <- reactive(nrow(dfshort()))
            dfmap <- reactive(dfshort()[!is.na(dfshort()$LATITUDE) & !is.na(dfshort()$LONGITUDE),])
            dfm <- reactive(data.frame(Lat = dfmap()$LATITUDE, Long = dfmap()$LONGITUDE, Tip = paste('<a href="http://', dfmap()$INSTURL,'">',dfmap()$INSTNM,"</a>",'<BR>',"SAT_75 = ",dfmap()$SAT_MTVR_75,'<BR>',"In State Tuition = ",dfmap()$TUITIONFEE_IN,'<BR>',"Out of State Tuition = ",dfmap()$TUITIONFEE_OUT,sep=''), LatLong = paste(dfmap()$LATITUDE, dfmap()$LONGITUDE, sep=":")))
            output$numSchoolswithLatLong <- reactive(nrow(dfm()))
            output$map1 <- renderGvis({
                  gvisMap(dfm(), "LatLong" , "Tip", options=list(showTip=TRUE, showLine=TRUE, enableScrollWheel=TRUE,mapType='hybrid', useMapTypeControl=TRUE,width=400,height=600))
            })
            output$states <- renderPrint(paste(listofstates(), collapse=":"))
            output$validstates <- renderPrint(paste(listofvalidstates(), collapse=":"))
            output$programs <- renderPrint(paste(listofprograms(), collapse=":"))
            output$histSATvsTut <- renderPlot({
                  plot(dfshort()$Tuition, dfshort()$SAT_MTVR_75, 
                                 col = dfshort()$STABBR,
                                 pch = 1 + 15*dfshort()$InState,
                                 main = "SAT vs. Tuition",
                                 xlab = "Tuition (Dollars)", 
                                 ylab = "SAT (math + reading) - 75th Percentile"
                       )
                  if (length(listofvalidstates()) < 10) {
                        legend(x='bottomright',legend=levels(dfshort()$STABBR), col=1:length(dfshort()$STABBR), lty=1)
                  }
            })
            output$info <- renderPrint({
                  dinfo <- dfshort()[,c( "STABBR", "SAT_MTVR_75", "Tuition",  "INSTNM")]
                  setnames(dinfo, old = c("SAT_MTVR_75", "STABBR"), new = c("SAT", "State"))
                  nearPoints(dinfo, input$plot_hover_SAT, xvar = "Tuition", yvar = "SAT")
            })
      }
)


