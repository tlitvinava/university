using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
using _253503_Studenichnik_Lab5.Domain;
using _253503_Studenichnik_Lab5.Domain.Abstractions;
using _253503_Studenichnik_Lab5.Domain.Models;
using Newtonsoft.Json;
using System.Xml.Linq;

namespace SerializerLib
{
    public class Serializer : ISerializer
    {
        private const string PATH = "C:\\Users\\Nikita\\source\\repos\\C# labs\\Sem 3\\253503_Studenichnik_Lab5\\Files\\";

        public Serializer()
        {
            if (Directory.Exists(PATH))
            {
                Directory.Delete(PATH, true);
            }
            Directory.CreateDirectory(PATH);
        }
        public IEnumerable<Computer> DeSerializeByLINQ(string fileName)
        {
            XDocument xDocument = XDocument.Load($"{PATH}\\{fileName}.xml");
            return xDocument.Descendants("computer")
             .Select(computerElement => new Computer
             {
                 Id = (int)computerElement.Attribute("computerId")!,
                 Issuer = (string)computerElement.Attribute("computerIssuer")!,
                 Winchester = new Winchester
                 {
                     Id = (int)computerElement.Element("winchester")!.Attribute("winchesterId")!,
                     Model = (string)computerElement.Element("winchester")!.Attribute("winchesterModel")!
                 }
             }).ToList();
        }

        public IEnumerable<Computer> DeSerializeJSON(string fileName)
        {
            return JsonConvert.DeserializeObject<IEnumerable<Computer>>(
                File.ReadAllText($"{PATH}\\{fileName}")
                ) ?? throw new ArgumentNullException();
        }

        public IEnumerable<Computer> DeSerializeXML(string fileName)
        {
            XmlSerializer xml = new XmlSerializer(typeof(Computer[]));
            using (var fileStream = new FileStream($"{PATH}\\{fileName}", FileMode.Open, FileAccess.Read))
            {
                while (fileStream.Position < fileStream.Length)
                {
                    return xml.Deserialize(fileStream) as Computer[];
                }

                return Enumerable.Empty<Computer>();
            }
        }


        public void SerializeByLINQ(IEnumerable<Computer> computers, string fileName)
        {
            XDocument xDocument = new XDocument();

            XElement xComputers = new XElement("computers");
            foreach (var computer in computers)
            {
                XElement xComputer = new XElement("computer");
                XAttribute xComputerId = new XAttribute("computerId", computer.Id);
                XAttribute xComputerIssuer = new XAttribute("computerIssuer", computer.Issuer);

                XElement xWinchester = new XElement("winchester");
                XAttribute xWinchesterId = new XAttribute("winchesterId", computer.Winchester.Id);
                XAttribute xWinchesterModel = new XAttribute("winchesterModel", computer.Winchester.Model);

                xWinchester.Add(xWinchesterId, xWinchesterModel);
                xComputer.Add(xComputerId, xComputerIssuer, xWinchester);
                xComputers.Add(xComputer);
            }

            xDocument.Add(xComputers);
            xDocument.Save($"{PATH}\\{fileName}.xml");
        }

        public void SerializeJSON(IEnumerable<Computer> computers, string fileName)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(JsonConvert.SerializeObject(computers));

            File.WriteAllText($"{PATH}\\{fileName}", sb.ToString());
        }

        public void SerializeXML(IEnumerable<Computer> computers, string fileName)
        {
            XmlSerializer serializer = new XmlSerializer(typeof(Computer[]));
            using (var memoryStream = new FileStream($"{PATH}\\{fileName}", FileMode.OpenOrCreate, FileAccess.Write))
            {
                serializer.Serialize(memoryStream, computers.ToArray());
            }
        }
    }
}
