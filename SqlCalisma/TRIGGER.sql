DECLARE @I AS INT=0


WHILE @I<10
BEGIN
DECLARE @ITEMID AS INT
DECLARE @DATE AS DATETIME
DECLARE @AMOUNT AS INT
DECLARE @IOTYPE AS SMALLINT
SET @ITEMID=ROUND(RAND()*4,0)
IF @ITEMID=0
    SET @ITEMID=1
SET @DATE=DATEADD(DAY,-ROUND(RAND()*365,0),GETDATE())
SET @AMOUNT=ROUND(RAND()*9,0)+1
SET @IOTYPE=ROUND(RAND()*1,0)+1
SELECT @ITEMID AS ITEMID,@DATE AS DATE_,@AMOUNT AS AMOUNT,@IOTYPE AS IOTYPE


INSERT INTO ITEMTRANSACTIONS
(ITEMID, DATE_, AMOUNT, IOTYPE)
VALUES(@ITEMID,@DATE,@AMOUNT,@IOTYPE)
SET @I=@I+1
END

SELECT * FROM ITEMTRANSACTIONS
TRUNCATE TABLE ITEMTRANSACTIONS
SELECT COUNT(*) FROM ITEMTRANSACTIONS

--------------------------------------------TRIGGER-----------------------------------------
--TRIGGER ITEMTRANSACTIONS TABLOSUNDAKI KAYIT DEGISIKLIKLERI OTOMATIK OLARAK STOCK TABLOSUNDA GUNCELLER
---------------------------------------EKLEME TRIGGER----------------------------------
CREATE TRIGGER TRG_TRANSACTION_INSERT
ON ITEMTRANSACTIONS
AFTER INSERT
AS 
BEGIN
DECLARE @ITEMID AS INT
DECLARE @AMOUNT AS INT
DECLARE @IOTYPE AS SMALLINT

SELECT @ITEMID=ITEMID,@AMOUNT=AMOUNT,@IOTYPE=IOTYPE FROM INSERTED
IF @IOTYPE=1
    UPDATE STOCK SET STOCK=STOCK+@AMOUNT WHERE ITEMID=@ITEMID
IF @IOTYPE=2
    UPDATE STOCK SET STOCK=STOCK-@AMOUNT WHERE ITEMID=@ITEMID

END

INSERT INTO ITEMTRANSACTIONS(ITEMID,AMOUNT,IOTYPE,DATE_)
VALUES(1,5,1,GETDATE())
SELECT * FROM STOCK
----------------------------------------------------------------SILME TRIGGER-------------------------
CREATE TRIGGER TRG_TRANSACTION_DELETE
ON ITEMTRANSACTIONS
AFTER DELETE
AS
BEGIN
DECLARE @ITEMID AS INT
DECLARE @AMOUNT AS INT
DECLARE @IOTYPE AS SMALLINT

SELECT @ITEMID=ITEMID,@AMOUNT=AMOUNT,@IOTYPE=IOTYPE FROM DELETED
IF @IOTYPE=1
    UPDATE STOCK SET STOCK=STOCK-@AMOUNT WHERE ITEMID=@ITEMID
IF @IOTYPE=2
    UPDATE STOCK SET STOCK=STOCK+@AMOUNT WHERE ITEMID=@ITEMID

END

SELECT * FROM ITEMS WHERE ID=1
SELECT * FROM ITEMTRANSACTIONS WHERE ITEMID=1
SELECT * FROM STOCK WHERE ITEMID=1

DELETE FROM ITEMTRANSACTIONS WHERE ID=1
------------------------------------------------GUNCELLEME TRIGGER-------------------------
CREATE TRIGGER TRG_TRANSACTION_UPDATE
ON ITEMTRANSACTIONS
AFTER UPDATE
AS
BEGIN
DECLARE @ITEMID AS INT
DECLARE @IOTYPE AS INT
DECLARE @OLDAMOUNT AS INT
DECLARE @NEWAMOUNT AS INT
DECLARE @AMOUNT AS INT

SELECT @ITEMID=ITEMID,@IOTYPE=IOTYPE,@OLDAMOUNT=AMOUNT FROM DELETED
SELECT @NEWAMOUNT=AMOUNT FROM INSERTED
SELECT @AMOUNT=@OLDAMOUNT - @NEWAMOUNT
IF @IOTYPE=1
    UPDATE STOCK SET STOCK=STOCK-@AMOUNT WHERE ITEMID=@ITEMID
IF @IOTYPE=2
    UPDATE STOCK SET STOCK=STOCK+@AMOUNT WHERE ITEMID=@ITEMID

END

SELECT * FROM ITEMS WHERE ID=1
SELECT * FROM ITEMTRANSACTIONS WHERE ITEMID=1
SELECT * FROM ITEMTRANSACTIONS WHERE ITEMID=3
SELECT*FROM STOCK WHERE ITEMID=1

UPDATE ITEMTRANSACTIONS SET AMOUNT=10 WHERE ID=3
-------------------------------------------------------ORNEK
INSERT INTO WORKERS(WORKERNAME)--BASKA VERI TABANININ COLOMN VERILERINI BASKA VTABANI TABLOSUNA ATADI.

SELECT TOP 1000
USERNAME_ AS WORKERNAME
FROM TEST.DBO.USERS


TRUNCATE TABLE WORKERS

