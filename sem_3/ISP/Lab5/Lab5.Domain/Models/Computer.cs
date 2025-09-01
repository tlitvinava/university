using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _253503_Studenichnik_Lab5.Domain.Models
{
    public class Computer : IEquatable<Computer>
    {
        public int Id { get; set; }
        public Winchester Winchester { get; set; }
        public string Issuer { get; set; }
        public Computer() { }
        public Computer(int id, Winchester winchester, string issuer)
        {
            Id = id;
            Winchester = winchester;
            Issuer = issuer;
        }
        public override string ToString()
        {
            return $"Id: {Id}, Winchester: {Winchester}, Issuer: {Issuer}";
        }

        public bool Equals(Computer? other)
        {
            if (other is null)
                return false;

            return Id == other.Id
                && Winchester.Equals(other.Winchester)
                && Issuer == other.Issuer;
        }
    }
}
