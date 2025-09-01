using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Text.Json;
using _353504_Litvinava_Lab6.Entities;
using _353504_Litvinava_Lab6.Abstractions;

namespace _353504_Litvinava_Lab6
{
    public static class Program
    {
        public const string PATH = "C:\\Users\\tlitv\\!Labs\\353504_Litvinava_Lab6\\353504_Litvinava_Lab6\\Files";

        static void Main(string[] args)
        {
            var employees = new List<Employee>();
            for (int i = 0; i < 6; i++)
            {
                employees.Add(Employee.GetRandomEmployee());
            }

            // Загрузка сборки
            Assembly assembly = Assembly.LoadFrom("C:\\Users\\tlitv\\!Labs\\353504_Litvinava_Lab6\\ClassLibrary\\bin\\Debug\\net8.0\\ClassLibrary.dll");

            // Вывод всех типов из сборки для отладки
            foreach (var t in assembly.GetTypes())
            {
                Console.WriteLine(t.FullName);
            }

            // Получение типа FileService<T>
            Type? type = assembly.GetType("FileService`1");

            if (type is null)
            {
                throw new ArgumentNullException(nameof(type), "Тип не найден. Проверьте имя типа и наличие сборки.");
            }

            // Определение конкретного типа для Employee
            Type employeeServiceType = type.MakeGenericType(typeof(Employee));

            // Получение методов
            MethodInfo? saveData = employeeServiceType.GetMethod("SaveData", new Type[] { typeof(IEnumerable<Employee>), typeof(string) });
            MethodInfo? readFile = employeeServiceType.GetMethod("ReadFile", new Type[] { typeof(string) });
            object? fileService = Activator.CreateInstance(employeeServiceType);

            // Сохранение данных
            saveData?.Invoke(fileService, new object[] { employees, "Employee.json" });

            // Чтение данных
            var employeesJSON = (IEnumerable<Employee>?)readFile?.Invoke(fileService, new object[] { "Employee.json" });

            Console.WriteLine("Employees from file:");
            if (employeesJSON is not null)
            {
                foreach (var employee in employeesJSON)
                {
                    Console.WriteLine(employee);
                }
            }
        }

        public static string GetRandomName(this string str)
        {
            Random random = new Random();

            var NAMES = new string[]
            {
                "Nikita",
                "Alexey",
                "Alexandr",
                "Ivan",
                "Evgeniy",
                "Andrew"
            };

            return NAMES[random.Next(NAMES.Length)];
        }


    }


    // Пример реализации FileService<T>
    public class FileService<T> : IFileService<T> where T : class
    {
        private string PATH;

        public IEnumerable<T> ReadFile(string fileName)
        {
            using (var stream = new FileStream(PATH + fileName, FileMode.Open, FileAccess.Read))
            {
                var list = JsonSerializer.Deserialize<IEnumerable<T>>(stream);
                return list ?? Enumerable.Empty<T>();
            }
        }

        public void SaveData(IEnumerable<T> data, string fileName)
        {
            using (var stream = new FileStream(PATH + fileName, FileMode.OpenOrCreate | FileMode.Truncate, FileAccess.Write))
            {
                JsonSerializer.Serialize(stream, data);
            }
        }
    }
}