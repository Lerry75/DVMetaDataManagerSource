CREATE VIEW [udm].[Map_#NAME#]

AS

SELECT 
  DW_LoadDate = rsat.LoadDate
  ,pit1.HK_Pit_#DIM_1#
  ,pit2.HK_Pit_#DIM_2#
  ,~(CONVERT(BIT, (DENSE_RANK() OVER (ORDER BY rsat.LoadDate DESC)) - 1)) IsCurrent
FROM [$(DV)].edw.Lnk_#MAP_NAME# lnk
  JOIN [$(DV)].edw.RSat_#MAP_NAME# rsat ON lnk.HK_#MAP_NAME# = rsat.HK_#MAP_NAME#
  
  JOIN [$(DV)].business.Pit_#DIM_1# pit1 ON lnk.HK_#DIM_1# = pit1.HK_#DIM_1#    -- i.e. JOIN [$(DV)].business.Pit_Host pit1 ON lnk.HK_Host = pit1.HK_Host
    AND rsat.LoadDateShort = pit1.SnapshotDateShort                                           --        AND rsat.LoadDateShort = pit1.SnapshotDateShort
  
  JOIN [$(DV)].business.Pit_#DIM_2# pit2 ON lnk.HK_#DIM_2# = pit2.HK_#DIM_2#    -- i.e. JOIN [$(DV)].business.Pit_Software pit2 ON lnk.HK_Software = pit2.HK_Software
    AND rsat.LoadDateShort = pit2.SnapshotDateShort                                           --        AND rsat.LoadDateShort = pit2.SnapshotDateShort
