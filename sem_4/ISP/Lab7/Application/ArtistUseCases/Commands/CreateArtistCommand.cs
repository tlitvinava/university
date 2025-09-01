using MediatR;

namespace Application.ArtistUseCases.Commands;

public record CreateArtistCommand : IRequest
{
	public string Name { get; init; } = null!;
	public string Genre { get; init; } = null!;
	public DateTime BirthDay { get; init; }
}

public class CreateArtistCommandHandler(IUnitOfWork unitOfWork) : IRequestHandler<CreateArtistCommand>
{
	public async Task Handle(CreateArtistCommand request, CancellationToken cancellationToken)
	{
		await unitOfWork.ArtistRepository.AddAsync(
		new Artist(request.Name, request.BirthDay, request.Genre),
		cancellationToken);

		await unitOfWork.SaveAllAsync();
	}
}
