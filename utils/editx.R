editx <- function(data) {
  
  temp_dir <- file.path(getwd(), "editx_temp")
  if (!dir.exists(temp_dir)) dir.create(temp_dir)
  temp_file <- file.path(temp_dir, "temp_edit.xlsx")
  
  if (is.null(rownames(data)) || all(rownames(data) == "")) {
    rownames(data) <- seq_len(nrow(data))
  }
  
  data_with_row_names <- data.frame(Row_Names = rownames(data), data, check.names = FALSE)
  write.xlsx(data_with_row_names, temp_file)
  
  edited_data <- NULL
  
  window <- tktoplevel()
  tkwm.title(window, "editx")
  tcl("wm", "attributes", window, topmost = TRUE)
  tkfocus(window)
  
  info_label <- tklabel(window, text = "Edit&save in Excel and click 'Done Edit' to save changes.\n\nClearing the contents of Row_Names column\ncauses row names to be regenerated to default values.", font = "Helvetica 10 bold")
  tkgrid(info_label, pady = 10)
  
  on_start_edit <- function() {
    browseURL(temp_file)
  }
  
  on_done_edit <- function() {
    edited_data <<- read.xlsx(temp_file)
    
    if ("Row_Names" %in% colnames(edited_data)) {
      if (all(is.na(edited_data$Row_Names)) || all(edited_data$Row_Names == "")) {
        rownames(edited_data) <<- seq_len(nrow(edited_data))
      } else {
        rownames(edited_data) <<- edited_data$Row_Names
      }
      edited_data <<- edited_data[, -1, drop = FALSE]
    } else {
      rownames(edited_data) <<- NULL
    }
    
    tkdestroy(window)
  }
  
  start_button <- tkbutton(window, text = "Start Edit", command = on_start_edit, font = "Helvetica 10 bold")
  done_button <- tkbutton(window, text = "Done Edit", command = on_done_edit, font = "Helvetica 10 bold")
  
  tkgrid(start_button, pady = 5)
  tkgrid(done_button, pady = 5)
  
  tkwait.window(window)
  return(edited_data)
}

cat("✔ Successfully loaded editx. \n   Example usage: df <- editx(df)\n")
