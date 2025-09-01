using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _353504_Litvinava_Lab6.Abstractions
{
    public interface IFileService<T> where T : class
    {
        IEnumerable<T> ReadFile(string fileName);
        void SaveData(IEnumerable<T> data, string fileName);
    }
}
