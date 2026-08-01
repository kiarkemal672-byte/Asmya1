import fs from 'fs';
import path from 'path';
import { pool } from '../config/db';

(async () => {
  try {
    const migrationFile = path.join(__dirname, 'migrations/001_init.sql');
    const sql = fs.readFileSync(migrationFile, 'utf8');
    await pool.query(sql);
    console.log('✅ Migrations applied successfully');
    process.exit(0);
  } catch (err) {
    console.error('❌ Migration failed', err);
    process.exit(1);
  }
})();
