using System.Globalization;

namespace UI.ValueConvertes;

internal class PlaceInChartsToColorConverter : IValueConverter
{
	public object? Convert(object? value, Type targetType, object? parameter, CultureInfo culture)
	{
		if ((int?)value <= 10)
			return Colors.Red;

		return Colors.Black;
	}

	public object? ConvertBack(object? value, Type targetType, object? parameter, CultureInfo culture)
	{
		throw new NotImplementedException();
	}
}
