# SpaceGuard — Plano de Testes
**Sistema de Monitoramento Ambiental**
**Versão:** 1.0 | **Data:** 01/06/2026

---

## 1. Introdução

Este documento descreve o plano de testes do sistema SpaceGuard, composto por um
aplicativo mobile SwiftUI e uma API REST desenvolvida em Java Spring Boot com banco
de dados PostgreSQL. Os testes têm como objetivo verificar o correto funcionamento
dos endpoints, a segurança da autenticação JWT e a integridade dos dados persistidos.

---

## 2. Escopo dos Testes

| Camada | O que é testado |
|---|---|
| API REST | Endpoints de autenticação, alertas, regiões, sensores e leituras |
| Segurança | Proteção de rotas com JWT, rejeição de tokens inválidos |
| Banco de Dados | Persistência correta dos dados após cada operação |
| IoT (Sensores) | Registro de leituras de sensores com dados ambientais |
| Validação | Rejeição de dados incompletos ou inválidos |

---

## 3. Ambiente de Testes

| Item | Configuração |
|---|---|
| Servidor | Java 21, Spring Boot 3.2, porta 8080 |
| Banco | PostgreSQL 15 (Homebrew), banco `spaceguard` |
| Ferramenta de teste | Postman / curl |
| Base URL | `http://localhost:8080` |
| Usuário de teste | `teste@spaceguard.com` / `teste123` |

---

## 4. Plano de Testes — Casos de Teste

---

### TC-001 — Cadastro de Novo Usuário

| Campo | Descrição |
|---|---|
| **ID** | TC-001 |
| **Funcionalidade** | Autenticação — Cadastro |
| **Cenário** | Registrar um novo usuário com e-mail e senha válidos |
| **Pré-condição** | E-mail não cadastrado no banco de dados |
| **Entrada** | `POST /auth/register` — `{ "email": "novo@spaceguard.com", "password": "senha123" }` |
| **Passos** | 1. Abrir Postman; 2. Configurar POST para `/auth/register`; 3. Inserir body JSON; 4. Enviar requisição |
| **Resultado Esperado** | HTTP 200 com token JWT e e-mail retornados |
| **Status** | ✅ PASSOU |

---

### TC-002 — Cadastro com E-mail Duplicado

| Campo | Descrição |
|---|---|
| **ID** | TC-002 |
| **Funcionalidade** | Autenticação — Cadastro |
| **Cenário** | Tentar registrar um e-mail que já existe no banco |
| **Pré-condição** | Usuário com o e-mail já cadastrado (TC-001 executado) |
| **Entrada** | `POST /auth/register` — `{ "email": "teste@spaceguard.com", "password": "outrasenha" }` |
| **Passos** | 1. Repetir requisição do TC-001 com mesmo e-mail; 2. Enviar |
| **Resultado Esperado** | HTTP 400 com `{ "error": "Email already registered" }` |
| **Status** | ✅ PASSOU |

---

### TC-003 — Login com Credenciais Válidas

| Campo | Descrição |
|---|---|
| **ID** | TC-003 |
| **Funcionalidade** | Autenticação — Login |
| **Cenário** | Usuário existente faz login com e-mail e senha corretos |
| **Pré-condição** | Usuário cadastrado no banco (TC-001 executado) |
| **Entrada** | `POST /auth/login` — `{ "email": "teste@spaceguard.com", "password": "teste123" }` |
| **Passos** | 1. Configurar POST para `/auth/login`; 2. Inserir credenciais corretas; 3. Enviar |
| **Resultado Esperado** | HTTP 200 com `token`, `email` e `type: "Bearer"` |
| **Status** | ✅ PASSOU |

---

### TC-004 — Login com Senha Incorreta

| Campo | Descrição |
|---|---|
| **ID** | TC-004 |
| **Funcionalidade** | Autenticação — Login |
| **Cenário** | Usuário tenta login com senha errada |
| **Pré-condição** | Usuário cadastrado no banco |
| **Entrada** | `POST /auth/login` — `{ "email": "teste@spaceguard.com", "password": "senhaerrada" }` |
| **Passos** | 1. Configurar POST para `/auth/login`; 2. Inserir senha incorreta; 3. Enviar |
| **Resultado Esperado** | HTTP 400 com `{ "error": "Invalid credentials" }` |
| **Status** | ✅ PASSOU |

---

### TC-005 — Acesso a Endpoint Protegido sem Token

| Campo | Descrição |
|---|---|
| **ID** | TC-005 |
| **Funcionalidade** | Segurança — Proteção JWT |
| **Cenário** | Requisição a endpoint protegido sem enviar o token de autenticação |
| **Pré-condição** | Nenhuma |
| **Entrada** | `GET /alerts` — sem header Authorization |
| **Passos** | 1. Configurar GET para `/alerts`; 2. Não adicionar header Authorization; 3. Enviar |
| **Resultado Esperado** | HTTP 403 — acesso negado pelo Spring Security |
| **Status** | ✅ PASSOU |

