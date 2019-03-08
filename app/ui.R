################################################################################
# UI of the app
#
# Author: Stefan Schliebs
# Created: 2019-01-22 09:44:46
################################################################################

htmlTemplate(
  filename = "www/index.html",
  box_packages_new_month = pretty_value_box_ui("packages-new-month", icon_name = "cubes"),
  box_packages_updated_month = pretty_value_box_ui("packages-updated-month", background_color = "#7ab885", icon_name = "cubes"),

  box_packages_new_year = pretty_value_box_ui("packages-new-year", icon_name = "cubes"),
  box_packages_updated_year = pretty_value_box_ui("packages-updated-year", background_color = "#7ab885", icon_name = "cubes"),

  n_packages = textOutput("n_cran_packages", inline = TRUE),# %>% withSpinner(size = 0.25, proxy.height = "20px"),
  last_update = textOutput("last_update", inline = TRUE), # %>% withSpinner(size = 0.25, proxy.height = "20px"),
  
  package_chart = package_chart_ui("package_chart"),
  
  featured_packages = featured_packages_ui("featured_packages"),

  dependency_network = graph_network_ui("dependency_network")
)
