-- Seed roles mặc định
INSERT INTO roles (id, name, description) 
SELECT 1, 'USER', 'Khách hàng' 
WHERE NOT EXISTS (SELECT 1 FROM roles WHERE name = 'USER');

INSERT INTO roles (id, name, description) 
SELECT 2, 'ADMIN', 'Quản trị viên' 
WHERE NOT EXISTS (SELECT 1 FROM roles WHERE name = 'ADMIN');
