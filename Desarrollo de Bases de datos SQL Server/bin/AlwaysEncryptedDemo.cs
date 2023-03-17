using System;
using System.Data;
using System.Data.SqlClient;


namespace AlwaysEncryptedDemo
{
	///<summary>
	/*
		A simple class to demostrate insert and query sensitive information using Always Encrypted functionality
		Apart from the connection string keyword ClumnEncryptionSetting, rest of the code looks very similar to
		a regular SqlClient application code.

		Pre-Requisites
		.NET 4.6
		SQL Script to setup the schema for Patents table
	*/

	class Program
	{
		private static SqlConnection _sqlconn;
		
		private static void AddNewPatient(string ssn, string firstName, string lastName, DateTime birthDate)
		{
			SqlCommand cmd = _sqlconn.CreateCommand();
			
			//Use parameterized SQL to insert the data
			cmd.CommandText = @"INSERT INTO [dbo].[Patients] ([SSN], [FirstName], [LastName], [BirthDate]) VALUES (@SSN, @firstName, @lasName, @birthDate);";

			SqlParameter paramSSN = cmd.CreateParameter();
			paramSSN.ParameterName = @"@SSN";
			paramSSN.DbType = DbType.String;
			paramSSN.Direction = ParameterDirection.Input;
			paramSSN.Value = ssn;
			paramSSN.Size = 11;
			cmd.Parameters.Add(paramSSN);

			SqlParameter paramFirstName = cmd.CreateParameter();
			paramFirstName.ParameterName = @"@FirstName";
			paramFirstName.DbType = DbType.String;
			paramFirstName.Direction = ParameterDirection.Input;
			paramFirstName.Value = firstName;
			paramFirstName.Size = 50;
			cmd.Parameters.Add(paramFirstName);

			SqlParameter paramLastName = cmd.CreateParameter();
			paramLastName.ParameterName = @"@LastName";
			paramLastName.DbType = DbType.String;
			paramLastName.Direction = ParameterDirection.Input;
			paramLastName.Value = lastName;
			paramLastName.Size = 50;
			cmd.Parameters.Add(paramLastName);

			SqlParameter paramBirthDate = cmd.CreateParameter();
			paramBirthDate.ParameterName = @"@BirthDate";
			paramBirthDate.DbType = DbType.DateTime2;
			paramBirthDate.Direction = ParameterDirection.Input;
			paramBirthDate.Value = birthDate;
			cmd.Parameters.Add(paramBirthDate);

			cmd.ExecuteNonQuery();
		}
		
		//Query the DB to find the patient with the desired SSN, and print the data int the console
		private static void FindAndPrintPatientInformation(string ssn)
		{
			SqlDataReader reader = null;
			try
			{
				reader = (ssn == null) ? FindAndPrintPatientInformationAll() : FindAndPrintPatientInformationSpecific(ssn);
				PrintPatientInformation(reader);
			}
			finally
			{
				if(reader != null)
					reader.Close();
			}
		}	
		
		private static void FindAndPrintPatientInformation()
		{
			//FindAndPrintPatientInformation(null);	
		}
	
		//Implementation for querying all patients in the DB
		private static SqlDataReader FindAndPrintPatientInformationAll()
		{
			SqlCommand cmd = _sqlconn.CreateCommand();
			//Normal select statement
			cmd.ComandText = @"SELECT SSN, FirstName, LastName, BirthDate FROM dbo.Patients ORDER BY PatientID";
			SqlDataReader reader = cmd.ExecuteReader();
			return reader;
		}
	}
}
