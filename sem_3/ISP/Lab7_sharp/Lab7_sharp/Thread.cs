using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lab7_sharp
{
    internal class MyThread
    {
            public int Count;
            string thrdName;
            public MyThread(string name)
            {
                Count = 0;
                thrdName = name;
            }
        
        public void Run()
        {
            Console.WriteLine(thrdName + " начат.");
            do
            {
                // Длительное вычисление
                Thread.Sleep(500); // ждать 500 мс
                Console.WriteLine($"В потоке {thrdName}, Count = {Count}");
                Count++;
            }
            while (Count < 10);
            Console.WriteLine(thrdName + " завершен.");
        }


    }
}


