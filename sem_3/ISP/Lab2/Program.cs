using Lab2.Collections;
using Lab2.Entities;
using Lab2.Exceptions;

internal class Program
{
	private static void Main(string[] args)
	{
		Bank bank = new("Bank");
		Journal journal = new();
		bank.AddClientEvent += journal.Log;
		Client oleg = new("oleg");
		bank.AddClient(oleg);
		oleg.AddDepositEvent += journal.Log;

		oleg.AddDeposit(new Deposit(1000, 10));
		oleg.AddDeposit(new Deposit(100, 1));

		Console.WriteLine("Logs are");
		Console.WriteLine(journal.GetLogs());

		oleg.AddDepositEvent += (message) => Console.WriteLine($"Console log: {message}");

		oleg.AddDeposit(new Deposit(100, 1));

		MyCustomCollection<int> collection = new()
		{
			1,
			2,
			3,
			4
		};

		Console.WriteLine("Foreach items");
		foreach (var item in collection)
		{
			Console.Write(item);
		}
		Console.WriteLine();

		try
		{
			collection.Remove(10);
		}
		catch (ObjectNotFoundException ex)
		{
			Console.WriteLine(ex.Message);
		}

		try
		{
			int v = collection[10];
		}
		catch (IndexOutOfRangeException ex)
		{
			Console.WriteLine(ex.Message);
		}
	}
}