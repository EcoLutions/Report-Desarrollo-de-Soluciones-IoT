workspace "WasteTrack Context Diagram" "Context diagram showing WasteTrack system and its direct interactions" {
    model {
        # Primary Users
        citizen = person "Citizen" "Lima residents who report waste issues, access educational content, and participate in rewards program"
        municipalAdmin = person "Municipal Administrator" "District administrators who manage waste collection operations, configure schedules, and monitor performance"
        driver = person "Collection Driver" "Vehicle operators who receive route assignments, navigate collection routes, and report completion status"
        ecoLutionsSupport = person "EcoLutions Support Staff" "Technical support team who monitors system health, provides customer support, and manages platform operations"

        # WasteTrack System (as black box)
        wasteTrackSystem = softwareSystem "WasteTrack System" "IoT-enabled smart waste management platform providing collection optimization, citizen engagement, and municipal operations management"

        # External Systems
        iotSensors = softwareSystem "IoT Container Sensors" "Physical sensors deployed in waste containers that monitor fill levels, detect overflows, and report status" "External,Hardware"
        paymentGateway = softwareSystem "Payment Gateway (Culqi)" "Peruvian payment processing service for handling municipal subscription billing and transactions" "External"
        emailService = softwareSystem "Email Service Provider" "Cloud email service for sending transactional emails, notifications, and administrative communications" "External"
        mapsAPI = softwareSystem "Google Maps API" "Mapping and navigation service providing route calculation, traffic data, and GPS navigation" "External"
        pushNotificationService = softwareSystem "Push Notification Service" "Firebase Cloud Messaging service for sending mobile notifications and alerts" "External"
        weatherService = softwareSystem "Weather Service API" "Weather data provider for route planning adaptation and operational scheduling" "External"

        # User interactions with WasteTrack
        citizen -> wasteTrackSystem "Reports container problems, accesses educational content, tracks reward points, and receives collection notifications using mobile app"
        municipalAdmin -> wasteTrackSystem "Manages district operations, configures collection schedules, monitors performance metrics, and handles billing using web dashboard"
        driver -> wasteTrackSystem "Receives route assignments, navigates optimized routes, reports collection status, and handles emergency insertions using mobile app"
        ecoLutionsSupport -> wasteTrackSystem "Monitors system performance, provides customer support, manages user accounts, and oversees platform operations using admin interface"

        # External system interactions
        iotSensors -> wasteTrackSystem "Transmits fill level data, sensor health status, overflow alerts, and environmental conditions"
        wasteTrackSystem -> paymentGateway "Processes subscription payments, handles billing cycles, manages payment methods, and processes refunds"
        wasteTrackSystem -> emailService "Sends welcome emails, payment notifications, system alerts, educational content, and administrative communications"
        wasteTrackSystem -> mapsAPI "Requests route calculations, retrieves traffic data, obtains GPS navigation instructions, and validates addresses"
        wasteTrackSystem -> pushNotificationService "Sends critical alerts, route updates, collection reminders, and reward notifications to mobile devices"
        wasteTrackSystem -> weatherService "Retrieves weather forecasts, precipitation data, and severe weather alerts for route planning adaptation"
    }

    views {
        systemContext wasteTrackSystem "WasteTrackContext" "Context diagram showing WasteTrack system and its environment" {
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
            element "Software System" {
                background #1168bd
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