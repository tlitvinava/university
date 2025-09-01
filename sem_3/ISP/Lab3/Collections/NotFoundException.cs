using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lab3.Collections
{
    internal class NotFoundException : Exception
    {
        public override string Message { get; }

        public NotFoundException()
        {
            Message = string.Empty;
        }

        public NotFoundException(string message)
        {
            Message = message;
        }
    }
}
