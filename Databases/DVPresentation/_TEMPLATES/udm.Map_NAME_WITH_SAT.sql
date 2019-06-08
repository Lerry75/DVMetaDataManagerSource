CREATE VIEW [udm].[Map_#NAME#]

AS

SELECT 
  DW_LoadDate = pit.SnapshotDate
  ,pit1.HK_Pit_#DIM_1#
  ,pit2.HK_Pit_#DIM_2#
  ,~(CONVERT(BIT, (DENSE_RANK() OVER (ORDER BY pit.SnapshotDate DESC)) - 1)) IsCurrent
  ,sat.#SAT_FIELD#          -- Add multiple rows in case of multiple attributes in Satellite (i.e. sat.Installation_Date, sat.Installation_Source, etc.)
FROM [$(DV)].business.Pit_#MAP_NAME# pit
  JOIN [$(DV)].edw.Lnk_#MAP_NAME# lnk ON pit.HK_#MAP_NAME# = lnk.HK_#MAP_NAME#
  JOIN [$(DV)].edw.Sat_#MAP_NAME#_#SOURCE_SYSTEM_1# sat ON pit.#MAP_NAME#_#SOURCE_SYSTEM_1#_HK_#MAP_NAME# = sat.HK_#MAP_NAME#   -- i.e. JOIN [$(DV)].edw.Sat_Host_Software_Installed_CMDB sat ON pit.Host_Software_Installed_CMDB_HK_Host_Software_Installed = sat.HK_Host_Software_Installed
    AND pit.#MAP_NAME#_#SOURCE_SYSTEM_1#_LoadDate = sat.LoadDate                                                                              --        AND pit.Host_Software_Installed_CMDB_LoadDate = sat.LoadDate
  
  JOIN [$(DV)].business.Pit_#DIM_1# pit1 ON lnk.HK_#DIM_1# = pit1.HK_#DIM_1#    -- i.e. JOIN [$(DV)].business.Pit_Host pit1 ON lnk.HK_Host = pit1.HK_Host
    AND pit.SnapshotDate = pit1.SnapshotDate                                                  --        AND pit.SnapshotDate = pit1.SnapshotDate
  
  JOIN [$(DV)].business.Pit_#DIM_2# pit2 ON lnk.HK_#DIM_2# = pit2.HK_#DIM_2#    -- i.e. JOIN [$(DV)].business.Pit_Software pit2 ON lnk.HK_Software = pit2.HK_Software
    AND pit.SnapshotDate = pit2.SnapshotDate                                                  --        AND pit.SnapshotDate = pit2.SnapshotDate
