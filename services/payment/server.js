const express = require('express');
const client = require('prom-client');
const app = express();
app.use(express.json());

const register = new client.Registry();
client.collectDefaultMetrics({ register });
app.get('/metrics', async (req, res) => {
  res.set('Content-Type', register.contentType);
  res.end(await register.metrics());
});

app.get('/health', (req, res) => res.json({ status: 'ok', service: 'payment' }));

// Simulated payment gateway (stub for Stripe/PayPal integration)
app.post('/pay', (req, res) => {
  const { amount } = req.body;
  if (!amount || amount <= 0) return res.status(400).json({ success: false, error: 'invalid amount' });
  // simulate 2% random failure to demonstrate rollback/retry handling
  const success = Math.random() > 0.02;
  setTimeout(() => {
    res.json({ success, transaction_id: success ? 'txn_' + Date.now() : null, amount });
  }, 150);
});

const PORT = process.env.PORT || 4000;
app.listen(PORT, () => console.log(`Payment service listening on ${PORT}`));
