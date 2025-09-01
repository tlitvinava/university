namespace Domain.Entities;

public class Song(string name, string description, TimeSpan duration) : Entity
{
	public string Name { get; set; } = name;
	public string Description { get; set; } = description;
	public TimeSpan Duration { get; set; } = duration;
	public int PlaceInCharts { get; private set; }
	public int ArtistId { get; set; }

	public override string ToString()
	{
		return Name + " " + Duration.ToString() + " " + Description;
	}

	public void AddToArtist(int artistId)
	{
		if (artistId <= 0) return;

		ArtistId = artistId;
	}

	public void ChangePlaceInCharts(int placeInCharts)
	{
		if (placeInCharts <= 0) return;

		PlaceInCharts = placeInCharts;
	}
}
