using _253503_Studenichnik_Lab6.Abstractions;
using _253503_Studenichnik_Lab6.Entities;
using _253503_Studenichnik_Lab6;
using System.Text.Json;


public class FileService<T> : IFileService<T> where T : class
{
    public IEnumerable<T> ReadFile(string fileName)
    {
        using (var stream = new FileStream(Program.PATH + fileName,
            FileMode.Open, FileAccess.Read))
        {
            var list = JsonSerializer.Deserialize<IEnumerable<T>>(stream);
            if (list is not null)
            {
                return list;
            }
            else return Enumerable.Empty<T>();
        }
    }

    public void SaveData(IEnumerable<T> data, string fileName)
    {
        using (var stream = new FileStream(Program.PATH + fileName, FileMode.OpenOrCreate
            | FileMode.Truncate, FileAccess.Write))
        {
            JsonSerializer.Serialize(stream, data);
        }
    }
}
