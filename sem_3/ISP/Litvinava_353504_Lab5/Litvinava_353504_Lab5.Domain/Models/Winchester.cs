using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Litvinava_353504_Lab5.Domain.Models
{
    public class Winchester : IEquatable<Winchester>
    {
        public int Id { get; set; }
        public string Model { get; set; } = null!;
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

        public override bool Equals(object? obj)
        {
            return Equals(obj as Winchester);
        }

        public override int GetHashCode()
        {
            return base.GetHashCode();
        }
    }
}
