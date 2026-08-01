"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.authController = void 0;
const bcryptjs_1 = __importDefault(require("bcryptjs"));
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const db_1 = require("../config/db");
const zod_1 = require("zod");
const loginSchema = zod_1.z.object({
    username: zod_1.z.string().min(3).max(50),
    password: zod_1.z.string().min(6).max(120),
});
const registerSchema = zod_1.z.object({
    username: zod_1.z.string().min(3).max(50).regex(/^[a-zA-Z0-9_]+$/),
    password: zod_1.z.string().min(6).max(120),
    display_name: zod_1.z.string().min(2).max(120),
    email: zod_1.z.string().email().optional().or(zod_1.z.literal('')),
    role: zod_1.z.enum(['TEACHER', 'STUDENT', 'PARENT', 'ADMIN_AMIR']).default('STUDENT'),
    side: zod_1.z.enum(['MEN', 'WOMEN']).optional(),
    admin_subrole: zod_1.z.string().optional(),
});
function signToken(payload) {
    return jsonwebtoken_1.default.sign(payload, process.env.JWT_SECRET, {
        expiresIn: process.env.JWT_EXPIRES_IN || '7d',
    });
}
exports.authController = {
    async login(req, res) {
        const parsed = loginSchema.safeParse(req.body);
        if (!parsed.success) {
            return res.status(400).json({ error: 'Invalid input', details: parsed.error.flatten() });
        }
        const { username, password } = parsed.data;
        const result = await (0, db_1.query)(`SELECT id, username, password_hash, display_name, role, side, admin_subrole, avatar_url, handle
       FROM users WHERE username = $1 AND is_active = TRUE`, [username]);
        if (result.rowCount === 0) {
            return res.status(401).json({ error: 'Invalid credentials' });
        }
        const user = result.rows[0];
        const valid = await bcryptjs_1.default.compare(password, user.password_hash);
        if (!valid) {
            return res.status(401).json({ error: 'Invalid credentials' });
        }
        const token = signToken({
            sub: user.id,
            username: user.username,
            role: user.role,
            side: user.side,
            admin_subrole: user.admin_subrole,
        });
        return res.json({
            token,
            user: {
                id: user.id,
                username: user.username,
                display_name: user.display_name,
                handle: user.handle,
                role: user.role,
                side: user.side,
                admin_subrole: user.admin_subrole,
                avatar_url: user.avatar_url,
            },
        });
    },
    async register(req, res) {
        const parsed = registerSchema.safeParse(req.body);
        if (!parsed.success) {
            return res.status(400).json({ error: 'Invalid input', details: parsed.error.flatten() });
        }
        const { username, password, display_name, email, role, side, admin_subrole } = parsed.data;
        const exists = await (0, db_1.query)('SELECT id FROM users WHERE username = $1', [username]);
        if (exists.rowCount && exists.rowCount > 0) {
            return res.status(409).json({ error: 'Username already taken' });
        }
        const saltRounds = parseInt(process.env.BCRYPT_SALT_ROUNDS || '10', 10);
        const password_hash = await bcryptjs_1.default.hash(password, saltRounds);
        const initials = display_name.split(' ').map(s => s[0]).join('').slice(0, 2).toUpperCase();
        const handle = '@' + username.toLowerCase();
        const result = await (0, db_1.query)(`INSERT INTO users (username, password_hash, display_name, email, role, side, admin_subrole, handle)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
       RETURNING id, username, display_name, role, side, admin_subrole, handle, avatar_url`, [username, password_hash, display_name, email || null, role, side || null,
            admin_subrole || null, handle]);
        const user = result.rows[0];
        const token = signToken({
            sub: user.id, username: user.username, role: user.role,
            side: user.side, admin_subrole: user.admin_subrole,
        });
        return res.status(201).json({
            token,
            user: { ...user, _initials: initials },
        });
    },
    async me(req, res) {
        const result = await (0, db_1.query)(`SELECT id, username, display_name, handle, role, side, admin_subrole,
              avatar_url, bio, preferred_language, dark_mode
       FROM users WHERE id = $1`, [req.user.sub]);
        if (result.rowCount === 0)
            return res.status(404).json({ error: 'User not found' });
        return res.json({ user: result.rows[0] });
    },
};
