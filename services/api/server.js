const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');
const client = require('prom-client');

const app = express();
app.use(cors());
app.use(express.json());

const pool = new Pool({
  host: process.env.DB_HOST || 'postgres',
  port: process.env.DB_PORT || 5432,
  user: process.env.DB_USER || 'ecommerce',
  password: process.env.DB_PASSWORD || 'ecommerce_pass',
  database: process.env.DB_NAME || 'ecommerce'
});

const register = new client.Registry();
client.collectDefaultMetrics({ register });
const httpRequestDuration = new client.Histogram({
  name: 'http_request_duration_seconds',
  help: 'Duration of HTTP requests in seconds',
  labelNames: ['method', 'route', 'status']
});
register.registerMetric(httpRequestDuration);

app.use((req, res, next) => {
  const end = httpRequestDuration.startTimer();
  res.on('finish', () => end({ method: req.method, route: req.path, status: res.statusCode }));
  next();
});

app.get('/metrics', async (req, res) => {
  res.set('Content-Type', register.contentType);
  res.end(await register.metrics());
});

app.get('/health', (req, res) => res.json({ status: 'ok', service: 'api' }));

async function initDb() {
  await pool.query(`
    CREATE TABLE IF NOT EXISTS products (
      id SERIAL PRIMARY KEY,
      name VARCHAR(255) NOT NULL,
      description TEXT,
      price NUMERIC(10,2) NOT NULL,
      stock INT DEFAULT 0
    );
    CREATE TABLE IF NOT EXISTS orders (
      id SERIAL PRIMARY KEY,
      product_id INT REFERENCES products(id),
      quantity INT NOT NULL,
      status VARCHAR(50) DEFAULT 'pending',
      created_at TIMESTAMP DEFAULT NOW()
    );
  `);
  const { rows } = await pool.query('SELECT COUNT(*) FROM products');
  if (parseInt(rows[0].count) === 0) {
    await pool.query(`INSERT INTO products (name, description, price, stock) VALUES
      ('Wireless Headphones', 'Bluetooth over-ear headphones', 49.99, 120),
      ('Mechanical Keyboard', 'RGB mechanical keyboard', 79.99, 60),
      ('Smart Watch', 'Fitness tracking smart watch', 129.99, 40)`);
  }
}

app.get('/api/products', async (req, res) => {
  const { rows } = await pool.query('SELECT * FROM products ORDER BY id');
  res.json(rows);
});

app.get('/api/products/:id', async (req, res) => {
  const { rows } = await pool.query('SELECT * FROM products WHERE id=$1', [req.params.id]);
  if (!rows[0]) return res.status(404).json({ error: 'not found' });
  res.json(rows[0]);
});

app.post('/api/orders', async (req, res) => {
  const { product_id, quantity } = req.body;
  const product = await pool.query('SELECT * FROM products WHERE id=$1', [product_id]);
  if (!product.rows[0]) return res.status(404).json({ error: 'product not found' });
  if (product.rows[0].stock < quantity) return res.status(400).json({ error: 'insufficient stock' });

  const paymentRes = await fetch(`${process.env.PAYMENT_URL || 'http://payment:4000'}/pay`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ amount: product.rows[0].price * quantity })
  }).then(r => r.json()).catch(() => ({ success: false }));

  if (!paymentRes.success) return res.status(402).json({ error: 'payment failed' });

  await pool.query('UPDATE products SET stock = stock - $1 WHERE id=$2', [quantity, product_id]);
  const order = await pool.query(
    'INSERT INTO orders (product_id, quantity, status) VALUES ($1,$2,$3) RETURNING *',
    [product_id, quantity, 'paid']
  );
  res.status(201).json(order.rows[0]);
});

app.get('/api/orders', async (req, res) => {
  const { rows } = await pool.query('SELECT * FROM orders ORDER BY id DESC');
  res.json(rows);
});

const PORT = process.env.PORT || 3000;
initDb().then(() => {
  app.listen(PORT, () => console.log(`API listening on ${PORT}`));
}).catch(err => {
  console.error('DB init failed, retrying in 5s...', err.message);
  setTimeout(() => process.exit(1), 5000);
});
