using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Persistence.Repository;

namespace Persistence;

public static class DependencyInjection
{
	public static IServiceCollection AddPersistence(this IServiceCollection services)
	{
		services.AddSingleton<IUnitOfWork, EfUnitOfWork>();
		return services;
	}
	public static IServiceCollection AddPersistence(this IServiceCollection services, DbContextOptions options)
	{
		services.AddPersistence()
		//.AddDbContext<ApplicationContext>();
		.AddSingleton(new ApplicationContext((DbContextOptions<ApplicationContext>)options));
		return services;
	}

}
