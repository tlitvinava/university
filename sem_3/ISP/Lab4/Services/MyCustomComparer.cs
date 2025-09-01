using Lab4.Models;
using Lab4.Abstractions;
using System.Collections.Generic;

namespace Lab4.Services
{
    internal class MyCustomComparer : IComparer<Computer>
    {
        public int Compare(Computer? x, Computer? y)
        {
            if (x == null || y == null)
                throw new ArgumentNullException($"x or y is null");

            return string.Compare(x.Name, y.Name, StringComparison.Ordinal);
        }
    }
}
