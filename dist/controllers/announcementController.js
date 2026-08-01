"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.announcementController = void 0;
const db_1 = require("../config/db");
exports.announcementController = {
    async list(_req, res) {
        const result = await (0, db_1.query)(`SELECT id, author_id, author_name, author_initials, title, content, created_at
       FROM announcements ORDER BY created_at DESC`);
        return res.json({ announcements: result.rows });
    },
    async create(req, res) {
        const { title, content } = req.body;
        if (!title || !content) {
            return res.status(400).json({ error: 'title and content required' });
        }
        const userResult = await (0, db_1.query)('SELECT display_name FROM users WHERE id = $1', [req.user.sub]);
        const displayName = userResult.rows[0]?.display_name || 'Unknown';
        const initials = displayName.split(' ').map(s => s[0]).join('').slice(0, 2).toUpperCase();
        const result = await (0, db_1.query)(`INSERT INTO announcements (author_id, author_name, author_initials, title, content)
       VALUES ($1, $2, $3, $4, $5)
       RETURNING id, author_id, author_name, author_initials, title, content, created_at`, [req.user.sub, displayName, initials, title, content]);
        return res.status(201).json({ announcement: result.rows[0] });
    },
    async remove(req, res) {
        const { id } = req.params;
        await (0, db_1.query)('DELETE FROM announcements WHERE id = $1', [id]);
        return res.json({ success: true });
    },
};
