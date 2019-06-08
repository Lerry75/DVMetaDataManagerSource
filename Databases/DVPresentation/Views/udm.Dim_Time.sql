CREATE VIEW [udm].[Dim_Time]

AS

SELECT 
  [TimeKey]
  ,[Time]
  ,[Hour] 
  ,[Minute]
  ,[PartOfDay]
FROM [$(DV)].[edw].[Ref_Time]
