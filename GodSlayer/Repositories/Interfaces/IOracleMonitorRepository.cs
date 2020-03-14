using GodSlayer.Models;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace GodSlayer.Repositories.Interfaces
{
    public interface IOracleMonitorRepository
    {
        Task<bool> HasResourcesByTable(string schema, string table);
        Task<IEnumerable<Resource>> ListResourcesByTable(string schema, string table);
    }
}
