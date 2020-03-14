namespace GodSlayer.Requests
{
    public class MessageCreateRequest
    {
        public string Schema { get; set; }
        public string Table { get; set; }
        public string Id { get; set; }
        public string Value { get; set; }
    }
}
