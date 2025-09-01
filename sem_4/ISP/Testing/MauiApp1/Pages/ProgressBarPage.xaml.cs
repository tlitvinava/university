using MauiTestApp.ProgressBar;

namespace MauiTestApp.Pages;

public partial class ProgressBarPage : ContentPage
{
	readonly IIntegralCalculator _integralCalculator;
	CancellationTokenSource cancellationTokenSource = new();
	CalculationStatus CalculationStatus = CalculationStatus.None;

	public ProgressBarPage(IIntegralCalculator integralCalculator)
	{
		InitializeComponent();
		_integralCalculator = integralCalculator;
	}

	private async void ButtonStart_Clicked(object sender, EventArgs e)
	{
		if (CalculationStatus is CalculationStatus.InProgress)
			return;

		Title.Text = "Counting Integral";

		if (cancellationTokenSource.IsCancellationRequested)
		{
			cancellationTokenSource = new CancellationTokenSource();
		}

		var cancellationToken = cancellationTokenSource.Token;

		_integralCalculator.Progress += (double progress) =>
		{
			ProgressBar.Dispatcher.Dispatch(() =>
			{
				ProgressBar.Progress = progress;
				ProgressPercent.Text = System.Math.Round(progress * 100) + "%";
			});
		};

		CalculationStatus = CalculationStatus.InProgress;

			var result = await Task.Run(()=> _integralCalculator.CalculateAsync(cancellationToken));
		
		CalculationStatus = CalculationStatus.Finished;

		if (!cancellationToken.IsCancellationRequested)
			Title.Text = "Result: " + result;
	}

	private void ButtonCancel_Clicked(object sender, EventArgs e)
	{
		if (CalculationStatus is CalculationStatus.InProgress)
		{
			cancellationTokenSource.Cancel();
			Title.Text = "Canceled";
			CalculationStatus = CalculationStatus.Canceled;
		}
	}
}