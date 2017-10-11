library(networkD3)
library(XLConnect)
library(htmltools)

wb <- loadWorkbook("/home/smbk/screenz/Ad-HOC/AFU/step2.xlsx")
nodes <- readWorksheet(wb, sheet="Node", startRow = 1, startCol = 1, header = TRUE)
links <- readWorksheet(wb, sheet="Edges", startRow = 1, startCol = 1, header = TRUE)
xlcFreeMemory()

MyClickScript1 <- 'alert("Mutation ->  " + d.name  + "\\n" +
                         "HIF_Median -> " + d.hif);'

MyClickScript2 <- '
nodeClick(this);'

pctg <- function(s) { s * 10} # Divide for EG
nodes$HIF_spc <- mapply(pctg, nodes$HIF_Median)

spc_grp <- c(min(nodes$HIF_Median), max(nodes$HIF_Median))
nodes$group <- ifelse(nodes$HIF_Median %in% spc_grp, "Min/Max", nodes$NCombo)
fn <- forceNetwork(Links = links, Nodes = nodes,
                   Source = "Source", Target = "ID", Value = "NCombo",
                   NodeID = "Mutation", linkDistance = JS('function(d){return d.value * 50;}'), #d.value * 50 for mannanase
                   Nodesize = "HIF_spc", Group = "group", radiusCalculation = JS("d.nodesize+6"),
                   zoom = T, bounded = F, legend = T, clickAction = 'nodeClick(d.name);',
                   opacity = 0.8,
                   fontSize = 16,
                   width = 1600, height = 1200
                   )

fn$x$nodes$hif <- paste0(
  round(nodes$HIF_Median, digits = 2)
)

fn$x$nodes$ncombo <- nodes$NCombo
fn$nodes$group <- nodes$group



# ColourScale <- 'd3.scale.()
#             .domain(["special"])
#            .range(["black"]);'

browsable(
    tagList(
      tags$head(
        tags$link(
          href="http://code.jquery.com/ui/1.11.0/themes/smoothness/jquery-ui.css",
          rel="stylesheet"
        )
      ),
      HTML(
        '<script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
        <script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
        <style type="text/css">
          #modal {
              position:fixed;
              left:150px;
              top:20px;
              z-index:1;
              background: white;
              border: 1px black solid;
              box-shadow: 10px 10px 5px #888888;
              display: none;
          }
            
          #content {
              max-height: 400px;
              overflow: auto;
          }
            
          #modalClose {
              position: absolute;
              top: -0px;
              right: -0px;
              z-index: 1;
          }
        </style>

        <script type="text/javascript">
          function closeButton() {
            d3.select("#modal").style("display","none");
          }
        </script>

        <div class="ui-widget">
          <input id="search">
          <button type="button">Search</button>
           HIF
          <select id="hif-comp">
            <option value="lt"><</option>
            <option value="gt">></option>
          </select>
          <input id="hif">
          <button type="button" id="smartSearch">SmartSearch</button>
        </div>
      
         
        
        <div id="modal">
          <div id="content"></div>
          <button id="modalClose" onclick="closeButton();">X</button>
        </div>
        '   
      ),
      fn
    )

)




