<body>
    <div style="text-align: center; font-weight: bolder">
        <p>Universidad Peruana de Ciencias Aplicadas - Ingeniería de Software - 7 Ciclo</p>
        <img src="assets/0.cover/logo-upc.png" alt="logo of UPC"/>
        <p>1ASI0572 - Desarrollo de Soluciones IOT</p>
        <p>Sección - 3414</p>
        <p>Docente: Ing. Marco Antonio Leon Baca</p>   
        <p>Informe de Trabajo Final<p>
        <p>Startup: EcoLutions</p>
        <p>Producto: WasteTrack</p>
    </div>
    <div style="text-align: center; display: flex; flex-direction: column; align-items: center">
        <h3 style="font-weight: bolder">Integrantes del equipo:</h3>
        <table style="width: fit-content">
            <tr>
                <th style="text-align:start;">Estudiante</th>
                <th style="text-align:center;">Código</th>
            </tr>
            <tr>
                <td style="text-align:start;">Gutiérrez Soto, Jhosepmyr Orlando</td>
                <td>202317638</td>
            </tr>
            <tr>
                <td style="text-align:start;">Hernández Tuiro, Eric Ernesto</td>
                <td>20221C857</td>
            </tr>
            <tr>
                <td style="text-align:start;">Rivadeneyra Ramos, Joaquin David</td>
                <td>202211846</td>
            </tr>
            <tr>
                <td style="text-align:start;">Riva Rodríguez, Elmer Augusto</td>
                <td>202220829</td>
            <tr>
              <td style="text-align:start;">Rojas Ccama, Carlos Andrés</td>
              <td>202114657</td>
            </tr>
        </table>
    </div>
    <p style="text-align: center">Septiembre 2025</p>
</body>

<div style="page-break-before: always"></div>


# Registro de Versiones del Informe

| Versión | Fecha      | Autor                             | Descripción de modificación |
|---------|------------|-----------------------------------|-----------------------------|

<div style="page-break-before: always"></div>

# Project Report Collaboration Insights

En esta sección se documenta la colaboración del equipo en la elaboración del informe, mostrando evidencias gráficas de la actividad en GitHub y su coherencia con el registro de versiones.

