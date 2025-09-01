using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lab3.Entities
{
    internal class Journal
    {
        public List<string> strings { get; set; } = new List<string>();
        public void AddNote(string message)
        {
            strings.Add(message);
        }
    }
}
