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

Este capítulo presenta el diseño de la experiencia de usuario (UX) y la interfaz de usuario (UI) de la solución, con el objetivo de asegurar una interacción fluida, intuitiva y visualmente coherente en todos los puntos de contacto con el usuario. A través de un enfoque centrado en el usuario, se definen lineamientos visuales, estructuras de navegación y prototipos que guían la implementación de una experiencia digital accesible, funcional y atractiva.

## 5.1. Style Guidelines

En esta sección de Style Guidelines se definen las directrices de estilo visual que regirán el diseño de la interfaz de usuario en los diferentes entornos donde estará presente la solución. Estas guías aseguran coherencia estética, usabilidad y reconocimiento de marca a lo largo de todas las plataformas y dispositivos.

### 5.1.1. General Style Guidelines
En esta sección se definen los lineamientos generales de diseño visual para garantizar coherencia en todos los productos digitales de WasteTrack.  

- **Paleta de colores:**  
Se establece una paleta compuesta por negro, blanco y cuatro tonos de verde que representan sostenibilidad, limpieza y tecnología.  

<p align="center">
  <img src="./assets/0.cover/paleta.jpg" alt="Paleta de colores" width="400"/>
</p>

- **Tipografía:**  
Se utilizarán tipografías modernas y legibles, priorizando la jerarquía visual.  
Ejemplo: *Montserrat* para títulos y *Roboto* para texto de párrafo.  

- **Espaciado y grillas:**  
Se aplicarán márgenes internos de 16px en formularios y botones, y entre secciones márgenes que varían entre 24px y 32px.  

<p align="center">
  <img src="./assets/0.cover/space.jpg" alt="Espaciado" width="400"/>
</p>

- **Branding:**  
El logo de WasteTrack debe transmitir sostenibilidad, innovación y confianza, alineado a la paleta de verdes definida.  

<p align="center">
  <img src="./assets/0.cover/logowaste.jpg" alt="Logo WasteTrack" width="400"/>
</p>

---

### 5.1.2. Web, Mobile and IoT Style Guidelines
En esta sección se detallan los lineamientos visuales y de diseño implementados en la interfaz de usuario para las diferentes plataformas del sistema WasteTrack: **web, móvil e IoT**.

---

#### Dimensiones
Se consideran dimensiones estándar para asegurar una experiencia de usuario óptima en distintos dispositivos:

- **Escritorio:** 1280 px de ancho  
- **Tablet:** 760 px de ancho  
- **Celular:** 480 px de ancho  

---

#### Navegación
La navegación sigue un **diseño minimalista y funcional**, priorizando la rapidez de acceso a la información crítica.  
- En web, el menú superior permite acceder a secciones principales como:  
  **Inicio, Mapa de contenedores y rutas, Contenedores, Ajustes y Acerca de nosotros**.  
- La sección activa se resalta en **negrita** y con un subrayado verde, siguiendo la paleta de colores corporativa.  

**Ejemplo de navegación web:**  
`[Inicio] [Mapa de contenedores y rutas] [Contenedores] [Ajustes] [Acerca de nosotros]`

<p align="center">
  <img src="./assets/0.cover/nave.jpg" alt="Logo WasteTrack" width="400"/>
</p>

---

#### Iconos
Se utilizan íconos simples y universales que refuercen la comprensión visual de las funciones.  
- **Inicio:** 🏠  
- **Mapa de contenedores y rutas:** 🗺️  
- **Contenedores:** 🗑️  
- **Alertas Activas:** ⚠️  
- **Tipo de Residuos:** ♻️  
- **Actividad Reciente:** 📊  
- **Ajustes:** ⚙️  
- **Acerca de nosotros:** ℹ️  

---

#### Alertas Activas
La sección de **alertas activas** se muestra de manera destacada con colores de alto contraste.  
- **Azul:** Funcionamiento normal.  
- **Amarillo:** Advertencia preventiva.  
- **Rojo:** Alerta crítica (contenedor lleno, falla en ruta, incidencia IoT).  
Cada alerta incluye un icono, un texto descriptivo breve y la hora de emisión.  

