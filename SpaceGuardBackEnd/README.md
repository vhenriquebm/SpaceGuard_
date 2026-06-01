# SpaceGuard — Backend

Sistema de monitoramento ambiental com sensores IoT simulados e alertas por região.  
API REST construída com Java Spring Boot + PostgreSQL.

---

## Stack

| Tecnologia | Versão |
|---|---|
| Java | 17+ |
| Spring Boot | 3.2.0 |
| PostgreSQL | 15 |
| Maven | 3.8+ |
| Lombok | 1.18.36 |
| JWT (jjwt) | 0.12.3 |
| Swagger (springdoc) | 2.3.0 |

---

## Pré-requisitos

- Java 17+ instalado (`java -version`)
- Maven 3.8+ instalado (`mvn -version`)
- PostgreSQL rodando localmente **ou** Docker instalado

---

## Como rodar

### 1. Subir o banco de dados

**Com Docker:**
```bash
docker-compose up -d
```

**Com Homebrew (macOS):**
```bash
brew services start postgresql@15
psql postgres -c "CREATE USER spaceguard WITH PASSWORD 'spaceguard123';"
psql postgres -c "CREATE DATABASE spaceguard OWNER spaceguard;"
```

### 2. Iniciar o servidor

```bash
mvn spring-boot:run
```

O servidor sobe em `http://localhost:8080`.

Na primeira execução o sistema cria automaticamente as tabelas e insere:
- Usuário admin: `admin@spaceguard.com` / `admin123`
- 2 regiões de exemplo (Amazônia, Pantanal)
- 2 sensores e 2 alertas ambientais

---

## Documentação da API

Acesse o Swagger após iniciar o servidor:

```
http://localhost:8080/swagger-ui.html
```

Para testar endpoints protegidos no Swagger:
1. Faça login em `POST /auth/login`
2. Copie o token retornado
3. Clique em **Authorize** (canto superior direito)
4. Cole o token e confirme

---

## Endpoints

| Método | Rota | Descrição | Auth |
|---|---|---|---|
| POST | `/auth/register` | Cadastrar usuário | — |
| POST | `/auth/login` | Login e geração de token | — |
| GET | `/regions` | Listar regiões | JWT |
| POST | `/regions` | Criar região | JWT |
| PUT | `/regions/{id}` | Atualizar região | JWT |
| DELETE | `/regions/{id}` | Remover região | JWT |
| GET | `/sensors` | Listar sensores | JWT |
| POST | `/sensors` | Criar sensor | JWT |
| GET | `/sensors/{id}/readings` | Leituras de um sensor | JWT |
| POST | `/sensors/{id}/readings` | Registrar leitura IoT | JWT |
| GET | `/alerts` | Listar alertas | JWT |
| GET | `/alerts/region/{id}` | Alertas por região | JWT |
| POST | `/alerts` | Criar alerta | JWT |
| PUT | `/alerts/{id}` | Atualizar alerta | JWT |
| DELETE | `/alerts/{id}` | Remover alerta | JWT |

---

## Autenticação

Todas as rotas exceto `/auth/**` e `/swagger-ui/**` exigem token JWT no header:

```
Authorization: Bearer <token>
```

O token é obtido via `POST /auth/login` e tem validade de 24 horas.

---

## Exemplo rápido com curl

```bash
# Login
curl -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@spaceguard.com","password":"admin123"}'

# Listar alertas (substituir <token> pelo valor retornado acima)
curl http://localhost:8080/alerts \
  -H "Authorization: Bearer <token>"

# Criar leitura de sensor
curl -X POST http://localhost:8080/sensors/1/readings \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <token>" \
  -d '{"temperature":44.7,"smokeLevel":0.88,"waterLevel":1.50}'
```

---

## Estrutura do projeto

```
src/main/java/com/spaceguard/backend/
├── SpaceGuardApplication.java
├── config/
│   ├── DataInitializer.java      # seed automático de dados
│   ├── OpenApiConfig.java        # configuração do Swagger
│   └── SecurityConfig.java       # Spring Security + JWT
├── controller/
│   ├── AuthController.java
│   ├── AlertController.java
│   ├── RegionController.java
│   └── SensorController.java
├── service/
│   ├── AuthService.java
│   ├── AlertService.java
│   ├── RegionService.java
│   └── SensorService.java
├── repository/
│   ├── UserRepository.java
│   ├── AlertRepository.java
│   ├── RegionRepository.java
│   ├── SensorRepository.java
│   └── SensorReadingRepository.java
├── entity/
│   ├── User.java
│   ├── Region.java
│   ├── Sensor.java
│   ├── SensorReading.java
│   ├── EnvironmentalAlert.java
│   ├── RiskLevel.java            # enum: LOW | MEDIUM | HIGH | CRITICAL
│   ├── AlertType.java            # enum: FIRE | FLOOD | SMOKE | CRITICAL_EVENT
│   ├── SensorType.java
│   └── SensorStatus.java
├── dto/
│   ├── LoginRequest.java
│   ├── LoginResponse.java
│   ├── RegisterRequest.java
│   ├── AlertDTO.java
│   ├── RegionDTO.java
│   ├── SensorDTO.java
│   └── SensorReadingDTO.java
├── security/
│   ├── JwtUtil.java
│   ├── JwtFilter.java
│   └── UserDetailsServiceImpl.java
└── exception/
    └── GlobalExceptionHandler.java
```

---

## Banco de dados

Scripts disponíveis em `docs/`:

| Arquivo | Conteúdo |
|---|---|
| `spaceguard_schema.sql` | CREATE TABLE com PKs, FKs e constraints |
| `spaceguard_inserts.sql` | Dados de exemplo para popular o banco |
| `spaceguard_queries.sql` | Consultas SQL operacionais |
| `spaceguard_dbdiagram.dbml` | Modelo ER para dbdiagram.io |

Para recriar o banco do zero:
```bash
psql -U spaceguard -d spaceguard -f docs/spaceguard_schema.sql
psql -U spaceguard -d spaceguard -f docs/spaceguard_inserts.sql
```

---

## Variáveis de configuração

Definidas em `src/main/resources/application.yml`:

| Propriedade | Padrão | Descrição |
|---|---|---|
| `server.port` | `8080` | Porta do servidor |
| `spring.datasource.url` | `jdbc:postgresql://localhost:5432/spaceguard` | URL do banco |
| `spring.datasource.username` | `spaceguard` | Usuário do banco |
| `spring.datasource.password` | `spaceguard123` | Senha do banco |
| `app.jwt.secret` | *(ver application.yml)* | Chave de assinatura JWT |
| `app.jwt.expiration` | `86400000` | Validade do token (24h em ms) |

---

## Projeto relacionado

- **SpaceGuard Mobile:** app iOS em SwiftUI com arquitetura MVVM, consome esta API.
