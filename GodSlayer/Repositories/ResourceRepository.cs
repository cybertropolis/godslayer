using Dapper;
using GodSlayer.Models;
using GodSlayer.Models.Enumerators;
using GodSlayer.Repositories.Interfaces;
using GodSlayer.Utilities;
using Microsoft.Extensions.Options;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace GodSlayer.Repositories
{
    public class ResourceRepository : IResourceRepository, IDisposable
    {
        private readonly Secrets secrets;
        private OracleConnection connection;

        public ResourceRepository(IOptions<Secrets> options)
        {
            secrets = options.Value;

            connection = new OracleConnection(secrets.ConnectionString);

            connection.Open();
        }

        public async Task<bool> Exists(string schema, string table)
        {
            var parameters = new DynamicParameters();

            parameters.Add("ESQUEMA", schema);
            parameters.Add("TABELA", table);

            const string command = @"
                SELECT COUNT(1)
                  FROM REPLICACAO.RECURSO R
                 WHERE R.ESQUEMA = :ESQUEMA
                   AND R.TABELA = :TABELA
                   AND R.SITUACAO = 1";

            return await connection.QuerySingleAsync<bool>(command, parameters);
        }

        public async Task<IEnumerable<Resource>> List(string schema, string table, Operation operation)
        {
            var parameters = new DynamicParameters();

            parameters.Add("ESQUEMA", schema);
            parameters.Add("TABELA", table);
            parameters.Add("OPERACAO", operation);

            const string command = @"
                SELECT R.ID,
                       R.ESQUEMA,
                       R.TABELA,
                       R.SITUACAO,
                       T.ID        AS TOPICO_ID,
                       T.NOME      AS TOPICO_NOME,
                       T.REPLICAS  AS TOPICO_REPLICAS,
                       T.PARTICOES AS TOPICO_PARTICOES,
                       T.SITUACAO  AS TOPICO_SITUACAO
                  FROM REPLICACAO.RECURSO R
                 INNER JOIN REPLICACAO.TOPICO T
                    ON T.ID = R.IDTOPICO
                   AND T.OPERACAO = :OPERACAO
                 WHERE R.ESQUEMA = :ESQUEMA
                   AND R.TABELA = :TABELA
                   AND R.SITUACAO = 1";

            var result = await connection.QueryAsync<dynamic>(command, parameters);

            IEnumerable<Resource> resources = result.Select(y => new Resource
            {
                Id = (int)y.ID,
                Esquema = y.ESQUEMA,
                Tabela = y.TABELA,
                Situacao = (int)y.SITUACAO == 0 ? Situation.Disabled : Situation.Enabled,
                Topico = new Topic
                {
                    Id = (int)y.TOPICO_ID,
                    Nome = y.TOPICO_NOME,
                    Replicas = (short?)y.TOPICO_REPLICAS,
                    Particoes = (int?)y.TOPICO_PARTICOES,
                    Situacao = (int)y.TOPICO_SITUACAO == 0 ? Situation.Disabled : Situation.Enabled,
                }
            });

            return resources;
        }

        public void Dispose()
        {
            connection.Close();
        }
    }
}
