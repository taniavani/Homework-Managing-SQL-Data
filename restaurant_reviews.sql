-- 1. Buat Tabel Restaurant
CREATE TABLE restaurant (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    street_address TEXT,
    description TEXT    
);

-- 2. Buat Tabel Review
CREATE TABLE review (
    id SERIAL PRIMARY KEY,
    restaurant_id INT REFERENCES restaurant(id) ON DELETE CASCADE,
    user_name VARCHAR(50) NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    review_text TEXT,
    review_date DATE DEFAULT CURRENT_DATE
);

-- 3. Insert Data Restoran
INSERT INTO restaurant (name, street_address, description) VALUES
('Bandar Djakarta', 'Taman Impian Jaya Ancol, Jakarta Utara', 'Olahan seafood segar dengan suasana tepi pantai'),
('Union', 'Plaza Senayan, Jakarta Pusat', 'Bistro ikonis terkenal dengan Red Velvet Cake terbaik'),
('Plataran Menteng', 'Jl. Cokroaminoto No. 42, Jakarta Pusat', 'Kuliner Indonesia bergaya fine dining nusantara');

-- 4. Insert Data Review
INSERT INTO review (restaurant_id, user_name, rating, review_text, review_date) VALUES
(1, 'Anisa', 4, 'Seafood segar banget, saus padangnya mantap!', '2026-08-01'),
(1, 'Rian', 4, 'Tempatnya bagus, tapi kalau weekend agak ramai.', '2026-08-05'),
(2, 'Jessica', 5, 'Red velvet cake tiada tanding, pelayanan super ramah.', '2026-08-10'),
(2, 'Budi', 3, 'Makanan enak tapi waiting list-nya cukup lama.', '2026-08-12'),
(3, 'Siti', 5, 'Gado-gado dan dendeng balado super lezat, tempatnya cantik!', '2026-08-15');

-- C. CRUD Operations
-- Tambah 1 restaurant baru
INSERT INTO restaurant (name, street_address, description)
VALUES ('Henshin', 'The Westin Jakarta Lt. 67-69, Jl. H.R. Rasuna Said, Jakarta Selatan', 'Restoran fine dining Nikkei tertinggi di Jakarta dengan pemandangan city light');

-- Tambah 1 review baru untuk Henshin (ID = 4)
INSERT INTO review (restaurant_id, user_name, rating, review_text, review_date)
VALUES (4, 'Fajar', 5, 'Pemandangan malamnya spektakuler, hidangan ceviche dan wagyu-nya sangat berkelas.', '2026-08-20');

-- Retrieve reviews based on restaurant_id
SELECT * FROM review WHERE restaurant_id = 1;
SELECT * FROM review WHERE restaurant_id = 2;
SELECT * FROM review WHERE restaurant_id = 3;
SELECT * FROM review WHERE restaurant_id = 4;

-- Retrieve all reviews with a rating of 4 or higher
SELECT * FROM review WHERE rating >= 4;

-- Use JOIN to display restaurants along with reviews
SELECT 
    r.name AS restaurant_name, 
    rv.user_name, 
    rv.rating, 
    rv.review_text, 
    rv.review_date
FROM restaurant r
JOIN review rv ON r.id = rv.restaurant_id;

-- Update description of restaurant (Henshin ID = 4)
UPDATE restaurant
SET description = 'Restoran fine dining Nikkei ikonis di lantai puncak The Westin Jakarta'
WHERE id = 4;

-- Update rating of specific review (ID = 4)
UPDATE review
SET rating = 2
WHERE id = 4;

-- Delete one review based on id
DELETE FROM review WHERE id = 2;

-- Delete a restaurant with CASCADE effect
DELETE FROM restaurant WHERE id = 4;

-- D. Additional Queries
-- 1. Highest-rated restaurant based on average rating
SELECT 
    r.name AS restaurant_name, 
    ROUND(AVG(rv.rating), 2) AS average_rating
FROM restaurant r
JOIN review rv ON r.id = rv.restaurant_id
GROUP BY r.id, r.name
ORDER BY average_rating DESC
LIMIT 1;

-- 2. Number of reviews per restaurant
SELECT 
    r.name AS restaurant_name, 
    COUNT(rv.id) AS review_count
FROM restaurant r
LEFT JOIN review rv ON r.id = rv.restaurant_id
GROUP BY r.id, r.name;

-- 3. Most recent review for each restaurant
SELECT DISTINCT ON (rv.restaurant_id) 
    r.name AS restaurant_name, 
    rv.user_name, 
    rv.rating, 
    rv.review_text, 
    rv.review_date
FROM review rv
JOIN restaurant r ON r.id = rv.restaurant_id
ORDER BY rv.restaurant_id, rv.review_date DESC;

-- Extra Credit
-- 1. Create menu table & insert menu items
CREATE TABLE menu (
    id SERIAL PRIMARY KEY,
    restaurant_id INT REFERENCES restaurant(id) ON DELETE CASCADE,
    item_name VARCHAR(100) NOT NULL,
    price NUMERIC(10, 2) NOT NULL
);

INSERT INTO menu (restaurant_id, item_name, price) VALUES
(1, 'Ikan Gurame Bakar Topik', 85000.00),
(1, 'Udang Gala Saus Padang', 120000.00),
(1, 'Cumi Goreng Tepung', 65000.00),
(2, 'Red Velvet Cake Slice', 75000.00),
(2, 'Truffle Cream Pasta', 140000.00),
(2, 'Ice Cream Avocado Coffee', 55000.00),
(3, 'Dendeng Batokok', 165000.00),
(3, 'Gado-Gado Dharmawangsa', 75000.00),
(3, 'Nasi Goreng Keling', 95000.00);

-- 2. Query display restaurant with menu and average rating
SELECT 
    r.name AS restaurant_name,
    m.item_name AS menu_item,
    m.price,
    ROUND(AVG(rv.rating), 2) AS average_rating
FROM restaurant r
JOIN menu m ON r.id = m.restaurant_id
LEFT JOIN review rv ON r.id = rv.restaurant_id
GROUP BY r.id, r.name, m.id, m.item_name, m.price
ORDER BY r.name, m.item_name;
