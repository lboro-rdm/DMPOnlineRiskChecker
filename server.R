# Server
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
  
  # Observe the uploaded file
  observeEvent(input$jsonfile, {
    req(input$jsonfile)
    
    # Load JSON data
    json_data <- fromJSON(input$jsonfile$datapath, simplifyVector = FALSE)
    str(json_data, max.level = 2)
    
    # Initialize a data frame to store matches
    matches <- data.frame(id = character(), data_contact_email = character(), content = character(), stringsAsFactors = FALSE)
    
    # Check if json_data is a list and iterate through each management plan
    if (is.list(json_data)) {
      for (plan in json_data) {
        # Get the ID safely
        plan_id <- if ("id" %in% names(plan)) as.character(plan$id) else NA
        
        # Get the data contact email safely
        data_contact_email <- NA  # Initialize as NA
        if ("data_contact" %in% names(plan)) {
          if ("email" %in% names(plan$data_contact)) {
            data_contact_email <- plan$data_contact$email
          }
        }
        
        # Check each content element for special category data
        if ("plan_content" %in% names(plan)) {
          for (content in plan$plan_content) {
            if ("sections" %in% names(content)) {
              for (section in content$sections) {
                if ("questions" %in% names(section)) {
                  for (question in section$questions) {
                    # Check if the question has an answer
                    if ("answer" %in% names(question) && "text" %in% names(question$answer)) {
                      answer_text <- question$answer$text
                      
                      # Clean the answer text by removing HTML tags and decoding
                      clean_text <- gsub("<[^>]+>", "", answer_text)  # Remove HTML tags
                      clean_text <- gsub("&nbsp;", " ", clean_text)   # Replace non-breaking spaces
                      
                      # Print cleaned answer text for debugging
                      cat(sprintf("Checking answer text: %s\n", clean_text))  # Debug output
                      
                      # Check for matches against special terms
                      match_found <- any(str_detect(tolower(clean_text), str_c(special_terms, collapse = "|")))
                      
                      # Print matching result for debugging
                      if (match_found) {
                        cat(sprintf("Match found in plan ID: %s, content: %s\n", plan_id, clean_text))  # Debug output
                        
                        # If a match is found, append it to the matches data frame
                        matches <- rbind(matches, data.frame(id = plan_id, data_contact_email = data_contact_email, content = clean_text, stringsAsFactors = FALSE))
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
    
    # Display the results in a table
    output$matches <- renderDT({
      datatable(matches, options = list(pageLength = 10, autoWidth = TRUE))
    })
  })
}