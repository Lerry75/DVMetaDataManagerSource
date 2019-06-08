CREATE VIEW [udm].[Dim_#NAME#]

AS

WITH #NAME# AS
(
SELECT 
  pit.HK_Pit_#NAME#     -- Hash Key from PIT (i.e. HK_Pit_Host)
  ,pit.SnapshotDate
  ,pit.SnapshotDateShort
  ,pit.HK_#NAME#
  ,~(CONVERT(BIT, (DENSE_RANK() OVER (ORDER BY pit.SnapshotDate DESC)) - 1)) IsCurrent
  ,hub.#BUSINESS_KEY#   -- Add multilple rows in in case of composite Business Key (i.e. hub.HostName, hub.HostDomain)
  ,sat1.#SAT_1_FIELD#   -- Add multiple rows in case of multiple attributes in Satellite (i.e. sat1.InstalledOS, sat1.OSVersion, etc.)
FROM [$(DV)].business.Pit_#NAME# pit
  JOIN [$(DV)].edw.Hub_#NAME# hub ON pit.HK_#NAME# = hub.HK_#NAME#
  JOIN [$(DV)].edw.Sat_#NAME#_#SOURCE_SYSTEM_1# sat1 ON pit.#NAME#_#SOURCE_SYSTEM_1#_HK_#NAME# = sat1.HK_#NAME#   -- i.e. JOIN [$(DV)].edw.Sat_Host_CMDB sat1 ON pit.Host_CMDB_HK_Host = sat1.HK_Host
    AND pit.#NAME#_#SOURCE_SYSTEM_1#_LoadDate = sat1.LoadDate                                                                   --        AND pit.Host_CMDB_LoadDate = sat1.LoadDate
)
  -- *** Referenced entities by main dimension ***
  ,#NAME#_#REFERENCE_NAME_1# AS
(
SELECT
  pit.HK_Pit_#REFERENCE_NAME_1#
  ,lnk.HK_#NAME#
  ,rsat.LoadDateShort
FROM [$(DV)].edw.Lnk_#NAME#_#REFERENCE_NAME_1# lnk
	JOIN [$(DV)].edw.RSat_#NAME#_#REFERENCE_NAME_1# rsat ON lnk.HK_#NAME#_#REFERENCE_NAME_1# = rsat.HK_#NAME#_#REFERENCE_NAME_1#
	JOIN [$(DV)].business.Pit_#REFERENCE_NAME_1# pit ON lnk.HK_#REFERENCE_NAME_1# = pit.HK_#REFERENCE_NAME_1#
    AND rsat.LoadDateShort = pit.SnapshotDateShort
)
  -- *** Additional referenced entities by main dimension. Remove if not needed ***
--  ,#NAME#_#REFERENCE_NAME_2# AS
--(
--SELECT
--  pit.HK_Pit_#REFERENCE_NAME_2#
--  ,lnk.HK_#NAME#
--  ,rsat.LoadDateShort
--FROM [$(DV)].edw.Lnk_#NAME#_#REFERENCE_NAME_2# lnk
--	JOIN [$(DV)].edw.RSat_#NAME#_#REFERENCE_NAME_2# rsat ON lnk.HK_#NAME#_#REFERENCE_NAME_2# = rsat.HK_#NAME#_#REFERENCE_NAME_2#
--	JOIN [$(DV)].business.Pit_#REFERENCE_NAME_2# pit ON lnk.HK_#REFERENCE_NAME_2# = pit.HK_#REFERENCE_NAME_2#
--    AND rsat.LoadDateShort = pit.SnapshotDateShort
--)

SELECT 
  #NAME#.*
  ,#NAME#_#REFERENCE_NAME_1#.HK_Pit_#REFERENCE_NAME_1#
  --,#NAME#_#REFERENCE_NAME_2#.HK_Pit_#REFERENCE_NAME_2#     -- Additional referenced dimension attributes. Remove if not needed
FROM #NAME#

  -- Add referenced dimension
  LEFT JOIN #NAME#_#REFERENCE_NAME_1# ON #NAME#.HK_#NAME# = #NAME#_#REFERENCE_NAME_1#.HK_#NAME#
	  AND #NAME#.SnapshotDateShort = #NAME#_#REFERENCE_NAME_1#.LoadDateShort

  -- *** Join for additional referenced dimension. Remove if not needed ***
  --LEFT JOIN #NAME#_#REFERENCE_NAME_2# ON #NAME#.HK_#NAME# = #NAME#_#REFERENCE_NAME_2#.HK_#NAME#
	 -- AND #NAME#.SnapshotDateShort = #NAME#_#REFERENCE_NAME_2#.LoadDateShort
