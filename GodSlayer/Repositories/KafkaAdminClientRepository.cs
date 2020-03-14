using Confluent.Kafka;
using Confluent.Kafka.Admin;
using GodSlayer.Models;
using GodSlayer.Repositories.Interfaces;
using GodSlayer.Utilities;
using Microsoft.Extensions.Options;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace GodSlayer.Repositories
{
    public class KafkaAdminClientRepository : IKafkaAdminClientRepository
    {
        private readonly IAdminClient client;

        public KafkaAdminClientRepository(IOptions<Secrets> secrets)
        {
            var client = new AdminClientConfig
            {
                BootstrapServers = secrets.Value.Kafka.Host,
                SaslMechanism = SaslMechanism.Plain,
                SecurityProtocol = SecurityProtocol.SaslSsl,
                SaslUsername = secrets.Value.Kafka.SaslUsername,
                SaslPassword = secrets.Value.Kafka.SaslPassword
            };

            this.client = new AdminClientBuilder(client).Build();
        }

        public async Task<bool> TopicExistsAsync(string topic)
        {
            var timeout = TimeSpan.FromSeconds(20);

            var metadata = client.GetMetadata(timeout);

            bool exists = metadata.Topics.Any(y => y.Topic == topic);

            return await Task.FromResult(exists);
        }

        public async Task AddTopicAsync(Topic topic)
        {
            try
            {
                var topicsSpecification = new TopicSpecification[]
                {
                    new TopicSpecification
                    {
                        Name = topic.Nome,
                        NumPartitions = topic.Particoes.GetValueOrDefault(6),
                        ReplicationFactor = topic.Replicas.GetValueOrDefault(3)
                    }
                };

                await client.CreateTopicsAsync(topicsSpecification);
            }
            catch (CreateTopicsException exception)
            {
                throw exception;
            }
        }
    }
}
