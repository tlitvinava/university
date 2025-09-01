using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lab3.Entities
{
    internal class AddingEventArgs : EventArgs
    {
        public string Message { get; }

        public AddingEventArgs()
        {
            Message = string.Empty;
        }

        public AddingEventArgs(string message)
        {
            Message = message;
        }
    }
}
