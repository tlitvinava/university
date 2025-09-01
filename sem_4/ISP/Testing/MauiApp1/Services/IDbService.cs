using MauiTestApp.Entities;

namespace MauiTestApp.Services
{
	public interface IDbService
	{
		IEnumerable<Museum> GetAllMuseums();
		IEnumerable<Exhibit> GetMuseumExhibit(int museumId);
		void Init();
	}
}
