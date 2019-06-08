using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VaultMetaDataManager
{
    public class SchemaVersion
    {
        public List<SchemaVersionMap> Versions { get; }

        public SchemaVersion()
        {
            Versions = new List<SchemaVersionMap>();

            // All database schema versions listed here
            Versions.Add(new SchemaVersionMap("Unknown", SchemaVersionStatus.Unsupported));
            Versions.Add(new SchemaVersionMap("1.1.0.1", SchemaVersionStatus.Supported));
        }
    }

    public enum SchemaVersionStatus
    {
        Supported,
        Unsupported
    }

    public struct SchemaVersionMap
    {
        public string schemaversion;
        public SchemaVersionStatus status;

        public SchemaVersionMap(string schema, SchemaVersionStatus state)
        {
            schemaversion = schema;
            status = state;
        }
    }

}
