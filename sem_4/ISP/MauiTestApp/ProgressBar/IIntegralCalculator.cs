namespace MauiTestApp.ProgressBar
{
	public interface IIntegralCalculator
	{
		Task<double> CalculateAsync(CancellationToken cancellationToken);
		public delegate void IntegralHandler(double objects);
		public event IntegralHandler? Progress;
	}
}
