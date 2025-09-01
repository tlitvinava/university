using Litvinava_353504_Lab5.Domain.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Litvinava_353504_Lab5.Domain.Interfaces
{
    public interface ISerializer
    {
        IEnumerable<Computer> DeSerializeByLINQ(string fileName);
        IEnumerable<Computer> DeSerializeXML(string fileName);
        IEnumerable<Computer> DeSerializeJSON(string fileName);
        void SerializeByLINQ(IEnumerable<Computer> computers, string fileName);
        void SerializeXML(IEnumerable<Computer> computers, string fileName);
        void SerializeJSON(IEnumerable<Computer> computers, string fileName);
    }
}
