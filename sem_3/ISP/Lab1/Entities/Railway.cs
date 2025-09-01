using _253503_Studenichnik_Lab3.Collections;
using _253503_Studenichnik_Lab3.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _253503_Studenichnik_Lab3.Entities
{
    internal class Railway : IRailway
    {
        private Dictionary<string, Tarif> tarifs;
        public IDictionary<string, Tarif> Tarifs { get => tarifs; }


        private List<Passenger> passengers;
        public IEnumerable<Passenger> Passengers { get => passengers; }


        public delegate void MyHandler(object sender, EventArgs eventArgs);

        public event MyHandler? Notify;

        public Railway()
        {
            tarifs = new()
            {
                { "Minsk-Belarus", new Tarif(){Direction = "NW", Cost = 10.65M } },
                { "Lida-Gomel", new Tarif(){Direction = "NE", Cost = 12.13M } },
                { "St.Petersburg-Moscow", new Tarif(){Direction = "SE", Cost = 18.92M } },
                { "Tokyo-New York", new Tarif(){Direction = "SW", Cost = 14.88M } },
            };

            passengers = new List<Passenger>()
            {
                new Passenger()
                {
                    Name = "Nikita",
                    PassportId = "MP124515",
                    Tickets = new List<Ticket>()
                    {
                        new Ticket()
                        {
                            DateTime = DateTime.Parse("06.04.2019 15:01"),
                            Tarif = tarifs["Minsk-Belarus"]
                        }
                    }
                },
                new Passenger()
                {
                    Name = "Svetlana",
                    PassportId = "MP1827293",
                    Tickets = new List<Ticket>()
                    {
                        new Ticket()
                        {
                            DateTime = DateTime.Parse("19.02.2021 18:25"),
                            Tarif = tarifs["Lida-Gomel"]
                        }
                    }
                }
            };
        }

        public void AddPassenger(Passenger passenger)
        {
            passengers.Add(passenger);
            Notify?.Invoke(this, new AddingEventArgs($"Added new passenger: {passenger}"));
        }

        public void AddTarif(string name, Tarif tarif)
        {
            if (tarifs.Contains(tarif))
            {
                tarifs.Find(tarif).Cost = tarif.Cost;
            }
            else
            {
                tarifs.Add(name, tarif);
            }
            Notify?.Invoke(this, new AddingEventArgs($"Added Tarif: {tarif}"));
        }

        public void BuyTicket(Passenger passenger, Ticket ticket)
        {
            passenger = passengers.Find(passenger);

            if (!passenger.Tickets.Contains(ticket))
            {
                passenger.Tickets.Add(ticket);
                Notify?.Invoke(this, new AddingEventArgs($"Passenger: {passenger} bought ticket: {ticket}"));
            }
        }

        public IEnumerable<Passenger> GetPassengers(string direction)
        {
            return passengers.GetAllPassengersViaDirecton(direction);
        }

        public decimal GetTotalCost(Passenger passenger)
        {
            return passengers.GetTotalCostForPassenger(passenger);
        }

        public IEnumerable<Ticket> GetAllTickets(Passenger passenger)
        {
            return passengers.First(p => p.Name == passenger.Name).Tickets;
        }

        public IEnumerable<string> GetAllTarifsNameSortedByCost()
        {
            return tarifs.GetAllTarifsNameSortedByCost();
        }

        public decimal GetTotalTicketsCost()
        {
            decimal totalTicketCost = 0;

            foreach (var passenger in passengers)
            {
                totalTicketCost += passenger.Tickets.GetTotalTicketCost();
            }

            return totalTicketCost;
        }

        public string GetPassengerNameMaxCost()
        {
            return passengers.GetPassengerMaxCost().Name;
        }

        public int GetAmountOfPassengersBiggerThanCost(decimal cost)
        {
            return passengers.GetAmountOfPassengersBiggerThanCost(cost);
        }
    }
}
