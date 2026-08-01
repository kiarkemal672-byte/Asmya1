import { Pool, QueryResult, QueryResultRow } from 'pg';
import dotenv from 'dotenv';

dotenv.config();

export const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  max: 20,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000,
});

pool.on('error', (err) => {
  console.error('[DB] Unexpected error on idle client', err);
  process.exit(-1);
});

export async function query<T extends QueryResultRow = QueryResultRow>(
  text: string,
  params?: unknown[]
): Promise<QueryResult<T>> {
  const start = Date.now();
  const res = await pool.query<T>(text, params as unknown[]);
  const duration = Date.now() - start;
  console.log('[DB] executed query', { text, duration: `${duration}ms`, rows: res.rowCount });
  return res;
}

export async function getClient() {
  return pool.connect();
}

export async function testConnection(): Promise<void> {
  try {
    const res = await query('SELECT NOW() as now;');
    console.log('[DB] Connected at:', res.rows[0].now);
  } catch (err) {
    console.error('[DB] Connection failed', err);
    throw err;
  }
}
