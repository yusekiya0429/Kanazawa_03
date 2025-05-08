function(input, output, session) {
    # デフォルトで使う今日の日付を取得    
    today <- Sys.Date()
    
    ## データ取り込みタブ
    shiny::addResourcePath('CMA_reporting', here::here("www"))
    homepath <- reactiveValues(home = getwd())

    
    # ####
    # # セッション切れたときにRを終了させる
    # session$onSessionEnded(function(){
    #     stopApp()
    #     q("no")
    # })                                       
}