using Confluent.Kafka;
using GodSlayer.Models;
using GodSlayer.Repositories.Interfaces;
using GodSlayer.Requests;
using GodSlayer.Services.Interfaces;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace GodSlayer.Services
{
    public class ChangeDataCaptureService : IChangeDataCaptureService
    {
        private readonly IOracleMonitorRepository oracleMonitorRepository;
        private readonly IKafkaAdminClientRepository kafkaAdminClientRepository;
        private readonly IKafkaProducerRepository<string, string> kafkaProducerRepository;

        public ChangeDataCaptureService(IOracleMonitorRepository oracleMonitorRepository,
                                        IKafkaAdminClientRepository kafkaAdminClientRepository,
                                        IKafkaProducerRepository<string, string> kafkaProducerRepository)
        {
            this.oracleMonitorRepository = oracleMonitorRepository;
            this.kafkaAdminClientRepository = kafkaAdminClientRepository;
            this.kafkaProducerRepository = kafkaProducerRepository;
        }

        public async Task CreateAsync(MessageCreateRequest request)
        {
            var message = new Message<string, string>
            {
                Key = request.Key,
                Value = request.Value
            };

            IEnumerable<Resource> resources = await oracleMonitorRepository.ListResourcesByTable(request.Schema, request.Table);

            foreach (Resource resource in resources)
            {
                if (!await kafkaAdminClientRepository.TopicExistsAsync(resource.Topic.Name))
                {
                    await kafkaAdminClientRepository.AddTopicAsync(topic: resource.Topic.Name,
                                                                   partitions: resource.Topic.Partitions,
                                                                   replicationFactor: resource.Topic.Replicas);
                }

                await kafkaProducerRepository.AddMessage(resource.Topic.Name, message);
            }
        }

        public async Task UpdateAsync(MessageUpdateRequest request)
        {
            // TODO: Obter essa configuração de uma base
            var topic = "";

            var message = new Message<string, string>
            {
                Key = request.Key,
                Value = request.Value
            };

            await kafkaProducerRepository.AddMessage(topic, message);
        }

        public async Task DeleteAsync(string resource, string key)
        {
            // TODO: Obter essa configuração de uma base
            var topic = "";

            var message = new Message<string, string> { Key = key };

            await kafkaProducerRepository.AddMessage(topic, message);
        }
    }
}
