"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const authController_1 = require("../controllers/authController");
const chatController_1 = require("../controllers/chatController");
const announcementController_1 = require("../controllers/announcementController");
const planController_1 = require("../controllers/planController");
const cashbookController_1 = require("../controllers/cashbookController");
const memberController_1 = require("../controllers/memberController");
const userController_1 = require("../controllers/userController");
const auth_1 = require("../middleware/auth");
const router = (0, express_1.Router)();
router.get('/health', (_req, res) => res.json({ status: 'ASMYA API OK', ts: Date.now() }));
// AUTH
router.post('/auth/login', authController_1.authController.login);
router.post('/auth/register', authController_1.authController.register);
router.get('/auth/me', auth_1.authMiddleware, authController_1.authController.me);
// USER
router.put('/user/profile', auth_1.authMiddleware, userController_1.userController.updateProfile);
router.put('/user/password', auth_1.authMiddleware, userController_1.userController.changePassword);
// CHAT
router.get('/chat/conversations', auth_1.authMiddleware, chatController_1.chatController.listConversations);
router.get('/chat/conversations/:conversationId/messages', auth_1.authMiddleware, chatController_1.chatController.getMessages);
router.post('/chat/conversations/:conversationId/messages', auth_1.authMiddleware, chatController_1.chatController.sendMessage);
// ANNOUNCEMENTS
router.get('/announcements', auth_1.authMiddleware, announcementController_1.announcementController.list);
router.post('/announcements', auth_1.authMiddleware, announcementController_1.announcementController.create);
router.delete('/announcements/:id', auth_1.authMiddleware, announcementController_1.announcementController.remove);
// PLANS
router.get('/plans', auth_1.authMiddleware, planController_1.planController.list);
router.post('/plans', auth_1.authMiddleware, planController_1.planController.create);
router.put('/plans/:id/status', auth_1.authMiddleware, planController_1.planController.updateStatus);
router.delete('/plans/:id', auth_1.authMiddleware, planController_1.planController.remove);
// REPORTS
router.get('/reports', auth_1.authMiddleware, planController_1.reportController.list);
router.post('/reports', auth_1.authMiddleware, planController_1.reportController.create);
router.delete('/reports/:id', auth_1.authMiddleware, planController_1.reportController.remove);
// CASHBOOK
router.get('/cashbook', auth_1.authMiddleware, cashbookController_1.cashbookController.list);
router.post('/cashbook', auth_1.authMiddleware, cashbookController_1.cashbookController.create);
router.delete('/cashbook/:id', auth_1.authMiddleware, cashbookController_1.cashbookController.remove);
// MEMBERS
router.get('/members', auth_1.authMiddleware, memberController_1.memberController.list);
router.post('/members', auth_1.authMiddleware, memberController_1.memberController.add);
exports.default = router;
