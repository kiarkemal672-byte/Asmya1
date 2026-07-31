import { Request, Response } from 'express';
import { query } from '../config/db';

export const cashbookController = {
  async list(_req: Request, res: Response) {
    const summary = await query(
      `SELECT
         COALESCE(SUM(CASE WHEN type = 'INCOME'  THEN amount ELSE 0 END), 0) AS total_in,
         COALESCE(SUM(CASE WHEN type = 'EXPENSE' THEN amount ELSE 0 END), 0) AS total_out
       FROM cashbook_transactions`
    );
    const totalIn = parseFloat(summary.rows[0].total_in);
    const totalOut = parseFloat(summary.rows[0].total_out);
    const balance = totalIn - totalOut;

    const tx = await query(
      `SELECT id, type, category, amount, description, user_initials,
              transaction_date, created_at
       FROM cashbook_transactions
       ORDER BY transaction_date DESC, created_at DESC`
    );
    return res.json({
      summary: { total_in: totalIn, total_out: totalOut, balance },
      transactions: tx.rows,
    });
  },

  async create(req: Request, res: Response) {
    const { type, category, amount, description, transaction_date } = req.body as {
      type: 'INCOME' | 'EXPENSE';
      category?: string;
      amount: number;
      description: string;
      transaction_date?: string;
    };
    if (!type || !amount || !description) {
      return res.status(400).json({ error: 'type, amount and description required' });
    }
    const userResult = await query('SELECT display_name FROM users WHERE id = $1', [req.user!.sub]);
    const displayName = userResult.rows[0]?.display_name || 'Unknown';
    const initials = displayName.split(' ').map(s => s[0]).join('').slice(0, 2).toUpperCase();
    const result = await query(
      `INSERT INTO cashbook_transactions (type, category, amount, description,
        user_initials, transaction_date, created_by)
       VALUES ($1::cash_type, $2::cash_category, $3, $4, $5, $6, $7)
       RETURNING *`,
      [type, (category || 'OTHER').toUpperCase(), amount, description, initials,
       transaction_date || new Date().toISOString().slice(0, 10), req.user!.sub]
    );
    return res.status(201).json({ transaction: result.rows[0] });
  },

  async remove(req: Request, res: Response) {
    const { id } = req.params;
    await query('DELETE FROM cashbook_transactions WHERE id = $1', [id]);
    return res.json({ success: true });
  },
};
