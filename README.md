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


<table style="text-align:center">
    <thead>
        <tr>
            <th>Integrantes</th>
            <th>Descripción</th>
            <th>Conocimientos</th>
        </tr>
    </thead>
    <body >
        <tr>
            <!-- DATOS del integrante 1-->
            <td> 
            <img src="./assets/img/chapter-I/d.jpg" height="120" width="100"> 
            <br> 
            </td>
            <!-- DESCRIPCIÓN del integrante 1-->
            <td ></td>
            <!-- CONOCIMIENTOS del integrante 1-->
            <td></td>
        </tr>
        <tr>
            <!-- DATOS del integrante 2-->
            <td>
            <img src="./assets/img/chapter-I/yo-Joaquin.jpg"
            height="120" width="100">
            <br>Joaquin David Rivadeneyra Ramos - U202211846
            </td>
            <!-- DESCRIPCIÓN del integrante 2-->
            <td>Soy Joaquin Rivadeneyra, tengo 20 años y actualmente estoy cursando el 7to ciclo de la carrera de Ingeniería de Software. Me considero una persona comunicativa y abierta a nuevas ideas, lo que me permite tener una buena relación con los demás miembros del equipo y fomentar un ambiente de trabajo colaborativo.</td>
            <!-- CONOCIMIENTOS del integrante 2-->
            <td>Poseo habilidades en las que puedo aportar en el grupo son dominio y práctica de lenguajes de programación como Vue y Angular, documentación de proyectos y metodologías ágiles y conocimientos básicos de base de datos.</td>
        </tr>
        <tr>
            <!-- DATOS del integrante 3-->
            <td>
            <img src="./assets/img/chapter-I/Andres.jpg" height="120" width="100">
            <br>Carlos Andres Rojas Ccama - 
            U202114657
            </td>
            <!-- DESCRIPCIÓN del integrante 2-->
            <td>Mi nombre es Carlos Rojas, estudio la carrera de Ingeniería de Software. Mi carrera consiste en crear softwares inteligentes y sistemas informáticos usando un lenguaje de programación con lógica. Me considero una persona responsable y colaborativo como ayudar a las personas y dar ideas, especialmente en grupos. En este trabajo en equipo se requiere dar una buena comunicación, por ello, siempre daré mi opinión.</td>
            <!-- CONOCIMIENTOS del integrante 2-->
            <td>Durante mi formación, he desarrollado habilidades en diversos lenguajes de programación como C++, Python así como experiencia práctica en desarrollo web con Angular para el frontend y Spring Boot para el backend. También he trabajado con bases de datos relacionales (MySQL, SQL Server)</td>
        </tr>
        <tr>
            <!-- DATOS del integrante 4-->
            <td>
            <img src="./assets/img/chapter-I/b." height="120" width="100">
            <br>
            </td>
            <!-- DESCRIPCIÓN del integrante 2-->
            <td></td>
            <!-- CONOCIMIENTOS del integrante 2-->
            <td></td>
        </tr>
        <tr>
            <!-- DATOS del integrante 5-->
            <td>
            <img src="./assets/img/chapter-I/a." height="120" width="100">
            <br>
            </td>
            <!-- DESCRIPCIÓN del integrante 2-->
            <td></td>
            <!-- CONOCIMIENTOS del integrante 2-->
            <td></td>
        </tr>
    </body>
</table>

## 1.2. Solution Profile

### 1.2.1. Antecedentes y problemática

**Antecedentes**  
La gestión de residuos urbanos es un desafío continuo para muchas ciudades. Los métodos tradicionales de recolección a menudo resultan ineficientes, con rutas no optimizadas, desbordamiento de contenedores y altos costos operativos. Además, la falta de transparencia en el proceso de recolección hace que los ciudadanos pierdan confianza en el sistema.

**Problemática**  
La recolección de residuos enfrenta varios problemas, como el mal manejo de rutas, la falta de monitoreo en tiempo real y la escasa participación ciudadana. Los sistemas actuales carecen de eficiencia y transparencia, lo que genera inconvenientes tanto para los municipios como para los ciudadanos.

- **Who? (¿Quién?)**
  
  Los consumidores urbanos que enfrentan una mala gestión de residuos y las municipalidades que buscan mejorar sus operaciones de recolección.

- **What? (¿Qué?)**
  
  Necesitamos mejorar la transparencia en los precios, optimizar las rutas de recolección, proporcionar una interfaz amigable y fomentar la participación de los ciudadanos.

- **Where? (¿Dónde?)**
  
  Principalmente en áreas urbanas con alta densidad de población, pero también en zonas menos cubiertas que pueden beneficiarse de soluciones tecnológicas.

- **When? (¿Cuándo?)**
  
  Durante periodos de alta demanda, como festividades o eventos, es crucial implementar tecnologías que mejoren la recolección en tiempo real.

