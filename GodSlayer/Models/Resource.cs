using GodSlayer.Models.Enumerators;

namespace GodSlayer.Models
{
    public class Resource
    {
        public int Id { get; set; }
        public string Esquema { get; set; }
        public string Tabela { get; set; }
        public Situation Situacao { get; set; }
        public Topic Topico { get; set; }
    }
}
