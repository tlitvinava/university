using Lab3.Collections;
using Lab3.Entities;
using System.Net.Sockets;
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

            var listOfPassengers = railway.GetPassengers(direction).ToList();

            if (listOfPassengers.Count != 0)
            {
                Console.WriteLine("Все пассажиры, купившие билеты на это направление: ");
                try
                {
                    for (int i = 0; i < listOfPassengers.Count; i++) // Изменено на '<'
                    {
                        Console.WriteLine($"{i + 1}. {listOfPassengers[i]}");
                    }
                }
                catch (IndexOutOfRangeException e)
                {
                    Console.WriteLine(e.Message);
                }
            }

            // Запрос тарифов
            /* DisplayTariffs(railway);

             Console.WriteLine("Введите название тарифа: ");
             // Метод для отображения всех тарифов
             static void DisplayTariffs(Railway railway)
             {
                 Console.WriteLine("Все доступные тарифы:");
                 foreach (var tarif in railway.Tarifs)
                 {
                     Console.WriteLine($"Направление: {tarif.Value.Direction}, Название: {tarif.Key}, Стоимость: {tarif.Value.Cost}");
                 }
             }
             string name = Console.ReadLine()!;*/


            // Ввод названия тарифа
            Console.Write("Введите название тарифа: ");
            Console.WriteLine("Все доступные тарифы:");
            foreach (var tarif in railway.Tarifs)
            {
                Console.WriteLine($"Направление: {tarif.Value.Direction}, Название: {tarif.Key}, Стоимость: {tarif.Value.Cost}");
            }
            string tarifName = Console.ReadLine()!;

            // Проверка существования тарифа
            if (railway.Tarifs.ContainsKey(tarifName))
            {
                Console.WriteLine("Тариф с таким именем уже существует. Пожалуйста, введите другое имя или обновите существующий тариф.");
            }
            else
            {
                // Ввод стоимости тарифа
                Console.Write($"Введите стоимость тарифа: ");
                if (decimal.TryParse(Console.ReadLine(), out decimal cost))
                {
                    railway.AddTarif(tarifName, new Tarif() { Cost = cost, Direction = direction });
                    Console.WriteLine("Новый тариф добавлен.");
                }
                else
                {
                    Console.WriteLine("Некорректный ввод стоимости. Пожалуйста, введите число.");
                }
            }

            Console.WriteLine("Введите паспортные данные пассажира: ");
            Console.Write("Введите имя: ");
            tarifName = Console.ReadLine()!;
            Console.Write("Введите номер паспорта: ");
            string passport = Console.ReadLine()!;

            var passenger = new Passenger() { Name = tarifName, PassportId = passport };
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

            Console.WriteLine($"Общая сумма всех покупок: {railway.GetTotalTicketsCost()}");

            Console.WriteLine($"Имя пассажира, потратившего больше всех: {railway.GetPassengerNameMaxCost()}");

            Console.Write($"Введите стоимость билетов: ");
            decimal maxCost = Convert.ToDecimal(Console.ReadLine()!);
            Console.WriteLine($"Кол-во пассажиров купившее больше билетов: {railway.GetAmountOfPassengersBiggerThanCost(maxCost)}");

            //Console.Write("Выберите направление: \n NE \n NW \n SE \n SW\n:");
            //direction = Console.ReadLine()!.ToUpper();

            //Console.WriteLine($"{passenger.GetSumsByDirection(direction)}");

            foreach (var directions in railway.Directions)
            {
                var sums = passenger.GetSumsByDirection(directions);
                if (sums.Any())
                {
                    Console.WriteLine($"Направление: {directions}, Сумма: {sums[directions]}");
                }
                else
                {
                    Console.WriteLine($"Направление: {directions}, Нет билетов.");
                }
            }
        }
    }
}

