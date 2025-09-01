using Lab3.Collections;
using Lab3.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lab3.Interfaces
{
    internal interface IRailway
    {
        public void AddTarif(string name, Tarif tarif);
        public void AddPassenger(Passenger passenger);
        public void BuyTicket(Passenger passenger, Ticket ticket);
        public decimal GetTotalCost(Passenger passenger);
        public IEnumerable<Passenger> GetPassengers(string direction);
        public IEnumerable<Ticket> GetAllTickets(Passenger passenger);
        public IEnumerable<string> GetAllTarifsNameSortedByCost();
        public decimal GetTotalTicketsCost();
        public string GetPassengerNameMaxCost();
        public int GetAmountOfPassengersBiggerThanCost(decimal cost);
    }
}
