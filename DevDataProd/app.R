

library(shiny)

f <- faithful
names(f)[2] <- "minutes"
f$hours <- f$minutes / 60

# Define UI for application that draws a histogram
ui <- fluidPage(
    titlePanel("Old Faithful Geyser Data"),

    # Output: Tabset w/ plot, summary, and table ----
    tabsetPanel(
        id = "main_tabs",
        type = "tabs",

        # Sidebar with a slider input for number of bins
        tabPanel("App", sidebarLayout(
            sidebarPanel(
                sliderInput(
                    "bins",
                    "Number of bins:",
                    min = 1,
                    max = 50,
                    value = 30
                ),
                hr(),
                radioButtons(
                    "HrMin",
                    label = h3("Hours or Minutes"),
                    choices = list("Hours" = 1, "Minutes" = 2),
                    selected = 2
                ),
            ),
            mainPanel(tabPanel("Plot", plotOutput("distPlot")))
        )),
        tabPanel("Docs",
            br(),
            h2("App background"),
            br(),
            p("This app shows a histogram of the ", em("faithful"), "data included in R to satisfy the final project assignment for the Cousera course ", em("Developing Data Products.")),
            br(),
            h2("Using the app"),
            p("The histrogram can be controlled by sliding the ", strong("slider control"), " to select the number of bins, as well as using ", strong("radio buttons"), " to select the units (hours or minutes) in which to show the X-axis. Adjusting either will update the chart")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        if(input$HrMin == "1") {
            x <- f[, 3]
            mess <- "Waiting time in hours"
        } else {
            x <- f[, 2]
            mess <- "Waiting time in minutes"
        }
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white',
             xlab = mess,
             main = 'Histogram of waiting times',
             include.lowest = TRUE)

    })
}

# Run the application
shinyApp(ui = ui, server = server)
