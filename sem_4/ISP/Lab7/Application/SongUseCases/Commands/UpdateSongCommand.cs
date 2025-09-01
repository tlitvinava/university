using MediatR;

namespace Application.SongUseCases.Commands;

public record UpdateSongCommand : IRequest
{
	public required Song Song { get; init; }
}

public class UpdateSongCommandHandler(IUnitOfWork unitOfWork) : IRequestHandler<UpdateSongCommand>
{
	public async Task Handle(UpdateSongCommand request, CancellationToken cancellationToken)
	{
		await unitOfWork.SongRepository.UpdateAsync(
			request.Song,
			cancellationToken);

		await unitOfWork.SaveAllAsync();
	}
}