- **Why? (¿Por qué?)**
  
  Porque los métodos actuales son ineficientes y carecen de transparencia, lo que crea frustración tanto en los ciudadanos como en las municipalidades.

- **How? (¿Cómo?)**
  
  WasteTrack resuelve estos problemas mediante el uso de sensores IoT para monitorear los niveles de llenado y la optimización de rutas para los camiones recolectores. Además, proporciona a los ciudadanos una plataforma para visualizar el recorrido estimado del camión y participar activamente.

- **How Much? (¿Cuánto?)**
  
  El costo de implementar WasteTrack incluye desarrollo tecnológico, integración de IoT y marketing. Utilizamos un modelo de negocio basado en suscripciones y comisiones, lo que permite un flujo de ingresos sostenible para los socios comerciales.

### 1.2.2. Lean UX Process

#### 1.2.2.1. Lean UX Problem Statements

---

La gestión de residuos urbanos tradicionalmente involucra una planificación de rutas ineficiente, contenedores desbordados y falta de visibilidad en tiempo real sobre el estado de los mismos, lo que genera un proceso poco transparente y difícil de gestionar para los municipios y los ciudadanos.

Las soluciones actuales de gestión de residuos suelen carecer de una plataforma unificada que optimice las rutas de recolección, permita el monitoreo en tiempo real y facilite la participación de los ciudadanos. Esto provoca frustración en los usuarios y una experiencia inconsistente en el proceso de recolección de residuos.

Nuestro producto, **WasteTrack**, abordará esta brecha a través de una plataforma web que ofrece una interfaz intuitiva para monitorear y gestionar contenedores de residuos, optimizar rutas de recolección y fomentar la participación activa de los ciudadanos en el mantenimiento de la limpieza urbana. La aplicación proporcionará información clara sobre el estado de los contenedores y las rutas de los camiones, promoviendo la eficiencia y la sostenibilidad en la gestión de residuos.

Nuestro enfoque inicial será dirigido a municipalidades que buscan optimizar la recolección de residuos y ciudadanos interesados en mejorar su contribución al cuidado del medio ambiente.

Sabremos que hemos tenido éxito cuando logremos una adopción del 30% entre las municipalidades dentro de los primeros 6 meses de implementación, y un índice de satisfacción superior al 80% medido a través de encuestas de los usuarios.

#### 1.2.2.2. Lean UX Assumptions

---

**Business Assumptions:**

- Creemos que las municipalidades necesitan una forma más eficiente y transparente para gestionar la recolección de residuos.
- Estas necesidades se pueden resolver con una plataforma web que optimice las rutas de recolección, permita el monitoreo de contenedores y fomente la participación ciudadana.
- Nuestros clientes iniciales serán las municipalidades que buscan optimizar la recolección de residuos y los ciudadanos interesados en mejorar la gestión de su entorno.
- El valor principal que un cliente desea obtener de **WasteTrack** es un proceso de gestión de residuos simplificado y eficiente, con acceso en tiempo real a la información sobre el estado de los contenedores y las rutas de los camiones.
- Los beneficios adicionales incluyen la optimización de rutas, el monitoreo de contenedores, y la participación ciudadana para mejorar la limpieza urbana.
- Vamos a adquirir la mayoría de nuestros clientes a través de asociaciones con municipalidades y campañas de concienciación sobre la gestión de residuos.
- Generaremos ingresos mediante un modelo de suscripción para las municipalidades y servicios adicionales ofrecidos a través de la plataforma.
- Nuestra competencia principal serán otras plataformas de gestión de residuos y soluciones de optimización de rutas.
- Venceremos a la competencia mediante una experiencia de usuario más intuitiva, mejores funcionalidades de monitoreo y mayor transparencia en la recolección de residuos.
- El mayor riesgo es la adopción de nuevas tecnologías por parte de las municipalidades y la resistencia de los ciudadanos a participar activamente en la gestión de residuos.
- Resolveremos esto mediante una interfaz fácil de usar, tutoriales explicativos y soporte al cliente accesible.

**User Assumptions:**

- Los usuarios principales serán los empleados de las municipalidades que gestionan la recolección de residuos y los ciudadanos que desean contribuir al mantenimiento de una ciudad limpia.
- **WasteTrack** se integrará en la vida diaria de los usuarios proporcionando una plataforma centralizada para gestionar los contenedores, optimizar rutas y ver el estado de los camiones recolectores en tiempo real.
- El producto resolverá problemas de complejidad y falta de transparencia en la gestión de residuos, mejorando la toma de decisiones con información clara y opciones personalizadas.
- Los usuarios utilizarán la plataforma web para obtener información sobre el estado de los contenedores, la optimización de las rutas y las notificaciones sobre los horarios de recolección.
- Las características importantes incluyen una interfaz de usuario intuitiva, información sobre el nivel de llenado de los contenedores, notificaciones en tiempo real y herramientas de participación ciudadana.
- **WasteTrack** debe tener un diseño limpio y moderno, con una interfaz clara que facilite la navegación y la visualización de las rutas y horarios.

