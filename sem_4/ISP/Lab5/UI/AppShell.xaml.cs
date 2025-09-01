using UI.Pages;

namespace UI;

public partial class AppShell : Shell
{
	public AppShell()
	{
		Routing.RegisterRoute(nameof(SongDetails), typeof(SongDetails));
		Routing.RegisterRoute(nameof(NewArtist), typeof(NewArtist));
		Routing.RegisterRoute(nameof(EditArtist), typeof(EditArtist));
		Routing.RegisterRoute(nameof(NewSong), typeof(NewSong));
		InitializeComponent();
	}
}