---

### TC-006 — Listagem de Alertas Autenticado

| Campo | Descrição |
|---|---|
| **ID** | TC-006 |
| **Funcionalidade** | Alertas — Listagem |
| **Cenário** | Usuário autenticado solicita lista de todos os alertas ambientais |
| **Pré-condição** | Token JWT válido obtido via login |
| **Entrada** | `GET /alerts` — header `Authorization: Bearer <token>` |
| **Passos** | 1. Fazer login (TC-003) e copiar token; 2. Configurar GET para `/alerts`; 3. Adicionar header Authorization; 4. Enviar |
| **Resultado Esperado** | HTTP 200 com array JSON de alertas, ordenados do mais recente para o mais antigo |
| **Status** | ✅ PASSOU |

---

### TC-007 — Criação de Alerta Ambiental

| Campo | Descrição |
|---|---|
| **ID** | TC-007 |
| **Funcionalidade** | Alertas — Criação |
| **Cenário** | Usuário autenticado cria um novo alerta para uma região existente |
| **Pré-condição** | Token JWT válido; região com ID 1 existente no banco |
| **Entrada** | `POST /alerts` com body: `{ "title": "Alerta de Fumaça", "description": "...", "riskLevel": "HIGH", "alertType": "SMOKE", "regionId": 1 }` |
| **Passos** | 1. Obter token via login; 2. Configurar POST para `/alerts`; 3. Inserir body JSON; 4. Adicionar Authorization header; 5. Enviar |
| **Resultado Esperado** | HTTP 201 com o objeto criado incluindo `id` e `createdAt` gerados pelo servidor |
| **Status** | ✅ PASSOU |

---

### TC-008 — Criação de Leitura de Sensor (IoT)

| Campo | Descrição |
|---|---|
| **ID** | TC-008 |
| **Funcionalidade** | Sensores — Leitura IoT |
| **Cenário** | Registrar nova leitura de um sensor com dados de temperatura, fumaça e água |
| **Pré-condição** | Token JWT válido; sensor com ID 1 existente no banco |
| **Entrada** | `POST /sensors/1/readings` com body: `{ "temperature": 44.7, "smokeLevel": 0.88, "waterLevel": 1.50 }` |
| **Passos** | 1. Obter token; 2. Configurar POST para `/sensors/1/readings`; 3. Inserir dados da leitura; 4. Enviar |
| **Resultado Esperado** | HTTP 201 com `id`, `sensorId`, valores e `recordedAt` preenchido automaticamente |
| **Status** | ✅ PASSOU |

---

### TC-009 — Consulta de Alertas por Região

| Campo | Descrição |
|---|---|
| **ID** | TC-009 |
| **Funcionalidade** | Alertas — Filtro por Região |
| **Cenário** | Buscar apenas os alertas de uma região específica |
| **Pré-condição** | Token JWT válido; alertas cadastrados para a região 2 (Pantanal) |
| **Entrada** | `GET /alerts/region/2` — header Authorization |
| **Passos** | 1. Obter token; 2. Configurar GET para `/alerts/region/2`; 3. Enviar |
| **Resultado Esperado** | HTTP 200 com array contendo apenas alertas cujo `regionId` é 2 |
| **Status** | ✅ PASSOU |

---

### TC-010 — Validação de Campos Obrigatórios

| Campo | Descrição |
|---|---|
| **ID** | TC-010 |
| **Funcionalidade** | Validação — Bean Validation |
| **Cenário** | Criar alerta sem enviar campos obrigatórios |
| **Pré-condição** | Token JWT válido |
| **Entrada** | `POST /alerts` com body incompleto: `{ "description": "Sem titulo" }` |
| **Passos** | 1. Obter token; 2. Configurar POST para `/alerts`; 3. Enviar body sem campos obrigatórios |
| **Resultado Esperado** | HTTP 400 com JSON listando cada campo inválido e a mensagem de erro correspondente |
| **Status** | ✅ PASSOU |

---

## 5. Testes Manuais via Postman

### Como configurar no Postman

1. Crie uma **Collection** chamada `SpaceGuard API`
2. Adicione uma variável de coleção: `token` (preenchida após o login)
3. No login, adicione este script em **Tests**:
```javascript
pm.collectionVariables.set("token", pm.response.json().token);
```
4. Nos demais requests, use no header: `Authorization: Bearer {{token}}`

---

### Requisições configuradas

