-- ASMYA Database Schema
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ===== ENUMS =====
CREATE TYPE user_role AS ENUM ('TEACHER', 'STUDENT', 'PARENT', 'ADMIN_AMIR');
CREATE TYPE user_side AS ENUM ('MEN', 'WOMEN');
CREATE TYPE admin_subrole AS ENUM ('NINE_AMIR_COUNCIL', 'EDUCATION_AMIR', 'COMMUNITY_AMIR',
  'ADMIN_AMIR', 'FINANCE_AMIR', 'PROGRAM_AMIR', 'SOCIAL_MEDIA_AMIR', 'VICE_AMIR',
  'SECRETARY', 'SUPERIOR_AMIR');
CREATE TYPE plan_status AS ENUM ('PENDING', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED');
CREATE TYPE cash_category AS ENUM ('EVENT', 'EDUCATION', 'CHARITY', 'OPERATIONAL', 'OTHER');
CREATE TYPE cash_type AS ENUM ('INCOME', 'EXPENSE');
CREATE TYPE message_status AS ENUM ('SENT', 'DELIVERED', 'READ');

-- ===== USERS =====
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  username VARCHAR(50) UNIQUE NOT NULL,
  email VARCHAR(120) UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  display_name VARCHAR(120) NOT NULL,
  handle VARCHAR(80) UNIQUE,
  role user_role NOT NULL DEFAULT 'STUDENT',
  side user_side,
  admin_subrole admin_subrole,
  avatar_url VARCHAR(500),
  bio TEXT,
  preferred_language VARCHAR(10) DEFAULT 'en',
  dark_mode BOOLEAN DEFAULT TRUE,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_role_side ON users(role, side);

-- ===== CONVERSATIONS =====
CREATE TABLE conversations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title VARCHAR(200) NOT NULL,
  description TEXT,
  is_group BOOLEAN DEFAULT TRUE,
  admin_subrole admin_subrole,
  avatar_initials VARCHAR(10),
  created_by UUID REFERENCES users(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE conversation_participants (
  conversation_id UUID REFERENCES conversations(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  joined_at TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (conversation_id, user_id)
);

-- ===== MESSAGES =====
CREATE TABLE messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  conversation_id UUID REFERENCES conversations(id) ON DELETE CASCADE,
  sender_id UUID REFERENCES users(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  status message_status DEFAULT 'SENT',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  read_at TIMESTAMPTZ
);
CREATE INDEX idx_messages_conversation ON messages(conversation_id, created_at DESC);

-- ===== ANNOUNCEMENTS =====
CREATE TABLE announcements (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  author_id UUID REFERENCES users(id) ON DELETE SET NULL,
  author_name VARCHAR(120) NOT NULL,
  author_initials VARCHAR(10) NOT NULL,
  title VARCHAR(300) NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX idx_announcements_created ON announcements(created_at DESC);

-- ===== PLANS =====
CREATE TABLE plans (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title VARCHAR(300) NOT NULL,
  description TEXT,
  status plan_status DEFAULT 'PENDING',
  due_date DATE,
  assignee_tags TEXT[],
  report_count INT DEFAULT 0,
  created_by UUID REFERENCES users(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX idx_plans_status ON plans(status);

-- ===== REPORTS =====
CREATE TABLE reports (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  plan_id UUID REFERENCES plans(id) ON DELETE CASCADE,
  author_id UUID REFERENCES users(id) ON DELETE SET NULL,
  author_name VARCHAR(120) NOT NULL,
  author_initials VARCHAR(10) NOT NULL,
  title VARCHAR(300) NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX idx_reports_plan ON reports(plan_id);
CREATE INDEX idx_reports_created ON reports(created_at DESC);

-- ===== CASHBOOK =====
CREATE TABLE cashbook_transactions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  type cash_type NOT NULL,
  category cash_category DEFAULT 'OTHER',
  amount NUMERIC(14,2) NOT NULL,
  description VARCHAR(400) NOT NULL,
  user_initials VARCHAR(10) NOT NULL,
  transaction_date DATE NOT NULL DEFAULT CURRENT_DATE,
  created_by UUID REFERENCES users(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX idx_cashbook_date ON cashbook_transactions(transaction_date DESC);
CREATE INDEX idx_cashbook_type ON cashbook_transactions(type);

-- ===== FOLLOWERS (parent -> child, teacher -> student) =====
CREATE TABLE followers (
  leader_id UUID REFERENCES users(id) ON DELETE CASCADE,
  follower_id UUID REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (leader_id, follower_id)
);

-- ===== ROW-LEVEL UPDATE TRIGGER =====
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$ BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
 $$ language 'plpgsql';

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_conversations_updated_at BEFORE UPDATE ON conversations
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_announcements_updated_at BEFORE UPDATE ON announcements
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_plans_updated_at BEFORE UPDATE ON plans
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
