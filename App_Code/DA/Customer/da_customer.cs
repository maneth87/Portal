using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;

/// <summary>
/// Summary description for da_customer
/// </summary>
public class da_customer
{	

    private static da_customer mytitle = null;
    
    public da_customer()
	{
        if (mytitle == null)
        {
            mytitle = new da_customer();
        }
    }

    #region "Public Functions"


    //Insert new customer into database then upon successful insert, return customer ID
    public static string InsertCustomer(bl_customer customer)
    {
        string temp_id = GetCustomerID();        
        string customer_id = "";
                
        //Create new customer and get Customer_ID        
        string connString = AppConfiguration.GetConnectionString();
        using (SqlConnection con = new SqlConnection(connString))
        {
            SqlCommand cmd = new SqlCommand();
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "SP_Insert_Customer";

            cmd.Parameters.AddWithValue("@Customer_ID", temp_id);
            cmd.Parameters.AddWithValue("@ID_Card", customer.ID_Card);
            cmd.Parameters.AddWithValue("@ID_Type", customer.ID_Type);
            cmd.Parameters.AddWithValue("@First_Name", customer.First_Name);
            cmd.Parameters.AddWithValue("@Last_Name", customer.Last_Name);
            cmd.Parameters.AddWithValue("@Gender", customer.Gender);
            cmd.Parameters.AddWithValue("@Birth_Date", customer.Birth_Date);
            cmd.Parameters.AddWithValue("@Country_ID", customer.Country_ID);
            cmd.Parameters.AddWithValue("@Khmer_First_Name", customer.Khmer_First_Name);
            cmd.Parameters.AddWithValue("@Khmer_Last_Name", customer.Khmer_Last_Name);
            cmd.Parameters.AddWithValue("@Father_First_Name", customer.Father_First_Name);
            cmd.Parameters.AddWithValue("@Father_Last_Name", customer.Father_Last_Name);
            cmd.Parameters.AddWithValue("@Mother_First_Name", customer.Mother_First_Name);
            cmd.Parameters.AddWithValue("@Mother_Last_Name", customer.Mother_Last_Name);
            cmd.Parameters.AddWithValue("@Prior_First_Name", customer.Prior_First_Name);
            cmd.Parameters.AddWithValue("@Prior_Last_Name", customer.Prior_Last_Name);

            cmd.Parameters.AddWithValue("@Created_On", DateTime.Now);
            cmd.Parameters.AddWithValue("@Created_By", customer.Created_By);
            cmd.Parameters.AddWithValue("@Created_Note", "");

            cmd.Connection = con;
            con.Open();
            try
            {                
                cmd.ExecuteNonQuery();
                customer_id = temp_id;                
            }
                
            catch (Exception ex)
            {
                //Add error to log 
                Log.AddExceptionToLog("Error in function [InsertCustomer] in class [da_customer]. Details: " + ex.Message);
            }
            con.Close();
        }
        return customer_id;
    }


   
    //Get last customer number
    public static string GetCustomerID()
    {
        string customer_id = "";

        string connString = AppConfiguration.GetConnectionString();

        using (SqlConnection con = new SqlConnection(connString))
        {
            SqlCommand cmd = new SqlCommand();
            cmd.CommandType = CommandType.StoredProcedure;

            //call store procedure by name
            cmd.CommandText = "SP_Get_Last_Customer_ID";

            cmd.Connection = con;
            con.Open();
            try
            {                
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    if (rdr.HasRows)
                    {
                        customer_id = rdr.GetString(rdr.GetOrdinal("Customer_ID"));

                        int strConvert = Convert.ToInt16(customer_id) + 1;
                        customer_id = strConvert.ToString("D8");
                       
                    }
                }
            }
            
            catch (Exception ex)
            {
                //Add error to log 
                Log.AddExceptionToLog("Error in function [GetCustomerID] in class [da_customer]. Details: " + ex.Message);
            }
            con.Close();
        }
        return customer_id;
    }


    //Function to check existing customer
    public static bool CheckExistingCustomer(string first_name, string last_name, int genter, DateTime dob)
    {
        bool result = false;
        string connString = AppConfiguration.GetConnectionString();
        try
        {
            using (SqlConnection myConnection = new SqlConnection(connString))
            {

                SqlCommand myCommand = new SqlCommand();
                myConnection.Open();
                myCommand.Connection = myConnection;
                myCommand.CommandType = CommandType.StoredProcedure;
                myCommand.CommandText = "SP_Check_Existing_Customer";
                myCommand.Parameters.AddWithValue("@First_Name", first_name);
                myCommand.Parameters.AddWithValue("@Last_Name", last_name);
                myCommand.Parameters.AddWithValue("@Gender", genter);
                myCommand.Parameters.AddWithValue("@DOB", dob);

                using (SqlDataReader myReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection))
                {
                    while (myReader.Read())
                    {
                        result = true;
                        break; // TODO: might not be correct. Was : Exit While
                    }
                    myReader.Close();
                }
                myConnection.Open();
                myCommand.ExecuteNonQuery();
                myConnection.Close();
            }
        }
        catch (Exception ex)
        {
            //Add error to log 
            Log.AddExceptionToLog("Error in function [CheckExistingCustomer] in class [da_customer]. Details: " + ex.Message);
        }
        return result;
    }

    //Get customer id (private key) by first_name, last_name, gender, dob    
    public static string  GetCustomerIDByNameDOBGender(string first_name, string last_name, int genter, DateTime dob)
    {
        string customer_id = "";
        string connString = AppConfiguration.GetConnectionString();
        try
        {
            using (SqlConnection myConnection = new SqlConnection(connString))
            {

                SqlCommand myCommand = new SqlCommand();
                myConnection.Open();
                myCommand.Connection = myConnection;
                myCommand.CommandType = CommandType.StoredProcedure;
                myCommand.CommandText = "SP_Get_Ct_Customer_ID_By_Name_DOB_Gender";
                myCommand.Parameters.AddWithValue("@First_Name", first_name);
                myCommand.Parameters.AddWithValue("@Last_Name", last_name);
                myCommand.Parameters.AddWithValue("@Gender", genter);
                myCommand.Parameters.AddWithValue("@DOB", dob);

                using (SqlDataReader myReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection))
                {
                    while (myReader.Read())
                    {
                        customer_id = myReader.GetString(myReader.GetOrdinal("Customer_ID")); ;
                        
                    }
                    myReader.Close();
                }
                myConnection.Open();
                myCommand.ExecuteNonQuery();
                myConnection.Close();
            }
        }
        catch (Exception ex)
        {
            //Add error to log 
            Log.AddExceptionToLog("Error in function [GetCustomerIDByNameDOBGender] in class [da_customer]. Details: " + ex.Message);
        }
        return customer_id;
    }

    //Function to check duplicate Card_ID
    public static bool CheckDuplicateCardID(int id_type, string card_id)
    {
        bool result = false;
        string connString = AppConfiguration.GetConnectionString();
        try
        {
            using (SqlConnection myConnection = new SqlConnection(connString))
            {

                SqlCommand myCommand = new SqlCommand();
                myConnection.Open();
                myCommand.Connection = myConnection;
                myCommand.CommandType = CommandType.StoredProcedure;
                myCommand.CommandText = "SP_Check_Duplicate_Card_ID";
                myCommand.Parameters.AddWithValue("@ID_Type", id_type);
                myCommand.Parameters.AddWithValue("@ID_Card", card_id);
              
                using (SqlDataReader myReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection))
                {
                    while (myReader.Read())
                    {
                        result = true;
                        break; // TODO: might not be correct. Was : Exit While
                    }
                    myReader.Close();
                }
                myConnection.Open();
                myCommand.ExecuteNonQuery();
                myConnection.Close();
            }
        }
        catch (Exception ex)
        {
            //Add error to log 
            Log.AddExceptionToLog("Error in function [CheckDuplicateCardID] in class [da_customer]. Details: " + ex.Message);
        }
        return result;
    }
    #endregion

}