---
name: sql-toolkit
version: 1.0.0
description: Use when working with SQLite, PostgreSQL, or MySQL databases. Covers schema design, migrations, query optimization, window functions, CTEs, JSONB, backup/restore, and database-specific patterns.
triggers:
 - SQLite
 - PostgreSQL
 - MySQL
 - database
 - SQL
 - query
 - schema
 - migration
 - window function
 - CTE
 - JSONB
 - backup
 - restore
role: specialist
scope: implementation
output-format: code
---

# SQL Toolkit

Comprehensive SQL guide covering SQLite, PostgreSQL, and MySQL. Includes schema design, migrations, query optimization, and database-specific patterns.

## Role Definition

You are a database specialist with expertise in SQLite, PostgreSQL, and MySQL. You write efficient queries, design normalized schemas, and implement safe migrations.

## Core Principles

1. **Start with SQLite** — zero setup, perfect for prototypes and small apps
2. **Normalize first** — denormalize only when measured performance requires it
3. **Index strategically** — based on query patterns, not every column
4. **Migrate safely** — test rollback, use transactions, backup first
5. **Optimize with data** — use EXPLAIN, measure before optimizing

---

## SQLite Patterns

### When to Use SQLite

- **Prototypes & MVPs** — zero setup, single file
- **Desktop apps** — embedded database, no server
- **Mobile apps** — iOS/Android built-in support
- **Small web apps** — < 100k requests/day
- **Data analysis** — CSV import, SQL queries, export results

### Schema Design

```sql
-- Users table with soft delete
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT UNIQUE NOT NULL,
  username TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  created_at TEXT DEFAULT (datetime('now')),
  deleted_at TEXT,
  CHECK (email LIKE '%@%')
);

-- Posts with foreign key
CREATE TABLE posts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  published_at TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Many-to-many with junction table
CREATE TABLE tags (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT UNIQUE NOT NULL
);

CREATE TABLE post_tags (
  post_id INTEGER NOT NULL,
  tag_id INTEGER NOT NULL,
  PRIMARY KEY (post_id, tag_id),
  FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
  FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE
);

-- Indexes
CREATE INDEX idx_posts_user_id ON posts(user_id);
CREATE INDEX idx_posts_published_at ON posts(published_at) WHERE published_at IS NOT NULL;
CREATE INDEX idx_users_deleted_at ON users(deleted_at) WHERE deleted_at IS NULL;
```

### Common Queries

```sql
-- Pagination
SELECT * FROM posts
WHERE published_at IS NOT NULL
ORDER BY published_at DESC
LIMIT 20 OFFSET 0;

-- Search with LIKE
SELECT * FROM posts
WHERE title LIKE '%search%' OR body LIKE '%search%'
ORDER BY created_at DESC;

-- Count with GROUP BY
SELECT user_id, COUNT(*) as post_count
FROM posts
WHERE published_at IS NOT NULL
GROUP BY user_id
ORDER BY post_count DESC;

-- Join with aggregation
SELECT u.username, COUNT(p.id) as post_count
FROM users u
LEFT JOIN posts p ON u.id = p.user_id AND p.published_at IS NOT NULL
WHERE u.deleted_at IS NULL
GROUP BY u.id, u.username
ORDER BY post_count DESC;
```

### JSON Support (SQLite 3.38+)

```sql
-- Store JSON
CREATE TABLE products (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  attributes TEXT -- JSON column
);

INSERT INTO products (name, attributes) VALUES
  ('Laptop', '{"brand": "Dell", "ram": 16, "storage": 512}'),
  ('Phone', '{"brand": "Apple", "ram": 8, "storage": 256}');

-- Query JSON
SELECT name, json_extract(attributes, '$.brand') as brand
FROM products
WHERE json_extract(attributes, '$.ram') >= 16;

-- Update JSON
UPDATE products
SET attributes = json_set(attributes, '$.storage', 1024)
WHERE id = 1;
```

### CSV Import/Export

```sql
-- Import CSV
.mode csv
.import data.csv users

-- Export CSV
.mode csv
.output users.csv
SELECT * FROM users;
.output stdout
```

### Backup & Restore

```bash
# Backup
sqlite3 app.db ".backup backup.db"

# Restore
sqlite3 app.db ".restore backup.db"

# Dump to SQL
sqlite3 app.db .dump > backup.sql

# Restore from SQL
sqlite3 app.db < backup.sql
```

---

## PostgreSQL Patterns

### When to Use PostgreSQL

- **Production web apps** — ACID, concurrent writes
- **Complex queries** — CTEs, window functions, full-text search
- **JSON data** — JSONB indexing and queries
- **Geospatial** — PostGIS extension
- **Large datasets** — partitioning, replication

### Schema Design

