using Microsoft.EntityFrameworkCore;
using System.Linq.Expressions;

namespace Persistence.Repository;

public class EfRepository<T>(ApplicationContext context) : IRepository<T> where T : Entity
{
	protected readonly DbSet<T> _entities = context.Set<T>();

	public async Task AddAsync(T entity, CancellationToken cancellationToken = default) =>
		await _entities.AddAsync(entity, cancellationToken);

	public Task DeleteAsync(T entity, CancellationToken cancellationToken = default)
	{
		_entities.Remove(entity);

		return Task.CompletedTask;
	}

	public async Task<T?> FirstOrDefaultAsync(Expression<Func<T, bool>> filter, CancellationToken cancellationToken = default)
	{
		var query = _entities.AsQueryable();

		if (filter is not null)
		{
			query = query.Where(filter);
		}

		return await query.FirstOrDefaultAsync(cancellationToken);
	}

	public async Task<T> GetByIdAsync(int id, CancellationToken cancellationToken = default, params Expression<Func<T, object>>[]? includesProperties)
	{
		var query = _entities.AsQueryable();

		if (includesProperties!.Length != 0)
		{
			foreach (var included in includesProperties)
			{
				query = query.Include(included);
			}
		}

		query = query.Where(x => x.Id == id);

		return await query.FirstAsync(cancellationToken);
	}

	public async Task<IReadOnlyList<T>> ListAllAsync(CancellationToken cancellationToken = default) =>
		 await _entities.ToListAsync(cancellationToken: cancellationToken);

	public async Task<IReadOnlyList<T>> ListAsync(Expression<Func<T, bool>> filter, CancellationToken cancellationToken = default, params Expression<Func<T, object>>[]? includesProperties)
	{
		var query = _entities.AsQueryable();

		if (includesProperties!.Length != 0)
		{
			foreach (var included in includesProperties)
			{
				query = query.Include(included);
			}
		}

		if (filter is not null)
		{
			query = query.Where(filter);
		}

		return await query.ToListAsync(cancellationToken);
	}

	public Task UpdateAsync(T entity, CancellationToken cancellationToken = default)
	{
		context.Entry(entity).State = EntityState.Modified;

		return Task.CompletedTask;
	}
}
