server <- function(input, output, session) {
  
  special_terms <- c(
    "activism", "ancestry", "biometric data", "belief", 
    "chronic illness", "cisgender", "confidential data", 
    "condition", "data breaches", "data protection", 
    "denomination", "disability", "disability status", 
    "ethnicity", "faith", "financial information", 
    "gender", "gender expression", "gender identity", 
    "illness", "indigenous", "LGBTQ+", 
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
    json_data <- fromJSON(input$jsonfile$datapath, simplifyVector = TRUE)
    
    # Initialize a data frame to store matches
    matches <- data.frame(id = character(), principal_investigator_email = character(), content = character(), stringsAsFactors = FALSE)
    
    # Check if json_data is a list and iterate through each data management plan
    if (is.list(json_data)) {
      for (plan in json_data) {
        # Get the ID safely
        plan_id <- if ("id" %in% names(plan)) as.character(plan$id) else NA
        
        # Skip processing if the ID is NA
        if (is.na(plan_id)) {
          next  # Skip this plan if there is no ID
        }
        
        # Get the principal investigator email safely
        pi_email <- NA  # Initialize as NA
        if ("principal_investigator" %in% names(plan)) {
          if ("email" %in% names(plan$principal_investigator)) {
            pi_email <- plan$principal_investigator$email
          }
        }
        
        # Check each content element for special category data
        for (field_name in names(plan)) {
          content <- plan[[field_name]]  # Access each field's content
          
          # Ensure content is not NULL
          if (!is.null(content)) {
            # Check if the content is a character vector or a list
            if (is.character(content) || is.list(content)) {
              # Unlist if it's a list to check for special terms
              if (is.list(content)) {
                content <- unlist(content)
              }
              # Use any() to check if any content matches the special terms
              if (any(str_detect(tolower(as.character(content)), str_c(special_terms, collapse = "|")))) {
                # If a match is found, append it to the matches data frame
                matches <- rbind(matches, data.frame(id = plan_id, principal_investigator_email = pi_email, content = as.character(content), stringsAsFactors = FALSE))
              }
            } else {
              cat(sprintf("Content for field '%s' is not a character or list: %s\n", field_name, class(content)))  # Debug output
            }
          } else {
            cat(sprintf("Content for field '%s' is NULL in plan ID: %s\n", field_name, plan_id))  # Debug output
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
