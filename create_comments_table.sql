-- Create comments table
CREATE TABLE IF NOT EXISTS comments (
    comment_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    entity_type ENUM('assignment', 'quiz', 'material') NOT NULL,
    entity_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX (entity_type, entity_id)
);

-- Add some test comments (if needed)
-- INSERT INTO comments (user_id, entity_type, entity_id, content, created_at)
-- VALUES 
--     (1, 'assignment', 1, 'This is a test comment on an assignment', NOW()),
--     (2, 'quiz', 1, 'This is a test comment on a quiz', NOW()),
--     (3, 'material', 1, 'This is a test comment on course material', NOW()); 