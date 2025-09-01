using Application.ArtistUseCases.Commands;
using CommunityToolkit.Mvvm.ComponentModel;
using UI.ViewModels;

namespace UI.Pages;

public partial class EditArtist : ContentPage
{
	private readonly EditArtistViewModel viewModel;
	public EditArtist(IMediator mediator)
	{
		viewModel = new EditArtistViewModel(mediator);
		BindingContext = viewModel;
		InitializeComponent();
	}
}