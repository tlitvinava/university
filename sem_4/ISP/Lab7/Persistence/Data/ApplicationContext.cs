using Microsoft.EntityFrameworkCore;

namespace Persistence.Data;

public class ApplicationContext : DbContext
{
	public DbSet<Song> Songs { get; set; }
	public DbSet<Artist> Artists { get; set; }
	public ApplicationContext(DbContextOptions<ApplicationContext> options) : base(options)
	{
		Database.EnsureCreated();
	}
}
