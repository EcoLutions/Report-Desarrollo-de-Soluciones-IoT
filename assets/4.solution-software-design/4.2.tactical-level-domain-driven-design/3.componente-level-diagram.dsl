workspace "Municipal Operations BC Component Diagram" "Component diagram for Municipal Operations bounded context within WasteTrack backend service" {
    model {
        # External Users and Systems
        municipalAdmin = person "Municipal Administrator" "District administrators managing municipal resources"
        maintenanceManager = person "Maintenance Manager" "Managers overseeing vehicle and equipment maintenance"
        driver = person "Collection Driver" "Drivers managing their assigned vehicles and schedules"

        # Other Bounded Contexts
        routePlanningBC = softwareSystem "Route Planning BC" "Route optimization and execution service"
        paymentSubscriptionsBC = softwareSystem "Payment & Subscriptions BC" "Municipal billing and subscription service"

        # WasteTrack System
        wasteTrackSystem = softwareSystem "WasteTrack System" "IoT-enabled smart waste management platform" {

            # API Gateway
            apiGateway = container "API Gateway" "Routes requests and handles authentication" "AWS API Gateway" "Gateway"

            # Message Queue
            messageQueue = container "Message Queue" "Handles municipal operation events and resource updates" "Apache Kafka" "MessageBroker"

            # Main Backend Service with Municipal Operations Components
            backendService = container "WasteTrack Backend Service" "Main monolithic service containing Municipal Operations BC components" "Java Spring Boot" {

                # Interface Layer - Controllers
                districtController = component "District Controller" "REST endpoints for district CRUD operations, resource allocation, and performance monitoring. Handles requests from admin dashboard" "Spring @RestController" "InterfaceLayer"
                vehicleController = component "Vehicle Controller" "REST endpoints for vehicle fleet management, maintenance scheduling, and availability tracking" "Spring @RestController" "InterfaceLayer"
                driverController = component "Driver Controller" "REST endpoints for driver management, shift scheduling, and performance tracking" "Spring @RestController" "InterfaceLayer"
                eventConsumer = component "Event Consumer" "Kafka consumer for route completion events from Route Planning BC and payment events from Payment BC" "Spring @KafkaListener" "InterfaceLayer"

                # Application Layer - Services
                municipalService = component "Municipal Service" "Main service orchestrating municipal operations including district management, resource allocation, and operational coordination. Uses Command pattern" "Spring @Service" "ApplicationLayer"
                fleetService = component "Fleet Service" "Manages vehicle fleet operations, maintenance scheduling, and availability optimization. Implements Strategy pattern for maintenance policies" "Spring @Service" "ApplicationLayer"
                resourceService = component "Resource Service" "Handles resource allocation, capacity planning, and operational efficiency optimization. Uses Factory pattern for resource creation" "Spring @Service" "ApplicationLayer"

                # Infrastructure Layer - Repositories and External Services
                districtRepository = component "District Repository" "JPA repository for district data persistence with hierarchical queries and geographic boundaries" "Spring Data JPA" "InfrastructureLayer"
                vehicleRepository = component "Vehicle Repository" "JPA repository for vehicle fleet data with maintenance history and availability tracking" "Spring Data JPA" "InfrastructureLayer"
                driverRepository = component "Driver Repository" "JPA repository for driver data with performance metrics and schedule management" "Spring Data JPA" "InfrastructureLayer"
                eventPublisher = component "Event Publisher" "Publishes municipal operation events to other bounded contexts via Kafka" "Spring Kafka" "InfrastructureLayer"
                cacheService = component "Cache Service" "Redis caching service for frequently accessed municipal data and resource availability" "Spring Cache" "InfrastructureLayer"
                notificationService = component "Notification Service" "Sends operational notifications via email and SMS for maintenance alerts and schedule updates" "Spring Integration" "InfrastructureLayer"
            }

            # Database
            database = container "PostgreSQL Database" "Main database storing municipal operations data" "PostgreSQL" "Database"

            # Cache
            redisCache = container "Redis Cache" "High-performance caching service" "Redis" "Cache"
        }

        # External Services
        emailService = softwareSystem "Email Service Provider" "Cloud email service for notifications" "External"
        smsService = softwareSystem "SMS Service Provider" "SMS service for urgent notifications" "External"

        # External User Interactions
        municipalAdmin -> apiGateway "Manages districts and monitors operations via admin dashboard"
        maintenanceManager -> apiGateway "Schedules maintenance and tracks vehicle status via web interface"
        driver -> apiGateway "Updates vehicle status and reports issues via mobile app"

        # Inter-BC Communications
        routePlanningBC -> messageQueue "Sends route completion and vehicle usage events"
        paymentSubscriptionsBC -> messageQueue "Sends municipal billing and subscription status updates"

        # API Gateway to Controllers
        apiGateway -> districtController "Routes district management requests"
        apiGateway -> vehicleController "Routes vehicle fleet management requests"
        apiGateway -> driverController "Routes driver management requests"

        # Message Queue to Event Consumer
        messageQueue -> eventConsumer "Delivers events from other BCs and external systems"

        # Controllers to Services
        districtController -> municipalService "Delegates district operations"
        vehicleController -> fleetService "Manages vehicle fleet operations"
        driverController -> municipalService "Handles driver management"
        eventConsumer -> municipalService "Processes external events"
        vehicleController -> resourceService "Requests resource allocation"

        # Services to Repositories
        municipalService -> districtRepository "Persists district data"
        municipalService -> driverRepository "Stores driver information"
        fleetService -> vehicleRepository "Manages vehicle fleet data"
        resourceService -> districtRepository "Queries district resource data"
        resourceService -> vehicleRepository "Queries vehicle availability"

        # Services to Infrastructure
        municipalService -> eventPublisher "Publishes district operation events"
        fleetService -> eventPublisher "Publishes vehicle status change events"
        resourceService -> cacheService "Caches resource allocation data"
        fleetService -> notificationService "Sends maintenance and schedule notifications"

        # Infrastructure to External
        districtRepository -> database "Persists district data"
        vehicleRepository -> database "Persists vehicle data"
        driverRepository -> database "Persists driver data"
        eventPublisher -> messageQueue "Publishes events to other BCs"
        cacheService -> redisCache "Uses Redis for caching"
        notificationService -> emailService "Sends email notifications"
        notificationService -> smsService "Sends SMS alerts"
    }

    views {
        component backendService "MunicipalOperationsComponents" "Municipal Operations BC components within WasteTrack backend service" {
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