# 
shinyUI(dashboardPage(
    dashboardHeader(title = "宿泊旅行統計調査可視化アプリ", 
                    disable = FALSE, 
                    titleWidth  = 550),
    dashboardSidebar(
        sidebarMenu(
            menuItem("施設数表", tabName = "HotelCountTable"
            ),
            menuItem("稼働率表", tabName = "OperatingRatioTable"
            ),
            menuItem("分類別可視化", tabName = "ClassLinePlot"
            ),
            menuItem("県別可視化", tabName = "ClassLinePlot"
            )
        )
    ),
    dashboardBody(
        tabItems(
            tabItem(tabName = "HotelCountTable",
                    h3("施設数表"), 
                    fluidRow(
                      column(width = 6,
                             ""
                             )      
                      )                  
                    ),
            
            tabItem(tabName = "OperatingRatioTable",
                    h3("稼働率表"), 
                    fluidRow(
                      column(width = 6,
                             ""
                             )      
                      )                  
                    ),
            
            tabItem(tabName = "ClassLinePlot",
                    h3("分類別可視化"), 
                    fluidRow(
                      column(width = 6,
                             ""
                             )      
                      )                  
                    ),
            
            tabItem(tabName = "ClassLinePlot",
                    h3("県別可視化"), 
                    fluidRow(
                      column(width = 6,
                             ""
                             )      
                      )                  
                    )

                )
            ),
    skin="blue"
    )
)
