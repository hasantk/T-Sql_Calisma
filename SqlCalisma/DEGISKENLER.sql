------------------------------------------------------------T-SQL PROGRAMLAMA------------------------------------------------------------
-------------------------------------------DEGISKENLER-------------------------------------------

DECLARE @SAYI AS INT---DEGISKEN TANIMLANDI
   SET @SAYI=15--DEGISKENE DEGER ATANDI

SELECT @SAYI AS SAYIDEGERI--SAYI DEGERI YAZDIRIRDI


DECLARE @AD AS VARCHAR(50)
   SET @AD='HASAN'
DECLARE @SOYAD AS VARCHAR(50)
   SET @SOYAD='ATIK'
DECLARE @ADSOYAD AS VARCHAR(100)
   SET @ADSOYAD=@AD+' '+@SOYAD

SELECT @ADSOYAD AS ADSOYAD


DECLARE @DOGUMTARIHI AS DATE
DECLARE @YAS AS INT

SET @DOGUMTARIHI='2002-05-25'
DECLARE @TARIH AS DATE
SET @TARIH=DATEADD(YEAR,-10,GETDATE())
SET @YAS=DATEDIFF(YEAR,@DOGUMTARIHI,@TARIH)
SELECT @YAS,@TARIH


DECLARE @ISIM AS VARCHAR(30)
DECLARE @SOYISIM AS VARCHAR(30)
--SET @ISIM=(SELECT @ISIM=NAME_FROM PERSONSWHEREGENDER='E')
SELECT @ISIM=NAME_, @SOYISIM=SURNAME 
FROM PERSONS
WHERE
GENDER='E'

SELECT @ISIM,@SOYISIM
