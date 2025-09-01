namespace Persistence.Repository;

public class EfUnitOfWork(ApplicationContext context) : IUnitOfWork
{
	private readonly Lazy<IRepository<Song>> _songRepository = new(() => new EfRepository<Song>(context));
	private readonly Lazy<IRepository<Artist>> _artistRepository = new(() => new EfRepository<Artist>(context));

	public IRepository<Song> SongRepository => _songRepository.Value;
	public IRepository<Artist> ArtistRepository => _artistRepository.Value;

	public async Task CreateDataBaseAsync() =>
		await context.Database.EnsureCreatedAsync();
	public async Task DeleteDataBaseAsync() =>
		await context.Database.EnsureDeletedAsync();
	public async Task SaveAllAsync() =>
		await context.SaveChangesAsync();
}