**Business Outcomes:**

- Lograr que al menos el 30% de las municipalidades en áreas urbanas adopten **WasteTrack** dentro del primer año.
- Asegurar que al menos el 70% de las municipalidades utilicen la plataforma para optimizar sus rutas de recolección.
- Observar que más del 50% de los ciudadanos registrados utilicen la plataforma para seguir la ruta del camión recolector y contribuir activamente al mantenimiento de la ciudad.
- Mantener una tasa de retención del 75% entre los usuarios activos.
- Recibir una valoración positiva superior al 85% en las encuestas de satisfacción de los usuarios después de cada recolección.

---

**User Outcomes:**

- Los usuarios experimentarán un proceso de gestión de residuos más eficiente y menos complicado, desde la visualización del nivel de llenado de los contenedores hasta la optimización de las rutas.
- Obtendrán información clara y precisa sobre los horarios de recolección y las rutas de los camiones, lo que facilita la planificación de sus actividades.
- Podrán participar activamente en la gestión de residuos, reportando incidencias o colaborando con el proceso de reciclaje.
- Los usuarios confiarán en la plataforma para gestionar las recolecciones de manera segura y eficiente, con soporte al cliente disponible para resolver dudas o problemas.

**Features:**

- **Interfaz Intuitiva:** Un diseño fácil de usar que permite a los usuarios gestionar y monitorear los contenedores de residuos rápidamente.
- **Disponibilidad en Tiempo Real:** Información actualizada sobre el nivel de llenado de los contenedores y las rutas de los camiones recolectores.
- **Optimización de Rutas:** Algoritmos que generan las rutas más eficientes para la recolección de residuos, ahorrando tiempo y recursos.
- **Participación Ciudadana:** Funcionalidad para que los ciudadanos sigan el recorrido de los camiones recolectores y reporten problemas o incidencias.
- **Soporte al Cliente:** Acceso a soporte en vivo para resolver problemas o responder preguntas.
- **Sistema de Notificaciones:** Alertas sobre horarios de recolección y eventos especiales relacionados con la gestión de residuos.

#### 1.2.2.3. Lean UX Hypothesis Statements

---

**Hipótesis 1:**

Creemos que brindando herramientas adecuadas para la gestión de residuos urbanos y la optimización de las rutas de recolección, podremos mejorar la eficiencia de los servicios de recolección en las municipalidades.

Sabremos que hemos tenido éxito cuando los usuarios municipales informen un incremento del 30% en la eficiencia de las rutas de recolección, junto con una mejora del 25% en la satisfacción del equipo de recolección respecto a la planificación y ejecución de las rutas.

---

**Hipótesis 2:**

Creemos que al integrar una plataforma intuitiva para el monitoreo en tiempo real de los contenedores de residuos, mejoraremos la eficiencia operativa y reduciremos los desbordamientos de residuos en áreas urbanas.

Sabremos que estamos en lo cierto cuando veamos una reducción del 20% en los incidentes de desbordamiento de contenedores y una mejora del 18% en la capacidad de respuesta ante situaciones imprevistas en las rutas.

---

**Hipótesis 3:**

Creemos que proporcionando a los ciudadanos una herramienta para seguir el recorrido en tiempo real de los camiones recolectores, incrementaremos su participación en la gestión de residuos y su satisfacción con el servicio.

Sabremos que hemos tenido éxito cuando observemos un aumento del 25% en la participación activa de los ciudadanos en el reporte de contenedores llenos y una mejora del 15% en la satisfacción general del ciudadano con el servicio de recolección.

---

**Hipótesis 4:**

Creemos que la implementación de alertas y notificaciones en tiempo real sobre la llegada del camión recolector mejorará la planificación de los ciudadanos y optimizará la eficiencia del proceso de recolección.

Sabremos que estamos en lo cierto cuando veamos una mejora del 20% en la puntualidad de los ciudadanos al disponer de sus residuos y un aumento del 10% en la eficiencia de la recolección.

---

**Hipótesis 5:**

Creemos que al ofrecer un sistema de monitoreo y seguimiento accesible y transparente para los ciudadanos, aumentaremos la confianza en el sistema de recolección de residuos y la percepción de limpieza en la ciudad.

Sabremos que hemos tenido éxito cuando observemos un aumento del 30% en la tasa de satisfacción de los ciudadanos respecto a la transparencia del servicio y una reducción del 10% en los reclamos relacionados con la falta de recolección.

---

**Hipótesis 6:**

