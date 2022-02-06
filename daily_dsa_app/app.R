library(shiny)
library(tidyverse)
library(readtext)
library(lubridate)



ui <- fluidPage(
    sidebarLayout(
        sidebarPanel(
            radioButtons("pats", "Todays_Patients", choices = c("")),
            h5("click pat to see labor werte from 0:00 Uhr")
        )
        
    
       
))

server <- function(input, output, session) {
    f <- stamp_date("2020_05_25.pdf")
    f_name <- str_c("../pdfs/", f(today()-1)) # why -1 ?????
    tod_pdf <- readtext::readtext(f_name)
    tex <- tod_pdf$text
    df <- str_split(tex, "\\n")[[1]] %>% tibble(text = .)
    todays_pats <- df %>% mutate(text = str_squish(text)) %>% 
        filter(str_detect(text, "\\|\\(\\s\\*\\d")|
                   lag(str_detect(text, "\\|\\(\\s\\*\\d"))) %>% 
        transmute(
            new = if_else(str_detect(text, "\\|\\(\\s\\*\\d"),
                          str_c(text, lead(text)),
                          "NA")) %>% 
        filter (new != "NA") %>% 
        mutate(
            name = str_extract(new, ".+,\\s\\w+(?=\\|)") %>% str_remove_all(.,"\\d+") %>% str_squish(.),
            dob = str_extract(new, "(?<=\\*)\\d{2}\\.\\d{2}\\.\\d{4}"),
            piz = str_extract(new, "\\d{8}")
        ) %>% select(-new)
    names_vect <- todays_pats$name
    updateRadioButtons(inputId = "pats", choices = names_vect)
    
    # addResourcePath("pdf_folder","H:/Abteilung Verwaltung/prepare_DSA/pdfs")
    #output$path <- renderUI({tags$iframe(src="pdf_folder/1.pdf",style="height:800px; width:100%;scrolling=yes")})
    
  
}

shinyApp(ui, server)