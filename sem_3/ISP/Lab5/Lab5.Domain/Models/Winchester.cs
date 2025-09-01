using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _253503_Studenichnik_Lab5.Domain.Models
{
    public class Winchester : IEquatable<Winchester>
    {
        public int Id { get; set; }
        public string Model { get; set; }
        public Winchester() { }
        public Winchester(int id, string model)
        {
            Id = id;
            Model = model;
        }

        public override string ToString()
        {
            return $"Id: {Id}, Model: {Model}";
        }

        public bool Equals(Winchester? other)
        {
            if (other is null)
                return false;

            return Id == other.Id && Model == other.Model;
        }
    }
}
