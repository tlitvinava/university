using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MauiTestApp
{
	public static class MuseumExtensions
	{ 
		public static string GetRandomName(this Random random)
		{
			string[] Names = ["first heart", "lorem ipsum", "jquery mention", "mementionare", "mona lisa", "russian kalinka", "suqulelite"];

			return Names[random.Next(Names.Length)];
		}
	}
}
