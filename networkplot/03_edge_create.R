options( java.parameters = "-Xmx4g" )
library(XLConnect)
library(plyr)

write_to_excel <- function(wbobj, sheetname, dataobj) {
  createSheet(wbobj, name=sheetname)
  writeWorksheet(wbobj, data=dataobj, sheet = sheetname, header = TRUE)
  setColumnWidth(wbobj, sheet = sheetname, column = 1:ncol(dataobj), width = -1) # Auto column width
}

wb = loadWorkbook("/home/smbk/Work/Test_data/CustomGraphs/NetworkPlot/Results/EG/EG_top20.xlsx")
nodes <- readWorksheet(wb, sheet="Node", header = TRUE)

combos <- sort(unique(na.omit(raw_data$NCombo)), decreasing = FALSE)

combo_trees <- list()
for (i in combos) {
  each_orders <- subset(nodes, nodes$NCombo == i)
  
  trees <- list()
  for (j in each_orders$Mutation) {
    each <- subset(nodes, grepl(j, Mutation))
    slno <- as.numeric(subset(each_orders, each_orders$Mutation == j, select=c("ID")))
    mut <- as.character(subset(each_orders, each_orders$Mutation == j, select=c("Mutation")))
    trees[[j]]  <- each
    trees[[j]]$Source <- slno
    trees[[j]]$From <- mut
  }
  final_each <- do.call(rbind, trees)

  combo_trees[[i]] <- final_each
}

edges <- do.call(rbind, combo_trees)
edges <- subset(edges, select = c("Source", "ID", "From", "Mutation", "HIF_Median", "NCombo"))

file <- '/home/smbk/Work/Test_data/CustomGraphs/NetworkPlot/Results/EG/EG_top20.xlsx'
wb <- loadWorkbook(file)
write_to_excel(wb, "Edges", edges)
saveWorkbook(wb)
xlcFreeMemory()