```sql
-- Use UUIDs for distributed systems
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email VARCHAR(255) UNIQUE NOT NULL,
  username VARCHAR(50) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ,
  CONSTRAINT users_email_format CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
);

-- Enum types
CREATE TYPE user_status AS ENUM ('active', 'inactive', 'suspended');

ALTER TABLE users ADD COLUMN status user_status DEFAULT 'active';

-- JSONB column
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  attributes JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- GIN index for JSONB
CREATE INDEX idx_products_attributes ON products USING gin(attributes);

-- Partial index
CREATE INDEX idx_users_active ON users(email) WHERE deleted_at IS NULL;

-- Composite index (order matters!)
CREATE INDEX idx_posts_user_published ON posts(user_id, published_at DESC);
```

### JSONB Queries

```sql
-- Insert JSONB
INSERT INTO products (name, attributes) VALUES
  ('Laptop', '{"brand": "Dell", "specs": {"ram": 16, "storage": 512}}'),
  ('Phone', '{"brand": "Apple", "specs": {"ram": 8, "storage": 256}}');

-- Query JSONB
SELECT name, attributes->>'brand' as brand
FROM products
WHERE (attributes->'specs'->>'ram')::int >= 16;

-- Update JSONB
UPDATE products
SET attributes = jsonb_set(attributes, '{specs,storage}', '1024')
WHERE id = 1;

-- Array contains
SELECT * FROM products
WHERE attributes->'tags' @> '["laptop"]';

-- Key exists
SELECT * FROM products
WHERE attributes ? 'warranty';
```

### Window Functions

```sql
-- Row number
SELECT
  username,
  created_at,
  ROW_NUMBER() OVER (ORDER BY created_at) as row_num
FROM users;

-- Rank with ties
SELECT
  username,
  post_count,
  RANK() OVER (ORDER BY post_count DESC) as rank
FROM user_stats;

-- Running total
SELECT
  date,
  revenue,
  SUM(revenue) OVER (ORDER BY date) as running_total
FROM daily_sales;

-- Moving average
SELECT
  date,
  revenue,
  AVG(revenue) OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) as avg_7_days
FROM daily_sales;

-- Partition by
SELECT
  category,
  product_name,
  sales,
  RANK() OVER (PARTITION BY category ORDER BY sales DESC) as rank_in_category
FROM products;
```

### CTEs (Common Table Expressions)

```sql
-- Basic CTE
WITH active_users AS (
  SELECT * FROM users WHERE deleted_at IS NULL
)
SELECT * FROM active_users WHERE created_at > '2024-01-01';

-- Multiple CTEs
WITH
  active_users AS (
    SELECT * FROM users WHERE deleted_at IS NULL
  ),
  user_posts AS (
    SELECT user_id, COUNT(*) as post_count
    FROM posts
    WHERE published_at IS NOT NULL
    GROUP BY user_id
  )
SELECT u.username, COALESCE(p.post_count, 0) as posts
FROM active_users u
LEFT JOIN user_posts p ON u.id = p.user_id
ORDER BY posts DESC;

-- Recursive CTE (tree traversal)
WITH RECURSIVE category_tree AS (
  -- Base case
  SELECT id, name, parent_id, 1 as level
  FROM categories
  WHERE parent_id IS NULL

  UNION ALL

  -- Recursive case
  SELECT c.id, c.name, c.parent_id, ct.level + 1
  FROM categories c
  JOIN category_tree ct ON c.parent_id = ct.id
)
SELECT * FROM category_tree ORDER BY level, name;
```

### Full-Text Search

```sql
-- Add tsvector column
ALTER TABLE posts ADD COLUMN search_vector tsvector
  GENERATED ALWAYS AS (
    to_tsvector('english', COALESCE(title, '') || ' ' || COALESCE(body, ''))
  ) STORED;

-- GIN index
CREATE INDEX idx_posts_search ON posts USING gin(search_vector);

-- Search query
SELECT title, ts_rank(search_vector, query) as rank
FROM posts, to_tsquery('english', 'postgresql & performance') query
WHERE search_vector @@ query
ORDER BY rank DESC;
```

### Triggers

```sql
-- Auto-update updated_at
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER users_updated_at
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();
```

---

## MySQL Patterns

### When to Use MySQL

- **WordPress/PHP apps** — ecosystem compatibility
- **Read-heavy workloads** — replication, caching
- **Simple queries** — CRUD operations
- **Legacy systems** — existing MySQL infrastructure

### Schema Design

```sql
-- Auto-increment primary key
CREATE TABLE users (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  username VARCHAR(50) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP NULL,
  INDEX idx_email (email),
  INDEX idx_deleted_at (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Foreign key
CREATE TABLE posts (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT UNSIGNED NOT NULL,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  published_at TIMESTAMP NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_user_id (user_id),
  INDEX idx_published_at (published_at),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### JSON Support (MySQL 5.7+)

```sql
-- JSON column
CREATE TABLE products (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  attributes JSON NOT NULL
) ENGINE=InnoDB;

-- Insert JSON
INSERT INTO products (name, attributes) VALUES
  ('Laptop', '{"brand": "Dell", "ram": 16, "storage": 512}'),
  ('Phone', '{"brand": "Apple", "ram": 8, "storage": 256}');

-- Query JSON
SELECT name, JSON_EXTRACT(attributes, '$.brand') as brand
FROM products
WHERE JSON_EXTRACT(attributes, '$.ram') >= 16;

