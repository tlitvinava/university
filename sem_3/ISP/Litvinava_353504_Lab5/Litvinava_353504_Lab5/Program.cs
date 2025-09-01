using System;
using System.Collections.Generic;
using System.Linq;
using Litvinava_353504_Lab5.Domain.Models;
using Microsoft.Extensions.Configuration;

using SerializerLib;

namespace Litvinava_353504_Lab5
{
    internal static class Program
    {
        static void Main(string[] args)
        {
            var configuration = new ConfigurationBuilder()
             .AddJsonFile("appsettings.json", false, true)
             .Build();

            string value = configuration["Directories:LocalPath"];

            var serializer = new Serializer(value);

            List<Computer> computers =
            [
                new Computer(1, new Winchester(1, "ASUS"), "HP"),
                new Computer(2, new Winchester(20, "INTEL"), "APPLE"),
                new Computer(3, new Winchester(512, "MOTOROLA"), "DELL"),
                new Computer(4, new Winchester(82, "GOOGLE"), "XIAOMI"),
                new Computer(5, new Winchester(40, "GIGABYTE"), "LENOVO"),
                new Computer(6, new Winchester(240, "RADEON"), "ACER"),
            ];

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