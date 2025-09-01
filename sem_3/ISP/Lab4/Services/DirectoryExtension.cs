using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lab4.Services
{
    internal class DirectoryExtension
    {
        public static void RecreateDirectory(string path)
        {
            Directory.Delete(path, true);
            Directory.CreateDirectory(path);
        }
    }
}
