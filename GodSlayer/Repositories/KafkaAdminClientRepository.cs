using Confluent.Kafka;
using Confluent.Kafka.Admin;
using GodSlayer.Repositories.Interfaces;
using GodSlayer.Utilities;
using Microsoft.Extensions.Options;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace GodSlayer.Repositories
{
    public class KafkaAdminClientRepository : IKafkaAdminClientRepository
    {
        private readonly IAdminClient adminClient;

        public KafkaAdminClientRepository(IOptions<Secrets> appSettings)
        {
            AdminClientConfig adminConfig = new AdminClientConfig
            {
                BootstrapServers = appSettings.Value.Kafka.SchemaRegistry.Host
            };

            adminClient = new AdminClientBuilder(adminConfig).Build();
        }

        public async Task<bool> TopicExistsAsync(string topic)
        {
            var timeout = new TimeSpan(0, 0, 15);

            bool exists = adminClient.GetMetadata(topic, timeout).Topics.Any(t => t.Topic == topic);

            return await Task.FromResult(exists);
        }

        public async Task AddTopicAsync(string topic, int partitions = -1, Dictionary<int, List<int>> replicas = null, short replicationFactor = -1)
        {
            var topicSpecification = new TopicSpecification
            {
                Name = topic,
                NumPartitions = partitions,
                ReplicasAssignments = replicas,
                ReplicationFactor = replicationFactor
            };

            var topicsSpecification = new List<TopicSpecification>
            {
                topicSpecification
            };

            await adminClient.CreateTopicsAsync(topicsSpecification);
        }
    }
}
