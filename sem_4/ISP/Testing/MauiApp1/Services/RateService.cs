using Calculator.Entites.Rates;
using System.Text.Json;

namespace MauiTestApp.Services;

public class RateService(HttpClient httpClient) : IRateService
{
	public async Task<IEnumerable<Rate>> GetRates(DateTime date)
	{

		Uri.TryCreate(httpClient.BaseAddress, $"?onDate={date:yyyy-MM-dd}&Periodicity=0", out var uri);
		using var request = new HttpRequestMessage(HttpMethod.Get, uri);
		//request.Content=new FormUrlEncodedContent()
		try
		{
			var response = await httpClient.SendAsync(request);

			response.EnsureSuccessStatusCode();

			var responseBody = await response.Content.ReadAsStringAsync();
			return JsonSerializer.Deserialize<IEnumerable<Rate>>(responseBody) ?? throw new HttpRequestException();
		}
		catch (HttpRequestException)
		{
			return [];
		}
	}
}
