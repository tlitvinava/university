using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lab3.Entities
{
    internal class Ticket
    {
        public Tarif Tarif { get; set; }
        public DateTime DateTime { get; set; }

        public Ticket()
        {
            Tarif = new Tarif();
        }

        public override string ToString()
        {
            return $"Тариф: {Tarif}, Дата: {$"{DateTime.ToShortDateString()} {DateTime.ToShortTimeString()}"}";
        }
    }
}
