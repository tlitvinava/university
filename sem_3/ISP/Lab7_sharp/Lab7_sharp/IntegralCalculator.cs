using System;
using System.Diagnostics;
using System.Threading;

namespace IntegralLibrary
{
    public class IntegralCalculator
    {
        public event Action<double, long> CalculationCompleted;
        public event Action<int> ProgressChanged;

        private static readonly object _lock = new object();
        private static int _activeThreads = 0;
        private static readonly int _maxThreads = 3; //Change to 1

        Semaphore sem =new Semaphore(3, 3);

        public void Calculate()
        {
            sem.WaitOne();
            //lock (_lock)
            //{
            //    while (_activeThreads >= _maxThreads)
            //    {
            //        Monitor.Wait(_lock);
            //    }
            //    _activeThreads++;
            //}

            Stopwatch stopwatch = new Stopwatch();
            stopwatch.Start();

            double a = 0;
            double b = 1;
            double step = 0.0001;
            double result = 0;
            long totalSteps = (long)((b - a) / step);
            long reportInterval = totalSteps / 100;
            long lastReported = 0;

            for (long i = 0; i < totalSteps; i++)
            {
                double x = a + i * step;
                result += Math.Sin(x) * step;

                // Искусственная задержка
                for (int j = 0; j < 10000; j++)
                {
                    double temp = x * x;
                }

                // Событие прогресса
                if (i - lastReported >= reportInterval)
                {
                    int progress = (int)((double)i / totalSteps * 100);
                    ProgressChanged?.Invoke(progress);
                    lastReported = i;
                }
            }

            stopwatch.Stop();
            long ticks = stopwatch.ElapsedTicks;

            // Событие завершения
            CalculationCompleted?.Invoke(result, ticks);

            //lock (_lock)
            //{
            //    _activeThreads--;
            //    Monitor.PulseAll(_lock);
            //}

            sem.Release();
        }
    }
}
