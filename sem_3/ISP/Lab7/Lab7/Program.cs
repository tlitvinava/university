using MathLibrary;
using System.Text;

namespace _253503_Studenichnik_Lab7
{
    internal class Program
    {
        static void Main()
        {
            Console.Write("Введите максимальное число потоков: ");
            int maxThreadCount = int.Parse(Console.ReadLine()!);

            Console.Write("Введите число одновременных потоков: ");
            int threadCount = int.Parse(Console.ReadLine()!);

            if (threadCount > maxThreadCount)
            {
                Console.ForegroundColor = ConsoleColor.Red;
                Console.WriteLine("\nЧисло одновременно работающих потоков больше чем максимальное.\n" +
                    $"Будет ограничено максимальным: {maxThreadCount}\n");
                Console.ForegroundColor = ConsoleColor.White;
            }

            var integralCalculator = new IntegralCalculator(threadCount);
            integralCalculator.Result += PrintResult;
            integralCalculator.Progress += PrintProgress;

            //var thread1 = new Thread(Calculate);
            //var thread2 = new Thread(Calculate);

            //thread1.Priority = ThreadPriority.Highest;
            //thread2.Priority = ThreadPriority.Lowest;
            //thread1.Start(integralCalculator);
            //thread2.Start(integralCalculator);

            Thread[] threads = new Thread[maxThreadCount];
            for (int i = 0; i < maxThreadCount; i++)
            {
                threads[i] = new Thread(Calculate);
                threads[i].Start(integralCalculator);
            }
        }

        private static void Calculate(object? calculator)
        {
            var integral = (IntegralCalculator?)calculator;
            if (integral is not null)
            {
                TimeSpan time = integral.CalculateIntegral();
                Console.ForegroundColor = ConsoleColor.Yellow;
                Console.WriteLine($"Время: {Math.Round(time.TotalSeconds, 3)}с\n");
                Console.ForegroundColor = ConsoleColor.White;
            }
        }

        private static void PrintProgress(double steps)
        {
            Semaphore semaphore = new Semaphore(1, 1);
            semaphore.WaitOne();
            var sb = new StringBuilder();
            sb.Append($"Поток {Environment.CurrentManagedThreadId}: [");

            for (int i = 0; i <= steps; i++)
            {
                sb.Append('=');
            }

            for (int i = 0; i < 100 - steps; i++)
            {
                sb.Append(' ');
            }

            sb.Append($"] {steps}%");
            Console.WriteLine(sb.ToString());
            semaphore.Release();
        }

        private static void PrintResult(double result)
        {
            Semaphore semaphore = new Semaphore(1, 1);
            semaphore.WaitOne();
                Console.ForegroundColor = ConsoleColor.Green;
                Console.WriteLine($"\nПоток: {Environment.CurrentManagedThreadId} Завершил работу с результатом: {result}");
                Console.ForegroundColor = ConsoleColor.White;
            semaphore.Release();
        }
    }
}