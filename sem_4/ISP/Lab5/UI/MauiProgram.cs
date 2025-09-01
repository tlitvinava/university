using CommunityToolkit.Maui;
using Microsoft.Extensions.Logging;
using Application;
using Persistence;
using Microsoft.Extensions.Configuration;
using System.Reflection;
using Microsoft.EntityFrameworkCore;
using System;
using Persistence.Data;

namespace UI;

public static class MauiProgram
{
	public static MauiApp CreateMauiApp()
	{
		string settingsStream = "UI.appsettings.json";

		var builder = MauiApp.CreateBuilder();
		var a = Assembly.GetExecutingAssembly();
		using var stream = a.GetManifestResourceStream(settingsStream);
		builder.Configuration.AddJsonStream(stream!);
		builder
			.UseMauiApp<App>()
			.UseMauiCommunityToolkit()
			.ConfigureFonts(fonts =>
			{
				fonts.AddFont("OpenSans-Regular.ttf", "OpenSansRegular");
				fonts.AddFont("OpenSans-Semibold.ttf", "OpenSansSemibold");
			});

		var connStr = builder.Configuration
			.GetConnectionString("SqliteConnection");
		var dataDirectory = FileSystem.Current.AppDataDirectory + "/";
		connStr = string.Format(connStr!, dataDirectory);

		var options = new DbContextOptionsBuilder<ApplicationContext>()
		 .UseSqlite(connStr).Options;



		builder.Services
			.AddApplication()
			.AddPersistence(options)
			.RegisterPages()
			.RegisterViewModels();

		DbInitializer
			.Initialize(builder.Services.BuildServiceProvider())
			.Wait();

#if DEBUG
		builder.Logging.AddDebug();
#endif

		return builder.Build();
	}
}
