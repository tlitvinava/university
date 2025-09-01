using Application.ArtistUseCases.Queries;
using Application.SongUseCases.Commands;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using System.Collections.ObjectModel;

namespace UI.ViewModels;

public partial class NewSongViewModel(IMediator mediator) : ObservableObject
{
	[ObservableProperty]
	public Song song = new("", "", TimeSpan.Zero);

	public ObservableCollection<Artist> Artists { get; set; } = [];

	[ObservableProperty]
	Artist selectedArtist = null!;

	[ObservableProperty]
	public bool isSuccess = false;

	[RelayCommand]
	public async Task UpdateGroupList() => await GetArtists();

	public async Task GetArtists()
	{
		var artists = await mediator.Send(new GetAllArtistsQuery());

		await MainThread.InvokeOnMainThreadAsync(() =>
		{
			Artists.Clear();
			foreach (var artist in artists)
				Artists.Add(artist);
		});
	}

	[RelayCommand]
	public async Task UpdateMemberList() => await Task.Run(() =>
	Song.AddToArtist(SelectedArtist.Id));

	[RelayCommand]
	public async Task CreateSong() => await CreateSongAsync();

	private async Task CreateSongAsync()
	{
		await mediator.Send(new CreateSongCommand()
		{
			ArtistId = SelectedArtist.Id,
			Description = Song.Description,
			Duration = Song.Duration,
			Name = Song.Name,
		}, CancellationToken.None);

		IsSuccess = true;
	}
}
