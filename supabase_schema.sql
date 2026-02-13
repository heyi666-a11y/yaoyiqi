-- 创建用户表
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- 创建游戏表
CREATE TABLE IF NOT EXISTS games (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    creator_id UUID REFERENCES users(id),
    invited_id UUID REFERENCES users(id),
    status VARCHAR(20) DEFAULT 'pending', -- pending, active, completed, rejected
    red_player_id UUID REFERENCES users(id),
    blue_player_id UUID REFERENCES users(id),
    winner_id UUID REFERENCES users(id),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- 创建游戏状态表
CREATE TABLE IF NOT EXISTS game_states (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    game_id UUID REFERENCES games(id),
    board_state JSONB NOT NULL,
    current_turn VARCHAR(10) DEFAULT 'red',
    move_count INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- 创建索引
CREATE INDEX IF NOT EXISTS idx_games_creator_id ON games(creator_id);
CREATE INDEX IF NOT EXISTS idx_games_invited_id ON games(invited_id);
CREATE INDEX IF NOT EXISTS idx_games_status ON games(status);
CREATE INDEX IF NOT EXISTS idx_game_states_game_id ON game_states(game_id);

-- 启用实时更新
ALTER PUBLICATION supabase_realtime ADD TABLE game_states;
