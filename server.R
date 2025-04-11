server <- function(input, output, session) {
  
  special_terms <- c(
    "activism", "ancestry", "biometric data", "belief", 
    "chronic illness", "cisgender", "confidential data", 
    "condition", "data breaches", "data protection", 
    "denomination", "disability", "disability status", 
    "ethnicity", "faith", "financial information", 
    "gender", "gender expression", "gender identity", 
    "illness", "indigenous", "lgbtq+", 
    "medical", "mental health", "mental illness", 
    "non-binary", "personal data", "personal information", 
    "personal opinions", "party membership", "political affiliation", 
    "political beliefs", "political opinion", "private information", 
    "religion", "religious affiliation", "religious practices", 
    "sect", "sexual orientation", "sexual preference", 
    "social security number", "spirituality", "surveillance", 
    "symptoms", "treatment", "vaccination", 
    "voting behavior", "user consent"
  )
  
  matches <- reactiveVal(data.frame(id = character(), data_contact_email = character(), content = character(), stringsAsFactors = FALSE))
  
  observeEvent(input$jsonfile, {
    req(input$jsonfile)
    
    matches(data.frame(id = character(), data_contact_email = character(), content = character(), stringsAsFactors = FALSE))
    
    json_data <- fromJSON(input$jsonfile$datapath, simplifyVector = FALSE)

    if (is.list(json_data)) {
      for (plan in json_data) {
        
        plan_id <- if ("id" %in% names(plan)) as.character(plan$id) else NA
        
        data_contact_email <- NA  
        if ("data_contact" %in% names(plan)) {
          if ("email" %in% names(plan$data_contact)) {
            data_contact_email <- plan$data_contact$email
          }
        }
        
        if ("plan_content" %in% names(plan)) {
          for (content in plan$plan_content) {
            if ("sections" %in% names(content)) {
              for (section in content$sections) {
                if ("questions" %in% names(section)) {
                  for (question in section$questions) {
                    
                    if ("answer" %in% names(question) && "text" %in% names(question$answer)) {
                      answer_text <- question$answer$text
                      
                      
                      clean_text <- gsub("<[^>]+>", "", answer_text)  
                      clean_text <- gsub("&nbsp;", " ", clean_text)   
                      
                      match_found <- any(str_detect(tolower(clean_text), str_c(special_terms, collapse = "|")))
                      
                      if (match_found) {
                        
                        current_matches <- matches()
                        new_match <- data.frame(id = plan_id, data_contact_email = data_contact_email, content = clean_text, stringsAsFactors = FALSE)
                        matches(rbind(current_matches, new_match))
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    } else {
      showNotification("The uploaded JSON file does not contain the expected data structure.")
    }
    
    output$matches <- renderDT({
      datatable(matches(), options = list(pageLength = 10, autoWidth = TRUE))
    })
  })
}
