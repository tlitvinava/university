namespace Persistence.FakeRepository;

public class FakeUnitOfWork : IUnitOfWork
{
	private readonly Lazy<IRepository<Song>> _songRepository = new(() => new FakeSongRepository());
	private readonly Lazy<IRepository<Artist>> _artistRepository = new(() => new FakeArtistRepository());

	public IRepository<Song> SongRepository => _songRepository.Value;
	public IRepository<Artist> ArtistRepository => _artistRepository.Value;

	public Task CreateDataBaseAsync()
	{
		throw new NotImplementedException();
	}

	public Task DeleteDataBaseAsync()
	{
		throw new NotImplementedException();
	}

	public Task SaveAllAsync()
	{
		throw new NotImplementedException();
	}
}
