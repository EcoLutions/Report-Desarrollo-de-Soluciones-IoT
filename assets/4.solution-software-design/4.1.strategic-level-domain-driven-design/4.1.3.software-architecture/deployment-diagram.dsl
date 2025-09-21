workspace "WasteTrack Deployment Diagram" "Deployment diagram showing WasteTrack infrastructure with proper grouping and connections" {
    model {
        # Define the WasteTrack System and its containers
        wasteTrackSystem = softwareSystem "WasteTrack System" "IoT-enabled smart waste management platform" {
            iotGatewayApp = container "IoT Gateway Application" "Edge application processing sensor data locally" "Python" "Edge"
            edgeDB = container "Edge SQLite Database" "Local sensor data storage" "SQLite" "Database"
            apiGateway = container "API Gateway" "Request routing and authentication" "AWS API Gateway" "Gateway"
            backendService = container "WasteTrack Backend Service" "Main application logic" "Java, Spring Boot" "Server"
            mainDB = container "PostgreSQL Database" "Application data storage" "PostgreSQL" "Database"
            redisCache = container "Redis Cache" "High-performance caching" "Redis" "Cache"
            messageQueue = container "Message Queue" "IoT data ingestion" "Apache Kafka" "MessageBroker"
            citizenMobileApp = container "Citizen Mobile App" "Mobile app for citizens" "React Native" "MobileApp"
            driverMobileApp = container "Driver Mobile App" "Mobile app for drivers" "React Native" "MobileApp"
            adminWebApp = container "Admin Web Application" "Web dashboard" "React, TypeScript" "Browser"
        }

        # External Systems
        iotHardware = softwareSystem "IoT Container Sensors" "Physical sensors in waste containers" "External,Hardware"
        paymentGateway = softwareSystem "Payment Gateway" "Culqi payment processing" "External"
        emailService = softwareSystem "Email Service" "SendGrid email delivery" "External"
        mapsAPI = softwareSystem "Maps API" "Google Maps routing" "External"
        pushService = softwareSystem "Push Service" "Firebase messaging" "External"
        weatherService = softwareSystem "Weather API" "Weather data provider" "External"

        # Container-level relationships (outside deployment)
        iotHardware -> iotGatewayApp "Transmits sensor data via MQTT/LoRaWAN"
        iotGatewayApp -> messageQueue "Sends processed data via HTTPS"
        iotGatewayApp -> edgeDB "Stores local sensor data"
        citizenMobileApp -> apiGateway "HTTPS REST API calls"
        driverMobileApp -> apiGateway "HTTPS REST API calls"
        adminWebApp -> apiGateway "HTTPS REST API calls"
        apiGateway -> backendService "Routes authenticated requests"
        backendService -> mainDB "SQL queries via connection pool"
        backendService -> redisCache "Cache operations via Redis protocol"
        backendService -> messageQueue "Consumes IoT events via Kafka"
        backendService -> paymentGateway "Payment processing via REST API"
        backendService -> emailService "Email delivery via SMTP/API"
        backendService -> mapsAPI "Route calculation via REST API"
        backendService -> pushService "Mobile notifications via FCM"
        backendService -> weatherService "Weather data via REST API"

        # Deployment Environment
        prod = deploymentEnvironment "Production" {
            
            # IoT Edge Infrastructure
            iotField = deploymentNode "IoT Field Deployment" "Container monitoring locations across Lima" "Field Infrastructure" {
                edgeGateway = deploymentNode "Edge Gateway Device" "Raspberry Pi 4 with 4GB RAM" "ARM64, 32GB Storage" {
                    edgeAppInstance = containerInstance iotGatewayApp
                    edgeDBInstance = containerInstance edgeDB
                }
            }

            # AWS Cloud Infrastructure
            awsRegion = deploymentNode "AWS South America (São Paulo)" "Primary cloud region" "AWS Region sa-east-1" {
                
                # Load Balancer Layer
                albLayer = deploymentNode "Application Load Balancer" "Traffic distribution and SSL termination" "AWS ALB" {
                    gatewayInstance = containerInstance apiGateway
                }
                
                # Compute Layer
                computeCluster = deploymentNode "ECS Fargate Cluster" "Serverless container orchestration" "AWS ECS Fargate" {
                    backendTasks = deploymentNode "Backend Service Tasks" "Auto-scaling from 2-10 instances" "ECS Tasks (2 vCPU, 4GB RAM)" {
                        backendInstance = containerInstance backendService
                    }
                }
                
                # Data Layer
                dataLayer = deploymentNode "Managed Database Services" "AWS managed data services" "AWS RDS/ElastiCache/MSK" {
                    primaryDB = deploymentNode "Primary Database" "Multi-AZ PostgreSQL instance" "RDS db.t3.large" {
                        mainDBInstance = containerInstance mainDB
                    }
                    cacheCluster = deploymentNode "Cache Cluster" "Redis for session and data caching" "ElastiCache cache.t3.medium" {
                        cacheInstance = containerInstance redisCache
                    }
                    kafkaCluster = deploymentNode "Streaming Platform" "Managed Kafka for IoT data" "MSK kafka.t3.small (3 brokers)" {
                        queueInstance = containerInstance messageQueue
                    }
                }
            }
            
            # Client Infrastructure
            mobileDevices = deploymentNode "Mobile Devices" "Android and iOS smartphones" "Mobile OS" {
                citizenPhone = deploymentNode "Citizen Smartphones" "Android/iOS devices" "React Native Runtime" {
                    citizenAppInstance = containerInstance citizenMobileApp
                }
                driverPhone = deploymentNode "Driver Smartphones" "Android/iOS devices with GPS" "React Native Runtime" {
                    driverAppInstance = containerInstance driverMobileApp
                }
            }
            
            adminWorkstations = deploymentNode "Admin Workstations" "Municipal administrator computers" "Windows/macOS/Linux" {
                adminBrowser = deploymentNode "Web Browser" "Chrome, Firefox, Safari, Edge" "Browser Runtime" {
                    adminAppInstance = containerInstance adminWebApp
                }
            }
        }
    }

    views {
        deployment wasteTrackSystem prod "ProductionDeployment" "WasteTrack Production Deployment Architecture" {
            include *
            autoLayout lr
        }

        styles {
            element "Software System" {
                background #1168bd
                color #ffffff
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
            element "Cache" {
                shape Component
                background #2a9d8f
                color #ffffff
            }
            element "MessageBroker" {
                shape Pipe
                background #f4a261
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
                background #2a9d8f
                color #ffffff
            }
            element "Gateway" {
                background #ff6b35
                color #ffffff
            }
            element "Server" {
                background #438dd5
                color #ffffff
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