# 
shinyUI(dashboardPage(
    dashboardHeader(title = "CMAレポート作成アプリ", 
                    disable = FALSE, 
                    titleWidth  = 550),
    dashboardSidebar(
        sidebarMenu(
            menuItem("", tabName = ""
            ),
            menuItem("", tabName = ""
            ),
            menuItem("", tabName = ""
            ),
            menuItem("", tabName = ""
            ),
            menuItem("", tabName = ""
            )
        )
    ),
    dashboardBody(
        tabItems(
            tabItem(tabName = "",
                    h3(""), 
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
