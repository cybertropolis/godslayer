using GodSlayer.Requests;
using System.Threading.Tasks;

namespace GodSlayer.Services.Interfaces
{
    public interface IChangeDataCaptureService
    {
        Task CreateAsync(MessageCreateRequest request);
        Task UpdateAsync(MessageUpdateRequest request);
        Task DeleteAsync(string schema, string table, string id);
    }
}
