using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lab3.Entities
{
    internal class Tarif
    {
        public string Direction { get; set; } = string.Empty;
        public decimal Cost { get; set; }


        private bool Equals(Tarif? tarif)
        {
            if (tarif == null)
                return false;
            return Direction == tarif.Direction;
        }
        public override bool Equals(object? obj)
        {
            return Equals(obj as Tarif);
        }

        public override string ToString()
        {
            return $"Направление: {Direction}, Стоимость: {Cost}";
        }

        public override int GetHashCode()
        {
            return Direction.GetHashCode();
        }
    }
}
