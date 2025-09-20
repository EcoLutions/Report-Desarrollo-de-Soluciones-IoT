workspace "WasteTrack Container Diagram" "Container diagram showing WasteTrack internal architecture with IoT edge computing" {
    model {
        # External Users
        citizen = person "Citizen" "Lima residents who interact with waste management services"
        municipalAdmin = person "Municipal Administrator" "District administrators managing waste operations"
        driver = person "Collection Driver" "Vehicle operators executing collection routes"
        ecoLutionsSupport = person "EcoLutions Support Staff" "Technical support and platform management team"

        # External Systems
        iotHardware = softwareSystem "IoT Container Sensors" "Physical sensors with cameras and fill level detectors" "External,Hardware"
        paymentGateway = softwareSystem "Payment Gateway (Culqi)" "Payment processing service" "External"
        emailService = softwareSystem "Email Service Provider" "Cloud email service" "External"
        mapsAPI = softwareSystem "Google Maps API" "Mapping and navigation service" "External"
        pushNotificationService = softwareSystem "Push Notification Service" "Firebase Cloud Messaging" "External"
        weatherService = softwareSystem "Weather Service API" "Weather data provider" "External"

        # WasteTrack System Containers
        wasteTrackSystem = softwareSystem "WasteTrack System" "IoT-enabled smart waste management platform" {
            
            # IoT Edge Computing Layer
            iotGatewayApp = container "IoT Gateway Application" "Edge application processing sensor data locally before sending to cloud" "Python" "Edge" {
                sensorController = component "Sensor Controller" "Interfaces with IoT hardware sensors and cameras" "Python"
                dataProcessor = component "Data Processor" "Processes and validates sensor data locally" "Python"
                edgeAnalytics = component "Edge Analytics" "Performs local analytics and anomaly detection" "Python"
                localCache = component "Local Cache" "Stores recent sensor data for offline operation" "Python"
            }
            
            edgeDB = container "Edge SQLite Database" "Stores sensor data locally on IoT gateway" "SQLite" "Database"
            
            # Frontend Applications
            citizenMobileApp = container "Citizen Mobile App" "Mobile application for citizens to report issues, access education, and track rewards" "React Native" "MobileApp"
            adminWebApp = container "Admin Web Application" "Web dashboard for municipal administrators and EcoLutions support" "React, TypeScript" "Browser"
            driverMobileApp = container "Driver Mobile App" "Mobile application for collection drivers to manage routes and report status" "React Native" "MobileApp"
            
            # Backend Services (Monolithic approach)
            apiGateway = container "API Gateway" "Routes requests and handles authentication" "AWS API Gateway" "Gateway"
            
            backendService = container "WasteTrack Backend Service" "Main application service handling all business logic" "Java, Spring Boot" "Server"
            
            # Single Database
            mainDB = container "WasteTrack PostgreSQL Database" "Main database storing all application data" "PostgreSQL" "Database"
            
            # Cache Layer
            redisCache = container "Redis Cache" "Caches frequently accessed data for performance" "Redis" "Cache"
            
            # Message Queue for IoT data
            messageQueue = container "Message Queue" "Handles IoT sensor data ingestion" "Apache Kafka" "MessageBroker"
        }

        # User interactions
        citizen -> citizenMobileApp "Uses mobile app to report issues, access education, and track rewards"
        municipalAdmin -> adminWebApp "Uses web dashboard to manage operations and monitor performance"
        driver -> driverMobileApp "Uses mobile app to receive routes and report collection status"
        ecoLutionsSupport -> adminWebApp "Uses admin interface to monitor system and provide support"

        # IoT Hardware to Edge
        iotHardware -> iotGatewayApp "Sends sensor data, camera images, and status updates via MQTT"

        # Edge to Cloud
        iotGatewayApp -> edgeDB "Stores and retrieves local sensor data"
        iotGatewayApp -> messageQueue "Sends processed sensor data to cloud via MQTT/HTTP"

        # Frontend to Backend
        citizenMobileApp -> apiGateway "Makes API calls via HTTPS/REST"
        adminWebApp -> apiGateway "Makes API calls via HTTPS/REST"
        driverMobileApp -> apiGateway "Makes API calls via HTTPS/REST"

        # API Gateway to Backend
        apiGateway -> backendService "Routes all requests to main backend service"

        # Backend to Data Layer
        backendService -> mainDB "Reads from and writes to using JPA/Hibernate"
        backendService -> redisCache "Caches frequently accessed data"
        backendService -> messageQueue "Consumes IoT sensor data"

        # External System Integrations
        backendService -> paymentGateway "Processes payments via REST API"
        backendService -> emailService "Sends emails via REST API"
        backendService -> mapsAPI "Requests route calculations via REST API"
        backendService -> pushNotificationService "Sends push notifications via REST API"
        backendService -> weatherService "Retrieves weather data via REST API"
    }

    views {
        container wasteTrackSystem "WasteTrackContainers" "Container diagram showing WasteTrack internal architecture" {
            include *
            autoLayout tb
        }

        component iotGatewayApp "IoTGatewayComponents" "IoT Gateway edge application components" {
            include *
            autoLayout lr
        }

        styles {
            element "Person" {
                color #ffffff
                fontSize 22
                shape Person
                background #08427b
            }
            element "Container" {
                background #438dd5
                color #ffffff
            }
            element "Database" {
                shape Cylinder
                background #438dd5
                color #ffffff
            }
            element "Server" {
                shape RoundedBox
                background #438dd5
                color #ffffff
            }
            element "MobileApp" {
                shape MobileDeviceLandscape
                background #438dd5
                color #ffffff
            }
            element "Browser" {
                shape WebBrowser
                background #85bbf0
                color #000000
            }
            element "Edge" {
                shape RoundedBox
                background #2a9d8f
                color #ffffff
            }
            element "Gateway" {
                shape RoundedBox
                background #ff6b35
                color #ffffff
            }
            element "MessageBroker" {
                shape Pipe
                background #f4a261
                color #ffffff
            }
            element "Cache" {
                shape Component
                background #2a9d8f
                color #ffffff
            }
            element "Component" {
                background #85bbf0
                color #000000
            }
            element "External" {
                background #999999
                color #ffffff
            }
            element "Hardware" {
                background #666666
                color #ffffff
            }
        }
    }
}