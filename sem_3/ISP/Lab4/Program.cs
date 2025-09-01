using Lab4.Models;
//using Lab4.Models;
using Lab4.Services;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace Lab4
{
    internal class Program
    {
        public const string PATH = "C:\\Users\\tlitv\\!Labs\\Lab4\\Files\\";

        static void Main(string[] args)
        {
            DirectoryExtension.RecreateDirectory(PATH);
            Random random = new Random();
            MyCustomComparer customComparer = new MyCustomComparer();

            // Создание 10 пустых файлов
            for (int i = 0; i < 10; i++)
            {
                string fileName = Path.Combine(PATH, $"{Path.GetRandomFileName()}{GetRandomFileExtension()}");
                File.Create(fileName).Close();
            }

            // Вывод информации о файлах
            DirectoryInfo directoryInfo = new DirectoryInfo(PATH);
            var files = directoryInfo.EnumerateFiles();
            foreach (var file in files)
            {
                Console.WriteLine($"Файл: {file.Name} имеет расширение {file.Extension}");
            }

            // Создание и заполнение коллекции объектов Computer
            var computers = new List<Computer>();
            for (int i = 0; i < 6; i++)
            {
                computers.Add(new Computer(random.GetRandomString(random.Next(3, 10)), random.Next(1, 200), random.Next(0, 2) == 1));
            }
            Console.WriteLine("\nКомпьютеры:");
            foreach (var computer in computers)
            {
                Console.WriteLine(computer);
            }

            // Сохранение данных в файл
            var file1 = files.First();
            FileService fileService = new FileService();
            fileService.SaveData(computers, file1.FullName);

            // Переименование файла
            var newFileName = "renamed" + file1.Extension;
            File.Move(file1.FullName, Path.Combine(PATH, newFileName));

            // Чтение данных из файла
            var newComputers = fileService.ReadFile(Path.Combine(PATH, newFileName)).ToList();

            // Сортировка по имени
            var sortedComputersByName = newComputers.OrderBy(comp => comp, customComparer);
            Console.WriteLine("\nОтсортированные компьютеры из файла по имени: ");
            foreach (var sortedComputer in sortedComputersByName)
            {
                Console.WriteLine(sortedComputer.ToString());
            }

            // Сортировка по идентификатору
            var sortedComputersById = newComputers.OrderBy(comp => comp.Id);
            Console.WriteLine("\nОтсортированные компьютеры из файла по Id: ");
            foreach (var sortedComputer in sortedComputersById)
            {
                Console.WriteLine(sortedComputer.ToString());
            }
        }

        private static string GetRandomFileExtension()
        {
            string[] extensions = { ".txt", ".rtf", ".dat", ".inf" };
            Random random = new Random();
            int index = random.Next(0, extensions.Length);
            return extensions[index];
        }
    }
}