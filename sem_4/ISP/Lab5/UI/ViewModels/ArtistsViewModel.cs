using Application.ArtistUseCases.Queries;
using Application.SongUseCases.Queries;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using Domain.Entities;
using MediatR;
using System.Collections.ObjectModel;
using UI.Pages;

namespace UI.ViewModels;

public partial class ArtistsViewModel(IMediator mediator) : ObservableObject
{
	public ObservableCollection<Artist> Artists { get; set; } = [];
	public ObservableCollection<Song> Songs { get; set; } = [];

	[ObservableProperty]
	Artist selectedArtist = null!;

	[RelayCommand]
	async Task ShowDetails(Song song) => await GotoDetailsPage(song);

	private async Task GotoDetailsPage(Song song)
	{
		var parameters = new Dictionary<string, object>()
		{
		{ "Song", song }
		};
		await Shell.Current.GoToAsync(nameof(SongDetails), parameters);
	}

	[RelayCommand]
	public async Task CreateNewGroup() => await Shell.Current.GoToAsync(nameof(NewArtist));

	[RelayCommand]
	public async Task EditGroup() => await EditArtist();

	private async Task EditArtist()
	{
		if (SelectedArtist is null)
			return;

		var parameters = new Dictionary<string, object>()
		{
		{ "Artist", SelectedArtist }
		};

		await Shell.Current.GoToAsync(nameof(Pages.EditArtist), parameters);
	}

	[RelayCommand]
	public async Task CreateMember() => await Shell.Current.GoToAsync(nameof(NewSong));

	[RelayCommand]
	public async Task UpdateGroupList() => await GetArtists();

	[RelayCommand]
	public async Task UpdateMemberList() => await GetSongs();

	public async Task GetSongs()
	{
		if (SelectedArtist is null)
		{
			Songs.Clear();
			return;
		}

		var songs = await mediator.Send(new GetAllSongsQuery()
		{ ArtistId = SelectedArtist.Id });

		await MainThread.InvokeOnMainThreadAsync(() =>
		{
			Songs.Clear();
			foreach (var song in songs)
				Songs.Add(song);
		});
	}

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
}
