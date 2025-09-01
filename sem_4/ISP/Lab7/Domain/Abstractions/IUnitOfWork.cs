namespace Domain.Abstractions;

public interface IUnitOfWork
{
	IRepository<Song> SongRepository { get; }
	IRepository<Artist> ArtistRepository { get; }
	public Task SaveAllAsync();
	public Task DeleteDataBaseAsync();
	public Task CreateDataBaseAsync();
}
