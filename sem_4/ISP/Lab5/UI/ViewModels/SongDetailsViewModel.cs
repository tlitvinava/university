using Application.ArtistUseCases.Queries;
using Application.SongUseCases.Commands;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using MediatR;
using System.Collections.ObjectModel;

namespace UI.ViewModels;
[QueryProperty(nameof(Song), "Song")]
internal partial class SongDetailsViewModel(IMediator mediator) : ObservableObject
{
	Song song;
	public Song Song
	{
		get => song;
		set
		{
			song = value;
			OnPropertyChanged();
		}
	}

	public ObservableCollection<Artist> Artists { get; set; } = [];

	[ObservableProperty]
	Artist selectedArtist = null!;

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

	[ObservableProperty]
	bool isNotEditing = true;

	[ObservableProperty]
	bool isEditing = false;

	[ObservableProperty]
	bool isSuccess = false;

	[RelayCommand]
	public void SetEditing()
	{
		IsEditing = !IsEditing;
		IsNotEditing = !IsNotEditing;
	}

	[RelayCommand]
	public async Task UpdateSong() => await UpdateSongAsync();

	[RelayCommand]
	public async Task UpdateMemberList() => await Task.Run(() =>
	Song.AddToArtist(SelectedArtist.Id));

	private async Task UpdateSongAsync()
	{
		await mediator.Send(new UpdateSongCommand()
		{
			Song = Song
		}, CancellationToken.None);

		IsSuccess = true;
	}
}
