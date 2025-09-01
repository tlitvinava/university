using UI.ViewModels;

namespace UI.Pages;

public partial class NewSong : ContentPage
{
	private readonly NewSongViewModel viewModel;
	public NewSong(IMediator mediator)
	{
		viewModel = new NewSongViewModel(mediator);
		BindingContext = viewModel;
		InitializeComponent();
	}
}