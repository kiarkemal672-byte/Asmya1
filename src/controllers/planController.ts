import { Request, Response } from 'express';
import { query } from '../config/db';

const VALID_STATUSES = ['PENDING', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED'];

export const planController = {
  async list(_req: Request, res: Response) {
    const result = await query(
      `SELECT id, title, description, status, due_date, assignee_tags, report_count,
              created_by, created_at, updated_at
       FROM plans ORDER BY created_at DESC`
    );
    return res.json({ plans: result.rows });
  },

  async create(req: Request, res: Response) {
    const { title, description, due_date, assignee_tags } = req.body as {
      title: string; description?: string; due_date?: string; assignee_tags?: string[];
    };
    if (!title) return res.status(400).json({ error: 'title required' });
    const result = await query(
      `INSERT INTO plans (title, description, due_date, assignee_tags, created_by)
       VALUES ($1, $2, $3, $4, $5)
       RETURNING *`,
      [title, description || null, due_date || null, assignee_tags || [], req.user!.sub]
    );
    return res.status(201).json({ plan: result.rows[0] });
  },

  async updateStatus(req: Request, res: Response) {
    const { id } = req.params;
    const { status } = req.body as { status: string };
    if (!VALID_STATUSES.includes(status)) {
      return res.status(400).json({ error: 'Invalid status' });
    }
    const result = await query(
      `UPDATE plans SET status = $1::plan_status WHERE id = $2 RETURNING *`,
      [status, id]
    );
    if (result.rowCount === 0) return res.status(404).json({ error: 'Plan not found' });
    return res.json({ plan: result.rows[0] });
  },

  async remove(req: Request, res: Response) {
    const { id } = req.params;
    await query('DELETE FROM plans WHERE id = $1', [id]);
    return res.json({ success: true });
  },
};

export const reportController = {
  async list(_req: Request, res: Response) {
    const result = await query(
      `SELECT id, plan_id, author_id, author_name, author_initials, title, content, created_at
       FROM reports ORDER BY created_at DESC`
    );
    return res.json({ reports: result.rows });
  },

  async create(req: Request, res: Response) {
    const { plan_id, title, content } = req.body as {
      plan_id?: string; title: string; content: string;
    };
    if (!title || !content) return res.status(400).json({ error: 'title and content required' });
    const userResult = await query('SELECT display_name FROM users WHERE id = $1', [req.user!.sub]);
    const displayName = userResult.rows[0]?.display_name || 'Unknown';
    const initials = displayName.split(' ').map(s => s[0]).join('').slice(0, 2).toUpperCase();
    const result = await query(
      `INSERT INTO reports (plan_id, author_id, author_name, author_initials, title, content)
       VALUES ($1, $2, $3, $4, $5, $6)
       RETURNING *`,
      [plan_id || null, req.user!.sub, displayName, initials, title, content]
    );
    if (plan_id) {
      await query('UPDATE plans SET report_count = report_count + 1 WHERE id = $1', [plan_id]);
    }
    return res.status(201).json({ report: result.rows[0] });
  },

  async remove(req: Request, res: Response) {
    const { id } = req.params;
    const rep = await query('SELECT plan_id FROM reports WHERE id = $1', [id]);
    if (rep.rowCount && rep.rows[0].plan_id) {
      await query('UPDATE plans SET report_count = GREATEST(report_count - 1, 0) WHERE id = $1',
        [rep.rows[0].plan_id]);
    }
    await query('DELETE FROM reports WHERE id = $1', [id]);
    return res.json({ success: true });
  },
};
