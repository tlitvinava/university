using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _253503_Studenichnik_Lab6.Abstractions
{
    public interface IFileService<T> where T : class
    {
        IEnumerable<T> ReadFile(string fileName);
        void SaveData(IEnumerable<T> data, string fileName);
    }
}
