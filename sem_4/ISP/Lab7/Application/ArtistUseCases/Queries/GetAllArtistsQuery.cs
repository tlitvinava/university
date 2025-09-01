using MediatR;

namespace Application.ArtistUseCases.Queries;

public record GetAllArtistsQuery : IRequest<IReadOnlyList<Artist>>
{ }

class GetAllArtistsQueryHandler(IUnitOfWork unitOfWork) : IRequestHandler<GetAllArtistsQuery, IReadOnlyList<Artist>>
{
	public Task<IReadOnlyList<Artist>> Handle(GetAllArtistsQuery request, CancellationToken cancellationToken) => 
		unitOfWork.ArtistRepository.ListAllAsync(cancellationToken);
}
