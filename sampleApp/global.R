
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
    "DT",
    "callr",
    "here",
    "readxl",
    "readr",
    "purrr",
    "plotly"
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

## データ取り込み
rawdataPath2023 <- "./rawdata/宿泊旅行統計調査_2023_確定値_001750679.xlsx"
rawdataPath2024 <- "./rawdata/宿泊旅行統計調査_2024_第2次速報値_001867118.xlsx"
sheetlist2023 <- excel_sheets(rawdataPath2023)
sheetlist_第1表 <- sheetlist2023[stri_detect_regex(sheetlist2023, "^第1表")]
sheetlist_第8表 <- sheetlist2023[stri_detect_regex(sheetlist2023, "^第8表")]
colname_base <- c("小規模_総数", "小規模_観光", "小規模_非観光", "小中規模_総数", "小中規模_観光", "小中規模_非観光", "中規模_総数", "中規模_観光", "中規模_非観光", "大規模_総数", "大規模_観光", "大規模_非観光", "旅館", "リゾートホテル", "ビジネスホテル", "シティホテル", "簡易宿所", "会社・団体の宿泊所")

## 施設数    
# 第1表（施設数）
colname_HotelCount <- c("CD所在地", "施設数.全体_総数", "施設数.全体_観光", "施設数.全体_非観光", paste0("施設数.", colname_base))
func_HotelCountData <- function(X){
  rawdat <- read_excel(path = filepath,
                       sheet = X,
                       na = "-",
                       col_names = FALSE,
                       col_types = "text",
                       range = "R8C1:R54C22")
  setnames(rawdat, colname_HotelCount)
  rawdat <- rawdat %>%
    mutate(Year = stri_sub(filepath, 20, 23),
           Month = as.numeric(stri_replace_all_fixed(X, "第1表(", "") %>% stri_replace_all_fixed("月)", ""))) %>%
    select(one_of(c("Year", "Month", colname_HotelCount)))
  return(rawdat)
}

filepath <- rawdataPath2023
HotelCountData_2023 <- purrr::map_dfr(sheetlist_第1表, func_HotelCountData) %>%
  mutate(across(4:24, ~as.numeric(formatC(.x, format = "fg"))),
         CD所在地 = stri_sub_replace(CD所在地, stri_locate_first_regex(CD所在地, '[0-9]+'), omit_na=TRUE, replacement= "")) 
filepath <- rawdataPath2024
HotelCountData_2024 <- purrr::map_dfr(sheetlist_第1表, func_HotelCountData) %>%
  mutate(across(4:24, ~as.numeric(formatC(.x, format = "fg"))))


## 稼働率
colname_OperatingRatio <- c("CD所在地", "稼働率.全体_総数", "稼働率.全体_観光", "稼働率.全体_非観光", paste0("稼働率.", colname_base))
# 第8表（稼働率）
func_OperatingRatio <- function(X){
  rawdat <- read_excel(path = filepath,
                       sheet = X,
                       na = "-",
                       col_names = FALSE,
                       col_types = "text",
                       range = "R8C1:R54C22")
  setnames(rawdat, colname_OperatingRatio)
  rawdat <- rawdat %>%
    mutate(Year = stri_sub(filepath, 20, 23),
           Month = as.numeric(stri_replace_all_fixed(X, "第8表(", "") %>% stri_replace_all_fixed("月)", ""))) %>%
    select(one_of(c("Year", "Month", colname_OperatingRatio)))
  return(rawdat)
}

filepath <- rawdataPath2023
OperatingRatio_2023 <- purrr::map_dfr(sheetlist_第8表, func_OperatingRatio) %>%
  mutate(across(4:24, ~as.numeric(formatC(.x, format = "fg"))),
         CD所在地 = stri_sub_replace(CD所在地, stri_locate_first_regex(CD所在地, '[0-9]+'), omit_na=TRUE, replacement= ""))
filepath <- rawdataPath2024
OperatingRatio_2024 <- purrr::map_dfr(sheetlist_第8表, func_OperatingRatio) %>%
  mutate(across(4:24, ~as.numeric(formatC(.x, format = "fg"))))

HotelCountData <- bind_rows(HotelCountData_2023, HotelCountData_2024) %>%
  pivot_longer(cols = starts_with("施設数"),
               names_to = "cat",
               values_to = "val") %>%
  separate(col = "cat",
           into = c("category", "colnames"),
           sep = "\\.") %>%
  pivot_wider(names_from = "colnames",
              values_from = "val")

OperatingRatio <- bind_rows(OperatingRatio_2023, OperatingRatio_2024) %>%
  pivot_longer(cols = starts_with("稼働率"),
               names_to = "cat",
               values_to = "val") %>%
  separate(col = "cat",
           into = c("category", "colnames"),
           sep = "\\.") %>%
  pivot_wider(names_from = "colnames",
              values_from = "val") %>%
  dplyr::filter(!is.na(Month))

HotelTotalData <- bind_rows(HotelCountData, OperatingRatio)

HotelTotalData_long <- HotelTotalData %>%
  pivot_longer(cols = 5:25,
               names_to = "Class",
               values_to = "val")

