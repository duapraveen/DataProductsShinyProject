library(shiny)
library(googleVis)

shinyUI(pageWithSidebar(
      headerPanel("College Finder App"),
      sidebarPanel(
            textInput('homestate', "Home State (Ex: CA)",'CA', 150),
            textInput('states', "Additional States (Ex: CA, NY)",'', 400),
            sliderInput("SAT", "SAT Threshold (math + reading)", 800, 1600,1200, step = 10),
            sliderInput("TuitionInState", "Max in-state Tuition", 1000, 60000,15000, step = 100),
            sliderInput("TuitionOutState", "Max out-of-state Tuition", 1000, 60000,55000, step = 100),
            selectInput("field", "Field of Study", 
                        choices = c(
                              "Agriculture, Agriculture Operations" = "CIP01",
                              "Natural Resources and Conservation" = "CIP03",
                              "Architecture and Related Services"  = "CIP04",
                              "Area, Ethnic, Cultural, Gender and Group Studies" = "CIP05",
                              "Communication, Journalism and Related" = "CIP09",
                              "Communication Technologies/Technicians and Services" = "CIP10",
                              "Computer and Information Sciences and Services" = "CIP11",
                              "Personal and Culinary Services" = "CIP12",
                              "Education" = "CIP13",
                              "Engineering" = "CIP14",
                              "Engineering Technologies and Engineering-Related Fields" = "CIP15",
                              "Foreign Languages, Literatures and Linguistics" = "CIP16",
                              "Family and Consumer Sciences/Human Sciences" = "CIP19",
                              "Legal Professions and Studies" = "CIP22",
                              "English Language and Literature/Letters" = "CIP23",
                              "Liberal Arts and Sciences, General Studies and Humanities" = "CIP24",
                              "Library Science" = "CIP25",
                              "Biological and Biomedical Sciences" = "CIP26",
                              "Mathematics and Statistics" = "CIP27",
                              "Military Technologies and Applied Sciences" = "CIP29",
                              "Multi/Inter-disciplinary Studies" = "CIP30",
                              "Parks, Recreation, Leisure and Fitness Studies" = "CIP31",
                              "Philosophy and Religious Studies" = "CIP38",
                              "Theology and Religious Vocations" = "CIP39",
                              "Physical Sciences" = "CIP40",
                              "Science Technologies/Technicians" = "CIP41",
                              "Psychology" = "CIP42",
                              "Homeland Security, Law Enforcement, Firefighting and Related" = "CIP43",
                              "Public Administration and Social Service Professions" = "CIP44",
                              "Social Sciences" = "CIP45",
                              "Construction Trades" = "CIP46",
                              "Mechanic and Repair Technologies/Technicians" = "CIP47",
                              "Precision Production" = "CIP48",
                              "Transportation and Materials Moving" = "CIP49",
                              "Visual and Performing Arts" = "CIP50",
                              "Health Professions and Related Programs" = "CIP51",
                              "Business, Management, Marketing and Related Support Services" = "CIP52",
                              "History" = "CIP54"
                        ),
                        multiple = FALSE,
                        selected = "CIP14"
            ),
            checkboxGroupInput("degree", "Degree Awarded", 
                               choices = c(
                                     "Bachelor's Degree" = "BACHL",
                                     "2-4 yr Certificate" = "CERT4",
                                     "2 yr Associate Degree" = "ASSOC",
                                     "1-2 yr Certificate" = "CERT2",
                                     "< 1 yr Certificate" = "CERT1"
                               ), 
                               selected = "BACHL" 
            ) 
      ),
      mainPanel(
            h3('Number of Colleges Matching Filter Criteria'),
            verbatimTextOutput('numSchools'),
            plotOutput("histSATvsTut", hover = "plot_hover_SAT"),
            h4('Hover mouse over points for magic ...'),
            verbatimTextOutput("info"),
            h3('Locations of Colleges'),
            htmlOutput("map1")
      )
)
)
