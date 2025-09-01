using MauiTestApp.Math;
using MauiTestApp.Pages;
using MauiTestApp.ProgressBar;
using MauiTestApp.Services;
using Microsoft.Extensions.Logging;

namespace MauiTestApp
{
	public static class MauiProgram
	{
		public static MauiApp CreateMauiApp()
		{
			var builder = MauiApp.CreateBuilder();
			builder
				.UseMauiApp<App>()
				.ConfigureFonts(fonts =>
				{
					fonts.AddFont("OpenSans-Regular.ttf", "OpenSansRegular");
					fonts.AddFont("OpenSans-Semibold.ttf", "OpenSansSemibold");
				});

			builder.Services.AddTransient<IIntegralCalculator, IntegralCalculator>();
			builder.Services.AddTransient<IDbService, SQLiteService>();
			builder.Services.AddTransient<IMathCalculator, MathCalculator>();
			builder.Services.AddHttpClient<IRateService, RateService>(opt => opt.BaseAddress
															= new Uri("https://www.nbrb.by/api/exrates/rates"));
			builder.Services.AddSingleton<CalculatorPage>();
			builder.Services.AddSingleton<ProgressBarPage>();
			builder.Services.AddSingleton<DatabasePage>();
			builder.Services.AddSingleton<ConverterPage>();
			

#if DEBUG
			builder.Logging.AddDebug();
#endif

			return builder.Build();
		}
	}
}