* URL del repositorio del Project Report en la organización de GitHub del equipo:
* [https://github.com/EcoLutions/Report-Desarrollo-de-Soluciones-IoT](https://github.com/EcoLutions/Report-Desarrollo-de-Soluciones-IoT)

<div style="page-break-before: always"></div>

# Contenido

<!-- TOC -->
* [Registro de Versiones del Informe](#registro-de-versiones-del-informe)
* [Project Report Collaboration Insights](#project-report-collaboration-insights)
* [Contenido](#contenido)
* [Student Outcome](#student-outcome)
* [Capítulo I: Introducción](#capítulo-i-introducción)
  * [1.1. Startup Profile](#11-startup-profile)
    * [1.1.1. Descripción de la Startup](#111-descripción-de-la-startup)
    * [1.1.2. Perfiles de integrantes del equipo](#112-perfiles-de-integrantes-del-equipo)
  * [1.2. Solution Profile](#12-solution-profile)
    * [1.2.1. Antecedentes y problemática](#121-antecedentes-y-problemática)
    * [1.2.2. Lean UX Process](#122-lean-ux-process)
      * [1.2.2.1. Lean UX Problem Statements](#1221-lean-ux-problem-statements)
      * [1.2.2.2. Lean UX Assumptions](#1222-lean-ux-assumptions)
      * [1.2.2.3. Lean UX Hypothesis Statements](#1223-lean-ux-hypothesis-statements)
      * [1.2.2.4. Lean UX Canvas](#1224-lean-ux-canvas)
  * [1.3. Segmentos objetivos](#13-segmentos-objetivos)
* [Capítulo II: Requirements Elicitation & Analysis](#capítulo-ii-requirements-elicitation--analysis)
  * [2.1. Competidores](#21-competidores)
    * [2.1.1. Análisis competitivo](#211-análisis-competitivo)
    * [2.1.2. Estrategias y tácticas frente a competidores](#212-estrategias-y-tácticas-frente-a-competidores)
  * [2.2. Entrevistas](#22-entrevistas)
    * [2.2.1. Diseño de entrevistas](#221-diseño-de-entrevistas)
    * [2.2.2. Registro de entrevistas](#222-registro-de-entrevistas)
    * [2.2.3. Análisis de entrevistas](#223-análisis-de-entrevistas)
  * [2.3. Need finding](#23-need-finding)
    * [2.3.1. User personas](#231-user-personas)
    * [2.3.2. User Task Matrix](#232-user-task-matrix)
    * [2.3.3. User Journey Mapping](#233-user-journey-mapping)
    * [2.3.4. Empathy Mapping](#234-empathy-mapping)
  * [2.4. Big Picture EventStorming](#24-big-picture-eventstorming)
    * [2.4.1. Introduction and Methodology](#241-introduction-and-methodology)
    * [2.4.2. Session Process](#242-session-process)
    * [2.4.3. Resultados Obtenidos](#243-resultados-obtenidos)
    * [2.4.4. Results Obtained](#244-results-obtained)
  * [2.5. Ubiquitous Language](#25-ubiquitous-language)
* [Capítulo III: Requirements Specification](#capítulo-iii-requirements-specification)
  * [3.1. User Stories](#31-user-stories)
  * [3.2. Impact Mapping](#32-impact-mapping)
  * [3.3. Product Backlog](#33-product-backlog)
* [Capítulo IV: Solution Software Design](#capítulo-iv-solution-software-design)
  * [4.1. Strategic-Level Domain-Driven Design](#41-strategic-level-domain-driven-design)
    * [4.1.1. Design-Level EventStorming](#411-design-level-eventstorming)
      * [4.1.1.1. Candidate Context Discovery](#4111-candidate-context-discovery)
      * [4.1.1.2. Domain Message Flows Modeling](#4112-domain-message-flows-modeling)
      * [4.1.1.3. Bounded Context Canvases](#4113-bounded-context-canvases)
    * [4.1.2. Context Mapping](#412-context-mapping)
    * [4.1.3. Software Architecture](#413-software-architecture)
      * [4.1.3.1. Software Architecture System Landscape Diagram](#4131-software-architecture-system-landscape-diagram)
      * [4.1.3.2. Software Architecture Context Level Diagrams](#4132-software-architecture-context-level-diagrams)
      * [4.1.3.3. Software Architecture Container Level Diagrams](#4133-software-architecture-container-level-diagrams)
      * [4.1.3.4. Software Architecture Deployment Diagrams](#4134-software-architecture-deployment-diagrams)
  * [4.2. Tactical-Level Domain-Driven Design](#42-tactical-level-domain-driven-design)
    * [4.2.1. Bounded Context: <Bounded Context Name>](#421-bounded-context-bounded-context-name)
      * [4.2.1.1. Domain Layer](#4211-domain-layer)
      * [4.2.1.2. Interface Layer](#4212-interface-layer)
      * [4.2.1.3. Application Layer](#4213-application-layer)
      * [4.2.1.4. Infrastructure Layer](#4214-infrastructure-layer)
      * [4.2.1.5. Bounded Context Software Architecture Component Level Diagrams](#4215-bounded-context-software-architecture-component-level-diagrams)
      * [4.2.1.6. Bounded Context Software Architecture Code Level Diagrams](#4216-bounded-context-software-architecture-code-level-diagrams)
        * [4.2.1.6.1. Bounded Context Domain Layer Class Diagrams](#42161-bounded-context-domain-layer-class-diagrams)
        * [4.2.1.6.2. Bounded Context Database Design Diagram](#42162-bounded-context-database-design-diagram)
    * [4.2.2. Bounded Context: <Bounded Context Name>](#422-bounded-context-bounded-context-name)
      * [4.2.2.1. Domain Layer](#4221-domain-layer)
      * [4.2.2.2. Interface Layer](#4222-interface-layer)
      * [4.2.2.3. Application Layer](#4223-application-layer)
      * [4.2.2.4. Infrastructure Layer](#4224-infrastructure-layer)
      * [4.2.2.5. Bounded Context Software Architecture Component Level Diagrams](#4225-bounded-context-software-architecture-component-level-diagrams)
      * [4.2.2.6. Bounded Context Software Architecture Code Level Diagrams](#4226-bounded-context-software-architecture-code-level-diagrams)
        * [4.2.2.6.1. Bounded Context Domain Layer Class Diagrams](#42261-bounded-context-domain-layer-class-diagrams)
        * [4.2.2.6.2. Bounded Context Database Design Diagram](#42262-bounded-context-database-design-diagram)
* [Capítulo V: Solution UI/UX Design](#capítulo-v-solution-uiux-design)
  * [5.1. Style Guidelines](#51-style-guidelines)
    * [5.1.1. General Style Guidelines](#511-general-style-guidelines)
    * [5.1.2. Web, Mobile and IoT Style Guidelines](#512-web-mobile-and-iot-style-guidelines)
  * [5.2. Information Architecture](#52-information-architecture)
    * [5.2.1. Organization Systems](#521-organization-systems)
    * [5.2.2. Labeling Systems](#522-labeling-systems)
    * [5.2.3. SEO Tags and Meta Tags](#523-seo-tags-and-meta-tags)
    * [5.2.4. Searching Systems](#524-searching-systems)
    * [5.2.5. Navigation Systems](#525-navigation-systems)
  * [5.3. Landing Page UI Design](#53-landing-page-ui-design)
    * [5.3.1. Landing Page Wireframe](#531-landing-page-wireframe)
    * [5.3.2. Landing Page Mock-up](#532-landing-page-mock-up)
  * [5.4. Applications UX/UI Design](#54-applications-uxui-design)
    * [5.4.1. Applications Wireframes](#541-applications-wireframes)
    * [5.4.2. Applications Wire flow Diagrams](#542-applications-wire-flow-diagrams)
    * [5.4.3. Applications Mock-ups](#543-applications-mock-ups)
    * [5.4.4. Applications User Flow Diagrams](#544-applications-user-flow-diagrams)
  * [5.5. Applications Prototyping](#55-applications-prototyping)
* [Conclusiones](#conclusiones)
* [Bibliografía](#bibliografía)
* [Anexos](#anexos)
  * [Anexo A: Enlaces de Herramientas Colaborativas](#anexo-a-enlaces-de-herramientas-colaborativas)
    * [A.1 Big Picture Event Storming - Workspace Figma](#a1-big-picture-event-storming---workspace-figma)
<!-- TOC -->

<div style="page-break-before: always"></div>

# Student Outcome

El curso contribuye al cumplimiento del Student Outcome ABET:

****ABET - EAC - Student Outcome 5****

**Criterio:** La capacidad de funcionar efectivamente en un equipo cuyos miembros juntos proporcionan liderazgo, crean un entorno de colaboración e inclusivo, establecen objetivos, planifican tareas y cumplen objetivos.

En el siguiente cuadro se describe las acciones realizadas y enunciados de conclusiones por parte del grupo, que permiten sustentar el haber alcanzado el logro del ABET – EAC - Student Outcome 5.

| **Criterio específico**                                                                             | **Acciones realizadas** | **Conclusiones** |
|-----------------------------------------------------------------------------------------------------|-------------------------|------------------|  
| **Trabaja en equipo para proporcionar liderazgo en forma conjunta.**                                |                         |                  |
| **Crea un entorno colaborativo e inclusivo, establece metas, planifica tareas y cumple objetivos.** |                         |                  |

<div style="page-break-before: always"></div>

# Capítulo I: Introducción

## 1.1. Startup Profile

### 1.1.1. Descripción de la Startup

### 1.1.2. Perfiles de integrantes del equipo

## 1.2. Solution Profile

### 1.2.1. Antecedentes y problemática

### 1.2.2. Lean UX Process

#### 1.2.2.1. Lean UX Problem Statements

#### 1.2.2.2. Lean UX Assumptions

#### 1.2.2.3. Lean UX Hypothesis Statements

#### 1.2.2.4. Lean UX Canvas

## 1.3. Segmentos objetivos

# Capítulo II: Requirements Elicitation & Analysis

## 2.1. Competidores

### 2.1.1. Análisis competitivo

### 2.1.2. Estrategias y tácticas frente a competidores

## 2.2. Entrevistas

### 2.2.1. Diseño de entrevistas

### 2.2.2. Registro de entrevistas

### 2.2.3. Análisis de entrevistas

## 2.3. Need finding

### 2.3.1. User personas

### 2.3.2. User Task Matrix

### 2.3.3. User Journey Mapping

### 2.3.4. Empathy Mapping

## 2.4. Big Picture EventStorming

### 2.4.1. Introduction and Methodology

**Propósito de la Sesión**

El Big Picture EventStorming para WasteTrack tiene como objetivo mapear de manera colaborativa todo el dominio de la gestión de residuos sólidos en Lima Metropolitana. Esta técnica permite al equipo comprender el landscape completo del negocio, identificar procesos clave y exponer potenciales problemas u oportunidades donde la solución IoT puede generar valor.

**Configuración de la Sesión**

* **Participantes**: 5 miembros del equipo EcoLutions
* **Duración**: 2 horas distribuidas en múltiples fases
* **Herramientas**: Figma para colaboración visual en tiempo real
* **Comunicación**: Discord para coordinación durante el proceso
* **Enfoque**: Mapeo completo del ecosistema de gestión de residuos desde generación hasta disposición final

### 2.4.2. Session Process

**Fase 1: Chaotic Exploration - Identificación de Eventos del Dominio**

En esta fase inicial, el equipo identificó de manera colaborativa todos los eventos significativos que ocurren en el dominio de gestión de residuos sólidos. Se aplicó la técnica de lluvia de ideas estructurada, donde cada miembro contribuyó con eventos desde su perspectiva del problema.

**Eventos identificados por categorías:**
* **Generación y Disposición**: Household Waste Generated, Commercial Waste Generated, Hospital Waste Generated, Industrial Waste Generated, Organic Waste Generated
* **Acumulación**: Container Filled, Container Overflowed, Container Saturated
* **Detección y Comunicación**: Problem Detected by Citizen, Citizen Complaint Registered, Call Received at Call Center
* **Planificación Operativa**: Weekly Schedule Defined, Budget Approved, Route Planned, Staff Assigned
* **Ejecución**: Truck Dispatched, Route Started, Collection Point Reached, Container Emptied
* **Transporte y Disposición**: Waste Transported, Transfer Station Reached, Landfill Reached, Waste Finally Disposed
* **Mantenimiento**: Maintenance Scheduled, Vehicle Repaired, Container Replaced, Fuel Supplied
* **Regulación**: Report Sent to MINAM

Total de eventos identificados: 54 eventos únicos

**Fase 2: Enforcing the Timeline - Organización Temporal**

Para organizar los eventos temporalmente, el equipo aplicó la estrategia **Combining Multiple Strategies**, utilizando:

**Temporal Milestones** como estructura principal:
* **Milestone 1**: "Waste Accumulation" (Generación → Llenado de contenedores)
* **Milestone 2**: "Problem Detection & Response" (Detección → Respuesta de emergencia)
* **Milestone 3**: "Collection Execution" (Planificación → Recolección completada)
* **Milestone 4**: "Final Disposal & Reporting" (Transporte → Reportes)

**Swimlanes** para procesos paralelos:

* Maintenance Operations (continuo)

**Fase 3: People and Systems - Identificación de Actores**

El equipo identificó los actores humanos y sistemas que participan en los eventos:

**People (8 actores principales):**
* Waste Generator, Citizen Reporter, Municipal Administrator, Collection Supervisor
* Emergency Dispatcher, Truck Driver, Maintenance Technician

**Systems (5 sistemas identificados):**
* Municipal Management System, Fleet Management System, Call Center System
* MINAM Reporting System, Social Media Platforms

**Fase 4: Explicit Walkthrough - Validación del Flujo**

Durante esta fase, el equipo validó la secuencia temporal completa, asegurando que:
* Los eventos fluyan lógicamente de un milestone al siguiente
* Los actores estén correctamente asignados a sus eventos respectivos
* Los sistemas soporten adecuadamente los procesos identificados
* Las disrupciones se integren coherentemente con el flujo principal

**Fase 5: Problems and Opportunities - Identificación de Hot Spots**

Se identificaron Hot Spots críticos que representan ineficiencias, gaps o oportunidades de mejora:

**Hot Spots principales:**
* **Visibility Gap**: Entre Container Filled y Container Problem Occurred
* **Detection Dependency**: Dependencia de detección manual ciudadana
* **Route Planning Inefficiency**: Planificación manual sin datos reales
* **Communication Fragmentation**: Múltiples canales descoordinados
* **Resource Coordination Gap**: Falta de sincronización entre recursos
* **Manual Data Collection**: Reportes propensos a errores
* **Reactive Maintenance**: Mantenimiento no predictivo

### 2.4.3. Resultados Obtenidos

**Big Picture Event Storm Completo**

El resultado final del Big Picture Event Storming presenta una vista panorámica integral del dominio de gestión de residuos sólidos en Lima Metropolitana. El Event Storm completo organiza 54 eventos únicos en un timeline horizontal que abarca desde la generación inicial de residuos hasta la disposición final y cumplimiento regulatorio.

![Big Picture Event Storm Completo](assets/2.requirements/2.4.big-picture-eventstorming/big-picture-complete.png)

La visualización muestra claramente la estructura temporal organizada en 4 milestones principales, con actores humanos (amarillo) y sistemas tecnológicos (rosa) distribuidos estratégicamente en sus puntos de interacción correspondientes. El timeline principal se complementa con una swimlane paralela que contiene los procesos continuos de mantenimiento, demostrando la complejidad operativa del dominio.

Los hot spots identificados revelan 13 oportunidades críticas donde WasteTrack puede intervenir para optimizar procesos, eliminar ineficiencias y agregar valor medible a las operaciones municipales de gestión de residuos.

Para acceder al Event Storm interactivo y explorar los detalles completos de la sesión colaborativa, consulte el Anexo A.1 donde se encuentra el enlace al workspace de Figma utilizado durante el proceso.


### 2.4.4. Results Obtained

**Procesos Core Identificados**
1. **Waste Accumulation Management**: Gestión de acumulación y detección de problemas
2. **Emergency Response Coordination**: Coordinación de respuestas a incidencias
3. **Route Planning and Execution**: Planificación y ejecución de rutas de recolección
4. **Compliance and Reporting**: Cumplimiento regulatorio y reportes

**Bounded Contexts Candidatos Identificados**

El Big Picture Event Storming reveló 5 bounded contexts naturales para el diseño de la solución:
1. **Container Monitoring**: Monitoreo y gestión de contenedores
2. **Route Optimization**: Planificación y optimización de rutas
3. **Fleet Management**: Gestión de vehículos y recursos
4. **Citizen Communication**: Comunicación con ciudadanos
5. **Regulatory Compliance**: Cumplimiento y reportes regulatorios

**Oportunidades Estratégicas para WasteTrack**

Los Hot Spots identificados representan oportunidades de valor cuantificables:
* Reducción de 30-40% en tiempo de detección de problemas mediante sensores IoT
* Optimización de rutas con potencial de 20-25% ahorro en combustible
* Automatización de reportes regulatorios eliminando errores manuales
* Integración de comunicación ciudadana reduciendo tiempo de respuesta en 50%

## 2.5. Ubiquitous Language

# Capítulo III: Requirements Specification

## 3.1. User Stories

## 3.2. Impact Mapping

## 3.3. Product Backlog

# Capítulo IV: Solution Software Design

## 4.1. Strategic-Level Domain-Driven Design

### 4.1.1. Design-Level EventStorming

#### 4.1.1.1. Candidate Context Discovery

#### 4.1.1.2. Domain Message Flows Modeling

#### 4.1.1.3. Bounded Context Canvases

### 4.1.2. Context Mapping

### 4.1.3. Software Architecture

#### 4.1.3.1. Software Architecture System Landscape Diagram

#### 4.1.3.2. Software Architecture Context Level Diagrams

#### 4.1.3.3. Software Architecture Container Level Diagrams

#### 4.1.3.4. Software Architecture Deployment Diagrams

## 4.2. Tactical-Level Domain-Driven Design

### 4.2.1. Bounded Context: <Bounded Context Name>

#### 4.2.1.1. Domain Layer

#### 4.2.1.2. Interface Layer

#### 4.2.1.3. Application Layer

#### 4.2.1.4. Infrastructure Layer

#### 4.2.1.5. Bounded Context Software Architecture Component Level Diagrams

#### 4.2.1.6. Bounded Context Software Architecture Code Level Diagrams

##### 4.2.1.6.1. Bounded Context Domain Layer Class Diagrams

##### 4.2.1.6.2. Bounded Context Database Design Diagram

### 4.2.2. Bounded Context: <Bounded Context Name>

#### 4.2.2.1. Domain Layer

#### 4.2.2.2. Interface Layer

#### 4.2.2.3. Application Layer

#### 4.2.2.4. Infrastructure Layer

#### 4.2.2.5. Bounded Context Software Architecture Component Level Diagrams

#### 4.2.2.6. Bounded Context Software Architecture Code Level Diagrams

##### 4.2.2.6.1. Bounded Context Domain Layer Class Diagrams

##### 4.2.2.6.2. Bounded Context Database Design Diagram

# Capítulo V: Solution UI/UX Design

## 5.1. Style Guidelines

### 5.1.1. General Style Guidelines

### 5.1.2. Web, Mobile and IoT Style Guidelines

## 5.2. Information Architecture

### 5.2.1. Organization Systems

### 5.2.2. Labeling Systems

### 5.2.3. SEO Tags and Meta Tags

### 5.2.4. Searching Systems

### 5.2.5. Navigation Systems

## 5.3. Landing Page UI Design

### 5.3.1. Landing Page Wireframe

### 5.3.2. Landing Page Mock-up

## 5.4. Applications UX/UI Design

### 5.4.1. Applications Wireframes

### 5.4.2. Applications Wire flow Diagrams

### 5.4.3. Applications Mock-ups

### 5.4.4. Applications User Flow Diagrams

## 5.5. Applications Prototyping

# Conclusiones

# Bibliografía

# Anexos

## Anexo A: Enlaces de Herramientas Colaborativas

### A.1 Big Picture Event Storming - Workspace Figma

**Enlace**: [https://www.figma.com/board/QhNzzswJLValHHzMBSmIX4/Big-Picture-Event-Storming?node-id=0-1&t=5gyvsiZiBpko8mBJ-1](https://www.figma.com/board/QhNzzswJLValHHzMBSmIX4/Big-Picture-Event-Storming?node-id=0-1&t=5gyvsiZiBpko8mBJ-1)

**Descripción**: Workspace interactivo de Figma donde se desarrolló la sesión completa de Big Picture Event Storming para WasteTrack. Incluye todas las fases del proceso: identificación de eventos, organización temporal, mapeo de actores y sistemas, y identificación de hot spots.

**Acceso**: Enlace público de solo lectura para revisión y validación del trabajo colaborativo realizado por el equipo EcoLutions.
