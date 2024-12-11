required_libraries <- c("tcltk", "ggplot2", "dplyr")
not_installed <- required_libraries[!required_libraries %in% installed.packages()]

if (length(not_installed) > 0) {
  cat("Error: The following packages are not installed:", paste(not_installed, collapse = ", "), "\n")
  del(required_libraries, not_installed)
  stop("Execution halted due to missing packages.")
} else {
  remove(required_libraries, not_installed)
}



library(tcltk)
library(ggplot2)
library(dplyr)

ggsavex <- function() {
  
  window <- tktoplevel()
  tkwm.title(window, "ggsavex")
  
  info_label <- tklabel(window, text = "Specify parameters to save the plot. Leave blank to use defaults.\nIf you're not sure, just click the Save button at the bottom.", font = "Helvetica 10 bold")
  tkgrid(info_label, columnspan = 2, pady = 10)
  tcl("wm", "attributes", window, topmost = TRUE)
  tkfocus(window)
  
  labels <- list(
    "Filename (default: 'plot')",
    "Path (default: current working directory)",
    "Scale (default: 1)",
    "Width (default: 6 inches)",
    "Height (default: 4 inches)",
    "DPI (default: 400)",
    "Background Color (default: NULL)",
    "Compression (default: 'lzw' for TIFF)"
  )
  
  entries <- list()  # To hold entry fields
  
  for (i in seq_along(labels)) {
    lbl <- tklabel(window, text = labels[[i]])
    tkgrid(lbl, row = i + 1, column = 0, sticky = "w", padx = 5)
    
    entry <- tkentry(window, width = 30)
    tkgrid(entry, row = i + 1, column = 1, padx = 5, pady = 2)
    entries[[labels[[i]]]] <- entry
  }
  
  tklabel(window, text = "Device Type (default: png):") %>% tkgrid(row = length(labels) + 2, column = 0, sticky = "w", padx = 5)
  device_options <- c("png", "pdf", "jpeg", "tiff", "bmp", "svg", "eps", "wmf")
  device_choice <- tclVar("tiff")
  for (j in seq_along(device_options)) {
    tkgrid(tkradiobutton(window, text = device_options[j], variable = device_choice, value = device_options[j]),
           row = length(labels) + 2 + j, column = 1, sticky = "w", padx = 5)
  }
  
  tklabel(window, text = "Units (default: in):") %>% tkgrid(row = length(labels) + 10, column = 0, sticky = "w", padx = 5)
  units_options <- c("in", "cm", "mm", "px")
  units_choice <- tclVar("in")
  for (k in seq_along(units_options)) {
    tkgrid(tkradiobutton(window, text = units_options[k], variable = units_choice, value = units_options[k]),
           row = length(labels) + 10 + k, column = 1, sticky = "w", padx = 5)
  }
  
  limit_size <- tclVar("1")
  tkgrid(tkcheckbutton(window, text = "Limit Size to prevent dimensions over 50x50 inches (default: TRUE)", variable = limit_size),
         row = length(labels) + 15, columnspan = 2, sticky = "w", padx = 5)
  
  on_save <- function() {
    filename <- tclvalue(tkget(entries[["Filename (default: 'plot')"]]))
    path <- tclvalue(tkget(entries[["Path (default: current working directory)"]]))
    scale <- as.numeric(tclvalue(tkget(entries[["Scale (default: 1)"]])))
    width <- as.numeric(tclvalue(tkget(entries[["Width (default: 6 inches)"]])))
    height <- as.numeric(tclvalue(tkget(entries[["Height (default: 4 inches)"]])))
    dpi <- as.numeric(tclvalue(tkget(entries[["DPI (default: 400)"]])))
    bg <- tclvalue(tkget(entries[["Background Color (default: NULL)"]]))
    compression <- tclvalue(tkget(entries[["Compression (default: 'lzw' for TIFF)"]]))
    
    device <- tclvalue(device_choice)
    units <- tclvalue(units_choice)
    limitsize <- as.logical(as.integer(tclvalue(limit_size)))
    
    if (filename == "") filename <- "plot"
    if (device == "") device <- "png"
    if (is.na(scale)) scale <- 1
    if (is.na(width)) width <- 6
    if (is.na(height)) height <- 4
    if (units == "") units <- "in"
    if (is.na(dpi)) dpi <- 400
    if (bg == "") bg <- NULL
    
    final_filename <- paste0(filename, ".", device)
    if (path == "") {
      path <- getwd()
    }
    path <- normalizePath(path, winslash = "/", mustWork = FALSE)
    
    if (device == "tiff") {
      if (compression == "") compression <- "lzw"
      ggsave(filename = final_filename, plot = last_plot(), device = device, path = path,
             scale = scale, width = width, height = height, units = units,
             dpi = dpi, limitsize = limitsize, bg = bg, compression = compression)
    } else {
      ggsave(filename = final_filename, plot = last_plot(), device = device, path = path,
             scale = scale, width = width, height = height, units = units,
             dpi = dpi, limitsize = limitsize, bg = bg)
    }
    
    cat(paste("✔ Info from ggsavex:", "Plot saved successfully to", paste(path, "/", final_filename, sep = "")))
    
    tkdestroy(window)
  }
  
  
  # Add Save Button to run the ggsave command
  save_button <- tkbutton(window, text = "Save Plot", command = on_save, font = "Helvetica 10 bold")
  tkgrid(save_button, row = length(labels) + 16, columnspan = 2, pady = 10)
}

cat("✔ Successfully loaded ggsavex. \n   Example usage: ggsavex()")

