import { Request, Response } from 'express';
import { query } from '../config/db';

const DEFAULT_CONVERSATIONS = [
  { title: 'Nine Amir Council', admin_subrole: 'NINE_AMIR_COUNCIL', initials: 'NC' },
  { title: 'Education Amir', admin_subrole: 'EDUCATION_AMIR', initials: 'EA' },
  { title: 'Community Amir', admin_subrole: 'COMMUNITY_AMIR', initials: 'CA' },
  { title: 'Admin Amir', admin_subrole: 'ADMIN_AMIR', initials: 'AA' },
  { title: 'Finance Amir', admin_subrole: 'FINANCE_AMIR', initials: 'FA' },
  { title: 'Program Amir', admin_subrole: 'PROGRAM_AMIR', initials: 'PA' },
  { title: 'Social Media Amir', admin_subrole: 'SOCIAL_MEDIA_AMIR', initials: 'SM' },
  { title: 'Vice Amir', admin_subrole: 'VICE_AMIR', initials: 'VA' },
  { title: 'Secretary', admin_subrole: 'SECRETARY', initials: 'SC' },
];

export const chatController = {
  async listConversations(_req: Request, res: Response) {
    const result = await query(
      `SELECT c.id, c.title, c.description, c.is_group, c.admin_subrole,
              c.avatar_initials,
              (SELECT content FROM messages WHERE conversation_id = c.id
               ORDER BY created_at DESC LIMIT 1) AS last_message,
              (SELECT sender_id FROM messages WHERE conversation_id = c.id
               ORDER BY created_at DESC LIMIT 1) AS last_sender_id,
              (SELECT created_at FROM messages WHERE conversation_id = c.id
               ORDER BY created_at DESC LIMIT 1) AS last_message_at,
              (SELECT COUNT(*) FROM messages WHERE conversation_id = c.id) AS message_count
       FROM conversations c
       ORDER BY c.title ASC`
    );
    if (result.rowCount === 0) {
      for (const c of DEFAULT_CONVERSATIONS) {
        await query(
          `INSERT INTO conversations (title, is_group, admin_subrole, avatar_initials)
           VALUES ($1, TRUE, $2, $3)`,
          [c.title, c.admin_subrole, c.initials]
        );
      }
      const refreshed = await query(
        `SELECT c.id, c.title, c.description, c.is_group, c.admin_subrole,
                c.avatar_initials, NULL AS last_message, NULL AS last_sender_id,
                NULL AS last_message_at, 0 AS message_count
         FROM conversations c ORDER BY c.title ASC`
      );
      return res.json({ conversations: refreshed.rows });
    }
    return res.json({ conversations: result.rows });
  },

  async getMessages(req: Request, res: Response) {
    const { conversationId } = req.params;
    const result = await query(
      `SELECT m.id, m.conversation_id, m.sender_id, m.content, m.status, m.created_at,
              u.display_name AS sender_name, u.username AS sender_username
       FROM messages m
       LEFT JOIN users u ON u.id = m.sender_id
       WHERE m.conversation_id = $1
       ORDER BY m.created_at ASC`,
      [conversationId]
    );
    return res.json({ messages: result.rows });
  },

  async sendMessage(req: Request, res: Response) {
    const { conversationId } = req.params;
    const { content } = req.body as { content: string };
    if (!content || !content.trim()) {
      return res.status(400).json({ error: 'Message content required' });
    }
    const result = await query(
      `INSERT INTO messages (conversation_id, sender_id, content, status)
       VALUES ($1, $2, $3, 'SENT')
       RETURNING id, conversation_id, sender_id, content, status, created_at`,
      [conversationId, req.user!.sub, content.trim()]
    );
    return res.status(201).json({ message: result.rows[0] });
  },
};
