using MediatR;
using UI.ViewModels;

namespace UI.Pages;

public partial class Artists : ContentPage
{
	private readonly ArtistsViewModel viewModel;

	public Artists(IMediator mediator)
	{
		viewModel = new ArtistsViewModel(mediator);
		BindingContext = viewModel;

		InitializeComponent();
	}
}