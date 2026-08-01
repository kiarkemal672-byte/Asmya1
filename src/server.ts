import dotenv from 'dotenv';
import { createApp } from './app';
import { testConnection } from './config/db';

dotenv.config();

const PORT = parseInt(process.env.PORT || '5000', 10);

(async () => {
  await testConnection();
  const app = createApp();
  app.listen(PORT, () => {
    console.log(`🕌 ASMYA API listening on http://localhost:${PORT}`);
  });
})().catch((err) => {
  console.error('Failed to start server', err);
  process.exit(1);
});
