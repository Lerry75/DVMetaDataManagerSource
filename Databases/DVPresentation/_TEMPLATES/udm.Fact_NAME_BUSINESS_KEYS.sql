CREATE VIEW [udm].[Fact_#NAME#]

AS

SELECT 
  DW_LoadDate = sat.LoadDate
  ,pit1.HK_Pit_#DIM_1#
  ,pit2.HK_Pit_#DIM_2#
  --,pit3.HK_Pit_#DIM_3#    -- Additional referenced dimension. Remove if not needed
  ,hub1.#BUSINESS_KEY#      -- Add multilple rows in in case of composite Business Key (i.e. hub1.NodeName, hub.NodeShortName)
  ,hub2.#BUSINESS_KEY#      -- Add multilple rows in in case of composite Business Key (i.e. hub2.QualifiedComponentName, hub2.ComponentType)
  --,hub3.#BUSINESS_KEY#    -- Additional referenced dimension. Remove if not needed
  ,FactDateKey = YEAR(lnk.#DATE_COLUMN#) * 10000 + MONTH(lnk.#DATE_COLUMN#) * 100 + DAY(lnk.#DATE_COLUMN#)
  ,FactTimeKey = DATEPART(HOUR, lnk.#DATE_COLUMN#) * 100 + DATEPART(MINUTE, lnk.#DATE_COLUMN#)
  ,FactDateTime = lnk.#DATE_COLUMN#
  ,sat.#SAT_FIELD#          -- Add multiple rows in case of multiple attributes in Satellite (i.e. sat.FreeMemory_avg, sat.BufferNoMemoryRate_avg, etc.)
FROM [$(DV)].edw.Lnk_#FACT_NAME# lnk                                                -- i.e. FROM [$(DV)].edw.Lnk_Node_Component_Hour lnk
  JOIN [$(DV)].edw.TSat_#FACT_NAME# sat ON lnk.HK_#FACT_NAME# = sat.HK_#FACT_NAME#  --        JOIN [$(DV)].edw.TSat_Node_Component_Hour sat ON lnk.HK_Node_Component_Hour = sat.HK_Node_Component_Hour
  
  JOIN [$(DV)].business.Pit_#DIM_1# pit1 ON lnk.HK_#DIM_1# = pit1.HK_#DIM_1#        -- i.e. JOIN [$(DV)].business.Pit_Node pit1 ON lnk.HK_Node = pit1.HK_Node
    AND lnk.LoadDateShort = pit1.SnapshotDateShort                                                --        AND lnk.LoadDateShort = pit1.SnapshotDateShort
  JOIN [$(DV)].edw.Hub_#DIM_1# hub1 on pit1.HK_#DIM_1# = hub1.HK_#DIM_1#            --      JOIN [$(DV)].edw.Hub_Node hub1 on pit1.HK_Node = hub1.HK_Node
  
  JOIN [$(DV)].business.Pit_#DIM_2# pit2 ON lnk.HK_#DIM_2# = pit2.HK_#DIM_2#        -- i.e. JOIN [$(DV)].business.Pit_Component pit2 ON lnk.HK_Component = pit2.HK_Component
    AND lnk.LoadDateShort = pit2.SnapshotDateShort                                                --        AND lnk.LoadDateShort = pit2.SnapshotDateShort
  JOIN [$(DV)].edw.Hub_#DIM_2# hub2 on pit2.HK_#DIM_2# = hub1.HK_#DIM_2#            --      JOIN [$(DV)].edw.Hub_Component hub2 on pit2.HK_Component = hub1.HK_Component
  
  -- *** Join for additional referenced dimension. Remove if not needed ***
  --JOIN [$(DV)].business.Pit_#DIM_3# pit3 ON lnk.HK_#DIM_3# = pit3.HK_#DIM_3#
  --  AND lnk.LoadDateShort = pit3.SnapshotDateShort
  --JOIN [$(DV)].edw.Hub_#DIM_3# hub3 on pit3.HK_#DIM_3# = hub1.HK_#DIM_3#
