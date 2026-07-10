const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');
const client = require('prom-client');

const app = express();
app.use(cors());

const pool = new Pool({
  host: process.env.DB_HOST || 'postgres',
  port: process.env.DB_PORT || 5432,
  user: process.env.DB_USER || 'ecommerce',
  password: process.env.DB_PASSWORD || 'ecommerce_pass',
  database: process.env.DB_NAME || 'ecommerce'
});

const register = new client.Registry();
client.collectDefaultMetrics({ register });
app.get('/metrics', async (req, res) => {
  res.set('Content-Type', register.contentType);
  res.end(await register.metrics());
});

app.get('/health', (req, res) => res.json({ status: 'ok', service: 'search' }));

// Full-text style search over products (swap for Elasticsearch client for production scale)
app.get('/search', async (req, res) => {
  const q = req.query.q || '';
  try {
    const { rows } = await pool.query(
      `SELECT * FROM products WHERE name ILIKE $1 OR description ILIKE $1 ORDER BY id`,
      [`%${q}%`]
    );
    res.json(rows);
  } catch (e) {
    res.status(500).json({ error: 'search unavailable, DB not ready' });
  }
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Search service listening on ${PORT}`));
