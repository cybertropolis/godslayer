using GodSlayer.Models.Enumerators;

namespace GodSlayer.Models
{
    public class Resource
    {
        public string Schema { get; set; }
        public string Table { get; set; }
        public Situation Situation { get; set; }
        public Topic Topic { get; set; }
    }
}
