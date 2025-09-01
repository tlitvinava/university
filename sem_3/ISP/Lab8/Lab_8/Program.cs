//using ClassLibrary.Extensions;
//using ClassLibrary.Models;
//using ClassLibrary.Services;

//namespace Lab_8
//{
//    internal class Program
//    {
//        static async Task Main(string[] args)
//        {
//            // Initialize starting data
//            var streamService = new StreamService();
//            var memoryStream = new MemoryStream();
//            var progress = new Progress<string>();
//            var computers = new List<Computer>().GetComputers(100);

//            progress.ProgressChanged += Progress_ProgressChanged;

//            Console.WriteLine($"Job has started in thread: {Environment.CurrentManagedThreadId}");

//            // Run writing and copying tasks using Task.Run
//            var writing = Task.Run(() => streamService.WriteToStreamAsync(memoryStream, computers, progress));
//            Thread.Sleep(20);
//            var copying = Task.Run(() => streamService.CopyFromStreamAsync(memoryStream, "Computers.txt", progress));

//            // Wait for both tasks to complete
//            await Task.WhenAll(writing, copying);

//            Console.WriteLine($"Statistic: {await streamService.GetStaticticAsync("Computers.txt", x => x.Contains('A'))}");
//        }

//        private static void Progress_ProgressChanged(object? sender, string e)
//        {
//            Console.WriteLine(e);
//        }
//    }
//}

using ClassLibrary.Extensions;
using ClassLibrary.Models;
using ClassLibrary.Services;

namespace Lab_8
{
    internal class Program
    {
        static async Task Main(string[] args)
        {
            // Initialize starting data
            var streamService = new StreamService();
            var memoryStream = new MemoryStream();
            var progress = new Progress<string>();
            var computers = new List<Computer>().GetComputers(100);

            progress.ProgressChanged += Progress_ProgressChanged;

            Console.WriteLine($"Job has started in thread: {Environment.CurrentManagedThreadId}");

            var writing = Task.Run(() => streamService.WriteToStreamAsync(memoryStream, computers, progress));
            //await writing;

            memoryStream.Position = 0;

            var copying = Task.Run(() => streamService.CopyFromStreamAsync(memoryStream, "Computers.txt", progress));
            //await copying;


            Task.WaitAll(writing, copying);

            Console.WriteLine($"Statistic: {await streamService.GetStaticticAsync("Computers.txt", x => x.Contains('A'))}");
        }

        private static void Progress_ProgressChanged(object? sender, string e)
        {
            Console.WriteLine(e);
        }
    }
}