-- Update JSON
UPDATE products
SET attributes = JSON_SET(attributes, '$.storage', 1024)
WHERE id = 1;
```

---

## Migration Patterns

### Migration Tracking

```sql
-- SQLite/PostgreSQL/MySQL
CREATE TABLE schema_migrations (
  version VARCHAR(255) PRIMARY KEY,
  applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Track migration
INSERT INTO schema_migrations (version) VALUES ('20240101_create_users');
```

### Safe Migration Process

```sql
-- 1. Backup first
-- SQLite: sqlite3 app.db ".backup backup.db"
-- PostgreSQL: pg_dump dbname > backup.sql
-- MySQL: mysqldump dbname > backup.sql

-- 2. Run migration in transaction (PostgreSQL/MySQL)
BEGIN;

-- Your migration here
ALTER TABLE users ADD COLUMN phone VARCHAR(20);

-- Verify
SELECT COUNT(*) FROM users;

-- Commit or rollback
COMMIT;
-- ROLLBACK;

-- 3. Record migration
INSERT INTO schema_migrations (version) VALUES ('20240101_add_phone');
```

### Zero-Downtime Migrations

```sql
-- Step 1: Add new column (nullable)
ALTER TABLE users ADD COLUMN display_name VARCHAR(100);

-- Step 2: Backfill data
UPDATE users SET display_name = username WHERE display_name IS NULL;

-- Step 3: Make NOT NULL
ALTER TABLE users ALTER COLUMN display_name SET NOT NULL; -- PostgreSQL
-- ALTER TABLE users MODIFY display_name VARCHAR(100) NOT NULL; -- MySQL

-- Step 4: Drop old column (after code deployment)
ALTER TABLE users DROP COLUMN username;
```

---

## Query Optimization

### Use EXPLAIN

```sql
-- SQLite
EXPLAIN QUERY PLAN
SELECT * FROM posts WHERE user_id = 1;

-- PostgreSQL
EXPLAIN ANALYZE
SELECT * FROM posts WHERE user_id = 1;

-- MySQL
EXPLAIN
SELECT * FROM posts WHERE user_id = 1;
```

### Index Strategy

```sql
-- Index foreign keys
CREATE INDEX idx_posts_user_id ON posts(user_id);

-- Composite index (order matters!)
CREATE INDEX idx_posts_user_published ON posts(user_id, published_at);

-- Covering index (PostgreSQL)
CREATE INDEX idx_posts_covering ON posts(user_id) INCLUDE (title, published_at);

-- Partial index (PostgreSQL/SQLite)
CREATE INDEX idx_posts_published ON posts(published_at) WHERE published_at IS NOT NULL;
```

### Avoid N+1 Queries

```sql
-- Bad: N+1 queries
SELECT * FROM users; -- 1 query
-- Then for each user:
SELECT * FROM posts WHERE user_id = ?; -- N queries

-- Good: Single query with JOIN
SELECT u.*, p.*
FROM users u
LEFT JOIN posts p ON u.id = p.user_id;

-- Or use subquery
SELECT u.*,
  (SELECT COUNT(*) FROM posts WHERE user_id = u.id) as post_count
FROM users u;
```

---

## Backup & Restore

### SQLite

```bash
# Backup
sqlite3 app.db ".backup backup.db"

# Restore
sqlite3 app.db ".restore backup.db"

# Dump to SQL
sqlite3 app.db .dump > backup.sql

# Restore from SQL
sqlite3 new.db < backup.sql
```

### PostgreSQL

```bash
# Backup single database
pg_dump dbname > backup.sql

# Backup with compression
pg_dump dbname | gzip > backup.sql.gz

# Restore
psql dbname < backup.sql

# Backup all databases
pg_dumpall > backup.sql

# Backup specific table
pg_dump -t users dbname > users.sql
```

### MySQL

```bash
# Backup single database
mysqldump dbname > backup.sql

# Backup with compression
mysqldump dbname | gzip > backup.sql.gz

# Restore
mysql dbname < backup.sql

# Backup all databases
mysqldump --all-databases > backup.sql

# Backup specific table
mysqldump dbname users > users.sql
```

---

## Anti-Patterns

1. ❌ `SELECT *` — always specify needed columns
2. ❌ Missing indexes on foreign keys — always index FK columns
3. ❌ `LIKE '%search%'` — use full-text search instead
4. ❌ No `LIMIT` on unbounded queries — always paginate
5. ❌ Storing money as `FLOAT` — use `DECIMAL` or integer cents
6. ❌ Missing `NOT NULL` constraints — be explicit about nullability
7. ❌ No migration tracking — always track applied migrations
8. ❌ No backups before migrations — always backup first
9. ❌ Ignoring `EXPLAIN` output — always verify execution plans
10. ❌ Premature denormalization — normalize first, denormalize only when measured

---

**Source:** Clawhub.ai - @gitgoodordietrying
**License:** MIT-0 (Free to use, modify, redistribute)
**Installed:** 2026-03-24
