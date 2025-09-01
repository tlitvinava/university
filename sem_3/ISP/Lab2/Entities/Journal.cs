using Lab2.Collections;

namespace Lab2.Entities;



public class Journal
{
	private readonly MyCustomCollection<string> logs;

	public Journal()
	{
		logs = new MyCustomCollection<string>();
	}

	public void Log(string log)
	{
		logs.Add(log);
	}

	public string GetLogs()
	{
		string res = "";
		foreach (var item in logs)
		{
			res += item + "\n";
		}
		return res;
	}
}
