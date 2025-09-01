using UI.Pages;
using UI.ViewModels;

namespace UI;

public static class DependencyInjection
{
	public static IServiceCollection RegisterPages(this IServiceCollection services)
	{
		services.AddTransient<Artists>();
		services.AddTransient<NewArtist>();
		services.AddTransient<EditArtist>();
		services.AddTransient<SongDetails>();
		services.AddTransient<NewSong>();

		return services;
	}
	public static IServiceCollection RegisterViewModels(this IServiceCollection services)
	{
		services.AddTransient<ArtistsViewModel>();
		services.AddTransient<SongDetailsViewModel>();

		return services;
	}
}
