namespace Domain.Entities;

public class Artist(string name, DateTime birthDay, string genre) : Entity
{
	public string Name { get; set; } = name;
	public DateTime BirthDay { get; set; } = birthDay;
	public string Genre { get; set; } = genre;

	public override string ToString()
	{
		return Name + " (" + Genre + ")";
	}
}
