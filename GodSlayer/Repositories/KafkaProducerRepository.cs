using Confluent.Kafka;
using GodSlayer.Repositories.Interfaces;
using GodSlayer.Utilities;
using Microsoft.Extensions.Options;
using System.Threading.Tasks;

namespace GodSlayer.Repositories
{
    public class KafkaProducerRepository<TKey, TValue> : IKafkaProducerRepository<TKey, TValue>
    {
        private readonly IProducer<TKey, TValue> producer;

        public KafkaProducerRepository(IOptions<Secrets> settings)
        {
            var config = new ProducerConfig
            {
                BootstrapServers = settings.Value.Kafka.SchemaRegistry.Host
            };

            producer = new ProducerBuilder<TKey, TValue>(config).Build();
        }
        
        public async Task<DeliveryResult<TKey, TValue>> AddMessage(string topic, Message<TKey, TValue> message)
        {
            DeliveryResult<TKey, TValue> result = await producer.ProduceAsync(topic, message);

            return result;
        }
    }
}
