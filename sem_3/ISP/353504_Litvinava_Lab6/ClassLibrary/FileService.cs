using _353504_Litvinava_Lab6;
using _353504_Litvinava_Lab6.Abstractions;
using System.Text.Json;

public class FileService<T> : IFileService<T> where T : class
{
    public IEnumerable<T> ReadFile(string fileName)
    {
        using (var stream = new FileStream(Path.Combine(Program.PATH, fileName),
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
        var fullPath = Path.Combine(Program.PATH, fileName);
        using (var stream = new FileStream(fullPath, FileMode.OpenOrCreate
            | FileMode.Truncate, FileAccess.Write))
        {
            JsonSerializer.Serialize(stream, data);
        }
    }
}
