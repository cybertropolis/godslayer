using System.Collections.Generic;
using System.Threading.Tasks;

namespace GodSlayer.Repositories.Interfaces
{
    public interface IKafkaAdminClientRepository
    {
        Task<bool> TopicExistsAsync(string topic);
        Task AddTopicAsync(string topic, int partitions = -1, Dictionary<int, List<int>> replicas = null, short replicationFactor = -1);
    }
}
