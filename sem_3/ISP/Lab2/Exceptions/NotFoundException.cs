namespace Lab2.Exceptions;

public class ObjectNotFoundException
		: ArgumentException
{
	public ObjectNotFoundException(string message)
		: base(message)
	{ }

	public ObjectNotFoundException()
		: base()
	{ }
}
