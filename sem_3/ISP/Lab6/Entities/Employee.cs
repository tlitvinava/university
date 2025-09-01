using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _253503_Studenichnik_Lab6.Entities
{
    public class Employee
    {
        public int Id { get; set; }
        public bool IsDeleted { get; set; }
        public string Name { get; set; } = string.Empty;

        public Employee()
        { }

        public override string ToString()
        {
            return $"ID: {Id}, Name: {Name}, Is deleted: {IsDeleted}";
        }
        public static Employee GetRandomEmployee()
        {
            Employee employee = new Employee();
            Random random = new Random();

            employee.Id = random.Next();
            employee.IsDeleted = random.Next() % 2 == 0;
            employee.Name = employee.Name.GetRandomName();

            return employee;
        }
    }
}
