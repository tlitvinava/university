using ClassLibrary.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClassLibrary.Extensions
{
    public static class EnumerableExtensions
    {
        public static IEnumerable<Computer> GetComputers(this IList<Computer> computers, int count)
        {
            for(int i = 0; i < count; i++)
            {
                computers.Add(new Computer());
            }

            return computers;
        }
    }
}
