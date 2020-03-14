using GodSlayer.Models;
using GodSlayer.Models.Enumerators;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace GodSlayer.Repositories.Interfaces
{
    public interface IResourceRepository
    {
        Task<bool> Exists(string schema, string table);
        Task<IEnumerable<Resource>> List(string schema, string table, Operation operation);
    }
}
