using System.Linq.Expressions;

namespace Persistence.FakeRepository;

public class FakeArtistRepository : IRepository<Artist>
{
	private List<Artist> _artists =
		[
		new Artist("James Hetfield", DateTime.Parse("10.03.1995"), "Thrash Metal"){Id = 1},
		new Artist("Lady Gaga", DateTime.Parse("05.01.1978"), "Pop"){Id = 2},
		new Artist("Eminem", DateTime.Parse("23.06.2002"), "Rap"){Id = 3},
		new Artist("Sergey Trofimov", DateTime.Parse("19.09.1982"), "Shanson"){Id = 4},
		];

	public Task AddAsync(Artist entity, CancellationToken cancellationToken = default)
	{
		throw new NotImplementedException();
	}

	public Task DeleteAsync(Artist entity, CancellationToken cancellationToken = default)
	{
		throw new NotImplementedException();
	}

	public Task<Artist?> FirstOrDefaultAsync(Expression<Func<Artist, bool>> filter, CancellationToken cancellationToken = default)
	{
		throw new NotImplementedException();
	}

	public Task<Artist> GetByIdAsync(int id, CancellationToken cancellationToken = default, params Expression<Func<Artist, object>>[]? includesProperties)
	{
		throw new NotImplementedException();
	}

	public async Task<IReadOnlyList<Artist>> ListAllAsync(CancellationToken cancellationToken = default) =>
		await Task.FromResult(_artists.AsReadOnly());

	public Task<IReadOnlyList<Artist>> ListAsync(Expression<Func<Artist, bool>> filter, CancellationToken cancellationToken = default, params Expression<Func<Artist, object>>[]? includesProperties)
	{
		throw new NotImplementedException();
	}

	public Task UpdateAsync(Artist entity, CancellationToken cancellationToken = default)
	{
		throw new NotImplementedException();
	}
}
