"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const fs_1 = __importDefault(require("fs"));
const path_1 = __importDefault(require("path"));
const db_1 = require("../config/db");
(async () => {
    try {
        const migrationFile = path_1.default.join(__dirname, 'migrations/001_init.sql');
        const sql = fs_1.default.readFileSync(migrationFile, 'utf8');
        await db_1.pool.query(sql);
        console.log('✅ Migrations applied successfully');
        process.exit(0);
    }
    catch (err) {
        console.error('❌ Migration failed', err);
        process.exit(1);
    }
})();
