using Lab4.Abstractions;
using Lab4.Models;
//using Lab4.Models;
using Lab4.Abstractions;
using System;
using System.Collections.Generic;
using System.IO;

namespace Lab4.Services
{
    internal class FileService : IFileService
    {
        public IEnumerable<Computer> ReadFile(string fileName)
        {
            using (BinaryReader reader = new BinaryReader(new FileStream(fileName, FileMode.Open)))
            {
                while (reader.BaseStream.Position < reader.BaseStream.Length)
                {
                    Computer computer = new Computer();
                    try
                    {
                        var id = reader.ReadInt32();
                        var name = reader.ReadString();
                        var isAdmin = reader.ReadBoolean();
                        computer = new Computer(name, id, isAdmin);
                    }
                    catch (Exception e) when (e is ArgumentException || e is IOException)
                    {
                        Console.WriteLine(e.Message);
                    }
                    yield return computer;
                }
            }
        }

        public void SaveData(IEnumerable<Computer> computers, string fileName)
        {
            if (File.Exists(fileName))
            {
                File.Delete(fileName);
            }

            try
            {
                using (BinaryWriter writer = new BinaryWriter(new FileStream(fileName, FileMode.Create)))
                {
                    foreach (var computer in computers)
                    {
                        writer.Write(computer.Id);
                        writer.Write(computer.Name);
                        writer.Write(computer.IsAdmin);
                    }
                }
            }
            catch (Exception e) when (e is ArgumentNullException || e is ArgumentException || e is IOException)
            {
                Console.WriteLine(e.Message);
            }
        }
    }
}
