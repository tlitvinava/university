using Lab3.Collections;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lab3.Entities
{
    internal class Passenger
    {
        public string Name { get; set; }
        public string PassportId { get; set; }
        public List<Ticket> Tickets { get; set; }

        public Passenger()
        {
            Name = string.Empty;
            PassportId = string.Empty;
            Tickets = new List<Ticket>();
        }

        public override string ToString()
        {
            return $"Name: {Name}, Passport: {PassportId}";
        }
        private bool Equals(Passenger? passenger)
        {
            if (passenger == null)
                return false;
            return Name == passenger.Name && passenger.PassportId == PassportId;
        }

        public override bool Equals(object? obj)
        {
            return Equals(obj as Passenger);
        }
        public override int GetHashCode()
        {
            return Name.GetHashCode();
        }
    }
}