CREATE VIEW [udm].[Fact_#NAME#]

AS

SELECT 
  DW_LoadDate = sat.LoadDate
  ,pit1.HK_Pit_#DIM_1#
  ,pit2.HK_Pit_#DIM_2#
  --,pit3.HK_Pit_#DIM_3#    -- Additional referenced dimension. Remove if not needed
  ,FactDateKey = YEAR(lnk.#DATE_COLUMN#) * 10000 + MONTH(lnk.#DATE_COLUMN#) * 100 + DAY(lnk.#DATE_COLUMN#)
  ,FactTimeKey = DATEPART(HOUR, lnk.#DATE_COLUMN#) * 100 + DATEPART(MINUTE, lnk.#DATE_COLUMN#)
  ,FactDateTime = lnk.#DATE_COLUMN#
  ,sat.#SAT_FIELD#          -- Add multiple rows in case of multiple attributes in Satellite (i.e. sat.FreeMemory_avg, sat.BufferNoMemoryRate_avg, etc.)
FROM [$(DV)].edw.Lnk_#FACT_NAME# lnk
  JOIN [$(DV)].edw.TSat_#FACT_NAME# sat ON lnk.HK_#FACT_NAME# = sat.HK_#FACT_NAME#
  
  JOIN [$(DV)].business.Pit_#DIM_1# pit1 ON lnk.HK_#DIM_1# = pit1.HK_#DIM_1#    -- i.e. JOIN [$(DV)].business.Pit_Node pit1 ON lnk.HK_Node = pit1.HK_Node
    AND lnk.LoadDateShort = pit1.SnapshotDateShort                                            --        AND lnk.LoadDateShort = pit1.SnapshotDateShort
  
  JOIN [$(DV)].business.Pit_#DIM_2# pit2 ON lnk.HK_#DIM_2# = pit2.HK_#DIM_2#    -- i.e. JOIN [$(DV)].business.Pit_Component pit2 ON lnk.HK_Component = pit2.HK_Component
    AND lnk.LoadDateShort = pit2.SnapshotDateShort                                            --        AND lnk.LoadDateShort = pit2.SnapshotDateShort
  
  -- *** Join for additional referenced dimension. Remove if not needed ***
  --JOIN [$(DV)].business.Pit_#DIM_3# pit3 ON lnk.HK_#DIM_3# = pit3.HK_#DIM_3#
  --  AND lnk.LoadDateShort = pit3.SnapshotDateShort