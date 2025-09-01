using SQLite;

namespace MauiTestApp.Entities
{
	[Table("Exhibits")]
	public class Exhibit
	{
		[PrimaryKey, AutoIncrement, Indexed]
		public int Id { get; set; }
		public string Name { get; set; } = null!;
		public decimal Cost { get; set; }
		public DateTime Date { get; set; }

		[Indexed]
		public int MuseumId {  get; set; }


		public override string ToString() =>
			"Id: " + Id +
			" Name: " + Name +
			" Cost: " + Cost +
			" Date: " + Date.ToShortDateString();
	}
}
