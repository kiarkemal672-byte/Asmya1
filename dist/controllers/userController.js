"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.userController = void 0;
const bcryptjs_1 = __importDefault(require("bcryptjs"));
const db_1 = require("../config/db");
exports.userController = {
    async updateProfile(req, res) {
        const { display_name, bio, avatar_url, preferred_language, dark_mode } = req.body;
        const result = await (0, db_1.query)(`UPDATE users
       SET display_name = COALESCE($1, display_name),
           bio = COALESCE($2, bio),
           avatar_url = COALESCE($3, avatar_url),
           preferred_language = COALESCE($4, preferred_language),
           dark_mode = COALESCE($5, dark_mode)
       WHERE id = $6
       RETURNING id, username, display_name, handle, role, side, admin_subrole,
                 avatar_url, bio, preferred_language, dark_mode`, [display_name || null, bio || null, avatar_url || null,
            preferred_language || null,
            typeof dark_mode === 'boolean' ? dark_mode : null,
            req.user.sub]);
        return res.json({ user: result.rows[0] });
    },
    async changePassword(req, res) {
        const { current_password, new_password } = req.body;
        if (!current_password || !new_password || new_password.length < 6) {
            return res.status(400).json({ error: 'Invalid input' });
        }
        const result = await (0, db_1.query)('SELECT password_hash FROM users WHERE id = $1', [req.user.sub]);
        if (result.rowCount === 0)
            return res.status(404).json({ error: 'User not found' });
        const valid = await bcryptjs_1.default.compare(current_password, result.rows[0].password_hash);
        if (!valid)
            return res.status(401).json({ error: 'Current password incorrect' });
        const salt = parseInt(process.env.BCRYPT_SALT_ROUNDS || '10', 10);
        const hash = await bcryptjs_1.default.hash(new_password, salt);
        await (0, db_1.query)('UPDATE users SET password_hash = $1 WHERE id = $2', [hash, req.user.sub]);
        return res.json({ success: true });
    },
};
