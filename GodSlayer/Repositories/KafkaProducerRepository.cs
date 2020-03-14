using Confluent.Kafka;
using GodSlayer.Repositories.Interfaces;
using GodSlayer.Utilities;
using Microsoft.Extensions.Options;
using System.Threading.Tasks;

namespace GodSlayer.Repositories
{
    public class KafkaProducerRepository<TKey, TValue> : IKafkaProducerRepository<TKey, TValue>
    {
        private readonly IProducer<TKey, TValue> client;

        public KafkaProducerRepository(IOptions<Secrets> secrets)
        {
            var client = new ProducerConfig
            {
                BootstrapServers = secrets.Value.Kafka.Host,
                SaslMechanism = SaslMechanism.Plain,
                SecurityProtocol = SecurityProtocol.SaslSsl,
                SaslUsername = secrets.Value.Kafka.SaslUsername,
                SaslPassword = secrets.Value.Kafka.SaslPassword
            };

            this.client = new ProducerBuilder<TKey, TValue>(client).Build();
        }

        public async Task<DeliveryResult<TKey, TValue>> AddMessage(string topic, Message<TKey, TValue> message)
        {
            try
            {
                DeliveryResult<TKey, TValue> result = await client.ProduceAsync(topic, message);

                return result;
            }
            catch (ProduceException<TKey, TValue> exception)
            {
                // TODO: logar o erro para aplicar melhoria contínua

                throw exception;
            }
        }
    }
}