Creemos que la automatización de la recolección de datos sobre el nivel de llenado de los contenedores reducirá la carga administrativa de las municipalidades y permitirá una planificación más eficiente.

Sabremos que hemos tenido éxito cuando veamos una reducción del 15% en el tiempo destinado a tareas administrativas y una mejora del 20% en la capacidad de las municipalidades para ajustar las rutas de recolección en función de los datos en tiempo real.

---

**Hipótesis 7:**

Creemos que la integración de un sistema de análisis predictivo para la gestión de residuos ayudará a prever desbordamientos y optimizar las rutas de recolección, mejorando la eficiencia del servicio.

Sabremos que hemos tenido éxito cuando veamos una reducción del 12% en los incidentes de desbordamiento de contenedores y un incremento del 25% en la capacidad de los servicios de recolección para adaptarse a cambios imprevistos.

---

**Hipótesis 8:**

Creemos que la posibilidad de gestionar las rutas de recolección y la disposición de residuos desde cualquier dispositivo aumentará la flexibilidad y eficiencia de las municipalidades en la gestión de residuos urbanos.

Sabremos que hemos tenido éxito cuando observemos un aumento del 20% en la eficiencia operativa de las municipalidades y una mejora del 18% en la capacidad de respuesta ante cambios en los horarios o rutas de recolección.

---

#### 1.2.2.4. Lean UX Canvas

| Sección | Contenido |
| -- | -- |
| **Business Problem** | La gestión ineficiente de la recolección de residuos urbanos genera desbordamientos, costos operativos elevados y falta de transparencia. Los métodos tradicionales carecen de herramientas para monitorear en tiempo real y optimizar las rutas de recolección. |
| **Business Outcomes** | Mejorar la eficiencia operativa de las municipalidades. <br> Reducir el tiempo de recolección y los costos operativos asociados a rutas no optimizadas. |
| **Users and Customers** | Municipalidades encargadas de la recolección de residuos y ciudadanos interesados en mejorar la limpieza urbana. |
| **User Benefits** | Optimización del proceso de recolección de residuos. <br> Participación activa de los ciudadanos. <br> Mayor transparencia y confianza en el servicio de recolección. |
| **Solution Ideas** | Implementar una plataforma web para monitorear los niveles de llenado de los contenedores en tiempo real. <br> Integrar algoritmos para optimizar las rutas de recolección. <br> Crear un sistema de notificaciones y alertas para los ciudadanos sobre los horarios de recolección y el estado de los contenedores. |
| **Hypotheses** | Creemos que brindando herramientas adecuadas para la gestión de residuos urbanos y optimización de rutas, mejoraremos la eficiencia operativa de las municipalidades y la participación ciudadana. Sabremos que hemos tenido éxito cuando observemos una mejora del 25% en la eficiencia de la recolección y un aumento del 30% en la participación ciudadana. |
| **What's the most important <br> thing we need to learn first?** | Conocer las expectativas de los municipios y los ciudadanos sobre la optimización de la recolección de residuos y la visibilidad en tiempo real. |
| **What's the least amount of <br> work we need to do to learn <br> the next most important thing?** | Realizar entrevistas con usuarios municipales y ciudadanos para entender sus necesidades y expectativas. <br> Probar prototipos de la plataforma para validar la utilidad de las notificaciones y la optimización de rutas. |

<p align="center">
  <img src="./assets/img/chapter-I/canva.jpg" alt="Lean UX Canvas">
</p>

## 1.3. Segmentos objetivos

**Municipalidades:** 

**Descripción:**  
Municipalidades encargadas de la planificación, monitoreo y optimización de los servicios de recolección de residuos urbanos. Buscan implementar soluciones tecnológicas que les ayuden a mejorar la eficiencia operativa, reducir los costos y optimizar las rutas de los camiones recolectores.  

**Necesidades:**  
Requieren herramientas para gestionar de manera eficiente la recolección de residuos, optimizar las rutas de los camiones, monitorear el nivel de llenado de los contenedores y mejorar la transparencia en la recolección.  

**Aspiraciones:**  
Desean mejorar la eficiencia del servicio, reducir costos operativos, promover la sostenibilidad y aumentar la participación ciudadana en la gestión de residuos.

---

**Ciudadanos:** 

**Descripción:**  
Ciudadanos que buscan disponer adecuadamente de sus residuos y seguir el recorrido del camión recolector para contribuir al mantenimiento de una ciudad más limpia.  

**Necesidades:**  
Requieren una plataforma que les permita conocer el recorrido del camión recolector en tiempo real, disponer sus residuos de forma adecuada y participar en la gestión de residuos urbanos.  

**Aspiraciones:**  
Desean contribuir activamente al cuidado del medio ambiente, conocer el estado de la recolección y estar informados sobre el proceso de gestión de residuos.

---

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
