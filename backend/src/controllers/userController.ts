import { Request, Response } from 'express';
import bcrypt from 'bcryptjs';
import { query } from '../config/db';

export const userController = {
  async updateProfile(req: Request, res: Response) {
    const { display_name, bio, avatar_url, preferred_language, dark_mode } = req.body as {
      display_name?: string; bio?: string; avatar_url?: string;
      preferred_language?: string; dark_mode?: boolean;
    };
    const result = await query(
      `UPDATE users
       SET display_name = COALESCE($1, display_name),
           bio = COALESCE($2, bio),
           avatar_url = COALESCE($3, avatar_url),
           preferred_language = COALESCE($4, preferred_language),
           dark_mode = COALESCE($5, dark_mode)
       WHERE id = $6
       RETURNING id, username, display_name, handle, role, side, admin_subrole,
                 avatar_url, bio, preferred_language, dark_mode`,
      [display_name || null, bio || null, avatar_url || null,
       preferred_language || null,
       typeof dark_mode === 'boolean' ? dark_mode : null,
       req.user!.sub]
    );
    return res.json({ user: result.rows[0] });
  },

  async changePassword(req: Request, res: Response) {
    const { current_password, new_password } = req.body as {
      current_password: string; new_password: string;
    };
    if (!current_password || !new_password || new_password.length < 6) {
      return res.status(400).json({ error: 'Invalid input' });
    }
    const result = await query('SELECT password_hash FROM users WHERE id = $1', [req.user!.sub]);
    if (result.rowCount === 0) return res.status(404).json({ error: 'User not found' });
    const valid = await bcrypt.compare(current_password, result.rows[0].password_hash);
    if (!valid) return res.status(401).json({ error: 'Current password incorrect' });
    const salt = parseInt(process.env.BCRYPT_SALT_ROUNDS || '10', 10);
    const hash = await bcrypt.hash(new_password, salt);
    await query('UPDATE users SET password_hash = $1 WHERE id = $2', [hash, req.user!.sub]);
    return res.json({ success: true });
  },
};
