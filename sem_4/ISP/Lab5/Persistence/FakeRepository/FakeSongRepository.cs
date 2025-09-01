using Microsoft.EntityFrameworkCore;
using System.Linq.Expressions;

namespace Persistence.FakeRepository;

public class FakeSongRepository : IRepository<Song>
{
	private readonly List<Song> _songs =
	[
		new("Master of puppets", "This song is about addiction", TimeSpan.Parse("08:32")){ ArtistId = 1 },
		new("God that failed", "This song is about believing in god", TimeSpan.Parse("04:33")){ ArtistId = 1 },
		new("Bad romance", "This song is about love",  TimeSpan.Parse("04:12" )){ ArtistId = 2 },
		new("Mockingbird", "This song is about kids and parents", TimeSpan.Parse("05:28")){ ArtistId = 3 },
		new("Sochi", "This song is about shashlichok and konyachok", TimeSpan.Parse("03:54")){ ArtistId = 4 }
	];

	public FakeSongRepository()
	{
		foreach (var song in _songs)
		{
			song.ChangePlaceInCharts(Random.Shared.Next(1, 10));
		}
	}

	public Task AddAsync(Song entity, CancellationToken cancellationToken = default)
	{
		throw new NotImplementedException();
	}

	public Task DeleteAsync(Song entity, CancellationToken cancellationToken = default)
	{
		throw new NotImplementedException();
	}

	public Task<Song?> FirstOrDefaultAsync(Expression<Func<Song, bool>> filter, CancellationToken cancellationToken = default)
	{
		throw new NotImplementedException();
	}

	public Task<Song> GetByIdAsync(int id, CancellationToken cancellationToken = default, params Expression<Func<Song, object>>[]? includesProperties)
	{
		throw new NotImplementedException();
	}

	public Task<IReadOnlyList<Song>> ListAllAsync(CancellationToken cancellationToken = default)
	{
		throw new NotImplementedException();
	}

	public async Task<IReadOnlyList<Song>> ListAsync(Expression<Func<Song, bool>> filter, CancellationToken cancellationToken = default, params Expression<Func<Song, object>>[]? includesProperties)
		=> await Task.Run(() => _songs.Where(filter.Compile()).ToList(), cancellationToken);

	public Task UpdateAsync(Song entity, CancellationToken cancellationToken = default)
	{
		throw new NotImplementedException();
	}
}
