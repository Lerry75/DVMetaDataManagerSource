CREATE VIEW [udm].[Dim_#NAME#]

AS

SELECT 
  pit.HK_Pit_#NAME#     -- Hash Key from PIT (i.e. HK_Pit_Host)
  ,pit.SnapshotDate
  ,~(CONVERT(BIT, (DENSE_RANK() OVER (ORDER BY pit.SnapshotDate DESC)) - 1)) IsCurrent
  ,hub.#BUSINESS_KEY#   -- Add multilple rows in in case of composite Business Key (i.e. hub.HostName, hub.HostDomain)
  ,sat1.#SAT_1_FIELD#   -- Add multiple rows in case of multiple attributes in Satellite (i.e. sat1.InstalledOS, sat1.OSVersion, etc.)
  --,sat2.#SAT_2_FIELD# -- Additional Satellites attributes. Remove if not needed
FROM [$(DV)].business.Pit_#NAME# pit
  JOIN [$(DV)].edw.Hub_#NAME# hub ON pit.HK_#NAME# = hub.HK_#NAME#
  JOIN [$(DV)].edw.Sat_#NAME#_#SOURCE_SYSTEM_1# sat1 ON pit.#NAME#_#SOURCE_SYSTEM_1#_HK_#NAME# = sat1.HK_#NAME#   -- i.e. JOIN [$(DV)].edw.Sat_Host_CMDB sat1 ON pit.Host_CMDB_HK_Host = sat1.HK_Host
    AND pit.#NAME#_#SOURCE_SYSTEM_1#_LoadDate = sat1.LoadDate                                                                   --        AND pit.Host_CMDB_LoadDate = sat1.LoadDate
  -- *** Join for additional Satellites attributes. Remove if not needed ***
  --JOIN [$(DV)].edw.Sat_#NAME#_#SOURCE_SYSTEM_2# sat2 ON pit.#NAME#_#SOURCE_SYSTEM_2#_HK_#NAME# = sat2.HK_#NAME# -- i.e. JOIN [$(DV)].edw.Sat_Host_HPA sat2 ON pit.Host_HPA_HK_Host = sat2.HK_Host
  --  AND pit.#NAME#_#SOURCE_SYSTEM_2#_LoadDate = sat2.LoadDate                                                                 --        AND pit.Host_HPA_LoadDate = sat2.LoadDate