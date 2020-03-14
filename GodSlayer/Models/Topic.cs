using GodSlayer.Models.Enumerators;

namespace GodSlayer.Models
{
    public class Topic
    {
        public int Id { get; set; }
        public string Nome { get; set; }
        public short? Replicas { get; set; }
        public int? Particoes { get; set; }
        public Situation Situacao { get; set; }
    }
}
