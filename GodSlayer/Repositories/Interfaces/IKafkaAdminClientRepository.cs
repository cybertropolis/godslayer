using GodSlayer.Models;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace GodSlayer.Repositories.Interfaces
{
    public interface IKafkaAdminClientRepository
    {
        Task<bool> TopicExistsAsync(string topic);
        Task AddTopicAsync(Topic topic);
    }
}
