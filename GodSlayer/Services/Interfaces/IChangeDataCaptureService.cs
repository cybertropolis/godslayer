using GodSlayer.Requests;
using System.Threading.Tasks;

namespace GodSlayer.Services.Interfaces
{
    public interface IChangeDataCaptureService
    {
        Task UpdateAsync(MessageUpdateRequest request);
        Task CreateAsync(MessageCreateRequest request);
        Task DeleteAsync(string resource, string key);
    }
}
