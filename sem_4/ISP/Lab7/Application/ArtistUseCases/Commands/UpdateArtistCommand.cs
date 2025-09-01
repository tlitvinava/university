using MediatR;

namespace Application.ArtistUseCases.Commands;

public record UpdateArtistCommand : IRequest
{
	public required Artist Artist { get; init; } = null!;
}

public class UpdateArtistCommandHandler(IUnitOfWork unitOfWork) : IRequestHandler<UpdateArtistCommand>
{
	public async Task Handle(UpdateArtistCommand request, CancellationToken cancellationToken)
	{
		await unitOfWork.ArtistRepository.UpdateAsync(
			request.Artist,
			cancellationToken);

		await unitOfWork.SaveAllAsync();
	}
}
