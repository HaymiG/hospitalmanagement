-- Insert default admin user if not exists
INSERT INTO adminreg (username, password) 
SELECT 'admin', 'admin'
WHERE NOT EXISTS (SELECT 1 FROM adminreg WHERE username = 'admin');
