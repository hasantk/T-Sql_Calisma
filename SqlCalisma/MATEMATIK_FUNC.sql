----------------------------------------------MATEMATIK FONKSIYONLARI---------------------------------------------

----------------------------ABS/SIGN FUNKSIYONLARI---------------------------
SELECT ABS(-25.15)/*SAYININ MUTLAK DEGERINI GOSTERIR*/,SIGN(54)/*SAYININ POZITIF NEGATIFLIK ISARETINI GOSTERIR*/

----------------------------ROUND/FLOOR/CEILING FUNKSIYONLARI---------------------------
SELECT
ROUND(CONVERT(FLOAT,156.99678),2) ROUND_,
FLOOR(156.9999) FLOOR_,
CEILING(156.000001) CEILING_

----------------------------RAND() FUNKSIYONU---------------------------
SELECT RAND()

SELECT CONVERT(INT,RAND()*50)

SELECT 50+CONVERT(INT,RAND()*50)
