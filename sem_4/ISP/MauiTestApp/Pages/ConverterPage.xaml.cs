using Calculator.Entites.Rates;
using MauiTestApp.Services;

namespace MauiTestApp.Pages;

public partial class ConverterPage : ContentPage
{
	private readonly IRateService _rateService;
	private IEnumerable<Rate>? Rates { get; set; }
	private readonly IList<string> RateAbbreviations =
	[
		"RUB", "EUR", "USD", "CHF", "CNY", "GBP"
	];

	public ConverterPage(IRateService rateService)
	{
		_rateService = rateService;
		InitializeComponent();
	}

	private async void DataPicker_DateSelected(object sender, DateChangedEventArgs e)
	{
		await FillCurrencies(DatePicker_name.Date);
	}

	private async Task FillCurrencies(DateTime dateTime)
	{
		Rates = await _rateService.GetRates(dateTime);
		CurrencyPicker_FROM.ItemsSource = Rates.ToList();
		CurrencyPicker_TO.ItemsSource = Rates.ToList();
		IList<Label> labels =
		[
		rub_OfficialRat,eur_OfficialRat,usd_OfficialRat,chf_OfficialRat,cny_OfficialRat,gbp_OfficialRat
		];

		if (Rates is not null)
		{
			for (int i = 0; i < 6; i++)
			{
				var rate = Rates.FirstOrDefault(p => p.Cur_Abbreviation == RateAbbreviations[i]);
				labels[i].Text = rate is null ? string.Empty : rate.Cur_OfficialRate.ToString();
			}
		}
	}

	private async void ConverterPage_Loaded(object sender, EventArgs e)
	{
		var dateTime = DateTime.Now.AddDays(-1);
		Rates = await _rateService.GetRates(dateTime);
		await FillCurrencies(dateTime);
		CurrencyPicker_FROM.SelectedItem = Rates.First();
		CurrencyPicker_TO.SelectedItem = Rates.First();
	}

	private void CountButtonFROMBYN_Clicked(object sender, EventArgs e)
	{
		if (int.TryParse(FromBYN.Text, out var num_from))
		{
			var course = (CurrencyPicker_TO.SelectedItem as Rate)!.Cur_OfficialRate;
			ResultCUR.Text = (num_from / course).ToString();
		}
	}

	private void CountButtonFROMCUR_Clicked(object sender, EventArgs e)
	{
		if (int.TryParse(FromCUR.Text, out var num_from))
		{
			var course = (CurrencyPicker_FROM.SelectedItem as Rate)!.Cur_OfficialRate;
			ResultBYN.Text = (course * num_from).ToString();
		}
	}
}