using System.Globalization;

namespace UI.ValueConvertes;

internal class ImagePathConverter : IValueConverter
{
	public object? Convert(object? value, Type targetType, object? parameter, CultureInfo culture)
	{
		var basepath = Path.Combine(FileSystem.Current.AppDataDirectory, "Images");

		var path = "";

		if (value is int id && id > 0) path = Path.Combine(basepath, id.ToString() + ".png");

		if (File.Exists(path)) return path;
		else return Path.Combine(basepath, "default.png");
	}

	public object? ConvertBack(object? value, Type targetType, object? parameter, CultureInfo culture)
	{
		throw new NotImplementedException();
	}
}
