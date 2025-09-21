workspace "Communication Hub BC Component Diagram" "Component diagram for Communication Hub bounded context within WasteTrack backend service" {
    model {
        # External Users and Systems
        municipalAdmin = person "Municipal Administrator" "District administrators receiving operational notifications"
        citizen = person "Citizen" "Citizens receiving service updates and alerts"
        driver = person "Collection Driver" "Drivers receiving route assignments and updates"

        # Other Bounded Contexts
        containerMonitoringBC = softwareSystem "Container Monitoring BC" "Container status and alerts service"
        routePlanningBC = softwareSystem "Route Planning BC" "Route execution and updates service"
        communityRelationsBC = softwareSystem "Community Relations BC" "Citizen engagement and rewards service"
        paymentSubscriptionsBC = softwareSystem "Payment & Subscriptions BC" "Billing and payment notifications service"
        municipalOperationsBC = softwareSystem "Municipal Operations BC" "District operations and maintenance service"

        # WasteTrack System
        wasteTrackSystem = softwareSystem "WasteTrack System" "IoT-enabled smart waste management platform" {

            # API Gateway
            apiGateway = container "API Gateway" "Routes requests and handles authentication" "AWS API Gateway" "Gateway"

            # Message Queue
            messageQueue = container "Message Queue" "Handles notification events and delivery requests" "Apache Kafka" "MessageBroker"

            # Main Backend Service with Communication Hub Components
            backendService = container "WasteTrack Backend Service" "Main monolithic service containing Communication Hub BC components" "Java Spring Boot" {

                # Interface Layer - Controllers
                notificationController = component "Notification Controller" "REST endpoints for notification management, template configuration, and delivery status tracking" "Spring @RestController" "InterfaceLayer"
                templateController = component "Template Controller" "REST endpoints for message template management and customization for different user types and scenarios" "Spring @RestController" "InterfaceLayer"
                deliveryController = component "Delivery Controller" "REST endpoints for delivery tracking, status monitoring, and channel performance analytics" "Spring @RestController" "InterfaceLayer"
                eventConsumer = component "Event Consumer" "Kafka consumer for notification events from all bounded contexts requiring multi-channel communication" "Spring @KafkaListener" "InterfaceLayer"

                # Application Layer - Services
                notificationService = component "Notification Service" "Main service orchestrating notification lifecycle, template selection, and channel routing. Uses Template Method pattern for different notification types" "Spring @Service" "ApplicationLayer"
                deliveryService = component "Delivery Service" "Manages multi-channel delivery coordination, retry logic, and fallback mechanisms. Implements Strategy pattern for channel selection" "Spring @Service" "ApplicationLayer"
                templateService = component "Template Service" "Handles message template management, personalization, and localization. Uses Builder pattern for complex message construction" "Spring @Service" "ApplicationLayer"

                # Infrastructure Layer - Repositories and External Services
                notificationRepository = component "Notification Repository" "JPA repository for notification data persistence with delivery tracking and analytics" "Spring Data JPA" "InfrastructureLayer"
                templateRepository = component "Template Repository" "JPA repository for message templates with versioning and localization support" "Spring Data JPA" "InfrastructureLayer"
                deliveryRepository = component "Delivery Repository" "JPA repository for delivery tracking with channel performance metrics" "Spring Data JPA" "InfrastructureLayer"
                cacheService = component "Cache Service" "Redis caching service for frequently used templates and delivery preferences" "Spring Cache" "InfrastructureLayer"
                emailAdapter = component "Email Service Adapter" "Integration with SendGrid email service for transactional and marketing emails" "Spring Integration" "InfrastructureLayer"
                smsAdapter = component "SMS Service Adapter" "Integration with Twilio SMS service for urgent notifications and alerts" "Spring Integration" "InfrastructureLayer"
                pushAdapter = component "Push Notification Adapter" "Integration with Firebase Cloud Messaging for mobile push notifications" "Spring Integration" "InfrastructureLayer"
            }

            # Database
            database = container "PostgreSQL Database" "Main database storing notification and template data" "PostgreSQL" "Database"

            # Cache
            redisCache = container "Redis Cache" "High-performance caching service" "Redis" "Cache"
        }

        # External Services
        sendGridService = softwareSystem "SendGrid Email Service" "Cloud email delivery service" "External"
        twilioService = softwareSystem "Twilio SMS Service" "SMS delivery service" "External"
        firebaseService = softwareSystem "Firebase Cloud Messaging" "Push notification service" "External"

        # External User Interactions
        municipalAdmin -> apiGateway "Configures notification preferences and monitors delivery via admin dashboard"
        citizen -> apiGateway "Manages notification preferences and views message history via mobile app"
        driver -> apiGateway "Receives route notifications and updates via mobile app"

        # Inter-BC Communications
        containerMonitoringBC -> messageQueue "Sends container alerts and maintenance notifications"
        routePlanningBC -> messageQueue "Sends route updates and completion notifications"
        communityRelationsBC -> messageQueue "Sends citizen engagement and rewards notifications"
        paymentSubscriptionsBC -> messageQueue "Sends billing and payment notifications"
        municipalOperationsBC -> messageQueue "Sends operational and maintenance alerts"

        # API Gateway to Controllers
        apiGateway -> notificationController "Routes notification management requests"
        apiGateway -> templateController "Routes template management requests"
        apiGateway -> deliveryController "Routes delivery tracking requests"

        # Message Queue to Event Consumer
        messageQueue -> eventConsumer "Delivers notification events from all bounded contexts"

        # Controllers to Services
        notificationController -> notificationService "Delegates notification operations"
        templateController -> templateService "Manages template operations"
        deliveryController -> deliveryService "Handles delivery tracking"
        eventConsumer -> notificationService "Processes incoming notification events"

        # Services to Repositories
        notificationService -> notificationRepository "Persists notification data"
        notificationService -> templateRepository "Retrieves message templates"
        deliveryService -> deliveryRepository "Stores delivery tracking data"
        templateService -> templateRepository "Manages template data"

        # Services to Infrastructure
        notificationService -> deliveryService "Coordinates message delivery"
        deliveryService -> emailAdapter "Sends email notifications"
        deliveryService -> smsAdapter "Sends SMS notifications"
        deliveryService -> pushAdapter "Sends push notifications"
        templateService -> cacheService "Caches frequently used templates"
        deliveryService -> cacheService "Caches delivery preferences and channel configurations"

        # Infrastructure to External
        notificationRepository -> database "Persists notification data"
        templateRepository -> database "Persists template data"
        deliveryRepository -> database "Persists delivery data"
        cacheService -> redisCache "Uses Redis for caching"
        emailAdapter -> sendGridService "Delivers emails via SendGrid API"
        smsAdapter -> twilioService "Delivers SMS via Twilio API"
        pushAdapter -> firebaseService "Delivers push notifications via Firebase"
    }

    views {
        component backendService "CommunicationHubComponents" "Communication Hub BC components within WasteTrack backend service" {
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