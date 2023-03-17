using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;


public partial class StoredProcedures
{
	[Microsoft.SqlServer.Server.SqlProcedure]
	public static void StoreProcedures()
	{
		// Put your code here
		using(SqlConnection connection = new SqlConnection("context connection = true"))
		{
			connection.Open();
			SqlCommand command = new SqlCommand("SELECT @@VERSION", connection);
			SqlDataReader reader = command.ExecuteReader();
			SqlContext.Pipe.Send(reader);
		}	
	}

	[Microsoft.SqlServer.Server.SqlFunction]
	public static SqlDouble MontoConIva(SqlDouble monto)
	{
		// Put your code here
		SqlDouble impuesto = monto * 0.12;
		return monto + impuesto;
	}

}
