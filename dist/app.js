"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.createApp = createApp;
const express_1 = __importDefault(require("express"));
const cors_1 = __importDefault(require("cors"));
const helmet_1 = __importDefault(require("helmet"));
const morgan_1 = __importDefault(require("morgan"));
const express_rate_limit_1 = __importDefault(require("express-rate-limit"));
const routes_1 = __importDefault(require("./routes"));
function createApp() {
    const app = (0, express_1.default)();
    app.use((0, helmet_1.default)());
    app.use((0, cors_1.default)({ origin: process.env.CORS_ORIGIN || '*' }));
    app.use(express_1.default.json({ limit: '2mb' }));
    app.use(express_1.default.urlencoded({ extended: true }));
    app.use((0, morgan_1.default)('dev'));
    const limiter = (0, express_rate_limit_1.default)({ windowMs: 60000, max: 300 });
    app.use('/api', limiter);
    app.use('/api', routes_1.default);
    app.get('/', (_req, res) => {
        res.json({ name: 'ASMYA API', version: '1.0.0' });
    });
    app.use((err, _req, res, _next) => {
        console.error('[ERR]', err);
        res.status(500).json({ error: 'Internal server error', detail: err.message });
    });
    return app;
}
