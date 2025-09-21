workspace "IAM BC Component Diagram" "Component diagram for IAM bounded context within WasteTrack backend service" {
    model {
        # External Users and Systems
        user = person "User (Citizen, Admin, Driver)" "Any user requiring authentication"
        ecoLutionsAdmin = person "EcoLutions Administrator" "Platform administrators managing system access"

        # Other Bounded Contexts
        profileBC = softwareSystem "Profile BC" "Manages user profiles and personal data"

        # WasteTrack System
        wasteTrackSystem = softwareSystem "WasteTrack System" "IoT-enabled smart waste management platform" {

            # API Gateway
            apiGateway = container "API Gateway" "Routes authentication requests and validates tokens" "AWS API Gateway" "Gateway"

            # Message Queue
            messageQueue = container "Message Queue" "Handles user lifecycle events" "Apache Kafka" "MessageBroker"

            # Main Backend Service with IAM Components
            backendService = container "WasteTrack Backend Service" "Main monolithic service containing IAM BC components" "Java Spring Boot" {

                # Interface Layer - Controllers
                authController = component "Auth Controller" "REST endpoints for user registration, login, password reset, and token validation" "Spring @RestController" "InterfaceLayer"

                # Application Layer - Services
                iamService = component "IAM Service" "Main service orchestrating authentication, authorization, user lifecycle management, and token generation. Implements Strategy pattern for different auth providers" "Spring @Service" "ApplicationLayer"

                # Infrastructure Layer - Repositories and External Services
                userRepository = component "User Repository" "JPA repository for user credentials and role persistence with secure password hashing" "Spring Data JPA" "InfrastructureLayer"
                eventPublisher = component "Event Publisher" "Publishes user lifecycle events (e.g., UserRegistered, PasswordReset) to other BCs via Kafka" "Spring Kafka" "InfrastructureLayer"
                tokenService = component "Token Service" "Generates and validates JWTs for secure session management" "Spring Security / JJWT" "InfrastructureLayer"
                roleRepository = component "Role Repository" "JPA repository for managing user roles and permissions" "Spring Data JPA" "InfrastructureLayer"
            }

            # Database
            database = container "PostgreSQL Database" "Main database storing user credentials, roles, and permissions" "PostgreSQL" "Database"

        }

        # External Services
        emailService = softwareSystem "Email Service Provider" "Cloud email service for sending verification and password reset emails" "External"

        # External User Interactions
        user -> apiGateway "Registers, logs in, and manages credentials"
        ecoLutionsAdmin -> apiGateway "Manages system-wide roles and permissions"

        # Inter-BC Communications
        profileBC -> messageQueue "Listens for UserRegistered events to create a corresponding profile"

        # API Gateway to Controllers
        apiGateway -> authController "Routes authentication and authorization requests"

        # Controllers to Services
        authController -> iamService "Delegates all authentication and user management operations"

        # Services to Repositories
        iamService -> userRepository "Persists and retrieves user credential data"
        iamService -> roleRepository "Manages user roles and permissions"

        # Services to Infrastructure
        iamService -> eventPublisher "Publishes user lifecycle events"
        iamService -> tokenService "Requests JWT generation and validation"
        iamService -> emailService "Sends verification and password reset emails"

        # Infrastructure to External
        userRepository -> database "Persists user data"
        roleRepository -> database "Persists role data"
        eventPublisher -> messageQueue "Publishes events to other BCs"
    }

    views {
        component backendService "IAMComponents" "IAM BC components within WasteTrack backend service" {
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