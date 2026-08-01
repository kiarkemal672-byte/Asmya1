"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.memberController = void 0;
const db_1 = require("../config/db");
const bcryptjs_1 = __importDefault(require("bcryptjs"));
exports.memberController = {
    async list(req, res) {
        const { filter } = req.query;
        if (filter === 'followers') {
            const result = await (0, db_1.query)(`SELECT u.id, u.username, u.display_name, u.handle, u.role, u.side,
                u.admin_subrole, u.avatar_url
         FROM users u
         JOIN followers f ON f.follower_id = u.id
         WHERE f.leader_id = $1
         ORDER BY u.display_name`, [req.user.sub]);
            return res.json({ members: result.rows });
        }
        const result = await (0, db_1.query)(`SELECT id, username, display_name, handle, role, side, admin_subrole, avatar_url
       FROM users WHERE is_active = TRUE ORDER BY display_name`);
        return res.json({ members: result.rows });
    },
    async add(req, res) {
        const { username, display_name, password, role, side, admin_subrole } = req.body;
        if (!username || !display_name || !password) {
            return res.status(400).json({ error: 'username, display_name, password required' });
        }
        const salt = parseInt(process.env.BCRYPT_SALT_ROUNDS || '10', 10);
        const hash = await bcryptjs_1.default.hash(password, salt);
        const handle = '@' + username.toLowerCase();
        const result = await (0, db_1.query)(`INSERT INTO users (username, password_hash, display_name, handle, role, side, admin_subrole)
       VALUES ($1, $2, $3, $4, $5, $6, $7)
       RETURNING id, username, display_name, handle, role, side, admin_subrole, avatar_url`, [username, hash, display_name, handle,
            (role || 'STUDENT').toUpperCase(), (side || null), (admin_subrole || null)]);
        await (0, db_1.query)(`INSERT INTO followers (leader_id, follower_id) VALUES ($1, $2)
       ON CONFLICT DO NOTHING`, [req.user.sub, result.rows[0].id]);
        return res.status(201).json({ member: result.rows[0] });
    },
};
