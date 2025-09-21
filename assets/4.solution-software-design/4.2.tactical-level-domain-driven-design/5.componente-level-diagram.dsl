workspace "Payment & Subscriptions BC Component Diagram" "Component diagram for Payment & Subscriptions bounded context within WasteTrack backend service" {
    model {
        # External Users and Systems
        municipalAdmin = person "Municipal Administrator" "District administrators managing subscription billing"
        financeManager = person "Finance Manager" "Municipal finance managers overseeing billing and payments"
        ecoLutionsAdmin = person "EcoLutions Administrator" "Platform administrators managing customer accounts"

        # Other Bounded Contexts
        municipalOperationsBC = softwareSystem "Municipal Operations BC" "District and resource management service"
        communicationHubBC = softwareSystem "Communication Hub BC" "Multi-channel notification service"

        # WasteTrack System
        wasteTrackSystem = softwareSystem "WasteTrack System" "IoT-enabled smart waste management platform" {

            # API Gateway
            apiGateway = container "API Gateway" "Routes requests and handles authentication" "AWS API Gateway" "Gateway"

            # Message Queue
            messageQueue = container "Message Queue" "Handles payment events and billing notifications" "Apache Kafka" "MessageBroker"

            # Main Backend Service with Payment & Subscriptions Components
            backendService = container "WasteTrack Backend Service" "Main monolithic service containing Payment & Subscriptions BC components" "Java Spring Boot" {

                # Interface Layer - Controllers
                subscriptionController = component "Subscription Controller" "REST endpoints for subscription management, plan configuration, and billing cycle operations. Handles requests from admin dashboard" "Spring @RestController" "InterfaceLayer"
                paymentController = component "Payment Controller" "REST endpoints for payment processing, method management, and transaction tracking" "Spring @RestController" "InterfaceLayer"
                billingController = component "Billing Controller" "REST endpoints for invoice generation, billing history, and financial reporting" "Spring @RestController" "InterfaceLayer"
                eventConsumer = component "Event Consumer" "Kafka consumer for district setup events from Municipal Operations BC and service usage events" "Spring @KafkaListener" "InterfaceLayer"

                # Application Layer - Services
                subscriptionService = component "Subscription Service" "Main service orchestrating subscription lifecycle, plan management, and billing coordination. Uses State pattern for subscription states" "Spring @Service" "ApplicationLayer"
                paymentService = component "Payment Service" "Handles payment processing, retry logic, and transaction management. Implements Strategy pattern for different payment methods" "Spring @Service" "ApplicationLayer"
                billingService = component "Billing Service" "Manages billing cycles, invoice generation, and financial calculations. Uses Builder pattern for complex billing scenarios" "Spring @Service" "ApplicationLayer"

                # Infrastructure Layer - Repositories and External Services
                subscriptionRepository = component "Subscription Repository" "JPA repository for subscription data persistence with billing history and status tracking" "Spring Data JPA" "InfrastructureLayer"
                paymentRepository = component "Payment Repository" "JPA repository for payment transactions with audit trail and reconciliation support" "Spring Data JPA" "InfrastructureLayer"
                invoiceRepository = component "Invoice Repository" "JPA repository for invoice data with tax calculations and compliance tracking" "Spring Data JPA" "InfrastructureLayer"
                eventPublisher = component "Event Publisher" "Publishes payment and billing events to other bounded contexts via Kafka" "Spring Kafka" "InfrastructureLayer"
                cacheService = component "Cache Service" "Redis caching service for frequently accessed billing data and payment configurations" "Spring Cache" "InfrastructureLayer"
                paymentGatewayAdapter = component "Payment Gateway Adapter" "Integration with Culqi payment gateway for processing transactions in Peru" "Spring Integration" "InfrastructureLayer"
            }

            # Database
            database = container "PostgreSQL Database" "Main database storing payment and subscription data" "PostgreSQL" "Database"

            # Cache
            redisCache = container "Redis Cache" "High-performance caching service" "Redis" "Cache"
        }

        # External Services
        culqiGateway = softwareSystem "Culqi Payment Gateway" "Peruvian payment processing service" "External"
        emailService = softwareSystem "Email Service Provider" "Cloud email service for billing notifications" "External"
        taxService = softwareSystem "Tax Calculation Service" "Peruvian tax compliance service" "External"

        # External User Interactions
        municipalAdmin -> apiGateway "Manages district subscriptions and monitors billing via admin dashboard"
        financeManager -> apiGateway "Reviews financial reports and payment status via finance interface"
        ecoLutionsAdmin -> apiGateway "Manages customer accounts and billing configurations via admin portal"

        # Inter-BC Communications
        municipalOperationsBC -> messageQueue "Sends district setup and service activation events"
        communicationHubBC -> messageQueue "Requests billing notifications and payment alerts"

        # API Gateway to Controllers
        apiGateway -> subscriptionController "Routes subscription management requests"
        apiGateway -> paymentController "Routes payment processing requests"
        apiGateway -> billingController "Routes billing and invoice requests"

        # Message Queue to Event Consumer
        messageQueue -> eventConsumer "Delivers events from other BCs and external systems"

        # Controllers to Services
        subscriptionController -> subscriptionService "Delegates subscription operations"
        paymentController -> paymentService "Manages payment processing"
        billingController -> billingService "Handles billing and invoicing"
        eventConsumer -> subscriptionService "Processes district activation events"
        eventConsumer -> billingService "Updates billing based on service usage"

        # Services to Repositories
        subscriptionService -> subscriptionRepository "Persists subscription data"
        subscriptionService -> paymentRepository "Records subscription payments"
        paymentService -> paymentRepository "Stores payment transactions"
        billingService -> invoiceRepository "Manages invoice data"
        billingService -> subscriptionRepository "Updates billing cycles"

        # Services to Infrastructure
        subscriptionService -> eventPublisher "Publishes subscription lifecycle events"
        paymentService -> eventPublisher "Publishes payment completion events"
        billingService -> eventPublisher "Publishes billing cycle events"
        paymentService -> paymentGatewayAdapter "Processes payments through Culqi"
        billingService -> cacheService "Caches billing calculations and tax rates"

        # Infrastructure to External
        subscriptionRepository -> database "Persists subscription data"
        paymentRepository -> database "Persists payment data"
        invoiceRepository -> database "Persists invoice data"
        eventPublisher -> messageQueue "Publishes events to other BCs"
        cacheService -> redisCache "Uses Redis for caching"
        paymentGatewayAdapter -> culqiGateway "Processes payments via Culqi API"
        paymentGatewayAdapter -> emailService "Sends payment confirmations"
        billingService -> taxService "Calculates Peruvian taxes and compliance"
    }

    views {
        component backendService "PaymentSubscriptionsComponents" "Payment & Subscriptions BC components within WasteTrack backend service" {
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