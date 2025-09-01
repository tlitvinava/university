using Application.ArtistUseCases.Commands;
using UI.ViewModels;

namespace UI.Pages;

public partial class NewArtist : ContentPage
{
	private readonly IMediator _mediator;
	public NewArtist(IMediator mediator)
	{
		_mediator = mediator;
		InitializeComponent();
	}

	private void Button_Clicked(object sender, EventArgs e)
	{
		_mediator.Send(new CreateArtistCommand()
		{
			BirthDay = ArtistBirthDay.Date,
			Genre = ArtistGenre.Text,
			Name = ArtistName.Text,
		}).Wait();

		SuccessMessage.IsVisible = true;
	}
}