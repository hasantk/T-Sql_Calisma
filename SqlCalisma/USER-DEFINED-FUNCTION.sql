-----USER DEFINED FUNCTION----
--TUM FONKSIYONLAR ALTER ILE DEGISTIRILIR CREATE ILE OLUSTURULUR DROP ILE SILINIR
----------------------------------------------------------
--SCALER-VALUED-FUNCTIONS
CREATE FUNCTION DBO.TOPLA(@SAYI1 AS INT,@SAYI2 AS INT)
RETURNS INT
AS
BEGIN
   DECLARE @SONUC  AS INT
   SET @SONUC=@SAYI1+@SAYI2
   RETURN @SONUC
END

SELECT DBO.TOPLA(90,50)
------------------------------------------------------------
CREATE FUNCTION DBO.CALCULATE_AGE(@BIRTHDATE AS DATE)
RETURNS INT
AS
BEGIN
DECLARE @RESULT AS INT
SET @RESULT=DATEDIFF(YEAR,@BIRTHDATE,GETDATE())
RETURN @RESULT
END

SELECT DBO.CALCULATE_AGE('20030525')
------------------------------------------------------------
ALTER FUNCTION DBO.MONTHNAME_(@DATE AS DATETIME)
RETURNS VARCHAR(10)
AS
BEGIN
DECLARE @RESULT AS VARCHAR(10)
IF DATEPART(MONTH,@DATE)=1 SET @RESULT='01.OCAK'
IF DATEPART(MONTH,@DATE)=2 SET @RESULT='02.SUBAT'
IF DATEPART(MONTH,@DATE)=3 SET @RESULT='03.MART'
IF DATEPART(MONTH,@DATE)=4 SET @RESULT='04.NISAN'
IF DATEPART(MONTH,@DATE)=5 SET @RESULT='05.MAYIS'
IF DATEPART(MONTH,@DATE)=6 SET @RESULT='06.HAZIRAN'
IF DATEPART(MONTH,@DATE)=7 SET @RESULT='07.TEMMUZ'
IF DATEPART(MONTH,@DATE)=8 SET @RESULT='08.OGUSTOS'
IF DATEPART(MONTH,@DATE)=9 SET @RESULT='09.EYLUL'
IF DATEPART(MONTH,@DATE)=10 SET @RESULT='10.EKIM'
IF DATEPART(MONTH,@DATE)=11 SET @RESULT='11.KASIM'
IF DATEPART(MONTH,@DATE)=12 SET @RESULT='12.ARALIK'
RETURN @RESULT
END

SELECT DBO.MONTHNAME_('20021018')
------------------------------------------------------------
CREATE FUNCTION DBO.GET_ITEM_PRICE(@ITEMID AS INT,@PRICETYPE AS VARCHAR(10))
RETURNS FLOAT
AS 
BEGIN
    DECLARE @RESULT AS FLOAT
	IF @PRICETYPE='MIN'
	BEGIN
	    SELECT @RESULT=MIN(UNITPRICE) FROM ORDERDETAILS OD WHERE OD.ITEMID=@ITEMID
	END
	IF @PRICETYPE='MAX'
	BEGIN
	    SELECT @RESULT=MAX(UNITPRICE) FROM ORDERDETAILS OD WHERE OD.ITEMID=@ITEMID
	END
	IF @PRICETYPE='AVG'
	BEGIN
	    SELECT @RESULT=AVG(UNITPRICE) FROM ORDERDETAILS OD WHERE OD.ITEMID=@ITEMID
	END
    RETURN @RESULT
END
-------------------------------------------------------------------------------
--TABLE-VALUED-FUNCTIONS
CREATE FUNCTION DBO.GET_ITEM_INFO(@ITEMID INT)
RETURNS TABLE
AS
RETURN
(
SELECT
    MIN(UNITPRICE) AS MINPRICE,
	MAX(UNITPRICE) AS MAXPRICE,
	AVG(UNITPRICE) AS AVGPRICE

FROM ORDERDETAILS WHERE ITEMID=@ITEMID
)

SELECT * FROM DBO.GET_ITEM_INFO(3)
--URUN ANALIZI--
SET STATISTICS TIME ON --NE KADAR SUREDE VERILERI CEKTIGINI GOSTERIR
SELECT ITM.ID,ITM.ITEMCODE MALZEMEKODU,ITM.ITEMNAME MALZEMEADI,
     ITEMINFO.MINPRICE AS ENDUSUKFIYAT,
	 ITEMINFO.MAXPRICE AS ENYUKSEKFIYAT,
	 ITEMINFO.AVGPRICE AS ORTALAMAFIYAT
FROM ITEMS ITM
CROSS APPLY DBO.GET_ITEM_INFO(ITM.ID) AS ITEMINFO