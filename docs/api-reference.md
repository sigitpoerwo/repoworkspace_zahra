# API Reference Template

> Template untuk dokumentasi API

---

## Base URL

```
Development: http://localhost:3000/api
Production: https://your-domain.com/api
```

---

## Authentication

### Bearer Token
```http
Authorization: Bearer <token>
```

### API Key (alternative)
```http
X-API-Key: <api-key>
```

---

## Endpoints

### Users

#### Get All Users
```http
GET /api/users
```

**Query Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| page | number | No | Page number (default: 1) |
| limit | number | No | Items per page (default: 10) |
| search | string | No | Search by name or email |

**Response:**
```json
{
  "data": [
    {
      "id": "uuid",
      "name": "John Doe",
      "email": "john@example.com",
      "createdAt": "2026-03-19T00:00:00.000Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 10,
    "total": 100,
    "totalPages": 10
  }
}
```

**Status Codes:**
- `200` — Success
- `401` — Unauthorized
- `500` — Server Error

---

#### Get User by ID
```http
GET /api/users/:id
```

**Path Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| id | string | Yes | User UUID |

**Response:**
```json
{
  "data": {
    "id": "uuid",
    "name": "John Doe",
    "email": "john@example.com",
    "createdAt": "2026-03-19T00:00:00.000Z"
  }
}
```

**Status Codes:**
- `200` — Success
- `404` — User not found
- `401` — Unauthorized

---

#### Create User
```http
POST /api/users
```

**Request Body:**
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "securepassword123"
}
```

**Validation Rules:**
- `name`: Required, min 2 characters
- `email`: Required, valid email format
- `password`: Required, min 8 characters

**Response:**
```json
{
  "data": {
    "id": "uuid",
    "name": "John Doe",
    "email": "john@example.com",
    "createdAt": "2026-03-19T00:00:00.000Z"
  },
  "message": "User created successfully"
}
```

**Status Codes:**
- `201` — Created
- `400` — Validation error
- `409` — Email already exists

---

#### Update User
```http
PATCH /api/users/:id
```

**Path Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| id | string | Yes | User UUID |

**Request Body:**
```json
{
  "name": "Jane Doe",
  "email": "jane@example.com"
}
```

**Response:**
```json
{
  "data": {
    "id": "uuid",
    "name": "Jane Doe",
    "email": "jane@example.com",
    "updatedAt": "2026-03-19T00:00:00.000Z"
  },
  "message": "User updated successfully"
}
```

**Status Codes:**
- `200` — Success
- `400` — Validation error
- `404` — User not found
- `401` — Unauthorized

---

#### Delete User
```http
DELETE /api/users/:id
```

**Path Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| id | string | Yes | User UUID |

**Response:**
```json
{
  "message": "User deleted successfully"
}
```

**Status Codes:**
- `204` — No Content
- `404` — User not found
- `401` — Unauthorized

---

## Error Responses

### Standard Error Format
```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable error message",
    "field": "fieldName" // Optional, for validation errors
  }
}
```

### Error Codes

| Code | Description |
|------|-------------|
| `VALIDATION_ERROR` | Request validation failed |
| `UNAUTHORIZED` | Authentication required |
| `FORBIDDEN` | Insufficient permissions |
| `NOT_FOUND` | Resource not found |
| `CONFLICT` | Resource already exists |
| `RATE_LIMIT_EXCEEDED` | Too many requests |
| `INTERNAL_ERROR` | Server error |

---

## Rate Limiting

- **Limit:** 100 requests per minute per IP
- **Headers:**
  ```
  X-RateLimit-Limit: 100
  X-RateLimit-Remaining: 95
  X-RateLimit-Reset: 1234567890
  ```

---

## Webhooks

### Event Types

| Event | Description |
|-------|-------------|
| `user.created` | New user registered |
| `user.updated` | User profile updated |
| `user.deleted` | User account deleted |

### Webhook Payload
```json
{
  "event": "user.created",
  "timestamp": "2026-03-19T00:00:00.000Z",
  "data": {
    "id": "uuid",
    "name": "John Doe",
    "email": "john@example.com"
  }
}
```

### Webhook Signature
```
X-Webhook-Signature: sha256=<signature>
```

Verify using HMAC SHA256 with your webhook secret.

---

## SDKs & Libraries

### JavaScript/TypeScript
```typescript
import { ApiClient } from '@your-org/api-client'

const client = new ApiClient({
  apiKey: 'your-api-key'
})

const users = await client.users.list()
```

### Python
```python
from your_org import ApiClient

client = ApiClient(api_key='your-api-key')
users = client.users.list()
```

---

## Changelog

### v1.1.0 (2026-03-19)
- Added pagination to user list endpoint
- Added search functionality
- Improved error messages

### v1.0.0 (2026-03-01)
- Initial release
- Basic CRUD operations for users

---

**Last Updated:** 2026-03-19
