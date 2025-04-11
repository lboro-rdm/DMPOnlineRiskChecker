library(shiny)
library(jsonlite)
library(tidyverse)
library(DT)

ui <- tags$html(
  lang = "en",
  fluidPage(
    style = "padding: 0px; margin: 0px;",
    tags$head(
      tags$title("DMP Risk Checker"),
      tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
    ),
    
    # Black banner
    tags$div(
      class = "black-banner",
      tags$div(
        class = "banner-content",
        tags$a(
          href = "https://www.lboro.ac.uk",
          target = "_blank",
          tags$img(src = "logo.png", class = "uni-logo", alt = "University Logo")
        ),
        tags$a(
          href = "https://www.lboro.ac.uk/services/library/",
          target = "_blank",
          class = "return-link",
          "University Library"
        )
      )
    ),
    
    # Blue banner
    tags$div(
      class = "blue-banner",
      tags$div(
        class = "banner-content",
        tags$span("Open Research Services"),
        tags$a(
          href = "https://dmponline.dcc.ac.uk/",
          class = "return-link",
          "< Return to DMPOnline"
        )
      )
    ),
    
    # Title section
    tags$div(
      class = "white-banner",
      tags$h1("DMPOnline Risk Checker")
    ),
  
    div(class = "main-wrapper",
    p("This webapp checks Data Management Plans (DPMs) created on DMPOnline for projects that are processing personal and special category data."),
    p(),
    p("To use this app, you would need to use the DMPOnline API to create a .json file of DMPs that you would like to check."),
    p(),
    p(
      "More information is available for the ",
      tags$a(
        href = "https://github.com/DMPRoadmap/roadmap/wiki/API-V0-Documentation#plans",
        target = "_blank",
        "DMPOnline API"
      ),
      "."
    ),
    p(),
    p(
      "If you have never used an API before, I would recommend getting started with ",
      tags$a(
        href = "https://www.postman.com/",
        target = "_blank",
        "Postman"
      ),
      "."
    ),
    p("To start using this app, upload your .json file."),
    p(),
     
  fileInput("jsonfile", "Upload a JSON File", accept = ".json"),
  DTOutput("matches"),
  p(),
  h2("About this app"),
  p("This shiny app searches for the following keywords:"),
  p("activism, ancestry, biometric data, belief, chronic illness, cisgender, confidential data, condition, data breaches, data protection, denomination, disability, disability status, ethnicity, faith, financial information, gender, gender expression, gender identity, illness, indigenous, LGBTQ+, medical, mental health, mental illness, non-binary, personal data, personal information, personal opinions, party membership, political affiliation, political beliefs, political opinion, private information, religion, religious affiliation, religious practices, sect, sexual orientation, sexual preference, spirituality, surveillance, symptoms, treatment, vaccination, voting behavior, and user consent."),
  p(),
  
  p("This web app was created and is maintained by Lara Skelly, Loughborough University, in R using the following packages:"),
  tags$ul(
    tags$li(
      HTML("Chang W, Cheng J, Allaire J, Sievert C, Schloerke B, Xie Y, Allen J, McPherson J, Dipert A, Borges B (2024). <i>shiny: Web Application Framework for R</i>. R package version 1.10.0, "),
      tags$a(href = "https://CRAN.R-project.org/package=shiny", "https://CRAN.R-project.org/package=shiny")
    ),
    tags$li(
      HTML("Ooms, J. (2014). “The jsonlite Package: A Practical and Consistent Mapping Between JSON Data and R Objects.” <i>arXiv:1403.2805 [stat.CO]</i>. "),
      tags$a(href = "https://arxiv.org/abs/1403.2805", "https://arxiv.org/abs/1403.2805")
    ),
    tags$li(
      HTML("Wickham H, Averick M, Bryan J, Chang W, McGowan LD, François R, Grolemund G, Hayes A, Henry L, Hester J, Kuhn M, Pedersen TL, Miller E, Bache SM, Müller K, Ooms J, Robinson D, Seidel DP, Spinu V, Takahashi K, Vaughan D, Wilke C, Woo K, Yutani H (2019). “Welcome to the tidyverse.” <i>Journal of Open Source Software</i>, 4(43), 1686. "),
      tags$a(href = "https://doi.org/10.21105/joss.01686", "https://doi.org/10.21105/joss.01686")
    ),
    tags$li(
      HTML("Xie Y, Cheng J, Tan X (2024). <i>DT: A Wrapper of the JavaScript Library 'DataTables'</i>. R package version 0.33, "),
      tags$a(href = "https://CRAN.R-project.org/package=DT", "https://CRAN.R-project.org/package=DT")
    )
  ),
  
  p(HTML("&copy; MIT. The code can be found on "), 
    a("GitHub", href = "https://github.com/lboro-rdm/DMPOnlineRiskChecker.git", target = "_blank")),
  
  p(),

  p("Throughout the creation of this Shiny app, ChatGPT acted as a conversation partner and a code checker."),
  p(),
  p("This web app does not use cookies or store any data on your device. Nor does it store anything uploaded. If you have any privacy concerns, please download the code and run it offline."),
  p(),
    ),

  # footer    
  tags$div(class = "footer", 
           fluidRow(
             column(12, 
                    tags$a(href = 'https://doi.org/10.17028/rd.lboro.28525481', 
                           "Accessibility Statement")
             )
           )
  )
  
  )
)