EXEC * GENERATE_WORKER_TRANSACTION 1 --1NUMARALI ID DEKI TRIGGERI CALISTIRIR.

insert into WORKER_LAST_TRANSACTIONS(WORKERID)
SELECT ID FROM WORKERS
SELECT*FROM WORKER_LAST_TRANSACTIONS

CREATE TRIGGER TRG_TRANSACTION_INSERT
ON WORKERTRANSACTIONS
AFTER INSERT
AS 
BEGIN 
DECLARE @WORKERID AS INT
DECLARE @DATE AS DATETIME
DECLARE @IOTYPE AS VARCHAR(1)

SELECT @WORKERID=WORKERID,@DATE=DATE_,@IOTYPE=IOTYPE FROM inserted
UPDATE WORKER_LAST_TRANSACTION SET LASTIOTYPE=IOTYPE,LASTDATE=@DATE WHERE @WORKERID=@WORKERID
END

TRUNCATE TABLE WORKERTRANSACTIONS
EXEC GENERATE_WORKER_TRANSACTION 1

SELECT * FROM WORKER_LAST_TRANSACTIONS

------------------------------------------LOGLAMA TRIGGER------------------------
CREATE TRIGGER TRG_ITEMS_UPDATE
ON ITEMS 
AFTER UPDATE
AS
BEGIN
INSERT INTO ITEMS_LOG
(ID, ITEMCODE, ITEMNAME, UNITPRICE, CATEGORY1, CATEGORY2, CATEGORY3, CATEGORY4, BRAND, LOG_ACTIONTYPE, LOG_DATE, LOG_USERNAME, LOG_PROGRAMNAME, LOG_HOSTNAME)
SELECT ID,ITEMCODE, ITEMNAME, UNITPRICE, CATEGORY1, CATEGORY2, CATEGORY3, CATEGORY4, BRAND,'UPDATE',GETDATE(),SUSER_NAME(),PROGRAM_NAME(),HOST_NAME()
FROM DELETED
END

CREATE TRIGGER TRG_ITEMS_DELETE_UPDATE--UPDATE DELETE ISLEMLERINDEN SONRA BU TRIGER ICERSINDEKI KOD BLOKLARI CALISIR
ON ITEMS 
AFTER DELETE,UPDATE
AS
BEGIN
DECLARE @DELETEDCOUNT AS INT
DECLARE @INSERTEDCOUNT AS INT

SELECT @DELETEDCOUNT=COUNT(*) FROM DELETED
SELECT @INSERTEDCOUNT=COUNT(*) FROM INSERTED

DECLARE @LOG_ACTIONTYPE AS VARCHAR(20)
IF @DELETEDCOUNT>0 AND @INSERTEDCOUNT>0
    SET @LOG_ACTIONTYPE='UPDATE'
IF @DELETEDCOUNT>0 AND @INSERTEDCOUNT=0
    SET @LOG_ACTIONTYPE='DELETE'
INSERT INTO ITEMS_LOG
(ID, ITEMCODE, ITEMNAME, UNITPRICE, CATEGORY1, CATEGORY2, CATEGORY3, CATEGORY4, BRAND, LOG_ACTIONTYPE, LOG_DATE, LOG_USERNAME, LOG_PROGRAMNAME, LOG_HOSTNAME)
SELECT ID,ITEMCODE, ITEMNAME, UNITPRICE, CATEGORY1, CATEGORY2, CATEGORY3, CATEGORY4, BRAND,@LOG_ACTIONTYPE,GETDATE(),SUSER_NAME(),PROGRAM_NAME(),HOST_NAME()
FROM DELETED
END


CREATE TRIGGER TRG_ITEMS_DELETE_UPDATE_INSTEADOF--DELETE UPDATE ISLEMLERI SIRASINDA GERCEK TABLODA KAYIT SILINMEZ VE DEGISTIRILEMEZ KAYIT ALTINA ALINIR KULLANICI YANILTILIR.
ON ITEMS 
INSTEAD OF DELETE,UPDATE
AS
BEGIN
DECLARE @DELETEDCOUNT AS INT
DECLARE @INSERTEDCOUNT AS INT

SELECT @DELETEDCOUNT=COUNT(*) FROM DELETED
SELECT @INSERTEDCOUNT=COUNT(*) FROM INSERTED

DECLARE @LOG_ACTIONTYPE AS VARCHAR(20)
IF @DELETEDCOUNT>0 AND @INSERTEDCOUNT>0
    SET @LOG_ACTIONTYPE='UPDATE'
IF @DELETEDCOUNT>0 AND @INSERTEDCOUNT=0
    SET @LOG_ACTIONTYPE='DELETE'
INSERT INTO ITEMS_LOG
(ID, ITEMCODE, ITEMNAME, UNITPRICE, CATEGORY1, CATEGORY2, CATEGORY3, CATEGORY4, BRAND, LOG_ACTIONTYPE, LOG_DATE, LOG_USERNAME, LOG_PROGRAMNAME, LOG_HOSTNAME)
SELECT ID,ITEMCODE, ITEMNAME, UNITPRICE, CATEGORY1, CATEGORY2, CATEGORY3, CATEGORY4, BRAND,@LOG_ACTIONTYPE,GETDATE(),SUSER_NAME(),PROGRAM_NAME(),HOST_NAME()
FROM DELETED
END