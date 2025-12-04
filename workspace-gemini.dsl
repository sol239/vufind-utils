workspace "KNAV Catalog (VuFind)" "C4 Model for KNAV Catalog with custom knav_katalog module" {

    model {
        user = person "Library Patron" "A user searching for books, articles, and managing their library account."

        group "KNAV Ecosystem" {
            vufind = softwareSystem "KNAV Catalog (VuFind)" "The main library discovery interface allowing users to search and manage resources." {
                
                webApp = container "Web Application" "Delivers the web interface, handles routing, and business logic." "PHP / Laminas Framework" {
                    
                    group "Module: knav_katalog" {
                        recordController = component "RecordController" "Overrides core RecordController. Handles record display logic." "PHP Controller"
                        myResearchController = component "MyResearchController" "Overrides core MyResearch. Handles user account, fines, and checkouts." "PHP Controller"
                        cartController = component "KnavCartController" "Custom cart handling logic." "PHP Controller"
                        edsController = component "EdsController" "Handles EBSCO Discovery Service interactions." "PHP Controller"
                        
                        alephDriver = component "Aleph ILS Driver" "Custom driver communicating with Aleph ILS for KNAV specific logic." "PHP Class"
                        solrDriver = component "SolrMarc Driver" "Custom record driver for parsing Solr results." "PHP Class"
                        
                        authPlugin = component "Auth Plugin" "Handles authentication." "PHP Class"
                    }

                    router = component "Router" "Routes requests to appropriate controllers. Handles multi-institution URLs." "Laminas Router"
                    viewLayer = component "View Layer" "Renders HTML using themes and custom view helpers." "Laminas View / PHTML"
                }

                database = container "Database" "Stores user accounts, comments, tags, and persistent sessions." "MySQL"
                searchIndex = container "Search Index" "Stores indexed MARC records for fast retrieval." "Apache Solr"
                fileSystem = container "File System" "Stores configuration, language files, and cached data." "Disk"
            }
        }

        aleph = softwareSystem "Aleph ILS" "Integrated Library System for holdings, circulation, and user management." "External System"
        eds = softwareSystem "EBSCO Discovery Service (EDS)" "External article and journal search service." "External System"
        ldap = softwareSystem "LDAP" "Directory service for user authentication." "External System"

        # Relationships - Context Level
        user -> vufind "Uses" "HTTPS"
        vufind -> aleph "Checks availability, places holds, authenticates users" "X-Server/API"
        vufind -> eds "Searches articles" "API"
        vufind -> ldap "Authenticates users" "LDAP"

        # Relationships - Container Level
        user -> webApp "Visits" "HTTPS"
        webApp -> database "Reads/Writes" "PDO/MySQL"
        webApp -> searchIndex "Queries" "HTTP/Solr"
        webApp -> fileSystem "Reads Config/Cache" "File I/O"
        webApp -> aleph "Calls" "Custom Driver"
        webApp -> eds "Calls" "API"
        webApp -> ldap "Authenticates"

        # Relationships - Component Level
        router -> recordController "Routes to"
        router -> myResearchController "Routes to"
        router -> cartController "Routes to"
        router -> edsController "Routes to"

        recordController -> solrDriver "Uses"
        solrDriver -> searchIndex "Fetches data from"
        recordController -> viewLayer "Passes data to"

        myResearchController -> alephDriver "Uses"
        alephDriver -> aleph "Communicates with"
        myResearchController -> viewLayer "Passes data to"

        edsController -> eds "Queries"
        
        authPlugin -> ldap "Validates credentials against"
        authPlugin -> database "Syncs user data with"
    }

    views {
        systemContext vufind "SystemContext" {
            include *
            autoLayout
        }

        container vufind "Containers" {
            include *
            autoLayout
        }

        component webApp "Components" {
            include *
            autoLayout
        }

        styles {
            element "Software System" {
                background #1168bd
                color #ffffff
            }
            element "Person" {
                shape Person
                background #08427b
                color #ffffff
            }
            element "Container" {
                background #438dd5
                color #ffffff
            }
            element "Component" {
                background #85bbf0
                color #000000
            }
            element "External System" {
                background #999999
                color #ffffff
            }
            element "Database" {
                shape Cylinder
            }
        }
    }
}
