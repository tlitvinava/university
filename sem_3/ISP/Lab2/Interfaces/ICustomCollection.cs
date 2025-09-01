namespace Lab2.Interfaces;

public interface ICustomCollection<T>
{
	public T this[int index] { get; set; }
	public void Add(T item);
	public void Remove(T item);
	public void Reset();
	public void Next();
	public T Current();
	public int Count { get; }
	public T RemoveCurrent();
}
