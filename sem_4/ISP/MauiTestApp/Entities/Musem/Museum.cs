using SQLite;

namespace MauiTestApp.Entities
{
	[Table("Museums")]
	public class Museum
	{
		[PrimaryKey, AutoIncrement, Indexed]
		public int Id { get; set; }
		public string Name { get; set; } = null!;
		public string Address { get; set; } = null!;
		public int HallNumber { get; set; }

		public override string ToString() => 
			"Id: " + Id +
			" Name: " + Name +
			" Address: " + Address +
			" Hall: " + HallNumber + ' ';
	}
}
