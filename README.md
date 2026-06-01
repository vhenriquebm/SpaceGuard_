<div align="center">

# 🛰️ SpaceGuard

### Sistema de Monitoramento Ambiental com Sensores IoT

*Plataforma full stack acadêmica para monitoramento de alertas ambientais por região,*
*integrando app iOS nativo, API REST e sensores simulados.*

---

[![Swift](https://img.shields.io/badge/Swift-5.9-orange?logo=swift)](https://swift.org)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.2.0-brightgreen?logo=springboot)](https://spring.io/projects/spring-boot)
[![Java](https://img.shields.io/badge/Java-17-blue?logo=openjdk)](https://openjdk.org)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-336791?logo=postgresql&logoColor=white)](https://www.postgresql.org)
[![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker&logoColor=white)](https://www.docker.com)
[![License](https://img.shields.io/badge/License-MIT-lightgrey)](LICENSE)

</div>

---

## 📋 Índice

- [Visão Geral](#-visão-geral)
- [Tecnologias](#-tecnologias)
- [Estrutura do Repositório](#-estrutura-do-repositório)
- [Funcionalidades](#-funcionalidades)
- [Arquitetura](#-arquitetura)
- [Como Rodar — Backend](#-como-rodar--backend)
- [Como Rodar — iOS](#-como-rodar--app-ios)
- [Endpoints da API](#-endpoints-da-api)
- [Swagger UI](#-swagger-ui)
- [Banco de Dados](#-banco-de-dados)
- [Segurança](#-segurança)
- [Simulação IoT](#-simulação-iot)
- [Testes](#-testes)
- [ODS da ONU](#-ods-da-onu)
- [Screenshots](#-screenshots)
- [Melhorias Futuras](#-melhorias-futuras)
- [Licença](#-licença)

---

## 🌍 Visão Geral

O **SpaceGuard** é um sistema acadêmico de monitoramento ambiental em tempo real desenvolvido como projeto integrador. A plataforma coleta leituras de sensores IoT simulados distribuídos por regiões geográficas, processa os dados no backend e exibe alertas ambientais categorizados por nível de risco em um app iOS nativo.

O sistema foi concebido para apoiar a tomada de decisão em cenários de risco ambiental — incêndios, inundações, fumaça e eventos críticos — oferecendo visibilidade regional e rastreabilidade histórica das leituras dos sensores.

**Principais aspectos do projeto:**

- 📱 App iOS nativo em SwiftUI com arquitetura MVVM
- ☁️ API REST em Spring Boot com autenticação JWT
- 🗄️ Persistência relacional em PostgreSQL
- 🔬 Sensores IoT simulados com múltiplos tipos de leitura
- 🚨 Sistema de alertas com quatro níveis de risco
- 📄 Documentação automática via Swagger/OpenAPI

---

## 🧰 Tecnologias

### 📱 Mobile
| Tecnologia | Versão | Uso |
|---|---|---|
| Swift | 5.9 | Linguagem principal |
| SwiftUI | — | Interface declarativa |
| Xcode | 15+ | IDE e simulador |

### ⚙️ Backend
| Tecnologia | Versão | Uso |
|---|---|---|
| Java | 17 | Linguagem principal |
| Spring Boot | 3.2.0 | Framework principal |
| Spring Security | 6.x | Autenticação e autorização |
| Spring Data JPA | — | ORM e repositórios |
| JJWT | 0.12.3 | Geração e validação de tokens JWT |
| Springdoc OpenAPI | 2.3.0 | Swagger UI automático |
| Lombok | 1.18.36 | Redução de boilerplate |
| Maven | — | Build e dependências |

### 🗄️ Banco de Dados
| Tecnologia | Versão | Uso |
|---|---|---|
| PostgreSQL | 15 | Banco relacional principal |
| Hibernate | 6.x | ORM (via Spring Data JPA) |

### 🔒 Segurança
| Tecnologia | Uso |
|---|---|
| JWT (HS256) | Tokens de acesso stateless |
| BCrypt | Hash de senhas |
| Spring Security | Filtros e configuração de rotas |
| Bean Validation | Validação de entrada nos DTOs |

### 🛠️ Ferramentas
| Tecnologia | Uso |
|---|---|
| Docker Compose | Ambiente de banco de dados local |
| Swagger UI | Documentação e teste de endpoints |
| Postman | Testes manuais de API |

---

## 📁 Estrutura do Repositório

```
SpaceGuard_/
│
├── SpaceGuard/                          # App iOS (SwiftUI)
│   └── SpaceGuard/
│       ├── Models/                      # Modelos de domínio Swift
│       ├── Views/                       # Telas e componentes SwiftUI
│       ├── ViewModels/                  # Lógica de apresentação (MVVM)
│       ├── Services/                    # Protocolos e serviços de dados
│       ├── MockData/                    # Dados simulados para desenvolvimento
│       └── SpaceGuardApp.swift          # Entry point do app
│
├── SpaceGuardBackEnd/                   # API REST (Spring Boot)
│   ├── src/main/java/com/spaceguard/backend/
│   │   ├── controller/                  # Endpoints REST (4 controllers)
│   │   ├── service/                     # Regras de negócio (4 services)
│   │   ├── repository/                  # Acesso a dados JPA (5 repositories)
│   │   ├── entity/                      # Entidades JPA (5 entities + 4 enums)
│   │   ├── dto/                         # Data Transfer Objects (6 DTOs)
│   │   ├── security/                    # JWT filter, util, UserDetailsService
│   │   ├── config/                      # SecurityConfig, OpenApi, DataInitializer
│   │   └── exception/                   # GlobalExceptionHandler
│   ├── src/main/resources/
│   │   └── application.yml              # Configurações da aplicação
│   ├── docker-compose.yml               # Serviço PostgreSQL
│   └── pom.xml                          # Dependências Maven
│
└── README.md
```

---

## ✅ Funcionalidades

| Funcionalidade | Status | Descrição |
|---|---|---|
| Autenticação JWT | ✅ | Login e registro com token HS256 de 24h |
| Dashboard de alertas | ✅ | Lista de alertas ordenada por data (mais recentes primeiro) |
| Detalhe do alerta | ✅ | Visualização completa com tipo, risco e região |
| Painel de sensores | ✅ | Listagem, criação e leituras por sensor |
| Gerenciamento de regiões | ✅ | CRUD completo de regiões com nível de risco |
| Alertas ambientais | ✅ | 4 tipos: FIRE, FLOOD, SMOKE, CRITICAL_EVENT |
| 4 níveis de risco | ✅ | LOW, MEDIUM, HIGH, CRITICAL |
| API REST completa | ✅ | 21 endpoints documentados |
| Swagger UI | ✅ | Documentação interativa em `/swagger-ui.html` |
| IoT simulado | ✅ | Sensores com leituras de temperatura, fumaça, água e umidade |
| Persistência de leituras | ✅ | Histórico de `SensorReading` por sensor |
| Inicialização de dados | ✅ | `DataInitializer` popula banco na primeira execução |

---

## 🏛️ Arquitetura

### App iOS — MVVM

```
View  ──►  ViewModel  ──►  Service  ──►  API / MockData
  ◄──        ◄──             ◄──
(SwiftUI)  (@Published)   (Protocol)
```

- **Views** são declarativas e sem lógica de negócio
- **ViewModels** expõem `@Published` para reatividade
- **Services** implementam `AlertServiceProtocol`, permitindo troca entre mock e real
- `MockAlertService` viabiliza desenvolvimento sem backend rodando

### Backend — Layered Architecture

```
Request  ──►  JwtFilter  ──►  Controller  ──►  Service  ──►  Repository  ──►  PostgreSQL
                                   ◄──             ◄──            ◄──
                               (DTO out)     (Entity in)     (JpaRepository)
```

- **Controller** recebe requisições HTTP e retorna DTOs
- **Service** contém as regras de negócio e orquestra repositórios
- **Repository** estende `JpaRepository<T, Long>` com queries customizadas
- **Entity** mapeada com JPA/Hibernate para tabelas PostgreSQL
- **JwtFilter** intercepta cada requisição e valida o Bearer token antes do controller

---

## 🚀 Como Rodar — Backend

### Pré-requisitos

- [Docker](https://www.docker.com) e Docker Compose
- [Java 17+](https://adoptium.net)
- [Maven 3.8+](https://maven.apache.org)

### 1. Subir o PostgreSQL

```bash
cd SpaceGuardBackEnd
docker compose up -d
```

O banco ficará disponível em `localhost:5432` com as credenciais:

| Parâmetro | Valor |
|---|---|
| Database | `spaceguard` |
| User | `spaceguard` |
| Password | `spaceguard123` |

### 2. Executar o backend

```bash
./mvnw spring-boot:run
```

Ou, para empacotar e executar:

```bash
./mvnw clean package -DskipTests
java -jar target/backend-*.jar
```

A API ficará disponível em: **`http://localhost:8080`**

### 3. Verificar

```bash
# Health check via curl
curl http://localhost:8080/regions
```

> **Nota:** Na primeira execução o `DataInitializer` popula o banco com regiões, sensores e alertas de exemplo automaticamente.

---

## 📱 Como Rodar — App iOS

### Pré-requisitos

- macOS 14+ (Sonoma ou superior)
- Xcode 15+
- iPhone Simulator (iOS 17+)

### Passos

```bash
# 1. Abrir o projeto no Xcode
open SpaceGuard/SpaceGuard.xcodeproj
```

1. No Xcode, selecione um simulador iPhone (ex: iPhone 15)
2. Pressione **⌘ + R** para compilar e executar
3. O app iniciará na tela de Login

> **Modo offline:** O app inclui `MockAlertService` com dados simulados, permitindo desenvolvimento sem o backend rodando.

---

## 📡 Endpoints da API

### Autenticação — `POST /auth/**` *(público)*

| Método | Endpoint | Descrição |
|---|---|---|
| `POST` | `/auth/register` | Cadastra novo usuário, retorna JWT |
| `POST` | `/auth/login` | Autentica usuário, retorna JWT |

**Exemplo de login:**
```json
POST /auth/login
{
  "email": "user@example.com",
  "password": "senha123"
}
```

**Resposta:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9..."
}
```

---

### Alertas — `/alerts/**` *(requer Bearer token)*

| Método | Endpoint | Descrição |
|---|---|---|
| `GET` | `/alerts` | Lista todos os alertas (mais recentes primeiro) |
| `GET` | `/alerts/{id}` | Retorna alerta por ID |
| `GET` | `/alerts/region/{regionId}` | Lista alertas de uma região |
| `POST` | `/alerts` | Cria novo alerta |
| `PUT` | `/alerts/{id}` | Atualiza alerta existente |
| `DELETE` | `/alerts/{id}` | Remove alerta |

---

### Sensores — `/sensors/**` *(requer Bearer token)*

| Método | Endpoint | Descrição |
|---|---|---|
| `GET` | `/sensors` | Lista todos os sensores |
| `GET` | `/sensors/{id}` | Retorna sensor por ID |
| `POST` | `/sensors` | Cria novo sensor |
| `PUT` | `/sensors/{id}` | Atualiza sensor |
| `DELETE` | `/sensors/{id}` | Remove sensor |
| `GET` | `/sensors/{id}/readings` | Lista leituras do sensor |
| `POST` | `/sensors/{id}/readings` | Registra nova leitura |

---

### Regiões — `/regions/**` *(requer Bearer token)*

| Método | Endpoint | Descrição |
|---|---|---|
| `GET` | `/regions` | Lista todas as regiões |
| `GET` | `/regions/{id}` | Retorna região por ID |
| `POST` | `/regions` | Cria nova região |
| `PUT` | `/regions/{id}` | Atualiza região |
| `DELETE` | `/regions/{id}` | Remove região |

**Autenticação nos endpoints protegidos:**
```
Authorization: Bearer <seu_jwt_token>
```

---

## 📄 Swagger UI

Com o backend rodando, acesse a documentação interativa:

```
http://localhost:8080/swagger-ui.html
```

O Swagger permite explorar todos os endpoints, visualizar schemas de request/response e executar chamadas diretamente pelo browser. Para testar endpoints protegidos, clique em **Authorize** e insira o token JWT no formato `Bearer <token>`.

A spec OpenAPI em JSON está disponível em:
```
http://localhost:8080/v3/api-docs
```

---

## 🗄️ Banco de Dados

### Diagrama de Entidades

```
User
 └── (autenticação independente)

Region  ──── Sensor ──── SensorReading
  │
  └──── EnvironmentalAlert
```

### Entidades

#### `User`
| Campo | Tipo | Descrição |
|---|---|---|
| `id` | `Long` | Chave primária |
| `email` | `String` | E-mail único do usuário |
| `passwordHash` | `String` | Senha com BCrypt |
| `createdAt` | `LocalDateTime` | Data de cadastro |

#### `Region`
| Campo | Tipo | Descrição |
|---|---|---|
| `id` | `Long` | Chave primária |
| `name` | `String` | Nome da região |
| `country` | `String` | País |
| `riskLevel` | `Enum` | LOW / MEDIUM / HIGH / CRITICAL |

#### `Sensor`
| Campo | Tipo | Descrição |
|---|---|---|
| `id` | `Long` | Chave primária |
| `name` | `String` | Identificação do sensor |
| `type` | `Enum` | TEMPERATURE / SMOKE / WATER / HUMIDITY / MULTI |
| `status` | `Enum` | ACTIVE / INACTIVE / MAINTENANCE |
| `region` | `FK` | Região associada |

#### `SensorReading`
| Campo | Tipo | Descrição |
|---|---|---|
| `id` | `Long` | Chave primária |
| `sensor` | `FK` | Sensor que gerou a leitura |
| `temperature` | `Double` | Temperatura (°C), nullable |
| `smokeLevel` | `Double` | Nível de fumaça, nullable |
| `waterLevel` | `Double` | Nível de água, nullable |
| `recordedAt` | `LocalDateTime` | Timestamp da leitura |

#### `EnvironmentalAlert`
| Campo | Tipo | Descrição |
|---|---|---|
| `id` | `Long` | Chave primária |
| `title` | `String` | Título do alerta |
| `description` | `String` | Descrição detalhada |
| `alertType` | `Enum` | FIRE / FLOOD / SMOKE / CRITICAL_EVENT |
| `riskLevel` | `Enum` | LOW / MEDIUM / HIGH / CRITICAL |
| `region` | `FK` | Região do alerta |
| `createdAt` | `LocalDateTime` | Data de criação |

---

## 🔒 Segurança

O sistema implementa autenticação stateless baseada em JWT:

1. **Registro/Login** — endpoint público em `/auth/**`; senha armazenada com **BCrypt**
2. **Emissão do token** — JWT assinado com HS256, expiração de **24 horas** (86400000 ms)
3. **Autorização** — `JwtFilter` intercepta todas as requisições, extrai e valida o Bearer token antes de liberar acesso
4. **Spring Security** — rotas públicas e protegidas configuradas em `SecurityConfig`; CSRF desativado (API stateless)
5. **Validação de entrada** — DTOs anotados com Bean Validation (`@NotBlank`, `@Email`, etc.)

---

## 📡 Simulação IoT

O projeto simula sensores de campo sem hardware real:

- **5 tipos de sensor:** `TEMPERATURE`, `SMOKE`, `WATER`, `HUMIDITY`, `MULTI`
- **3 estados operacionais:** `ACTIVE`, `INACTIVE`, `MAINTENANCE`
- **Leituras multi-variável:** um único `SensorReading` pode conter temperatura, nível de fumaça e nível de água simultaneamente (campos nullable)
- **App iOS:** `SensorSimulationView` + `SensorSimulationViewModel` permitem disparar leituras simuladas diretamente do app
- **MockData:** `MockAlertData.swift` e `MockAlertService.swift` fornecem dados de teste estáticos para desenvolvimento offline

---

## 🧪 Testes

### Via Postman

1. Importe a coleção ou crie as requisições manualmente
2. Faça login em `POST /auth/login` e copie o token da resposta
3. Configure a variável `{{token}}` no ambiente do Postman
4. Adicione o header `Authorization: Bearer {{token}}` nas requisições protegidas
5. Teste o fluxo completo: criar região → criar sensor → registrar leitura → criar alerta

### Fluxo básico de validação

```bash
# 1. Registrar usuário
curl -X POST http://localhost:8080/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@test.com","password":"senha123"}'

# 2. Login (guarde o token retornado)
curl -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@test.com","password":"senha123"}'

# 3. Listar regiões com token
curl http://localhost:8080/regions \
  -H "Authorization: Bearer SEU_TOKEN_AQUI"
```

---

## 🌐 ODS da ONU

O SpaceGuard está alinhado com os Objetivos de Desenvolvimento Sustentável da ONU:

| ODS | Título | Relação com o projeto |
|---|---|---|
| **ODS 9** | Indústria, Inovação e Infraestrutura | Uso de IoT, APIs REST e arquitetura de software moderna para infraestrutura de monitoramento |
| **ODS 11** | Cidades e Comunidades Sustentáveis | Monitoramento de regiões urbanas e rurais para gestão de riscos ambientais locais |
| **ODS 13** | Ação Contra a Mudança Global do Clima | Coleta e análise de dados ambientais (temperatura, fumaça, água) para suporte à tomada de decisão climática |

---

## 📸 Screenshots

> *As imagens abaixo serão adicionadas após execução em simulador/dispositivo real.*

### Login
| Tela de Login |
|---|
| `[ screenshot Login ]` |

### Dashboard de Alertas
| Dashboard — Lista de Alertas |
|---|
| `[ screenshot Dashboard ]` |

### Detalhe do Alerta
| Detalhe + Nível de Risco |
|---|
| `[ screenshot AlertDetail ]` |

### Simulação de Sensor
| Painel de Simulação IoT |
|---|
| `[ screenshot SensorSimulation ]` |

### Swagger UI
| Documentação Interativa |
|---|
| `[ screenshot Swagger ]` |

---

## 🔮 Melhorias Futuras

- [ ] **Mapas interativos** — exibição geoespacial de sensores e alertas com MapKit (iOS) e integração de coordenadas nas entidades
- [ ] **Notificações push** — integração com APNs para alertas críticos em tempo real no dispositivo
- [ ] **Integração NASA / ESA** — consumo de APIs de dados de satélite para enriquecer o contexto ambiental
- [ ] **MQTT real** — substituir simulação por protocolo MQTT para conexão com hardware IoT físico
- [ ] **Machine learning** — modelos de predição de risco baseados no histórico de `SensorReading`
- [ ] **Dashboard web** — painel administrativo em React ou Angular para gestão de regiões e sensores
- [ ] **Multi-tenant** — suporte a múltiplas organizações com isolamento de dados por conta
- [ ] **Refresh token** — implementar rotação de tokens JWT para sessões de longa duração

---

## 📜 Licença

Este projeto está licenciado sob a **MIT License**.

```
MIT License

Copyright (c) 2024 SpaceGuard

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
```

---

<div align="center">

Desenvolvido como projeto acadêmico — SpaceGuard 🛰️

</div>
