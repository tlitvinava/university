using Calculator.Entites.Rates;

namespace MauiTestApp.Services;

public interface IRateService
{
	Task<IEnumerable<Rate>> GetRates(DateTime date);
}
