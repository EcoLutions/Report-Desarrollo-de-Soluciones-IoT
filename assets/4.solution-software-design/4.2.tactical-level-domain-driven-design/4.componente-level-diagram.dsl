workspace "Community Relations BC Component Diagram" "Component diagram for Community Relations bounded context within WasteTrack backend service" {
    model {
        # External Users and Systems
        citizen = person "Citizen" "Lima residents engaging with municipal waste services"
        communityLeader = person "Community Leader" "Local leaders coordinating community initiatives"
        municipalAdmin = person "Municipal Administrator" "Administrators managing citizen engagement programs"

        # Other Bounded Contexts
        containerMonitoringBC = softwareSystem "Container Monitoring BC" "Container status and monitoring service"
        routePlanningBC = softwareSystem "Route Planning BC" "Route planning and execution service"

        # WasteTrack System
        wasteTrackSystem = softwareSystem "WasteTrack System" "IoT-enabled smart waste management platform" {

            # API Gateway
            apiGateway = container "API Gateway" "Routes requests and handles authentication" "AWS API Gateway" "Gateway"

            # Message Queue
            messageQueue = container "Message Queue" "Handles community events and citizen notifications" "Apache Kafka" "MessageBroker"

            # Main Backend Service with Community Relations Components
            backendService = container "WasteTrack Backend Service" "Main monolithic service containing Community Relations BC components" "Java Spring Boot" {

                # Interface Layer - Controllers
                citizenController = component "Citizen Controller" "REST endpoints for citizen registration, profile management, and service requests. Handles requests from citizen mobile app" "Spring @RestController" "InterfaceLayer"
                reportController = component "Report Controller" "REST endpoints for citizen problem reports, status tracking, and feedback management" "Spring @RestController" "InterfaceLayer"
                rewardsController = component "Rewards Controller" "REST endpoints for rewards program management, points tracking, and redemption processes" "Spring @RestController" "InterfaceLayer"
                eventConsumer = component "Event Consumer" "Kafka consumer for container status updates and route completion events from other BCs" "Spring @KafkaListener" "InterfaceLayer"

                # Application Layer - Services
                citizenService = component "Citizen Service" "Main service orchestrating citizen operations including registration, profile management, and engagement tracking. Uses Command pattern" "Spring @Service" "ApplicationLayer"
                reportService = component "Report Service" "Manages citizen problem reports, validation, routing to appropriate services, and feedback loops. Implements State pattern for report lifecycle" "Spring @Service" "ApplicationLayer"
                rewardsService = component "Rewards Service" "Handles rewards program logic, points calculation, redemption processes, and gamification features. Uses Strategy pattern for reward calculations" "Spring @Service" "ApplicationLayer"

                # Infrastructure Layer - Repositories and External Services
                citizenRepository = component "Citizen Repository" "JPA repository for citizen data persistence with engagement history and preferences" "Spring Data JPA" "InfrastructureLayer"
                reportRepository = component "Report Repository" "JPA repository for citizen reports with geospatial queries and status tracking" "Spring Data JPA" "InfrastructureLayer"
                rewardsRepository = component "Rewards Repository" "JPA repository for rewards data with points history and redemption tracking" "Spring Data JPA" "InfrastructureLayer"
                eventPublisher = component "Event Publisher" "Publishes community events to other bounded contexts via Kafka" "Spring Kafka" "InfrastructureLayer"
                cacheService = component "Cache Service" "Redis caching service for frequently accessed citizen data and rewards calculations" "Spring Cache" "InfrastructureLayer"
                notificationService = component "Notification Service" "Sends citizen notifications via email, SMS, and push notifications for reports and rewards" "Spring Integration" "InfrastructureLayer"
            }

            # Database
            database = container "PostgreSQL Database" "Main database storing community relations data" "PostgreSQL" "Database"

            # Cache
            redisCache = container "Redis Cache" "High-performance caching service" "Redis" "Cache"
        }

        # External Services
        emailService = softwareSystem "Email Service Provider" "Cloud email service for citizen communications" "External"
        smsService = softwareSystem "SMS Service Provider" "SMS service for urgent citizen notifications" "External"
        pushService = softwareSystem "Push Notification Service" "Firebase messaging for mobile notifications" "External"

        # External User Interactions
        citizen -> apiGateway "Reports problems, tracks rewards, and engages with services via mobile app"
        communityLeader -> apiGateway "Coordinates community initiatives and monitors neighborhood reports"
        municipalAdmin -> apiGateway "Manages citizen engagement programs and monitors community feedback"

        # Inter-BC Communications
        containerMonitoringBC -> messageQueue "Sends container status updates and maintenance alerts"
        routePlanningBC -> messageQueue "Sends route completion events and collection confirmations"

        # API Gateway to Controllers
        apiGateway -> citizenController "Routes citizen management requests"
        apiGateway -> reportController "Routes problem reporting requests"
        apiGateway -> rewardsController "Routes rewards program requests"

        # Message Queue to Event Consumer
        messageQueue -> eventConsumer "Delivers events from other BCs and external systems"

        # Controllers to Services
        citizenController -> citizenService "Delegates citizen operations"
        reportController -> reportService "Manages problem reports and feedback"
        rewardsController -> rewardsService "Handles rewards and gamification"
        eventConsumer -> reportService "Updates report status from container events"
        eventConsumer -> rewardsService "Awards points from collection events"

        # Services to Repositories
        citizenService -> citizenRepository "Persists citizen data"
        citizenService -> rewardsRepository "Updates citizen reward points"
        reportService -> reportRepository "Stores and tracks citizen reports"
        reportService -> citizenRepository "Updates citizen engagement metrics"
        rewardsService -> rewardsRepository "Manages rewards and redemptions"

        # Services to Infrastructure
        reportService -> eventPublisher "Publishes report events to other BCs"
        rewardsService -> eventPublisher "Publishes rewards achievement events"
        citizenService -> cacheService "Caches citizen profiles and preferences"
        reportService -> notificationService "Sends report status notifications"
        rewardsService -> notificationService "Sends rewards and achievement notifications"

        # Infrastructure to External
        citizenRepository -> database "Persists citizen data"
        reportRepository -> database "Persists report data"
        rewardsRepository -> database "Persists rewards data"
        eventPublisher -> messageQueue "Publishes events to other BCs"
        cacheService -> redisCache "Uses Redis for caching"
        notificationService -> emailService "Sends email notifications"
        notificationService -> smsService "Sends SMS alerts"
        notificationService -> pushService "Sends push notifications"
    }

    views {
        component backendService "CommunityRelationsComponents" "Community Relations BC components within WasteTrack backend service" {
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