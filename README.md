### **Introduction**

`RxUtils` is my little hobby project—a collection of handy R tools to make life easier. It’s all about simplifying those everyday tasks in R. No overcomplications—just tools to save time and keep things fun! 😊

Utilities:

- `ggsavex` is an R source that simplifies saving `ggplot2` plots by providing an intuitive graphical interface. It lets you easily set file name, path, size, resolution, and format without memorizing complex arguments. If you don't even want to spend time on figuring out these parameters, simply click the `Save Plot` button and your plot will be saved with the default parameters.

- `editx` is an R source that allows interactively editing data frames directly in your systems' default office software (such as MS Excel, LibreOffice Calc) and seamlessly import the changes back into R. This simplifies data correction and updates. First Edit&save in MSExcel/LibreCalc  and then click `Done Edit` to save changes.

### **Key Features**

#### ggsavex

- Interactive GUI for plot export settings.
- Default options for quick saving.
- Support for multiple formats (PNG, PDF, TIFF, etc.).
- Safety checks to prevent oversized plots.

#### editx
- Export data frames to office GUI software for editing.
- Automatically includes row names as a separate editable column.
- Regenerate row names if cleared during editing.

### **Example Usage**

```R
# REMEMBER to set a working directory
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
cat("Working directory set to:", getwd(), "\n")


# ggsavex

source("utils/ggsavex.R")

ggplot(mtcars, aes(x = hp, y = mpg, color = factor(cyl))) +
  geom_point(size = 3) +
  labs(
    title = "Scatter Plot of MPG vs. Horsepower",
    x = "Horsepower",
    y = "Miles Per Gallon",
    color = "Number of Cylinders"
) +
theme_minimal()

ggsavex()


# editx

source("utils/editx.R")

df <- mtcars
df <- editx(df)
# First Save in Excel/Calc, then click Done.
```

<img src="https://github.com/puff-dayo/RxUtils/blob/main/screenshots/ggsavex.png?raw=true" width="400" height="auto">

