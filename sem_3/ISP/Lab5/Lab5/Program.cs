using _253503_Studenichnik_Lab5.Domain.Models;
using SerializerLib;

namespace _253503_Studenichnik_Lab5
{
    internal static class Program
    {
        static void Main(string[] args)
        {
            Serializer serializer = new Serializer();
            List<Computer> computers = new List<Computer>()
            {
                new Computer(1, new Winchester(1, "ASUS"), "HP"),
                new Computer(2, new Winchester(20, "INTEL"), "APPLE"),
                new Computer(3, new Winchester(512, "MOTOROLA"), "DELL"),
                new Computer(4, new Winchester(82, "GOOGLE"), "XIAOMI"),
                new Computer(5, new Winchester(40, "GIGABYTE"), "LENOVO"),
                new Computer(6, new Winchester(240, "RADEON"), "ACER"),
            };

            serializer.SerializeXML(computers, "Computers in XML");
            serializer.SerializeJSON(computers, "Computers in JSON");
            serializer.SerializeByLINQ(computers, "Computers in XML.Linq");

            var ComputersFromXML = serializer.DeSerializeXML("Computers in XML");

            var ComputersFromJSON = serializer.DeSerializeJSON("Computers in JSON");

            var ComputersFromXMLLinq = serializer.DeSerializeByLINQ("Computers in XML.Linq");

            Console.WriteLine("Computers from .xml file are equal? {0}", computers.SequenceEqual(ComputersFromXML));
            Console.WriteLine("Computers from JSON file are equal? {0}", computers.SequenceEqual(ComputersFromJSON));
            Console.WriteLine("Computers from linq.xml file are equal? {0}", computers.SequenceEqual(ComputersFromXMLLinq));
        }
    }
}