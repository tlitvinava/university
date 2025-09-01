namespace MauiTestApp.Math
{
	class MathCalculator : IMathCalculator
	{
		public decimal Abs(decimal value)
		{
			return System.Math.Abs(value);
		}

		public decimal Evaluate(decimal a, decimal b, Operation operation)
		{
			try
			{
				var result = operation switch
				{
					Operation.Add => a + b,
					Operation.Subtract => a - b,
					Operation.Multiply => a * b,
					Operation.Divide => a / b,
					_ => 0,
				};

				return result;
			}
			catch (OverflowException)
			{ 
				return 0;
			}
		}

		public decimal OneOverX(decimal value)
		{
			return 1 / value;
		}

		public decimal Percent(decimal value)
		{
			return value / 100.0M;
		}

		public decimal Sqrt(decimal value)
		{
			var result = System.Math.Sqrt((double)value);
			if (result is double.NaN)
				throw new NegativeSqrtException();

			return (decimal)result;
		}
		public decimal RaiseToTwo(decimal value)
		{
			return value * value;
		}
	}
}
