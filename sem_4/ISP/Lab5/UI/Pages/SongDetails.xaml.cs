using MediatR;
using UI.ViewModels;

namespace UI.Pages;

public partial class SongDetails : ContentPage
{
	private readonly SongDetailsViewModel viewModel;
	public SongDetails(IMediator mediator)
	{
		viewModel = new SongDetailsViewModel(mediator);
		BindingContext = viewModel;
		InitializeComponent();
	}
}