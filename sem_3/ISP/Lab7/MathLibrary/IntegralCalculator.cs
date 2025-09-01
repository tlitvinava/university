using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MathLibrary
{
    public class IntegralCalculator
    {
        public delegate void IntegralHandler(double objects);
        public event IntegralHandler? Result;
        public event IntegralHandler? Progress;
        private readonly Semaphore semaphore;

        public IntegralCalculator(int threadNumber)
        {
            semaphore = new Semaphore(threadNumber, threadNumber);
        }
        public TimeSpan CalculateIntegral()
        {
            semaphore.WaitOne();

            var timer = new Stopwatch();
            timer.Start();

            double result = 0;
            const double STEP = 0.00000001;

            int totalSteps = (int)Math.Ceiling(1 / STEP);

            for (double x = 0, steps = 1; x <= 1; x += STEP, steps++)
            {
                result += STEP * Math.Sin(x);

                for (int i = 0; i < 1; i++)
                {
                    i++;
                    i--;
                }

                var progress = steps * 100 / totalSteps;
                if (progress % 1 == 0)
                    Progress?.Invoke(progress);
            }

            Result?.Invoke(result);

            semaphore.Release();

            return timer.Elapsed;
        }
    }
}
