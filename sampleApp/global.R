
#### max upload file size increase 5000M ####
options(shiny.maxRequestSize=5000*1024^2)

## load libraries 
need_packages <- c(
    "data.table",
    "shiny",
    "shinydashboard",
    "shinyWidgets",
    "shinyFiles",
    "dplyr",
    "tidyr",
    "ggplot2",
    "stringi",
    "pdftools",
    # "htmltools",
    "DT",
    "callr",
    "here",
    "tictoc",
    "formattable",
    "extrafont"
)

to_be_installed <- setdiff(need_packages, installed.packages())
if (length(to_be_installed) > 0) {
    install.packages(to_be_installed, repos = "https://cloud.r-project.org/", dependencies = TRUE,
                     # type = "binary",
    )
}

for (p in need_packages) {
    library(p, character.only = TRUE)
}