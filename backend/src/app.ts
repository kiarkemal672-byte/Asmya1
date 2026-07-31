import express, { Request, Response, NextFunction } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import rateLimit from 'express-rate-limit';
import router from './routes';

export function createApp() {
  const app = express();
  app.use(helmet());
  app.use(cors({ origin: process.env.CORS_ORIGIN || '*' }));
  app.use(express.json({ limit: '2mb' }));
  app.use(express.urlencoded({ extended: true }));
  app.use(morgan('dev'));

  const limiter = rateLimit({ windowMs: 60_000, max: 300 });
  app.use('/api', limiter);

  app.use('/api', router);

  app.get('/', (_req: Request, res: Response) => {
    res.json({ name: 'ASMYA API', version: '1.0.0' });
  });

  app.use((err: Error, _req: Request, res: Response, _next: NextFunction) => {
    console.error('[ERR]', err);
    res.status(500).json({ error: 'Internal server error', detail: err.message });
  });

  return app;
}
