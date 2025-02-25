SELECT
    ps.PatientId
    
    ,ps.AdmittedDate
    
    ,ps.DischargeDate
    
    ,ps.Hospital
    
    ,ps.Ward 
    
    ,DATEDIFF(DAY,PS.AdmittedDaTE,PS.DischargeDate) +1 AS LengthOfStay
    
    ,DATEADD(DAY,-14, PS.AdmittedDate) AS RemindDate
FROM
    PatientStay ps
WHERE
    PS.Hospital IN ('OXLEAS','PRUH')
    AND PS.AdmittedDate BETWEEN '2024-02-01' AND '2024-02-29'
    AND PS.WARD LIKE '%SURGERY'
ORDER BY ps.AdmittedDate DESC
    , ps.PatientId DESC

SELECT
    ps.Hospital
    
    ,COUNT (*) AS NUMPATIENTS
    
    ,SUM (ps.Tariff) AS TotalTariff
    
    ,AVG(ps.Tariff) AS AverageTariff
FROM
    PatientStay ps
GROUP BY ps.Hospital
HAVING
COUNT (*) > 10
ORDER BY NUMPATIENTS DESC

--CREATING TEMP TABLE--
DROP TABLE IF EXISTS #EDD

SELECT
    ps.Hospital
    
    ,COUNT (*) AS NUMPATIENTS
    
    ,SUM (ps.Tariff) AS TotalTariff
    ,CONVERT(DECIMAL(10,2), AVG(ps.Tariff)) AS AverageTariff
INTO #EDD
FROM
    PatientStay ps
GROUP BY ps.Hospital
HAVING
COUNT (*) > 10
ORDER BY NUMPATIENTS DESC

SELECT
    *
FROM
    #EDD
WHERE (NUMPATIENTS)>=10
ORDER BY NUMPATIENTS DESC


SELECT
    TOP 10
    ps.PatientId
    ,ps.Tariff
FROM
    PatientStay ps
ORDER BY ps.Tariff DESC

--subquery
SELECT
    SUM (toppatients.Tariff)
FROM
    (
    SELECT
        TOP 10
        ps.PatientId
    ,ps.Tariff
    FROM
        PatientStay ps
    ORDER BY ps.Tariff DESC) TopPatients;

--CTE (writing outer query) COMMON TABLE EXPRESSION
;
WITH
    TopPatients
    AS
    (
        SELECT
            TOP 10
            ps.PatientId
    ,ps.Tariff
        FROM
            PatientStay ps
        ORDER BY ps.Tariff DESC
    )
    ,CTE2
    AS
    (
        SELECT
            *
        FROM
            TopPatients
    )
SELECT
    SUM (CTE2.Tariff)
FROM
    CTE2

--TEMP TABLE
DROP TABLE IF EXISTS
SELECT
    TOP 10
    ps.PatientId
    ,ps.Tariff
INTO #TopPatients
FROM
    PatientStay ps
    ORDER BY ps.Tariff DESC
SELECT
    Sum(Tariff)
FROM
    #TopPatients AS TOP10PATIENTS

