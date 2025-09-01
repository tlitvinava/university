using MauiTestApp.Entities;
using MauiTestApp.Services;
using System.Runtime.CompilerServices;

namespace MauiTestApp.Pages;

public partial class DatabasePage : ContentPage
{
	private readonly IDbService _service;

	public DatabasePage(IDbService service)
	{
		InitializeComponent();
		_service = service;
		_service.Init();
	}

	private void CollectionView_Loaded(object sender, EventArgs e)
	{
		Picker.ItemsSource = _service.GetAllMuseums().ToList();
	}

	private void CollectionView_SelectionChanged(object sender, SelectionChangedEventArgs e)
	{
		var museum = e.CurrentSelection.FirstOrDefault() as Museum;

		if (museum is not null)
		{
			CollectionView.ItemsSource = _service.GetMuseumExhibit(museum.Id);
		}
	}

	private void Picker_SelectedIndexChanged(object sender, EventArgs e)
	{
		var museum = (sender as Picker)?.SelectedItem as Museum;

		if (museum is not null)
		{
			CollectionView.ItemsSource = _service.GetMuseumExhibit(museum.Id);
		}
	}
}