using LoremNET;

namespace ClassLibrary.Models
{
    public class Computer
    {
        public Guid Id { get; set; }
        public string Name { get; set; }
        public string Brand { get; set; }

        public Computer()
        {
            Id = Guid.NewGuid();
            Brand = Lorem.Words(1);
            Name = Lorem.Words(1);
        }
        public override string ToString()
        {
            return $"Id: {Id}, Name: {Name}, Brand: {Brand}";
        }
    }
}
