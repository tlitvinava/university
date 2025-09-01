using ClassLibrary.Extensions;
using System.Text;
using System;
using ClassLibrary.Models;
using System.Text.RegularExpressions;

namespace ClassLibrary.Services
{
	public class StreamService
	{
		Semaphore semaphore = new Semaphore(1, 1);
		public async Task WriteToStreamAsync(Stream stream, IEnumerable<Computer> data, IProgress<string> progress)
		{
			semaphore.WaitOne();

			//stream = (MemoryStream)stream;

			progress.ReportWritingBegan();

			int percent = 0;
			foreach (var item in data)
			{
				var buffer = Encoding.Default.GetBytes($"{item} ");
				await stream.WriteAsync(buffer);
				percent++;
				progress.ReportProgress("Writing", percent);
				await Task.Delay(30);
			}

			progress.ReportWritingEnded();
			semaphore.Release();
		}

		public async Task CopyFromStreamAsync(Stream stream, string fileName, IProgress<string> progress)
		{
			semaphore.WaitOne();
			progress.ReportCopyingBegan();
			var memoryStream = (MemoryStream)stream;
			//using var fileWriter = new FileStream(Path.Combine(Directory.GetCurrentDirectory(), fileName), FileMode.OpenOrCreate, FileAccess.Write);


			await File.WriteAllBytesAsync(Path.Combine(Directory.GetCurrentDirectory(),fileName), memoryStream.ToArray());
			for (int percent = 0; percent < 200; percent++)
			{
				percent++;
				progress.ReportProgress("Copying", percent);
			}

			progress.ReportCopyingEnded();
			semaphore.Release();
		}

		public async Task<int> GetStaticticAsync(string fileName, Func<string, bool> filter)
		{
			var regex = new Regex("Brand: (\\w+)");
			var text = await File.ReadAllTextAsync(Path.Combine(Directory.GetCurrentDirectory(),fileName));
			var brands = regex.Matches(text);
			var stat = brands.Count(b => filter.Invoke(b.Value));

			return stat;
		}
	}
}