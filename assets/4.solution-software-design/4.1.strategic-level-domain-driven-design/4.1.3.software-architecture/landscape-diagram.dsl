workspace "WasteTrack System Landscape" "System Landscape diagram for WasteTrack within Lima Metropolitan ecosystem" {
    model {
        # External People
        citizens = person "Citizens of Lima" "Residents of Lima Metropolitana who generate waste and interact with municipal services"
        minamOfficials = person "MINAM Officials" "Ministry of Environment officials monitoring waste management compliance"
        ecoLutionsSupport = person "EcoLutions Support Staff" "EcoLutions technical support and customer success team"

        # External Systems
        emailService = softwareSystem "Email Service" "Cloud-based email service provider for transactional emails" "External"
        paymentGateway = softwareSystem "Payment Gateway (Culqi)" "Payment processing service for subscription billing in Peru" "External"
        mapsAPI = softwareSystem "Google Maps API" "Mapping and navigation services for route optimization" "External"
        pushNotificationService = softwareSystem "Firebase Cloud Messaging" "Push notification service for mobile devices" "External"
        weatherAPI = softwareSystem "Weather Service API" "Weather data service for route planning adaptation" "External"
        iotHardware = softwareSystem "IoT Container Sensors" "Physical IoT sensors deployed in waste containers for monitoring fill levels" "External,Hardware"

        # Lima Metropolitan Enterprise
        group "Lima Metropolitan Government" {
            municipalAdmins = person "Municipal Administrators" "District administrators responsible for waste management operations"
            drivers = person "Collection Drivers" "Vehicle operators who execute waste collection routes"
            emergencyPersonnel = person "Emergency Response Personnel" "Serenazgo and municipal emergency response teams"

            # Core WasteTrack System
            wasteTrackSystem = softwareSystem "WasteTrack System" "IoT-enabled smart waste management platform providing collection optimization and citizen engagement"
            
            # Government Systems
            seaceSystem = softwareSystem "SEACE System" "Electronic System for Government Procurement managing municipal contracts"
            siafSystem = softwareSystem "SIAF System" "Integrated Financial Administration System for municipal budget management"
            reniecSystem = softwareSystem "RENIEC System" "National Registry of Identification and Civil Status for citizen verification"
            siatSystem = softwareSystem "SIAT System" "Tax Administration Information System for municipal revenue management"
            sigaSystem = softwareSystem "SIGA System" "Administrative Management Information System for municipal processes"
            trafficSystem = softwareSystem "Metropolitan Traffic Management System" "Lima traffic coordination and urban mobility system"
            environmentalSystem = softwareSystem "Environmental Monitoring System" "Municipal environmental data collection and compliance tracking"
            publicHealthSystem = softwareSystem "Public Health Department System" "Health monitoring and epidemiological surveillance system"
            citizenPortal = softwareSystem "Lima Municipality Citizen Portal" "Unified digital services platform for citizen-government interaction"
            emergencySystem = softwareSystem "Emergency Response Coordination System" "Integrated emergency management and response coordination"
        }

        # External relationships
        citizens -> wasteTrackSystem "Reports waste issues, accesses education content, and tracks rewards using"
        citizens -> citizenPortal "Accesses broader municipal services using"
        ecoLutionsSupport -> wasteTrackSystem "Monitors, maintains, and provides customer support for"
        minamOfficials -> wasteTrackSystem "Monitors environmental compliance and waste management performance using"
        
        # Internal user relationships
        municipalAdmins -> wasteTrackSystem "Manages district operations, configures schedules, and monitors performance using"
        municipalAdmins -> siafSystem "Manages waste management budgets and expenditures using"
        municipalAdmins -> sigaSystem "Handles administrative processes and approvals using"
        drivers -> wasteTrackSystem "Receives route assignments, navigation guidance, and reports collection status using"
        emergencyPersonnel -> emergencySystem "Coordinates emergency responses using"
        
        # IoT and External Service Integrations
        iotHardware -> wasteTrackSystem "Transmits fill level data, sensor status, and environmental conditions to"
        wasteTrackSystem -> emailService "Sends transactional emails and notifications using"
        wasteTrackSystem -> paymentGateway "Processes municipal subscription payments using"
        wasteTrackSystem -> mapsAPI "Calculates optimal routes and provides navigation using"
        wasteTrackSystem -> pushNotificationService "Sends mobile notifications and alerts using"
        wasteTrackSystem -> weatherAPI "Adapts collection schedules based on weather conditions using"
        
        # Government System Integrations
        wasteTrackSystem -> siafSystem "Integrates billing data and budget reporting with"
        wasteTrackSystem -> trafficSystem "Coordinates route optimization with traffic management using"
        wasteTrackSystem -> environmentalSystem "Reports waste management metrics and environmental impact to"
        wasteTrackSystem -> reniecSystem "Validates citizen identity for service registration using"
        wasteTrackSystem -> emergencySystem "Sends critical waste-related alerts and coordinates emergency responses with"
        wasteTrackSystem -> publicHealthSystem "Reports health-risk waste incidents and contamination alerts to"
        
        # Inter-government system relationships
        citizenPortal -> wasteTrackSystem "Provides integrated access to waste management services through"
        siafSystem -> siatSystem "Exchanges financial data and tax information with"
        seaceSystem -> siafSystem "Reports procurement expenses and contract payments to"
        environmentalSystem -> publicHealthSystem "Shares environmental health data with"
    }

    views {
        systemLandscape "SystemLandscape" "System Landscape diagram showing WasteTrack within Lima Metropolitan ecosystem" {
            include *
            autoLayout lr
        }

        styles {
            element "Person" {
                color #ffffff
                fontSize 22
                shape Person
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