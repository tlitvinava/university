using _253503_Studenichnik_Lab6.Entities;
using System.Reflection;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;
using System.Text;

namespace _253503_Studenichnik_Lab6
{
    public static class Program
    {
        public const string PATH = "C:\\Users\\Nikita\\source\\repos\\C# labs\\Sem 3\\253503_Studenichnik_Lab6\\Files\\";
        static void Main(string[] args)
        {
            var employees = new List<Employee>();
            for (int i = 0; i < 6; i++)
            {
                employees.Add(Employee.GetRandomEmployee());
            }

            Assembly assembly = Assembly.LoadFrom("C:\\Users\\Nikita\\source\\repos\\C# labs\\Sem 3\\ClassLibrary\\bin\\Debug\\net6.0\\ClassLibrary.dll");
            Type? type = assembly.GetType("_353504_Litvinava_Lab6.FileService`1");

            if (type is null)
            {
                throw new ArgumentNullException(nameof(type));
            }

            MethodInfo? SaveData = type.GetMethod("SaveData", new Type[] { typeof(IEnumerable<Employee>), typeof(string) });
            MethodInfo? ReadFile = type.GetMethod("ReadFile", new Type[] { typeof(string) });
            object? FileService = Activator.CreateInstance(type);

            SaveData?.Invoke(FileService, new object[] { employees, "Employees.json" });
            var employeesJSON = (IEnumerable<Employee>?)ReadFile?.Invoke(FileService, new object[] { "Employees.json" });

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
}