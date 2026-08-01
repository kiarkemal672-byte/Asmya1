import { Router } from 'express';
import { authController } from '../controllers/authController';
import { chatController } from '../controllers/chatController';
import { announcementController } from '../controllers/announcementController';
import { planController, reportController } from '../controllers/planController';
import { cashbookController } from '../controllers/cashbookController';
import { memberController } from '../controllers/memberController';
import { userController } from '../controllers/userController';
import { authMiddleware, requireAdmin } from '../middleware/auth';

const router = Router();

router.get('/health', (_req, res) => res.json({ status: 'ASMYA API OK', ts: Date.now() }));

// AUTH
router.post('/auth/login', authController.login);
router.post('/auth/register', authController.register);
router.get('/auth/me', authMiddleware, authController.me);

// USER
router.put('/user/profile', authMiddleware, userController.updateProfile);
router.put('/user/password', authMiddleware, userController.changePassword);

// CHAT
router.get('/chat/conversations', authMiddleware, chatController.listConversations);
router.get('/chat/conversations/:conversationId/messages', authMiddleware, chatController.getMessages);
router.post('/chat/conversations/:conversationId/messages', authMiddleware, chatController.sendMessage);

// ANNOUNCEMENTS
router.get('/announcements', authMiddleware, announcementController.list);
router.post('/announcements', authMiddleware, announcementController.create);
router.delete('/announcements/:id', authMiddleware, announcementController.remove);

// PLANS
router.get('/plans', authMiddleware, planController.list);
router.post('/plans', authMiddleware, planController.create);
router.put('/plans/:id/status', authMiddleware, planController.updateStatus);
router.delete('/plans/:id', authMiddleware, planController.remove);

// REPORTS
router.get('/reports', authMiddleware, reportController.list);
router.post('/reports', authMiddleware, reportController.create);
router.delete('/reports/:id', authMiddleware, reportController.remove);

// CASHBOOK
router.get('/cashbook', authMiddleware, cashbookController.list);
router.post('/cashbook', authMiddleware, cashbookController.create);
router.delete('/cashbook/:id', authMiddleware, cashbookController.remove);

// MEMBERS
router.get('/members', authMiddleware, memberController.list);
router.post('/members', authMiddleware, memberController.add);

export default router;