**POST /auth/register**
```
Método:  POST
URL:     http://localhost:8080/auth/register
Headers: Content-Type: application/json
Body:
{
    "email": "novo@spaceguard.com",
    "password": "senha123"
}
Resposta esperada (200):
{
    "token": "eyJhbGci...",
    "email": "novo@spaceguard.com",
    "type": "Bearer"
}
```

**POST /auth/login**
```
Método:  POST
URL:     http://localhost:8080/auth/login
Headers: Content-Type: application/json
Body:
{
    "email": "teste@spaceguard.com",
    "password": "teste123"
}
Resposta esperada (200):
{
    "token": "eyJhbGci...",
    "email": "teste@spaceguard.com",
    "type": "Bearer"
}
```

**GET /alerts**
```
Método:  GET
URL:     http://localhost:8080/alerts
Headers: Authorization: Bearer {{token}}
Body:    (vazio)
Resposta esperada (200): array de alertas
```

**POST /alerts**
```
Método:  POST
URL:     http://localhost:8080/alerts
Headers: Content-Type: application/json
         Authorization: Bearer {{token}}
Body:
{
    "title": "Alerta de Fumaça — Novo Foco",
    "description": "Sensor detectou aumento súbito no índice de fumaça.",
    "riskLevel": "HIGH",
    "alertType": "SMOKE",
    "regionId": 1
}
Resposta esperada (201):
{
    "id": 6,
    "title": "Alerta de Fumaça — Novo Foco",
    "riskLevel": "HIGH",
    "alertType": "SMOKE",
    "regionId": 1,
    "createdAt": "2026-06-01T21:19:37"
}
```

**POST /sensors/{id}/readings**
```
Método:  POST
URL:     http://localhost:8080/sensors/1/readings
Headers: Content-Type: application/json
         Authorization: Bearer {{token}}
Body:
{
    "temperature": 44.7,
    "smokeLevel": 0.88,
    "waterLevel": 1.50
}
Resposta esperada (201):
{
    "id": 9,
    "sensorId": 1,
    "temperature": 44.7,
    "smokeLevel": 0.88,
    "waterLevel": 1.5,
    "recordedAt": "2026-06-01T21:19:47"
}
```

**GET /alerts/region/{id}**
```
Método:  GET
URL:     http://localhost:8080/alerts/region/2
Headers: Authorization: Bearer {{token}}
Body:    (vazio)
Resposta esperada (200): apenas alertas da região 2 (Pantanal)
```

---

## 6. Evidências de Execução

### Evidência 1 — TC-001: Cadastro de Usuário (HTTP 200)

**Descrição:** Print da aba "Body" do Postman mostrando o retorno do cadastro com token JWT gerado.

**Log capturado:**
```json
POST /auth/register → HTTP 200 OK

Request Body:
{
  "email": "teste@spaceguard.com",
  "password": "teste123"
}

Response Body:
{
  "token": "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0ZXN0ZUBzcGFjZWd1YXJkLmNvbSIsImlhdCI6MTc4MDM0NTExMSwiZXhwIjoxNzgwNDMxNTExfQ.SYQwI5jw_Yzr6LKd5AliN1KQGTgzOYVXabQ-U303AKpOFUbd9ilhsmZsR-jRJak0hXgWvA2sBRyaqZdO_QfbUg",
  "email": "teste@spaceguard.com",
  "type": "Bearer"
}
```
**O que salvar:** Print da tela do Postman com status 200, response body e o token JWT visível.

---

### Evidência 2 — TC-006 + TC-008: Listagem de Alertas e Criação de Leitura (HTTP 200 / 201)

**Descrição:** Print mostrando a listagem completa de alertas retornados pela API e o registro de uma nova leitura de sensor.

**Log capturado — GET /alerts (HTTP 200):**
```json
[
  {
    "id": 1,
    "title": "Incêndio Detectado — Setor Norte",
    "description": "Temperatura acima de 45°C e fumaça densa detectadas no setor norte.",
    "riskLevel": "CRITICAL",
    "alertType": "FIRE",
    "regionId": 2,
    "createdAt": "2026-06-01T18:30:00"
  },
  {
    "id": 3,
    "title": "Fumaça Densa — Área de Preservação",
    "riskLevel": "HIGH",
    "alertType": "SMOKE",
    "regionId": 1,
    "createdAt": "2026-06-01T15:00:00"
  }
  ...
]
```

**Log capturado — POST /sensors/1/readings (HTTP 201):**
```json
{
  "id": 9,
  "sensorId": 1,
  "temperature": 44.7,
  "smokeLevel": 0.88,
  "waterLevel": 1.5,
  "recordedAt": "2026-06-01T21:19:47.401034"
}
```
**O que salvar:** Print do Postman mostrando status 201, o objeto retornado com `id` e `recordedAt` gerados automaticamente pelo servidor.

