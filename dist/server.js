"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const dotenv_1 = __importDefault(require("dotenv"));
const app_1 = require("./app");
const db_1 = require("./config/db");
dotenv_1.default.config();
const PORT = parseInt(process.env.PORT || '5000', 10);
(async () => {
    await (0, db_1.testConnection)();
    const app = (0, app_1.createApp)();
    app.listen(PORT, () => {
        console.log(`🕌 ASMYA API listening on http://localhost:${PORT}`);
    });
})().catch((err) => {
    console.error('Failed to start server', err);
    process.exit(1);
});
