using MediatR;

namespace Application.SongUseCases.Commands;

public record CreateSongCommand : IRequest
{
	public required int ArtistId { get; init; }
	public string Name { get; init; } = null!;
	public string Description { get; init; } = null!;
	public TimeSpan Duration { get; init; }
}

public class CreateSongCommandHandler(IUnitOfWork unitOfWork) : IRequestHandler<CreateSongCommand>
{
	public async Task Handle(CreateSongCommand request, CancellationToken cancellationToken)
	{
		await unitOfWork.SongRepository.AddAsync(
			new Song(request.Name, request.Description, request.Duration)
			{
				ArtistId = request.ArtistId
			},
			cancellationToken);

		await unitOfWork.SaveAllAsync();
	}
}
