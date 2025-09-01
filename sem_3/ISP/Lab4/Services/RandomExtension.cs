using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;

namespace Lab4.Services
{
    internal static class RandomExtension
    {
        public static string GetRandomString(this Random random, int length)
        {
            StringBuilder sb = new StringBuilder();

            for (int i = 0; i < length; i++)
            {
                char symbol = Convert.ToChar(random.Next(65, 90));
                if (random.Next(0, 2) == 1)
                    symbol = char.ToLower(symbol);
                sb.Append(symbol);
            }

            return sb.ToString();
        }
    }
}
