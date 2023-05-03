-----------------------------------------TIP DONUSUM FONKSIYONLARI-------------------------------------


-------------------------------------CAST/CONVERT ORNEK-------------------------------------------
SELECT CAST ('20230503' AS DATE)
SELECT CAST ('20230503' AS INT),
CONVERT(DATE,'20230503')
SELECT CONVERT(INT,'18')
SELECT CAST ('2023-05-03' AS INT)
SELECT CONVERT(DATE,GETDATE(),103)

-------------------------------------TRY_CAST/TRY_CONVERT ORNEK-------------------------------------------
SELECT TRY_CAST ('20231603' AS DATE)--HATALI DONUSUMLERE NULL DEGER ATAR
SELECT TRY_CONVERT(DATE,'20232521')--HATALI DONUSUMLERE NULL DEGER ATAR


