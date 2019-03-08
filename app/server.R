################################################################################
# Server logic of the app
#
# Author: Stefan Schliebs
# Created: 2019-01-22 09:44:28
################################################################################


server <- function(input, output, session) {

  # load namespace from session
  ns <- session$ns
  

  # Data reactives ----------------------------------------------------------

  d_pkg_dependencies <- reactive(readr::read_csv(S3_PKG_DEPENDENCIES))
  # d_pkg_dependencies <- reactive(readr::read_csv("data/pkg_dependencies.csv"))
  
  d_pkg_releases <- reactive(readr::read_csv(S3_PKG_RELEASES))
  # d_pkg_releases <- reactive(readr::read_csv("data/pkg_releases.csv"))
  
  d_pkg_details <- reactive(readRDS("data/pkg_details.rds"))
  
  l_tile_summary <- reactive(readRDS(url(S3_TILE_SUMMARIES)))
  # l_tile_summary <- reactive(readRDS("data/tile_summary.rds"))
  
  

  # Last updated ------------------------------------------------------------

  output$last_update <- renderText({
    max(d_pkg_releases()$published, na.rm = TRUE) %>% 
      strftime("%d %b %Y")
  })
  
  output$n_cran_packages <- renderText({
    n_distinct(d_pkg_releases()$package) %>% 
      format(big.mark = ",")
  })
  

  # CRAN stats info boxes ---------------------------------------------------
  
  # define the info boxes as instances of the pretty_value_box module
  m_pkgs_new_month <- callModule(pretty_value_box, id = "packages-new-month")
  m_pkgs_updated_month <- callModule(pretty_value_box, id = "packages-updated-month")
  m_pkgs_new_year <- callModule(pretty_value_box, id = "packages-new-year")
  m_pkgs_updated_year <- callModule(pretty_value_box, id = "packages-updated-year")
  
  # populate the info boxes when new tile data become available
  observeEvent(l_tile_summary(), {
    map2(
      list(m_pkgs_new_month, m_pkgs_updated_month, m_pkgs_new_year, m_pkgs_updated_year),
      l_tile_summary(),
      function(mod, values) {
        do.call(mod$set_values, values)
      }
    )
  })
  
  
  # Dependency network ------------------------------------------------------

  callModule(graph_network, "dependency_network", d_pkg_dependencies, d_pkg_details, d_pkg_releases)  
  

  # Package chart -----------------------------------------------------------

  callModule(package_chart, "package_chart", d_pkg_releases)
  

  # Featured packages -------------------------------------------------------

  callModule(featured_packages, "featured_packages", d_pkg_releases, d_pkg_dependencies, d_pkg_details)
  
  
  # Test plots --------------------------------------------------------------
  
  output$plot <- renderHighchart({
    hchart(ggplot2::mpg, "scatter", hcaes(x = displ, y = hwy, group = class))
  })
  
  output$plot2 <- renderPlot({
    plot(rnorm(40))
  })
  
}