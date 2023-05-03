------------------------------------------------STRING FONKSIYONLAR----------------------------------------------

----------------------------------ORNEK 1----------------------------------
SELECT * FROM PERSONS

UPDATE PERSONS SET NAMESURNAME=NAME_+' '+SURNAME

----------------------------------ORNEK 2----------------------------------
/*
   URUN KODU: 1 BU SEKILDE CIKTI ALARAK VERI CEKME
   URUN ADI: KALEM
*/

SELECT 
'URUN KODU:'+ITEMCODE+CHAR(13)+'URUN ADI:'+ITEMNAME
FROM ITEMS
WHERE ID=1

----------------------------------ORNEK 3----------------------------------
--mssql dil ayarý turkce ise
SELECT UPPER('washington' collate sql_latin1_general_cp1_ci_as)
SELECT UPPER('washington')


SELECT *FROM CUSTOMERS

UPDATE CUSTOMERS SET CITY=UPPER(CITY),TOWN=UPPER(TOWN)

----------------------------------ORNEK 4----------------------------------

SELECT *FROM CUSTOMERS
UPDATE CUSTOMERS SET CITY=LEFT(CITY,1)+LOWER(RIGHT(CITY,LEN(CITY)-1)),TOWN=LEFT(TOWN,1)+LOWER(RIGHT(TOWN,LEN(TOWN)-1))

SELECT CITY FROM CUSTOMERS WHERE ID=3

UPDATE CUSTOMERS SET CITY='Ankara' WHERE ID=3

----------------------------------ORNEK 5----------------------------------
USE ALISTIRMA
select RIGHT(EMAIL,LEN(EMAIL)-CHARINDEX('@',EMAIL))
from ORNEK05

SELECT CHARINDEX('@','hsn16@gmail.com')
SELECT
--RIGHT('hsn16@gmail.com',LEN('hsn16@gmail.com')-CHARINDEX('@','hsn16@gmail.com'))
RIGHT(EMAIL,LEN(EMAIL)-CHARINDEX('@',EMAIL))
SERVISSAGLAYICI,
COUNT(*) MUSTERISAYISI
FROM ORNEK05
GROUP BY RIGHT(EMAIL,LEN(EMAIL)-CHARINDEX('@',EMAIL))
ORDER BY 2 DESC

----------------------------------ORNEK 6----------------------------------
SELECT *, '+90 ('+SUBSTRING(TELNR,2,3)+') '
+SUBSTRING(TELNR,5,3)+' '
+SUBSTRING(TELNR,8,2)+' '
+SUBSTRING(TELNR,10,2) AS TELNO FROM ORNEK06

----------------------------------ORNEK 7----------------------------------
SELECT *FROM ORNEK07

SELECT ID,ITEMCODE,ITEMNAME,CATEGORY1CODE,CATEGORY1 FROM ORNEK07

UPDATE ORNEK07 SET ITEMCODE=CATEGORY1CODE+REPLICATE('0',6-LEN(ITEMCODE))+ITEMCODE


----------------------------------ORNEK 8----------------------------------
SELECT * FROM ORNEK08

SELECT *,(SELECT COUNT(*) FROM string_split(FULLTEXT,' ')) WORDCOUNT
FROM ORNEK08

---------------------------------------------------------DATE TIME FONKSITONLARI-------------------------------------

-------------------------------------ORNEK 1---------------------------------------
SELECT *, DATEDIFF(YEAR,BIRTHDATE,GETDATE()) AS AGE
FROM DATETIME_ORNEK1
WHERE
DATEDIFF(YEAR,BIRTHDATE,GETDATE())
BETWEEN 40 AND 50
AND GENDER = 'E'
ORDER BY 5 -- 5. COLUMNS A GORE SIRALASIN 

-------------------------------------ORNEK 2---------------------------------------

SELECT *,DATENAME(MONTH,BIRTHDATE) MONTH_
FROM DATETIME_ORNEK1
WHERE
MONTH(BIRTHDATE) = 5