---

### Evidência 3 — TC-005 + TC-010: Segurança e Validação (HTTP 403 / 400)

**Descrição:** Print demonstrando que o sistema rejeita acessos não autorizados e dados inválidos.

**Log capturado — GET /alerts sem token (HTTP 403):**
```
GET http://localhost:8080/alerts
(sem header Authorization)

Status: 403 Forbidden
Body: (vazio — bloqueado pelo Spring Security antes de chegar ao controller)
```

**Log capturado — POST /alerts sem campos obrigatórios (HTTP 400):**
```json
POST /alerts com body: { "description": "Sem titulo" }

Status: 400 Bad Request
Response Body:
{
  "riskLevel": "Risk level is required",
  "alertType": "Alert type is required",
  "regionId":  "Region ID is required",
  "title":     "Title is required"
}
```
**O que salvar:** Print mostrando os dois casos lado a lado — 403 sem token e 400 com validação detalhada por campo.

---

## 7. Como os Testes Validam o Sistema

### 7.1 API REST
Os testes TC-001 a TC-010 cobrem os principais fluxos da API: cadastro, login, leitura,
criação e filtragem de dados. Cada teste verifica o **método HTTP correto**, a
**estrutura do JSON de resposta** e o **status HTTP esperado** (200, 201 ou 400),
garantindo que os endpoints se comportam conforme a especificação REST.

### 7.2 Segurança
O TC-005 valida que **nenhum endpoint protegido** pode ser acessado sem um token JWT
válido — o Spring Security retorna 403 antes mesmo de o código da aplicação ser
executado. O TC-004 confirma que credenciais incorretas não geram token, e o TC-002
impede cadastros duplicados. Isso assegura que o sistema não expõe dados ambientais
sem autenticação, requisito essencial para a integração com o app iOS.

### 7.3 Banco de Dados
Toda operação de escrita (TC-001, TC-007, TC-008) é verificada pelo retorno do objeto
persistido com `id` gerado pelo PostgreSQL e `createdAt`/`recordedAt` preenchidos
automaticamente. Isso confirma que os dados chegaram ao banco com integridade. O
TC-009 (filtro por região) valida que as **chaves estrangeiras** estão funcionando
corretamente e que os relacionamentos entre entidades estão íntegros.

### 7.4 IoT — Leituras de Sensores
O TC-008 simula o comportamento de um sensor IoT enviando dados de campo:
temperatura (44.7°C), nível de fumaça (0.88) e nível de água (1.50m). O retorno
com `recordedAt` automático replica o comportamento esperado de um dispositivo real
registrando uma telemetria. Em produção, esse endpoint seria chamado diretamente
pelo firmware do sensor ou por um gateway MQTT.

### 7.5 Fluxo Principal do Sistema
Os testes cobrem o **fluxo completo de ponta a ponta**:

```
1. Usuário se cadastra           → TC-001 (POST /auth/register)
2. Usuário faz login             → TC-003 (POST /auth/login)
3. Sensor registra leitura       → TC-008 (POST /sensors/{id}/readings)
4. Sistema gera alerta           → TC-007 (POST /alerts)
5. App lista alertas             → TC-006 (GET /alerts)
6. App filtra por região         → TC-009 (GET /alerts/region/{id})
7. Acesso sem autenticação falha → TC-005 (GET /alerts sem token)
```

Esse fluxo reflete exatamente como o aplicativo iOS SpaceGuard consumiria a API:
o usuário faz login, recebe o token, e todas as requisições subsequentes usam
esse token para acessar os dados de monitoramento ambiental.

---

## 8. Resumo dos Resultados

| ID | Funcionalidade | Status HTTP Esperado | Resultado |
|---|---|---|---|
| TC-001 | Cadastro de usuário novo | 200 | ✅ PASSOU |
| TC-002 | Cadastro com e-mail duplicado | 400 | ✅ PASSOU |
| TC-003 | Login com credenciais válidas | 200 | ✅ PASSOU |
| TC-004 | Login com senha incorreta | 400 | ✅ PASSOU |
| TC-005 | Acesso sem token JWT | 403 | ✅ PASSOU |
| TC-006 | Listagem de alertas | 200 | ✅ PASSOU |
| TC-007 | Criação de alerta ambiental | 201 | ✅ PASSOU |
| TC-008 | Criação de leitura de sensor | 201 | ✅ PASSOU |
| TC-009 | Alertas filtrados por região | 200 | ✅ PASSOU |
| TC-010 | Validação de campos obrigatórios | 400 | ✅ PASSOU |

**Taxa de sucesso: 10/10 — 100%**
