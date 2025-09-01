using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Lab4.Models;

namespace Lab4.Abstractions
{
        internal interface IFileService
        {
            IEnumerable<Computer> ReadFile(string fileName);
            void SaveData(IEnumerable<Computer> data, string fileName);
        }
}
