using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for da_application
/// </summary>
public class da_application
{
    private static da_application mytitle = null;
    public da_application()
	{
        if (mytitle == null)
        {
            mytitle = new da_application();
		}
	}
     

    //Function to get application_id by application code
    public static string GetApplicationIDByApplicationCode(string application_code)
    {
        string application_id = "";
        string connString = AppConfiguration.GetConnectionString();
        try
        {
            using (SqlConnection myConnection = new SqlConnection(connString))
            {

                SqlCommand myCommand = new SqlCommand();
                myConnection.Open();
                myCommand.Connection = myConnection;
                myCommand.CommandType = CommandType.StoredProcedure;
                myCommand.CommandText = "SP_Get_Application_ID_By_Application_Code";
                myCommand.Parameters.AddWithValue("@Application_Code", application_code);
             
                using (SqlDataReader myReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection))
                {
                    while (myReader.Read())
                    {
                        application_id = myReader.GetString(myReader.GetOrdinal("Application_ID"));
                        
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
            Log.AddExceptionToLog("Error in function [GetApplicationIDByApplicationCode] in class [da_application]. Details: " + ex.Message);
        }
        return application_id;
    }

    //Insert Ct_App_Benefit_Item
    public static bool InsertAppBenefitItem(bl_app_benefit_item app_benefit_item)
    {
        bool result = false;
        string connString = AppConfiguration.GetConnectionString();
        using (SqlConnection con = new SqlConnection(connString))
        {
            SqlCommand cmd = new SqlCommand();
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "SP_Insert_App_Benefit_Item";

            cmd.Parameters.AddWithValue("@App_Register_ID", app_benefit_item.App_Register_ID);
            cmd.Parameters.AddWithValue("@App_Benefit_Item_ID", app_benefit_item.App_Benefit_Item_ID);
            cmd.Parameters.AddWithValue("@Full_Name", app_benefit_item.Full_Name);
            cmd.Parameters.AddWithValue("@ID_Type", app_benefit_item.ID_Type);
            cmd.Parameters.AddWithValue("@ID_Card", app_benefit_item.ID_Card);
            cmd.Parameters.AddWithValue("@Percentage", app_benefit_item.Percentage);
            cmd.Parameters.AddWithValue("@Relationship", app_benefit_item.Relationship);
            cmd.Parameters.AddWithValue("@Seq_Number", app_benefit_item.Seq_Number);
            cmd.Parameters.AddWithValue("@Relationship_Khmer", app_benefit_item.Relationship_Khmer);
            cmd.Parameters.AddWithValue("@Relationship_Reason", app_benefit_item.Relationship_Reason);

            cmd.Connection = con;
            con.Open();
            try
            {
                cmd.ExecuteNonQuery();
                result = true;
                con.Close();
            }
            catch (Exception ex)
            {
                //Add error to log 
                con.Close();
                Log.AddExceptionToLog("Error in function [InsertAppBenefitItem] in class [da_application]. Details: " + ex.Message);
            }
        }
        return result;
    }

    //Get List of Benefit_Items by app_id
    public static List<bl_app_benefit_item> GetAppBenefitItem(string app_id)
    {

        List<bl_app_benefit_item> benefit_items = new List<bl_app_benefit_item>();

        string connString = AppConfiguration.GetConnectionString();

        using (SqlConnection con = new SqlConnection(connString))
        {
            SqlCommand cmd = new SqlCommand("SP_Get_App_Benefit_Item_By_App_Register_ID", con);
            cmd.CommandType = CommandType.StoredProcedure;

            SqlParameter paramName = new SqlParameter();
            paramName.ParameterName = "@App_Register_ID";
            paramName.Value = app_id;
            cmd.Parameters.Add(paramName);

            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                if (rdr.HasRows)
                {
                    bl_app_benefit_item benefit_item = new bl_app_benefit_item();

                    benefit_item.App_Register_ID = rdr.GetString(rdr.GetOrdinal("App_Register_ID"));
                    benefit_item.App_Benefit_Item_ID = rdr.GetString(rdr.GetOrdinal("App_Benefit_Item_ID"));
                    benefit_item.Full_Name = rdr.GetString(rdr.GetOrdinal("Full_Name"));
                    benefit_item.ID_Card = rdr.GetString(rdr.GetOrdinal("ID_Card"));
                    benefit_item.ID_Type = rdr.GetInt32(rdr.GetOrdinal("ID_Type"));
                    benefit_item.Percentage = rdr.GetDouble(rdr.GetOrdinal("Percentage"));
                    benefit_item.Relationship = rdr.GetString(rdr.GetOrdinal("Relationship"));
                    benefit_item.Seq_Number = rdr.GetInt32(rdr.GetOrdinal("Seq_Number"));

                    benefit_items.Add(benefit_item);
                }
            }
            con.Close();
        }
        return benefit_items;
    }

    //Delete Ct_App_Benefit_Item
    public static bool DeleteAppBenefitItem(string app_register_id)
    {
        bool result = false;
        string connString = AppConfiguration.GetConnectionString();
        using (SqlConnection con = new SqlConnection(connString))
        {
            SqlCommand cmd = new SqlCommand();
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "SP_Delete_App_Benefit_Item";

            cmd.Parameters.AddWithValue("@App_Register_ID", app_register_id);

            cmd.Connection = con;
            con.Open();
            try
            {
                cmd.ExecuteNonQuery();
                result = true;
                con.Close();
            }
            catch (Exception ex)
            {
                //Add error to log
                con.Close();
                Log.AddExceptionToLog("Error in function [DeleteAppBenefitItem] in class [da_application]. Details: " + ex.Message);
            }
        }
        return result;
    }


}