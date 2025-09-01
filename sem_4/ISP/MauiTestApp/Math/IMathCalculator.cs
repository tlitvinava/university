namespace MauiTestApp.Math
{
	public interface IMathCalculator
	{
		decimal OneOverX(decimal value);
		decimal Sqrt(decimal value);
		decimal RaiseToTwo(decimal value);
		decimal Abs(decimal value);
		decimal Percent(decimal value);
		decimal Evaluate(decimal a, decimal b, Operation operation);
	}
}