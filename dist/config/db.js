"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.pool = void 0;
exports.query = query;
exports.getClient = getClient;
exports.testConnection = testConnection;
const pg_1 = require("pg");
const dotenv_1 = __importDefault(require("dotenv"));
dotenv_1.default.config();
exports.pool = new pg_1.Pool({
    connectionString: process.env.DATABASE_URL,
    max: 20,
    idleTimeoutMillis: 30000,
    connectionTimeoutMillis: 2000,
});
exports.pool.on('error', (err) => {
    console.error('[DB] Unexpected error on idle client', err);
    process.exit(-1);
});
async function query(text, params) {
    const start = Date.now();
    const res = await exports.pool.query(text, params);
    const duration = Date.now() - start;
    console.log('[DB] executed query', { text, duration: `${duration}ms`, rows: res.rowCount });
    return res;
}
async function getClient() {
    return exports.pool.connect();
}
async function testConnection() {
    try {
        const res = await query('SELECT NOW() as now;');
        console.log('[DB] Connected at:', res.rows[0].now);
    }
    catch (err) {
        console.error('[DB] Connection failed', err);
        throw err;
    }
}
