library(shiny)
library(ggplot2)

ui <- fluidPage(
  selectInput(
    "n_breaks",
    label = "Number of bins in histogram (approximate):",
    choices = c(10, 20, 35, 50),
    selected = 20
  ),

  checkboxInput(
    "individual_obs",
    label = strong("Show individual observations"),
    value = FALSE
  ),

  checkboxInput(
    "density",
    label = strong("Show density estimate"),
    value = FALSE
  ),

  plotOutput("main_plot", height = "300px"),

  conditionalPanel(
    condition = "input.density == true",
    sliderInput(
      "bw_adjust",
      label = "Bandwidth adjustment:",
      min = 0.2, max = 2, value = 1, step = 0.2
    )
  )
)

server <- function(input, output) {
  output$main_plot <- renderPlot({
    p <- ggplot(faithful, aes(x = eruptions)) +
      geom_histogram(
        aes(y = after_stat(density)),
        bins = as.numeric(input$n_breaks),
        fill = "grey",
        color = "white"
      ) +
      labs(
        x = "Duration (minutes)",
        title = "Geyser eruption duration"
      ) +
      theme_minimal()

    if (input$individual_obs) {
      p <- p + geom_rug()
    }

    if (input$density) {
      p <- p + geom_density(adjust = input$bw_adjust, color = "blue", size = 1)
    }

    p
  })
}

shinyApp(ui, server)
