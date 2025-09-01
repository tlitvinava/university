namespace MauiTestApp.ProgressBar
{
	public class IntegralCalculator : IIntegralCalculator
	{
		readonly int totalSteps = (int)System.Math.Ceiling(1 / step);
		const double step = 0.005D;

		public event IIntegralCalculator.IntegralHandler? Progress;

		public async Task<double> CalculateAsync(CancellationToken cancellationToken) =>
			await Task.Run(async () =>
			{
				var result = 0.0D;

				for (double i = 0, steps = 1; i <= 1; i += step, steps++)
				{
					if (cancellationToken.IsCancellationRequested)
					{
						return result;
					}

					result += step * System.Math.Sin(i);

					await Task.Delay(1);

					double? progress = steps * 100 / totalSteps;
					if (progress - (int)progress is null)
						Progress?.Invoke(progress.Value / 100.0D);
				}

				return result;
			}, cancellationToken);
	}
}
