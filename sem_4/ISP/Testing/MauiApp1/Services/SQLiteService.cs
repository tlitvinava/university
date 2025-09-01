using MauiTestApp.Entities;
using SQLite;

namespace MauiTestApp.Services
{
	public class SQLiteService : IDbService
	{
		private readonly string connectionString = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "museums.db");

		public IEnumerable<Museum> GetAllMuseums()
		{
			using var connection = new SQLiteConnection(connectionString);

			var result = connection.Table<Museum>();

			return result.ToList();
		}

		public IEnumerable<Exhibit> GetMuseumExhibit(int museumId)
		{
			using var connection = new SQLiteConnection(connectionString);

			var result = connection.Table<Exhibit>().Where(x => x.MuseumId == museumId).ToList();

			return result;
		}

		public void Init()
		{
			using var connection = new SQLiteConnection(connectionString);

			connection.DropTable<Museum>();
			connection.DropTable<Exhibit>();

			connection.CreateTable<Museum>();
			connection.CreateTable<Exhibit>();

			var museums = new List<Museum>()
			{
				new()
				{
					Address = "street",
					HallNumber = 1,
					Name = "museum"
				},
				new()
				{
					Address = "second street",
					HallNumber = 10,
					Name = "second museum"
				}
			};

			foreach (var museum in museums)
			{
				connection.Insert(museum);

				var random = new Random();

				for (int i = 0; i < 5; i++)
				{
					var exhibit = new Exhibit()
					{
						MuseumId = museum.Id,
						Cost = random.Next(),
						Date = new DateTime(DateTime.UtcNow.Ticks - random.Next()),
						Name = random.GetRandomName()
					};

					connection.Insert(exhibit);
				}
			}
		}
	}
}

