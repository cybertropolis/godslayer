using Confluent.Kafka;
using System.Threading.Tasks;

namespace GodSlayer.Repositories.Interfaces
{
    public interface IKafkaProducerRepository<TKey, TValue>
    {
        Task<DeliveryResult<TKey, TValue>> AddMessage(string topic, Message<TKey, TValue> message);
    }
}
