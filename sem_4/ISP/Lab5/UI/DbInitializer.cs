using Domain.Abstractions;
using System;

namespace UI;

public static class DbInitializer
{
	public static async Task Initialize(IServiceProvider services)
	{
		var unitOfWork = services.GetRequiredService<IUnitOfWork>();

		await unitOfWork.DeleteDataBaseAsync();
		await unitOfWork.CreateDataBaseAsync();

		for (int i = 0; i < 20; i++)
		{
			var name = GetRandomName();
			var artist = new Artist(name, DateTime.UtcNow.AddYears(-i), GetRandomGenre());
			await unitOfWork.ArtistRepository.AddAsync(artist);
		}

		await unitOfWork.SaveAllAsync();

		foreach(var artist in await unitOfWork.ArtistRepository.ListAllAsync())
		{
			var maxJ = Random.Shared.Next(10, 15);
			for (int j = 0; j < maxJ; j++)
			{
				var songName = GetRandomSongName();
				var song = new Song(songName, $"This song, named '{songName}' is about life", TimeSpan.FromSeconds(Random.Shared.Next(120, 500)))
				{
					ArtistId = artist.Id,
				};
				song.ChangePlaceInCharts(Random.Shared.Next(1, 101));

				await unitOfWork.SongRepository.AddAsync(song);
			}
		}

		await unitOfWork.SaveAllAsync();
	}

	private static string GetRandomSongName()
	{
		string[] popularSongs =
		[
			"Shape of You",
			"Despacito",
			"Blinding Lights",
			"Dance Monkey",
			"Uptown Funk",
			"Closer",
			"Happy",
			"Something Just Like This",
			"Hello",
			"Senorita",
			"Bad Guy",
			"Cheap Thrills",
			"Thinking Out Loud",
			"Believer",
			"Love Yourself",
			"Sorry",
			"Waka Waka (This Time for Africa)",
			"Rockabye",
			"Rolling in the Deep",
			"Old Town Road",
			"The Hills",
			"7 Rings",
			"Counting Stars",
			"Thunder",
			"Havana",
			"Let Her Go",
			"All of Me",
			"Circles",
			"Stressed Out",
			"Rude",
			"I Don't Wanna Live Forever",
			"Take Me to Church",
			"Can't Stop the Feeling!",
			"Photograph",
			"One Dance",
			"Chandelier",
			"Wrecking Ball",
			"Hymn for the Weekend",
			"Meant to Be",
			"What Do You Mean?",
			"Faded",
			"Riptide",
			"Lean On",
			"Radioactive",
			"Shake It Off",
			"Sugar",
			"Attention",
			"Happier",
			"Let It Go",
			"I Like It",
			"Fancy",
			"Girls Like You",
			"Stay with Me",
			"Love Me like You Do",
			"Stay",
			"Señorita",
			"Sugar",
			"Work",
			"Roar",
			"Panda",
			"The Box",
			"This Is What You Came For",
			"Chained to the Rhythm",
			"Starboy",
			"Just the Way You Are",
			"Dusk Till Dawn",
			"Wolves",
			"The Scientist",
			"Animals",
			"Sicko Mode",
			"Watermelon Sugar",
			"Beautiful People",
			"God's Plan",
			"Never Be the Same",
			"Bang Bang",
			"All About That Bass",
			"Attention",
			"Perfect",
			"Finesse",
			"Side to Side",
			"Born This Way",
			"I Feel It Coming",
			"Little Talks",
			"Lovely",
			"Umbrella",
			"Some Nights",
			"Monster",
			"Adore You",
			"Can't Feel My Face",
			"Rise",
			"Firework",
			"God Is a Woman",
			"Problem",
			"The Lazy Song",
			"Lose You to Love Me",
			"E.T.",
			"Break Free",
			"Dynamite",
			"Rude",
			"Wrecking Ball"
		];

		return popularSongs[Random.Shared.Next(0, popularSongs.Length)];
	}
	private static string GetRandomName()
	{
		string[] names = ["Клифф Ричард",
			"Дайана Росс",
			"Scorpions",
			"Шарль Азнавур",
			"Бинг Кросби",
			"Глория Эстефан",
			"Deep Purple",
			"Iron Maiden",
			"Том Джонс",
			"The Jackson 5",
			"Дайон Уорик",
			"Spice Girls",
			"Лучано Паваротти",
			"Долли Партон",
			"Оззи Осборн",
			"Андреа Бочелли"];

		return names[Random.Shared.Next(0, names.Length)];
	}
	private static string GetRandomGenre()
	{
		string[] genres = ["Metal", "Rock", "Pop", "Hip-hop", "Rap"];

		return genres[Random.Shared.Next(0, genres.Length)];
	}
}
