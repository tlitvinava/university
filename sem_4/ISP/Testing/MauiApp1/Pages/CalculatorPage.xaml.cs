using MauiTestApp.Math;

namespace MauiTestApp.Pages;

public partial class CalculatorPage : ContentPage
{
	readonly IMathCalculator _mathCalculator;

	public CalculatorPage(IMathCalculator mathCalculator)
	{
		InitializeComponent();

		BindingContext = this;
		_mathCalculator = mathCalculator;
		Label1.Text="Hi";
	

	}

	public string CurrentEntry
	{
		get { return currentEntry; }
		set
		{
			if (currentEntry != value)
			{
				currentEntry = value;

				if (currentEntry.Length > 30)
				{
					currentEntry = currentEntry.Remove(30);
				}

				OnPropertyChanged(nameof(CurrentEntry));
			}
		}
	}

	string currentEntry = "0";
	decimal FirstNumber;
	decimal SecondNumber;
	Operation LastOperation = Math.Operation.None;

	private void DigitButton_Clicked(object sender, EventArgs e)
	{
		var button = (Button)sender;

		if (CurrentEntry is "0" || CurrentEntry.Any(char.IsLetter) || CurrentEntry == FirstNumber.ToString())
		{
			CurrentEntry = button.Text;
		}
		else
		{
			CurrentEntry += button.Text;
		}

	}

	private void ButtonClearAll_Clicked(object sender, EventArgs e)
	{
		CurrentEntry = "0";
		Operation.Text = string.Empty;
		FirstNumber = SecondNumber = 0;
		LastOperation = Math.Operation.None;
	}

	private void ButtonErase_Clicked(object sender, EventArgs e)
	{
		if (CurrentEntry.Length is 1)
		{
			CurrentEntry = "0";
		}
		else
		{
			CurrentEntry = currentEntry.Remove(currentEntry.Length - 1);
		}
	}

	private void ButtonEquals_Clicked(object sender, EventArgs e)
	{
		if (string.IsNullOrEmpty(Operation.Text))
			FirstNumber = SecondNumber;
		Evaluate();
	}

	private void Evaluate()
	{
		if (LastOperation is not Math.Operation.None)
		{
			SecondNumber = Convert.ToDecimal(CurrentEntry);

			try
			{
				var result = _mathCalculator.Evaluate(
					FirstNumber,
					SecondNumber,
					LastOperation);

				CurrentEntry = result.ToString();
			}
			catch (DivideByZeroException)
			{
				CurrentEntry = "Cannot divide by zero";
			}
			Operation.Text = string.Empty;
		}
	}

	private void ButtonOperation_Clicked(object sender, EventArgs e)
	{
		var button = (Button)sender;
		SaveFirstNumberAndOperation(button);
		CurrentEntry = "0";
	}

	private void SaveFirstNumberAndOperation(Button button)
	{
		if (button.Text is "=")
		{
			FirstNumber = SecondNumber;
			return;
		}

		var operation = button.Text switch
		{
			"+" => Math.Operation.Add,
			"-" => Math.Operation.Subtract,
			"/" => Math.Operation.Divide,
			"X" => Math.Operation.Multiply,
			_ => Math.Operation.None
		};
		LastOperation = operation;
		Operation.Text = button.Text;
		FirstNumber = Convert.ToDecimal(CurrentEntry.Any(char.IsLetter) ? 0 : CurrentEntry);
	}

	private void ButtonPlusMinus_Clicked(object sender, EventArgs e)
	{
		if (CurrentEntry is "0")
			return;
		if (char.IsDigit(CurrentEntry[0]))
		{
			CurrentEntry = '-' + CurrentEntry[0..];
		}
		else
		{
			CurrentEntry = CurrentEntry[1..];
		}
	}

	private void ButtonDot_Clicked(object sender, EventArgs e)
	{
		if (CurrentEntry.Any(x => x is ','))
			return;

		CurrentEntry += ',';
	}

	private void AdvancedOperation_Clicked(object sender, EventArgs e)
	{
		var button = (Button)sender;
		var value = decimal.Parse(CurrentEntry);

		try
		{
			var result = button.Text switch
			{
				"%" => _mathCalculator.Percent(value),
				"|x|" => _mathCalculator.Abs(value),
				"√x" => _mathCalculator.Sqrt(value),
				"1/x" => _mathCalculator.OneOverX(value),
				"x^2" => _mathCalculator.RaiseToTwo(value),
				_ => 0
			};

			CurrentEntry = result.ToString();
		}
		catch (DivideByZeroException)
		{
			CurrentEntry = "Cannot divide by zero";
		}
		catch (NegativeSqrtException)
		{
			CurrentEntry = "Negative number";
		}
		catch(OverflowException)
		{
			CurrentEntry = "0";
		}
	}
}