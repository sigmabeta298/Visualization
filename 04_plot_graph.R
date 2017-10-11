library(networkD3)
library(XLConnect)

wb <- loadWorkbook("/home/smbk/Work/Test_data/CustomGraphs/NetworkPlot/Results/EG/EG_full.xlsx")
nodes <- readWorksheet(wb, sheet="Node", startRow = 1, startCol = 1, header = TRUE)
links <- readWorksheet(wb, sheet="Edges", startRow = 1, startCol = 1, header = TRUE)

MyClickScript1 <- 'alert("Mutation ->  " + d.name  + "\\n" +
                         "HIF_Median -> " + d.hif);'
pctg <- function(s) { s / 5}
nodes$HIF_spc <- mapply(pctg, nodes$HIF_Median)
fn <- forceNetwork(Links = links, Nodes = nodes,
                   Source = "Source", Target = "ID", Value = "NCombo",
                   NodeID = "Mutation", linkDistance = JS('function(d){return d.value * 50;}'), #d.value * 50 for mannanase
                   Nodesize = "HIF_spc", Group = "NCombo", radiusCalculation = JS("d.nodesize+6"),
                   zoom = T, bounded = F, legend = T, clickAction = MyClickScript1,
                   opacity = 0.8,
                   fontSize = 16 )

fn$x$nodes$hif <- paste0(
  round(nodes$HIF_Median, digits = 2)
)
# View(fn$x$nodes)
fn

xlcFreeMemory()

