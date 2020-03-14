using Confluent.Kafka;
using GodSlayer.Models;
using GodSlayer.Models.Enumerators;
using GodSlayer.Repositories.Interfaces;
using GodSlayer.Requests;
using GodSlayer.Services.Interfaces;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace GodSlayer.Services
{
    public class ChangeDataCaptureService : IChangeDataCaptureService
    {
        private readonly IResourceRepository oracleMonitorRepository;
        private readonly IKafkaAdminClientRepository kafkaAdminClientRepository;
        private readonly IKafkaProducerRepository<string, string> kafkaProducerRepository;

        public ChangeDataCaptureService(IResourceRepository oracleMonitorRepository,
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
                Key = request.Id,
                Value = request.Value
            };

            IEnumerable<Resource> resources = await oracleMonitorRepository.List(request.Schema, request.Table, Operation.Create);

            foreach (Resource resource in resources)
            {
                bool exists = await kafkaAdminClientRepository.TopicExistsAsync(resource.Topico.Nome);

                if (!exists)
                {
                    await kafkaAdminClientRepository.AddTopicAsync(resource.Topico);
                }

                await kafkaProducerRepository.AddMessage(resource.Topico.Nome, message);
            }
        }

        public async Task UpdateAsync(MessageUpdateRequest request)
        {
            var message = new Message<string, string>
            {
                Key = request.Id,
                Value = request.Value
            };

            IEnumerable<Resource> resources = await oracleMonitorRepository.List(request.Schema, request.Table, Operation.Update);

            foreach (Resource resource in resources)
            {
                bool exists = await kafkaAdminClientRepository.TopicExistsAsync(resource.Topico.Nome);

                if (!exists)
                {
                    await kafkaAdminClientRepository.AddTopicAsync(resource.Topico);
                }

                await kafkaProducerRepository.AddMessage(resource.Topico.Nome, message);
            }
        }

        public async Task DeleteAsync(string schema, string table, string id)
        {
            var message = new Message<string, string>
            {
                Key = id
            };

            IEnumerable<Resource> resources = await oracleMonitorRepository.List(schema, table, Operation.Delete);

            foreach (Resource resource in resources)
            {
                bool exists = await kafkaAdminClientRepository.TopicExistsAsync(resource.Topico.Nome);

                if (!exists)
                {
                    await kafkaAdminClientRepository.AddTopicAsync(resource.Topico);
                }

                await kafkaProducerRepository.AddMessage(resource.Topico.Nome, message);
            }
        }
    }
}
