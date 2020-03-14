using GodSlayer.Repositories.Interfaces;
using GodSlayer.Utilities;
using Microsoft.Extensions.Options;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Dapper;
using System.Data.SqlClient;
using GodSlayer.Models;

namespace GodSlayer.Repositories
{
    public class OracleMonitorRepository : IOracleMonitorRepository, IDisposable
    {
        private readonly Secrets secrets;
        private SqlConnection connection;

        public OracleMonitorRepository(IOptions<Secrets> options)
        {
            secrets = options.Value;

            connection = new SqlConnection(secrets.ConnectionString);
            
            connection.Open();
        }

        public async Task<bool> HasResourcesByTable(string schema, string table)
        {
            var parameters = new DynamicParameters();

            parameters.Add("SCHEMA", schema);
            parameters.Add("TABLE", table);

            const string command = @"
                SELECT COUNT(1)
                  FROM REPLICATION.RESOURCE R 
                 WHERE R.SCHEMA = :SCHEMA
                   AND R.TABLE = :TABLE";

            return await connection.QuerySingleAsync<bool>(command, parameters);
        }

        public async Task<IEnumerable<Resource>> ListResourcesByTable(string schema, string table)
        {
            var parameters = new DynamicParameters();

            parameters.Add("SCHEMA", schema);
            parameters.Add("TABLE", table);

            const string command = @"
                SELECT COUNT(*)
                  FROM REPLICATION.RESOURCE R
                 WHERE R.SCHEMA = :SCHEMA
                   AND R.TABLE = :TABLE";

            return await connection.QueryAsync<Resource>(command, parameters);
        }

        public void Dispose()
        {
            connection.Close();
        }
    }
}
