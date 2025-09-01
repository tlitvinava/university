using Lab3.Collections;
using Lab3.Entities;
using System.Security.Cryptography.X509Certificates;

namespace Lab3
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Railway railway = new Railway();
            Journal journal = new Journal();

            railway.Notify += (sender, eventArgs) => journal.AddNote(((AddingEventArgs)eventArgs).Message);

            Console.Write("Выберите направление: \n NE \n NW \n SE \n SW\n:");
            string direction = Console.ReadLine()!.ToUpper();

            var listOfPassengers = (List<Passenger>)railway.GetPassengers(direction);

            if (listOfPassengers.Count != 0)
            {
                Console.WriteLine("Все пасажиры купившие билеты на это направление: ");
                try
                {
                    for (int i = 0; i <= listOfPassengers.Count; i++)
                    {
                        Console.WriteLine($"{i + 1}. {listOfPassengers[i]}");
                    }
                }
                catch (IndexOutOfRangeException e)
                {
                    Console.WriteLine(e.Message);
                }
            }

            Console.WriteLine("Введите название тарифа: ");
            string name = Console.ReadLine()!;

            Console.WriteLine($"Текущий тариф на это направление: {railway.Tarifs[name]}");
            Console.Write($"Введите новый тариф на направление {direction}: ");
            decimal cost = decimal.Parse(Console.ReadLine()!);

            railway.AddTarif(name, new Tarif() { Cost = cost, Direction = direction });

            Console.WriteLine("Введите паспортные данные пассажира: ");
            Console.Write("Введите имя: ");
            name = Console.ReadLine()!;
            Console.Write("Введите номер паспорта: ");
            string passport = Console.ReadLine()!;

            var passenger = new Passenger() { Name = name, PassportId = passport };
            railway.AddPassenger(passenger);

            try
            {
                railway.Tarifs.Remove("Minsk-Minsk");
            }
            catch (NotFoundException e)
            {
                Console.WriteLine(e.Message);
            }

            Console.WriteLine("Введите номер билета, который хотите купить: ");

            foreach (var tarif in railway.Tarifs)
            {
                Console.WriteLine(tarif);
            }

            int ticketId = int.Parse(Console.ReadLine()!);

            railway.BuyTicket(passenger, new Ticket() { Tarif = railway.Tarifs["Minsk-Belarus"], DateTime = DateTime.Now });

            Console.WriteLine("Все ваши билеты:");

            var tickets = railway.GetAllTickets(passenger);

            foreach (var ticket in tickets)
            {
                Console.WriteLine($"{ticket}");
            }

            Console.WriteLine($"Сумма: {railway.GetTotalCost(passenger)}");

            Console.WriteLine("Имена всех пассажиров по стоимости: ");
            var collection = railway.GetAllTarifsNameSortedByCost();
            foreach (var item in collection)
            {
                Console.WriteLine(item);
            }

            Console.WriteLine($"Общая сумма всех покупок: {railway.GetTotalTicketsCost()}");

            Console.WriteLine($"Имя пассажира, потратившего больше всех: {railway.GetPassengerNameMaxCost()}");

            Console.Write($"Введите стоимость билетов: ");
            decimal maxCost = Convert.ToDecimal(Console.ReadLine()!);
            Console.WriteLine($"Кол-во пассажиров купившее больше билетов: {railway.GetAmountOfPassengersBiggerThanCost(maxCost)}");

            Console.Write("Выберите направление: \n NE \n NW \n SE \n SW\n:");
            direction = Console.ReadLine()!.ToUpper();

            Console.WriteLine($"{passenger.GetSumsByDirection(direction)}");
        }

    }
}