<p align="center">
  <img src="./assets/0.cover/alertas.jpg" alt="Logo WasteTrack" width="400"/>
</p>

---

#### Tipo de Residuos
El sistema clasifica los residuos utilizando **colores distintivos** y **iconografía clara** para facilitar la identificación rápida en la interfaz:  

<p align="center">
  <img src="./assets/0.cover/residuos.jpg" alt="Logo WasteTrack" width="400"/>
</p>

- 🥬 **Orgánicos** – Verde (#4CAF50)  
- 🧴 **Plásticos** – Azul (#2196F3)  
- 📄 **Papel** – Amarillo (#FFEB3B)  
- 🍾 **Vidrio** – Morado (#9C27B0)  
- 🗑️ **General** – Negro (#000000)  

Cada categoría se representa en contenedores, mapas y dashboards, garantizando uniformidad visual y mejor comprensión por parte de los usuarios.  
 

Esto permite que el usuario identifique rápidamente el estado de los contenedores y el tipo de material.

---

#### Actividad Reciente
La sección de **actividad reciente** registra las interacciones clave dentro de la plataforma, mostrando un historial en orden cronológico.  
- **Ejemplo:** “Contenedor #34 vaciado – 10:45 am”  
- Incluye íconos de acción y colores de estado.  
- La interfaz utiliza tarjetas minimalistas con sombra suave y espaciado de 16 px para facilitar la lectura.  

<p align="center">
  <img src="./assets/0.cover/actividad.jpg" alt="Logo WasteTrack" width="400"/>
</p>

---

#### Colores de Fondo
La paleta de WasteTrack combina sostenibilidad y tecnología:  
- **Primario:** Verde oscuro (#004d40) – usado en headers y secciones principales.  
- **Secundario:** Gris claro (#f5f5f5) – utilizado en fondos secundarios.  
- **Terciario:** Verde lima (#8bc34a) – para botones y llamadas a la acción.  

---

#### Estilos de Texto
- **H1:** Títulos principales con tipografía *Montserrat*, tamaño 32 px.  
- **H2:** Subtítulos con menor jerarquía, tamaño 24 px.  
- **Párrafo:** Texto en *Roboto*, tamaño 16 px, alta legibilidad.  
- **Enlaces (a):** Color verde lima, subrayado al pasar el cursor (*hover*).  

---

#### Aplicación Móvil
La versión móvil adapta los principios del diseño web a pantallas táctiles, optimizando la usabilidad.  

- **Dimensiones base:** Adaptativas entre 360 px y 480 px.  
- **Navegación móvil:**  
  - Menú inferior fijo con íconos: [Inicio | Contenedores | Alertas Activas | Actividad Reciente | Cuenta].  
  - Opción de menú hamburguesa para configuraciones avanzadas.  
- **Componentes táctiles:** Botones grandes, espaciado de al menos 16 px entre elementos, retroalimentación visual al presionar.  
- **Iconografía optimizada:** Íconos simples y claros para facilitar la interacción.  

---

#### IoT
Las interfaces IoT de WasteTrack (pantallas embebidas en camiones y dashboards de monitoreo) priorizan la simplicidad y la claridad de información.  

- **Diseño simplificado:** Menús grandes, botones de acción destacados.  
- **Contraste elevado:** Verde/rojo para alertas críticas en tiempo real.  
- **Visualización rápida:** Indicadores gráficos de nivel de llenado, tipo de residuo y rutas en ejecución.  
- **Iconografía clara:** Íconos minimalistas acompañados de etiquetas de texto.  

---

## 5.2. Information Architecture 
La arquitectura de información de **WasteTrack** busca **facilitar la comprensión, navegación y acceso eficiente a los datos**, asegurando que tanto funcionarios municipales como ciudadanos interactúen de manera **intuitiva, coherente y ágil** con el sistema.  
El diseño se basa en principios de **usabilidad, accesibilidad y consistencia omnicanal**, adaptándose a las características de cada dispositivo (web, móvil e IoT).  

---

### 5.2.1. Organization Systems
Para organizar la información, WasteTrack implementa diferentes **modelos de estructuración**, orientados a reducir la carga cognitiva y aumentar la eficiencia del usuario:

- **Jerarquía visual:**  
  La información se organiza con distintos niveles de importancia, destacando datos críticos como:
  - Alertas de contenedores llenos.  
  - Retrasos en rutas de recolección.  
  - Indicadores de sostenibilidad y eficiencia.  
  Este enfoque asegura que el usuario pueda priorizar acciones urgentes sin distracciones.  

- **Secuencial (paso a paso):**  
  Procesos sensibles se presentan de forma guiada y lineal, como:  
  - Registro de nuevos usuarios.  
  - Configuración de preferencias de alertas.  
  - Generación y descarga de reportes en PDF/Excel.  
  Este modelo garantiza que los usuarios completen cada proceso sin omitir pasos esenciales.  

- **Matricial (multidimensional):**  
  Utilizado principalmente en los **dashboards de funcionarios municipales**, permite la combinación de múltiples criterios para analizar información:
  - Estado de contenedores vs. tipo de residuos.  
  - Rutas activas vs. historial de cumplimiento.  
  - Comparación de camiones activos por zonas.  
  Este enfoque en “tablas y tarjetas interactivas” facilita la **toma de decisiones estratégicas** en tiempo real.  

---

### 5.2.2. Labeling Systems
El sistema de etiquetado de WasteTrack emplea **lenguaje simple, intuitivo y consistente**, evitando tecnicismos innecesarios y priorizando la **rapidez de reconocimiento**.  
Cada plataforma adapta sus etiquetas a las necesidades de su público objetivo.  

---

#### 📌 Aplicación Web (Funcionarios y Administradores)
| Etiqueta        | Descripción                                                                 |
|-----------------|-----------------------------------------------------------------------------|
| **Inicio**      | Página principal con métricas globales, indicadores clave y estado general. |
| **Contenedores**| Visualización del nivel de llenado, estado de sensores y ubicación en mapa. |
| **Rutas**       | Planificación, seguimiento y optimización de rutas de recolección.          |
| **Alertas**     | Panel de notificaciones críticas (retrasos, fallos de sensores, incidencias).|
| **Reportes**    | Generación y exportación de datos en PDF o Excel con filtros avanzados.     |
| **Ajustes**     | Configuración de usuarios, roles, permisos y parámetros del sistema.        |
| **Acerca de**   | Información institucional, soporte y documentación del sistema.             |

---

#### 📱 Aplicación Móvil (Ciudadanos y Conductores)
| Etiqueta             | Descripción                                                                 |
|----------------------|-----------------------------------------------------------------------------|
| **Home**             | Vista general de alertas y resumen del estado en la zona.                   |
| **Mapa**             | Ubicación de contenedores cercanos y seguimiento de camiones en tiempo real.|
| **Notificaciones**   | Alertas personalizadas sobre retrasos, llenado de contenedores y novedades. |
| **Actividad Reciente**| Histórico de interacciones: reportes enviados, alertas recibidas.           |
| **Cuenta**           | Perfil del usuario, configuración de preferencias y opciones de sesión.     |
| **Acerca de**        | Información de la aplicación, soporte y contacto directo.                   |

---

#### ⚙️ Interfaces IoT (Dashboards y Camiones)
| Etiqueta             | Descripción                                                                 |
|----------------------|-----------------------------------------------------------------------------|
| **Dashboard**        | Estado en tiempo real de sensores y alertas críticas.                       |
| **Rutas Activas**    | Seguimiento de vehículos en ejecución, tiempos estimados y atrasos.          |
| **Alertas Activas**  | Panel de incidencias críticas en campo (contenedor lleno, sensor inactivo). |
| **Tipo de Residuos** | Visualización por colores: Orgánicos, Plástico, Papel, Vidrio, General.      |
| **Actividad Reciente**| Registro de operaciones realizadas (inicio/final de rutas, incidencias).    |
| **Configuración**    | Ajustes básicos de dispositivo y conexión IoT.                              |

---

Con esta clasificación y estandarización de etiquetas, WasteTrack garantiza:  
- **Claridad semántica:** cada etiqueta comunica exactamente su función.  
- **Consistencia visual y lingüística:** evita confusión entre plataformas.  
- **Eficiencia operativa:** reduce tiempos de aprendizaje y errores en la interacción.  

---

### 5.2.3. SEO Tags and Meta Tags
Las etiquetas y metadatos están optimizados para mejorar el posicionamiento en buscadores.  

Meta tags estratégicos se usarán para posicionar la landing page y aplicación web de **WasteTrack**, mejorando su visibilidad y acceso.  

- **Title tag:** Título principal que será visualizado tanto en la landing page, versión mobile y aplicación web.  
- **Meta Description:** Descripción que explica de qué trata WasteTrack.  
- **Meta Keywords:** Palabras clave para que los usuarios encuentren la aplicación web más rápido y sencillo.  
- **Author and Copyright:** Enmarcar derechos de autor para WasteTrack.  
- **Viewport:** Sirve para indicar al navegador cómo ajustar el tamaño de la página en relación con el dispositivo.  

<title>WasteTrack - Gestión inteligente de residuos con IoT</title>
<meta name="description" content="WasteTrack optimiza la gestión de residuos con sensores IoT, rutas inteligentes y reportes en tiempo real."/>
<meta name="keywords" content="WasteTrack, IoT, gestión de residuos, rutas inteligentes, sostenibilidad, smart city"/>
<meta name="author" content="EcoLutions"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>

---

### 5.2.4. Searching Systems
El sistema de búsqueda en WasteTrack se ha diseñado para ser **rápido, flexible e intuitivo**, permitiendo a los distintos perfiles de usuarios (funcionarios municipales, ciudadanos y administradores) acceder de forma eficiente a la información crítica sobre residuos, rutas y alertas.

#### Objetivos del sistema de búsqueda
- **Eficiencia:** Reducir el tiempo que toma encontrar información clave.  
- **Personalización:** Adaptar resultados según el perfil del usuario (funcionario, administrador o ciudadano).  
- **Escalabilidad:** Permitir búsquedas simples y avanzadas con múltiples filtros.  
- **Transparencia:** Mostrar resultados claros y confiables, reduciendo la carga cognitiva.  

#### Funcionalidades principales
1. **Búsqueda por contenedor:**  
   - Permite al funcionario localizar un contenedor específico por ID, código QR o zona geográfica.  
   - Muestra estado de llenado, ubicación en mapa y último historial de recolección.  

2. **Búsqueda por rutas de camiones:**  
   - Se pueden consultar rutas activas, programadas y completadas.  
   - Ofrece filtros por fecha, tipo de residuo transportado o zona cubierta.  
   - Incluye visualización en mapa con colores que representan nivel de cumplimiento (verde = completada, amarillo = en progreso, rojo = retrasada).  

3. **Búsqueda por alertas:**  
   - Acceso a las notificaciones generadas por el sistema (contenedor lleno, retraso de camión, sensor inactivo).  
   - Filtros avanzados por fecha, tipo de alerta y estado de resolución.  

4. **Búsqueda por reportes históricos:**  
   - Exportación rápida de reportes filtrados (PDF o Excel).  
   - Búsquedas cronológicas para visualizar tendencias semanales o mensuales.  

#### Interfaz de búsqueda
- **Barra de búsqueda principal:** Ubicada en la parte superior de la web y la app. Incluye autocompletado y sugerencias.  
- **Filtros dinámicos:** Checkboxes y dropdowns para seleccionar zona, fecha, tipo de residuo o nivel de prioridad.  
- **Visualización de resultados:**  
  - En **web:** Listados con paginación y gráficos de barras o circulares.  
  - En **móvil:** Resultados simplificados con tarjetas e iconos de colores para alertas.  
  - En **IoT:** Pantallas embebidas que muestran los resultados en listas cortas, optimizadas para la toma de decisiones en campo.  

---

### 5.2.5. Navigation Systems
El sistema de navegación de WasteTrack se ha diseñado con un enfoque **omnicanal**: coherente en todas las plataformas (Landing Page, Aplicación Web, App Móvil e IoT), pero adaptado a las particularidades de cada dispositivo y perfil de usuario.  

#### Principios de navegación
- **Claridad:** Menús intuitivos y organizados según las prioridades del usuario.  
- **Consistencia:** Estilo homogéneo entre web, móvil e IoT.  
- **Accesibilidad:** Uso de iconografía clara, contraste visual y atajos de navegación.  
- **Flexibilidad:** Navegación jerárquica, secuencial y contextual según el flujo de trabajo.  

---

#### Landing Page
- **Menú superior fijo** con desplazamiento automático a secciones: *Inicio, Beneficios, Funcionamiento, Contacto*.  
- **Botones destacados:**  
  - “Solicita una demo” (CTA principal).  
  - “Descargar app” (enlace a App Store/Google Play).  
- **Soporte multilenguaje:** Botón flotante para cambiar idioma (Español / Inglés).  

---

#### Aplicación Web (Funcionarios y Administradores)
- **Menú lateral izquierdo:** Navegación vertical que agrupa secciones críticas:  
  - **Dashboard:** Resumen de indicadores clave.  
  - **Contenedores:** Estado y ubicación.  
  - **Rutas:** Monitoreo y programación.  
  - **Alertas:** Gestión de notificaciones.  
  - **Reportes:** Exportación y estadísticas.  
  - **Configuración:** Roles, usuarios y preferencias del sistema.  

- **Breadcrumbs (migas de pan):** Permiten al usuario ubicar su posición en el sistema y volver a niveles anteriores.  

- **Atajos de acción rápida:**  
  - Botón flotante para crear reportes.  
  - Icono de campana para alertas en tiempo real.  

---

#### Aplicación Móvil (Ciudadanos y Conductores)
- **Navegación inferior (bottom bar) con íconos:**  
  - Ciudadanos: [🏠 Home | 🗺️ Mapa | 🔔 Notificaciones | 👤 Cuenta]  
  - Conductores: [🏠 Home | 📍 Rutas | 🔔 Notificaciones | 👤 Cuenta]  

- **Menú hamburguesa lateral:** Incluye opciones secundarias como configuración avanzada, historial de uso y soporte técnico.  

- **Navegación contextual:**  
  - Al tocar un contenedor en el mapa, se despliega un menú con opciones como *Ver detalles, Reportar problema, Ver historial*.  

---

#### IoT (Dashboards y Pantallas embebidas en camiones)
- **Menús simplificados:**  
  - Estado de contenedores.  
  - Alertas activas.  
  - Rutas en tiempo real.  

- **Navegación optimizada para condiciones de campo:**  
  - Botones grandes y de alto contraste.  
  - Acceso directo a la acción crítica (ej. *Iniciar ruta*, *Reportar incidencia*).  

- **Flujo secuencial:** El conductor sigue un orden paso a paso (Inicio de ruta → Estado de contenedores → Finalizar ruta), reduciendo errores y mejorando la eficiencia.  

---

#### Resumen de navegación
- **Landing Page:** Informativa y de captación de usuarios.  
- **Web App:** Analítica y de gestión avanzada para funcionarios.  
- **Mobile App:** Interacción ciudadana y operativa en campo.  
- **IoT:** Control rápido y simplificado para camiones y dashboards municipales.  

---

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
