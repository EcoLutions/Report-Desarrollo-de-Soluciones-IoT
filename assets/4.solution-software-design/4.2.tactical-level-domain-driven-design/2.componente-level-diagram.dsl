workspace "Route Planning BC Component Diagram" "Component diagram for Route Planning bounded context within WasteTrack backend service" {
    model {
        # External Users and Systems
        driver = person "Collection Driver" "Drivers executing waste collection routes"
        municipalAdmin = person "Municipal Administrator" "District administrators managing route operations"

        # Other Bounded Contexts
        containerMonitoringBC = softwareSystem "Container Monitoring BC" "Container status and fill level service"
        municipalOperationsBC = softwareSystem "Municipal Operations BC" "District and vehicle management service"

        # WasteTrack System
        wasteTrackSystem = softwareSystem "WasteTrack System" "IoT-enabled smart waste management platform" {

            # API Gateway
            apiGateway = container "API Gateway" "Routes requests and handles authentication" "AWS API Gateway" "Gateway"

            # Message Queue
            messageQueue = container "Message Queue" "Handles route events and optimization requests" "Apache Kafka" "MessageBroker"

            # Main Backend Service with Route Planning Components
            backendService = container "WasteTrack Backend Service" "Main monolithic service containing Route Planning BC components" "Java Spring Boot" {

                # Interface Layer - Controllers
                routeController = component "Route Controller" "REST endpoints for route CRUD operations, optimization requests, and real-time updates. Handles requests from driver mobile apps and admin dashboard" "Spring @RestController" "InterfaceLayer"
                optimizationController = component "Optimization Controller" "REST endpoints for route optimization algorithms and performance metrics. Provides optimization configuration interface" "Spring @RestController" "InterfaceLayer"
                eventConsumer = component "Event Consumer" "Kafka consumer for container status updates from Container Monitoring BC and vehicle updates from Municipal Operations BC" "Spring @KafkaListener" "InterfaceLayer"

                # Application Layer - Services
                routeService = component "Route Service" "Main service orchestrating route creation, updates, assignments, and execution tracking. Uses Command pattern for route operations" "Spring @Service" "ApplicationLayer"
                optimizationService = component "Optimization Service" "Generates optimized collection routes using multiple algorithms and real-time data. Implements Strategy pattern for different optimization approaches" "Spring @Service" "ApplicationLayer"
                trackingService = component "Tracking Service" "Manages real-time route execution tracking, progress monitoring, and deviation handling. Uses State pattern for route status management" "Spring @Service" "ApplicationLayer"

                # Infrastructure Layer - Repositories and External Services
                routeRepository = component "Route Repository" "JPA repository for route persistence with geospatial queries and optimization history" "Spring Data JPA" "InfrastructureLayer"
                optimizationRepository = component "Optimization Repository" "JPA repository for optimization results and algorithm performance metrics" "Spring Data JPA" "InfrastructureLayer"
                eventPublisher = component "Event Publisher" "Publishes route events to other bounded contexts via Kafka" "Spring Kafka" "InfrastructureLayer"
                cacheService = component "Cache Service" "Redis caching service for route calculations and frequently accessed optimization data" "Spring Cache" "InfrastructureLayer"
                externalMapsService = component "External Maps Service" "Integration with Google Maps API for route calculation and traffic data" "Spring Integration" "InfrastructureLayer"
            }

            # Database
            database = container "PostgreSQL Database" "Main database storing route and optimization data" "PostgreSQL" "Database"

            # Cache
            redisCache = container "Redis Cache" "High-performance caching service" "Redis" "Cache"
        }

        # External Services
        googleMapsAPI = softwareSystem "Google Maps API" "Google Maps routing and traffic service" "External"
        weatherService = softwareSystem "Weather Service API" "Weather data for route adaptation" "External"

        # External User Interactions
        driver -> apiGateway "Receives route assignments and reports progress via mobile app"
        municipalAdmin -> apiGateway "Manages routes and monitors performance via admin dashboard"

        # Inter-BC Communications
        containerMonitoringBC -> messageQueue "Sends container fill level updates and critical alerts"
        municipalOperationsBC -> messageQueue "Sends vehicle availability and driver assignment updates"

        # API Gateway to Controllers
        apiGateway -> routeController "Routes route management requests"
        apiGateway -> optimizationController "Routes optimization requests"

        # Message Queue to Event Consumer
        messageQueue -> eventConsumer "Delivers events from other BCs and external systems"

        # Controllers to Services
        routeController -> routeService "Delegates route operations"
        optimizationController -> optimizationService "Requests route optimization"
        eventConsumer -> routeService "Handles container and vehicle updates"
        routeController -> trackingService "Updates route execution status"

        # Services to Repositories
        routeService -> routeRepository "Persists route data"
        routeService -> optimizationRepository "Stores optimization results"
        optimizationService -> routeRepository "Queries historical route data for optimization"
        optimizationService -> optimizationRepository "Stores algorithm performance metrics"
        trackingService -> routeRepository "Updates route execution status"

        # Services to Infrastructure
        optimizationService -> eventPublisher "Publishes route optimization completed events"
        trackingService -> eventPublisher "Publishes route status change events"
        optimizationService -> cacheService "Caches optimization calculations"
        optimizationService -> externalMapsService "Requests route calculations and traffic data"

        # Infrastructure to External
        routeRepository -> database "Persists route data"
        optimizationRepository -> database "Persists optimization data"
        eventPublisher -> messageQueue "Publishes events to other BCs"
        cacheService -> redisCache "Uses Redis for caching"
        externalMapsService -> googleMapsAPI "Requests route calculations via REST API"
        externalMapsService -> weatherService "Retrieves weather data for route adaptation"
    }

    views {
        component backendService "RoutePlanningComponents" "Route Planning BC components within WasteTrack backend service" {
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