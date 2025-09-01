using MediatR;

namespace Application.SongUseCases.Queries;

public record GetAllSongsQuery : IRequest<IReadOnlyList<Song>>
{
	public required int ArtistId { get; init; }
}

class GetAllSongsQueryHandler(IUnitOfWork unitOfWork) : IRequestHandler<GetAllSongsQuery, IReadOnlyList<Song>>
{
	public async Task<IReadOnlyList<Song>> Handle(GetAllSongsQuery request, CancellationToken cancellationToken) => 
		await unitOfWork.SongRepository.ListAsync(x => x.ArtistId == request.ArtistId, cancellationToken: cancellationToken);
}