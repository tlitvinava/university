using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Runtime.Serialization.Formatters.Binary;
using System.Text;
using System.Threading.Tasks;

namespace Lab4.Models
{
        internal class Computer
        {
            public string Name { get; private set; } = string.Empty;
            public int Id { get; private set; }
            public bool IsAdmin { get; private set; }

            public Computer() { }

            public Computer(string name, int id, bool isAdmin)
            {
                Name = name;
                Id = id;
                IsAdmin = isAdmin;
            }

            public override string ToString()
            {
                return $"Id: {Id}, Имя компьютера: {Name}, Администратор? {IsAdmin}";
            }
        }
}
