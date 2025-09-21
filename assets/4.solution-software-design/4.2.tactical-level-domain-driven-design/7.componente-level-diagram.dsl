workspace "Profile BC Component Diagram" "Component diagram for Profile bounded context within WasteTrack backend service" {
    model {
        # External Users and Systems
        citizen = person "Citizen" "Citizens managing their profiles and preferences"
        municipalAdmin = person "Municipal Administrator" "Administrators managing user profiles and system configurations"
        driver = person "Collection Driver" "Drivers managing their work profiles and preferences"
        ecoLutionsAdmin = person "EcoLutions Administrator" "Platform administrators managing user accounts and system settings"

        # Other Bounded Contexts
        iamBC = softwareSystem "IAM BC" "Identity and access management service"
        communityRelationsBC = softwareSystem "Community Relations BC" "Citizen engagement and rewards service"
        communicationHubBC = softwareSystem "Communication Hub BC" "Multi-channel notification service"

        # WasteTrack System
        wasteTrackSystem = softwareSystem "WasteTrack System" "IoT-enabled smart waste management platform" {

            # API Gateway
            apiGateway = container "API Gateway" "Routes requests and handles authentication" "AWS API Gateway" "Gateway"

            # Message Queue
            messageQueue = container "Message Queue" "Handles profile events and preference updates" "Apache Kafka" "MessageBroker"

            # Main Backend Service with Profile Components
            backendService = container "WasteTrack Backend Service" "Main monolithic service containing Profile BC components" "Java Spring Boot" {

                # Interface Layer - Controllers
                profileController = component "Profile Controller" "REST endpoints for user profile management, personal information updates, and account settings" "Spring @RestController" "InterfaceLayer"
                preferencesController = component "Preferences Controller" "REST endpoints for notification preferences, privacy settings, and communication channel management" "Spring @RestController" "InterfaceLayer"
                personalizationController = component "Personalization Controller" "REST endpoints for UI customization, language settings, and user experience personalization" "Spring @RestController" "InterfaceLayer"
                eventConsumer = component "Event Consumer" "Kafka consumer for account activation events from IAM BC and engagement updates from Community Relations BC" "Spring @KafkaListener" "InterfaceLayer"

                # Application Layer - Services
                profileService = component "Profile Service" "Main service orchestrating profile operations including creation, updates, validation, and lifecycle management. Uses Command pattern for profile operations" "Spring @Service" "ApplicationLayer"
                preferencesService = component "Preferences Service" "Manages user preferences including notifications, privacy, and communication channels. Implements Strategy pattern for preference validation" "Spring @Service" "ApplicationLayer"
                personalizationService = component "Personalization Service" "Handles UI personalization, theme management, and user experience customization. Uses Builder pattern for complex personalization configurations" "Spring @Service" "ApplicationLayer"

                # Infrastructure Layer - Repositories and External Services
                profileRepository = component "Profile Repository" "JPA repository for user profile data persistence with privacy controls and audit trail" "Spring Data JPA" "InfrastructureLayer"
                preferencesRepository = component "Preferences Repository" "JPA repository for user preferences with versioning and change tracking" "Spring Data JPA" "InfrastructureLayer"
                personalizationRepository = component "Personalization Repository" "JPA repository for personalization settings with theme and layout configurations" "Spring Data JPA" "InfrastructureLayer"
                eventPublisher = component "Event Publisher" "Publishes profile and preference events to other bounded contexts via Kafka" "Spring Kafka" "InfrastructureLayer"
                cacheService = component "Cache Service" "Redis caching service for frequently accessed profile data and preferences" "Spring Cache" "InfrastructureLayer"
                encryptionService = component "Encryption Service" "Data encryption service for sensitive personal information and privacy protection" "Spring Security" "InfrastructureLayer"
            }

            # Database
            database = container "PostgreSQL Database" "Main database storing profile and preferences data" "PostgreSQL" "Database"

            # Cache
            redisCache = container "Redis Cache" "High-performance caching service" "Redis" "Cache"
        }

        # External Services
        emailService = softwareSystem "Email Service Provider" "Cloud email service for profile-related notifications" "External"
        geocodingService = softwareSystem "Geocoding Service" "Address validation and geocoding service" "External"

        # External User Interactions
        citizen -> apiGateway "Manages personal profile, preferences, and privacy settings via mobile app"
        municipalAdmin -> apiGateway "Manages municipal administrator profiles and system preferences via admin dashboard"
        driver -> apiGateway "Manages driver profile, work preferences, and notification settings via mobile app"
        ecoLutionsAdmin -> apiGateway "Manages platform user accounts and system-wide profile configurations via admin portal"

        # Inter-BC Communications
        iamBC -> messageQueue "Sends account activation and authentication events"
        communityRelationsBC -> messageQueue "Sends engagement level updates and rewards milestone events"
        communicationHubBC -> messageQueue "Requests user preference data for notification delivery"

        # API Gateway to Controllers
        apiGateway -> profileController "Routes profile management requests"
        apiGateway -> preferencesController "Routes preference management requests"
        apiGateway -> personalizationController "Routes personalization requests"

        # Message Queue to Event Consumer
        messageQueue -> eventConsumer "Delivers events from other BCs and external systems"

        # Controllers to Services
        profileController -> profileService "Delegates profile operations"
        preferencesController -> preferencesService "Manages user preferences"
        personalizationController -> personalizationService "Handles personalization settings"
        eventConsumer -> profileService "Processes account activation events"
        eventConsumer -> preferencesService "Updates preferences based on engagement"

        # Services to Repositories
        profileService -> profileRepository "Persists profile data"
        profileService -> preferencesRepository "Updates linked preferences"
        preferencesService -> preferencesRepository "Manages preference data"
        personalizationService -> personalizationRepository "Stores personalization settings"

        # Services to Infrastructure
        profileService -> eventPublisher "Publishes profile lifecycle events"
        preferencesService -> eventPublisher "Publishes preference change events"
        profileService -> encryptionService "Encrypts sensitive personal data"
        preferencesService -> cacheService "Caches frequently accessed preferences"
        personalizationService -> cacheService "Caches UI personalization settings"

        # Infrastructure to External
        profileRepository -> database "Persists profile data"
        preferencesRepository -> database "Persists preferences data"
        personalizationRepository -> database "Persists personalization data"
        eventPublisher -> messageQueue "Publishes events to other BCs"
        cacheService -> redisCache "Uses Redis for caching"
        encryptionService -> emailService "Sends encrypted profile notifications"
        profileService -> geocodingService "Validates and geocodes addresses"
    }

    views {
        component backendService "ProfileComponents" "Profile BC components within WasteTrack backend service" {
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