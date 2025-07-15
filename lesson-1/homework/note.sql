
-- OSON DARAZA
-- 1. Atamalar izohi (bu SQL emas, tushunchalar)
-- 2. SQL Server funksiyalari va autentifikatsiya turlari

-- O'RTACHA DARAZA
-- Ma'lumotlar bazasini yaratish
CREATE DATABASE SchoolDB;
GO

-- Bazaga o'tish va Students jadvalini yaratish
USE SchoolDB;
GO
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,        -- Talaba ID (asosiy kalit)
    Name VARCHAR(50),                 -- Talabaning ismi
    Age INT                           -- Talabaning yoshi
);
GO

-- Students jadvaliga 3 ta yozuv qo'shish
INSERT INTO Students (StudentID, Name, Age) VALUES
(1, 'Ali Karimov', 20),
(2, 'Dilshod Yusupov', 22),
(3, 'Zarina Qodirova', 19);
GO

-- QIYIN DARAZA
-- SQL buyrug'lari bo'yicha misollar (DQL, DML, DDL, DCL, TCL)

-- DQL: Ma'lumotni olish (SELECT)
SELECT * FROM Students;

-- DML: Ma'lumotni o'zgartirish (UPDATE)
UPDATE Students SET Age = 21 WHERE StudentID = 1;

-- DDL: Tuzilmani o'zgartirish (jadvalga ustun qo'shish)
ALTER TABLE Students ADD Email VARCHAR(100);

-- DCL: Ruxsat berish (foydalanuvchiga SELECT huquqi berish)
-- GRANT SELECT ON Students TO SomeUser;

-- TCL: Tranzaksiyalarni boshqarish
-- BEGIN TRAN; UPDATE Students SET Age = 22 WHERE StudentID = 2; COMMIT;

-- .bak faylni tiklash bo'yicha amallar (bu SQL emas, yo'riqnoma):
-- 1. Yuklab olish: https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorksDW2022.bak
-- 2. SSMS oching > 'Databases' ustiga o'ng tugma > Restore Database
-- 3. 'Device' tanlang va .bak faylni belgilang
-- 4. Fayl yo'llarini tekshirib, OK tugmasini bosing
