using Application.ArtistUseCases.Commands;
using Application.SongUseCases.Queries;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using System.Collections.ObjectModel;

namespace UI.ViewModels;

[QueryProperty(nameof(Artist), "Artist")]
public partial class EditArtistViewModel(IMediator mediator) : ObservableObject
{
	Artist artist;
	public Artist Artist
	{
		get => artist;
		set
		{
			artist = value;
			OnPropertyChanged();
		}
	}

	[ObservableProperty]
	public bool isSuccess = false;

	[RelayCommand]
	public async Task EditArtist() => await EditArtistAsync();

	private async Task EditArtistAsync()
	{
		await mediator.Send(new UpdateArtistCommand()
		{
			Artist = artist
		}, CancellationToken.None);

		IsSuccess = true;
	}
}
