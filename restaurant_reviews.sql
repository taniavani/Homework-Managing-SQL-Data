-- BAGIAN A & B: MEMBUAT TABEL & MEMASUKKAN DATA AWAL

CREATE TABLE restaurant (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    street_address TEXT,
    description TEXT
);

CREATE TABLE review (
    id SERIAL PRIMARY KEY,
    restaurant_id INT REFERENCES restaurant(id) ON DELETE CASCADE,
    user_name VARCHAR(50) NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    review_text TEXT,
    review_date DATE DEFAULT CURRENT_DATE
);

INSERT INTO restaurant (name, street_address, description) VALUES
('Bandar Djakarta', 'Taman Impian Jaya Ancol, Jakarta Utara', 'Olahan seafood segar dengan suasana tepi pantai'),
('Union', 'Plaza Senayan, Jakarta Pusat', 'Bistro ikonis terkenal dengan Red Velvet Cake terbaik'),
('Plataran Menteng', 'Jl. Cokroaminoto No. 42, Jakarta Pusat', 'Kuliner Indonesia bergaya fine dining nusantara');

INSERT INTO review (restaurant_id, user_name, rating, review_text, review_date) VALUES
(1, 'Anisa', 4, 'Seafood segar banget, saus padangnya mantap!', '2026-08-01'),
(1, 'Rian', 4, 'Tempatnya bagus, tapi kalau weekend agak ramai.', '2026-08-05'),
(2, 'Jessica', 5, 'Red velvet cake tiada tanding, pelayanan super ramah.', '2026-08-10'),
(2, 'Budi', 2, 'Makanan enak tapi waiting list-nya cukup lama.', '2026-08-12'),
(3, 'Siti', 5, 'Gado-gado dan dendeng balado super lezat, tempatnya cantik!', '2026-08-15');
