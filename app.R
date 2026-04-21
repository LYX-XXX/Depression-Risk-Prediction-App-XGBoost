# ==========================================
# Adult Depression Risk Prediction App (V2.0)
# Based on 4 core features: Sleep, BMI, Smoke, Arthritis
# ==========================================

library(shiny)
library(xgboost)
library(shapviz)
library(ggplot2)

# --- 1. 用户界面 (UI) 设计 ---
ui <- fluidPage(
  titlePanel("Adult Depression Risk Prediction (COVID-19 Era)"),
  
  sidebarLayout(
    sidebarPanel(
      h4("Patient Characteristics"),
      p("Based on 4 causal features screened by Logistic ∩ MR."),
      hr(),
      
      # 1. 睡眠质量
      sliderInput("Sleep", "Weekday Sleep Duration/Quality (hours/score):", 
                  min = 0, max = 24, value = 7, step = 0.5),
      
      # 2. BMI
      numericInput("BMI", "Body Mass Index (BMI):", 
                   value = 24.5, min = 10, max = 60, step = 0.1),
      
      # 3. 吸烟暴露
      selectInput("smoke", "Household Smoking Exposure:", 
                  choices = list("0 Member" = 0, "1 Member" = 1, "≥2 Members" = 2),
                  selected = 0),
      
      # 4. 关节炎病史
      selectInput("arthritis", "History of Arthritis:", 
                  choices = list("No" = 0, "Yes" = 1),
                  selected = 0),
      
      hr(),
      actionButton("predict_btn", "Calculate Risk", 
                   style = "color: white; background-color: #007BFF; border-color: #007BFF; width: 100%;")
    ),
    
    # --- 结果展示区 ---
    mainPanel(
      h3("Prediction Results"),
      verbatimTextOutput("risk_prob"),
      br(),
      h4("Individual Risk Explanation (SHAP Waterfall)"),
      plotOutput("shap_plot", height = "450px")
    )
  )
)

# --- 2. 服务器端逻辑 (Server) ---
server <- function(input, output, session) {
  
  # 加载您的模型 (这里假设您使用 xgb_model.json，如果您用的是 .rds，请改为 readRDS("dummy_model.rds"))
  # 注意：确保模型文件和这个 app.R 放在同一个文件夹下！
  model <- xgb.load("xgb_model.json") 
  
  # 监听按钮，构建用户输入数据
  user_data <- eventReactive(input$predict_btn, {
    # 【注意】这里的列名 (Sleep, BMI, smoke, arthritis) 必须与您训练 XGBoost 时的列名完全一致，区分大小写！
    df <- data.frame(
      Sleep = as.numeric(input$Sleep),
      BMI = as.numeric(input$BMI),
      smoke = as.numeric(input$smoke),
      arthritis = as.numeric(input$arthritis)
    )
    dtest <- xgb.DMatrix(data = as.matrix(df))
    return(list(df = df, dtest = dtest))
  }, ignoreNULL = FALSE) # 页面加载时默认计算一次
  
  # 预测概率输出
  output$risk_prob <- renderText({
    req(user_data())
    prob <- predict(model, user_data()$dtest)
    # 如果您的 XGBoost 直接输出的是概率 (objective = "binary:logistic")
    paste0("Estimated Depression Risk Probability: ", round(prob * 100, 2), "%")
  })
  
  # SHAP 瀑布图输出
  output$shap_plot <- renderPlot({
    req(user_data())
    shp <- shapviz(model, X_pred = as.matrix(user_data()$df))
    
    sv_waterfall(shp, row_id = 1) +
      theme_minimal(base_size = 14) +
      ggtitle("How specific features contributed to this patient's prediction")
  })
}

# --- 3. 运行应用 ---
shinyApp(ui = ui, server = server)