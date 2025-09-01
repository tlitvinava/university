using System;
using System.Threading;
using IntegralLibrary;

namespace IntegralApp
{
    class Program
    {
        static void Main(string[] args)
        {
            // Запуск двух экземпляров с разными приоритетами
            Thread threadHigh = new Thread(CalculateIntegral);
            Thread threadLow = new Thread(CalculateIntegral);

            threadHigh.Name = "Поток High";
            threadLow.Name = "Поток Low";
            threadHigh.Priority = ThreadPriority.Highest;
            threadLow.Priority = ThreadPriority.Lowest;

            threadHigh.Start();
            threadLow.Start();

            threadHigh.Join();
            threadLow.Join();

            // Запуск 5 потоков для проверки ограничения количества выполняемых потоков
            for (int i = 1; i <= 5; i++)
            {
                Thread thread = new Thread(CalculateIntegral);
                thread.Name = $"Поток {i}";
                thread.Start();
            }
        }

        static void CalculateIntegral()
        {
            IntegralCalculator calculator = new IntegralCalculator();

            calculator.ProgressChanged += progress =>
            {
                Console.WriteLine($"{Thread.CurrentThread.Name}: [{new string('=', progress / 10)}{new string(' ', 10 - progress / 10)}] {progress}%");
            };

            calculator.CalculationCompleted += (result, ticks) =>
            {
                Console.WriteLine($"{Thread.CurrentThread.Name}: Завершен с результатом: {result}, затраченное время: {ticks} тиков");
            };

            calculator.Calculate();
        }
    }
}
