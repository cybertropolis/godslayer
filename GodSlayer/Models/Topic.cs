using GodSlayer.Models.Enumerators;

namespace GodSlayer.Models
{
    public class Topic
    {
        public string Name { get; set; }
        public short Replicas { get; set; }
        public short Partitions { get; set; }
        public Situation Situation { get; set; }
    }
}
