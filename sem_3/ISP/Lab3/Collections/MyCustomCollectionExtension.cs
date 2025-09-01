using Lab3.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;

namespace Lab3.Collections
{
    static internal class MyCustomCollectionExtension
    {
        public static bool Contains(this IDictionary<string, Tarif> dictionary, Tarif tarif)
        {
            var value = dictionary.FirstOrDefault(kvp => kvp.Value == tarif);
            return value.Value != null;
        }

        public static Tarif Find(this IDictionary<string, Tarif> dictionary, Tarif tarif)
        {
            return dictionary.First(kvp => kvp.Value == tarif).Value;
        }

        public static Passenger Find(this IEnumerable<Passenger> passengers, Passenger passenger)
        {
            return passengers.First(p => p == passenger);
        }

        public static IEnumerable<Passenger> GetAllPassengersViaDirecton(this IEnumerable<Passenger> passengers, string direction)
        {
            return passengers.Where(passenger => passenger.Tickets != null)
                .Where(passenger => passenger.Tickets
                .Any(ticket => ticket.Tarif.Direction == direction));
        }

        public static decimal GetTotalCostForPassenger(this IList<Passenger> passengers, Passenger passenger)
        {
            passenger = passengers.First(p => p.Name == passenger.Name);

            decimal totalCost = 0;

            foreach (var ticket in passenger.Tickets)
            {
                totalCost += ticket.Tarif.Cost;
            }

            return totalCost;
        }

        public static IEnumerable<string> GetAllTarifsNameSortedByCost(this IDictionary<string, Tarif> dictionary)
        {
            return dictionary.OrderByDescending(kvp => kvp.Value.Cost).Select(kvp => kvp.Key);
        }

        public static decimal GetTotalTicketCost(this IEnumerable<Ticket> tickets)
        {
            decimal totalTicketCost = 0;

            foreach (var ticket in tickets)
            {
                totalTicketCost += tickets.Sum(t => t.Tarif.Cost);
            }

            return totalTicketCost;
        }

        public static Passenger GetPassengerMaxCost(this IEnumerable<Passenger> passengers)
        {
            return passengers.OrderByDescending(p => p.Tickets.GetTotalTicketCost()).First();
        }

        public static int GetAmountOfPassengersBiggerThanCost(this IEnumerable<Passenger> passengers, decimal cost)
        {
            return passengers.Aggregate(0, (accumulator, passenger) =>
            {
                decimal totalCost = passenger.Tickets.GetTotalTicketCost();
                return accumulator + (totalCost > cost ? 1 : 0);
            });
        }

        public static IDictionary<string, decimal> GetSumsByDirection(this Passenger passenger, string direcion)
        {
            return passenger.Tickets
                .Where(t => t.Tarif.Direction == direcion)
                .GroupBy(ticket => ticket.Tarif.Direction, ticket => ticket.Tarif.Cost)
                .ToDictionary(group => group.Key, group => group.Sum());
        }
    }
}
