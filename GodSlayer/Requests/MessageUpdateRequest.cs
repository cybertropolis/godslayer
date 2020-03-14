namespace GodSlayer.Requests
{
    public class MessageUpdateRequest
    {
        public string Schema { get; set; }
        public string Table { get; set; }
        public string Key { get; set; }
        public string Value { get; set; }
    }
}
