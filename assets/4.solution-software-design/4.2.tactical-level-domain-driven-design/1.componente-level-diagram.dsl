workspace "Container Monitoring BC Component Diagram" "Component diagram for Container Monitoring bounded context within WasteTrack backend service" {
    model {
        # External Users and Systems
        citizen = person "Citizen" "Lima residents reporting container issues"
        municipalAdmin = person "Municipal Administrator" "District administrators monitoring containers"
        iotSensors = person "IoT Sensors" "Physical sensors in waste containers"

        # Other Bounded Contexts
        routePlanningBC = softwareSystem "Route Planning BC" "Route optimization service"
        communityRelationsBC = softwareSystem "Community Relations BC" "Citizen engagement service"

        # WasteTrack System
        wasteTrackSystem = softwareSystem "WasteTrack System" "IoT-enabled smart waste management platform" {

            # API Gateway
            apiGateway = container "API Gateway" "Routes requests and handles authentication" "AWS API Gateway" "Gateway"

            # Message Queue
            messageQueue = container "Message Queue" "Handles IoT sensor data and events" "Apache Kafka" "MessageBroker"

            # Main Backend Service with Container Monitoring Components
            backendService = container "WasteTrack Backend Service" "Main monolithic service containing Container Monitoring BC components" "Java Spring Boot" {

                # Interface Layer - Controllers
                containerController = component "Container Controller" "REST endpoints for container CRUD operations, status queries, and analytics. Handles requests from admin dashboard and mobile apps" "Spring @RestController" "InterfaceLayer"
                sensorDataController = component "Sensor Data Controller" "REST endpoints for receiving IoT sensor data from message queue. Validates and processes sensor readings" "Spring @RestController" "InterfaceLayer"
                eventConsumer = component "Event Consumer" "Kafka consumer for container events from Route Planning BC and Community Relations BC" "Spring @KafkaListener" "InterfaceLayer"

                # Application Layer - Services
                containerService = component "Container Service" "Main service orchestrating container operations including creation, updates, and status management. Uses Facade pattern" "Spring @Service" "ApplicationLayer"
                analyticsService = component "Analytics Service" "Generates container fill level analytics, usage patterns, and predictive insights. Implements Builder pattern" "Spring @Service" "ApplicationLayer"
                alertService = component "Alert Service" "Manages container alerts for overflow warnings and sensor malfunctions. Uses Observer pattern" "Spring @Service" "ApplicationLayer"

                # Infrastructure Layer - Repositories and External Services
                containerRepository = component "Container Repository" "JPA repository for container persistence with custom queries for analytics" "Spring Data JPA" "InfrastructureLayer"
                sensorRepository = component "Sensor Repository" "JPA repository for sensor readings with time-series optimization" "Spring Data JPA" "InfrastructureLayer"
                eventPublisher = component "Event Publisher" "Publishes container events to other bounded contexts via Kafka" "Spring Kafka" "InfrastructureLayer"
                cacheService = component "Cache Service" "Redis caching service for frequently accessed container data" "Spring Cache" "InfrastructureLayer"
                notificationService = component "Notification Service" "Sends alerts via email and push notifications using external services" "Spring Integration" "InfrastructureLayer"
            }

            # Database
            database = container "PostgreSQL Database" "Main database storing container and sensor data" "PostgreSQL" "Database"

            # Cache
            redisCache = container "Redis Cache" "High-performance caching service" "Redis" "Cache"
        }

        # External Services
        emailService = softwareSystem "Email Service Provider" "Cloud email service" "External"
        pushService = softwareSystem "Push Notification Service" "Firebase messaging service" "External"

        # External User Interactions
        citizen -> apiGateway "Reports container problems via mobile app"
        municipalAdmin -> apiGateway "Monitors containers via admin dashboard"
        iotSensors -> messageQueue "Sends sensor data via MQTT"

        # Inter-BC Communications
        routePlanningBC -> apiGateway "Requests container priority data"
        communityRelationsBC -> messageQueue "Sends citizen problem reports"

        # API Gateway to Controllers
        apiGateway -> containerController "Routes container requests"
        apiGateway -> sensorDataController "Routes sensor data requests"

        # Message Queue to Event Consumer
        messageQueue -> eventConsumer "Delivers events from other BCs and IoT data"

        # Controllers to Services
        containerController -> containerService "Delegates container operations"
        sensorDataController -> containerService "Processes sensor data"
        eventConsumer -> containerService "Handles external events"
        containerController -> analyticsService "Requests analytics generation"

        # Services to Repositories
        containerService -> containerRepository "Persists container data"
        containerService -> sensorRepository "Stores sensor readings"
        analyticsService -> containerRepository "Queries container data for analytics"
        analyticsService -> sensorRepository "Queries sensor data for trends"

        # Services to Infrastructure
        alertService -> eventPublisher "Publishes critical alert events"
        analyticsService -> cacheService "Caches analytics results"
        alertService -> notificationService "Sends critical notifications"

        # Infrastructure to External
        containerRepository -> database "Persists container data"
        sensorRepository -> database "Persists sensor readings"
        eventPublisher -> messageQueue "Publishes events to other BCs"
        cacheService -> redisCache "Uses Redis for caching"
        notificationService -> emailService "Sends email alerts"
        notificationService -> pushService "Sends push notifications"
    }

    views {
        component backendService "ContainerMonitoringComponents" "Container Monitoring BC components within WasteTrack backend service" {
            include *
            autoLayout tb
        }

        styles {
            element "Person" {
                shape Person
                background "#1976d2"
                color "#ffffff"
            }
            element "Software System" {
                background "#757575"
                color "#ffffff"
            }
            element "External" {
                background "#999999"
                color "#ffffff"
            }
            element "Container" {
                background "#438dd5"
                color "#ffffff"
            }
            # Database - Red with Cylinder shape
            element "Database" {
                shape Cylinder
                background "#f44336"
                color "#ffffff"
            }
            # Cache - Orange with Component shape
            element "Cache" {
                shape Component
                background "#ff9800"
                color "#ffffff"
            }
            # Message Broker - Purple with Pipe shape
            element "MessageBroker" {
                shape Pipe
                background "#9c27b0"
                color "#ffffff"
            }
            # API Gateway - Orange with RoundedBox
            element "Gateway" {
                shape RoundedBox
                background "#ff6b35"
                color "#ffffff"
            }
            # Interface Layer - Light Green
            element "InterfaceLayer" {
                background "#c8e6c9"
                color "#000000"
                shape RoundedBox
            }
            # Application Layer - Medium Green
            element "ApplicationLayer" {
                background "#81c784"
                color "#000000"
                shape RoundedBox
            }
            # Infrastructure Layer - Dark Green
            element "InfrastructureLayer" {
                background "#4caf50"
                color "#ffffff"
                shape RoundedBox
            }
            # Default Component styling
            element "Component" {
                background "#e8f5e8"
                color "#000000"
                shape RoundedBox
            }
        }
    }
}