using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for da_channel
/// </summary>
public class da_channel
{
    private static da_channel mytitle = null;
    public da_channel()
	{
        if (mytitle == null)
        {
            mytitle = new da_channel();
		}
	}
   
    //Function to get channel_channel_item_id by channel sub id and channel item id
    public static string GetChannelChannelItemIDByChannelSubIDAndChannelItemID(int channel_sub_id, string channel_item_id)
    {
        string channel_channel_item_id = "";
        string connString = AppConfiguration.GetConnectionString();
        try
        {
            using (SqlConnection myConnection = new SqlConnection(connString))
            {

                SqlCommand myCommand = new SqlCommand();
                myConnection.Open();
                myCommand.Connection = myConnection;
                myCommand.CommandType = CommandType.StoredProcedure;
                myCommand.CommandText = "SP_Get_Channel_Channel_Item_ID_By_Channel_And_Channel_Item_ID";
                myCommand.Parameters.AddWithValue("@Channel_Sub_ID", channel_sub_id);
                myCommand.Parameters.AddWithValue("@Channel_Item_ID", channel_item_id);

                using (SqlDataReader myReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection))
                {
                    while (myReader.Read())
                    {
                        bl_channel_location channel_location = new bl_channel_location();

                        channel_channel_item_id = myReader.GetString(myReader.GetOrdinal("Channel_Channel_Item_ID"));

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
            Log.AddExceptionToLog("Error in function [GetChannelChannelItemIDByChannelAndChannelItemID] in class [da_channel]. Details: " + ex.Message);
        }
        return channel_channel_item_id;
    }

    //Get channel_item_id by channel_location_id
    public static string GetChannelItemIDByChannelLocationID(string channel_location_id)
    {
        //Declare object
        string channel_item_id = "";

        string connString = AppConfiguration.GetConnectionString();
        try
        {
            using (SqlConnection myConnection = new SqlConnection(connString))
            {

                SqlCommand myCommand = new SqlCommand();
                myConnection.Open();
                myCommand.Connection = myConnection;
                myCommand.CommandType = CommandType.StoredProcedure;
                myCommand.CommandText = "SP_Get_Channel_Item_ID_By_Channel_Location_ID";
                myCommand.Parameters.AddWithValue("@Channel_Location_ID", channel_location_id);

                using (SqlDataReader myReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection))
                {
                    while (myReader.Read())
                    {
                        //If found row, return true & do the statement
                        if (myReader.HasRows)
                        {
                            channel_item_id = myReader.GetString(myReader.GetOrdinal("Channel_Item_ID"));

                        }
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
            //Add error to log for analysis
            Log.AddExceptionToLog("Error function [GetChannelItemIDByChannelLocationID] in class [da_channel]. Details: " + ex.Message);
        }
        return channel_item_id;
    }

   
    //Function to get channel item name by id
    public static string GetChannelItemNameByID(string channel_item_id)
    {
        string channel_item_name = "";
        string connString = AppConfiguration.GetConnectionString();
        try
        {
            using (SqlConnection myConnection = new SqlConnection(connString))
            {

                SqlCommand myCommand = new SqlCommand();
                myConnection.Open();
                myCommand.Connection = myConnection;
                myCommand.CommandType = CommandType.StoredProcedure;
                myCommand.CommandText = "SP_Get_Channel_Item_Name_By_ID";
                myCommand.Parameters.AddWithValue("@Channel_Item_ID", channel_item_id);

                using (SqlDataReader myReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection))
                {
                    while (myReader.Read())
                    {


                        channel_item_name = myReader.GetString(myReader.GetOrdinal("Channel_Name"));

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
            Log.AddExceptionToLog("Error in function [GetChannelItemNameByID] in class [da_channel]. Details: " + ex.Message);
        }
        return channel_item_name;
    }

    //Function to get channel location code by channel location id
    public static string GetChannelLocationCodeByID(string channel_location_id)
    {
        string channel_location_name = "";
        string connString = AppConfiguration.GetConnectionString();
        try
        {
            using (SqlConnection myConnection = new SqlConnection(connString))
            {

                SqlCommand myCommand = new SqlCommand();
                myConnection.Open();
                myCommand.Connection = myConnection;
                myCommand.CommandType = CommandType.StoredProcedure;
                myCommand.CommandText = "SP_Get_Channel_Location_Code_By_ID";
                myCommand.Parameters.AddWithValue("@Channel_Location_ID", channel_location_id);

                using (SqlDataReader myReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection))
                {
                    while (myReader.Read())
                    {

                        channel_location_name = myReader.GetString(myReader.GetOrdinal("Office_Code"));
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
            Log.AddExceptionToLog("Error in function [GetChannelLocationNameByID] in class [da_channel]. Details: " + ex.Message);
        }
        return channel_location_name;
    }

    //Function to get channel location code by channel location id
    public static string GetChannelLocationNameByID(string channel_location_id)
    {
        string channel_location_name = "";
        string connString = AppConfiguration.GetConnectionString();
        try
        {
            using (SqlConnection myConnection = new SqlConnection(connString))
            {

                SqlCommand myCommand = new SqlCommand();
                myConnection.Open();
                myCommand.Connection = myConnection;
                myCommand.CommandType = CommandType.StoredProcedure;
                myCommand.CommandText = "SP_Get_Channel_Location_Name_By_ID";
                myCommand.Parameters.AddWithValue("@Channel_Location_ID", channel_location_id);

                using (SqlDataReader myReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection))
                {
                    while (myReader.Read())
                    {

                        channel_location_name = myReader.GetString(myReader.GetOrdinal("Office_Name"));
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
            Log.AddExceptionToLog("Error in function [GetChannelLocationNameByID] in class [da_channel]. Details: " + ex.Message);
        }
        return channel_location_name;
    }

    //Function to get channel location id by user id
    public static string GetChannelLocationIDByUserID(string user_id)
    {
        string channel_location_id = "";
        string connString = AppConfiguration.GetConnectionString();
        try
        {
            using (SqlConnection myConnection = new SqlConnection(connString))
            {

                SqlCommand myCommand = new SqlCommand();
                myConnection.Open();
                myCommand.Connection = myConnection;
                myCommand.CommandType = CommandType.StoredProcedure;
                myCommand.CommandText = "SP_Get_Channel_Location_ID_By_User_ID";
                myCommand.Parameters.AddWithValue("@User_ID", user_id);

                using (SqlDataReader myReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection))
                {
                    while (myReader.Read())
                    {

                        channel_location_id = myReader.GetString(myReader.GetOrdinal("Channel_Location_ID"));
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
            Log.AddExceptionToLog("Error in function [GetChannelLocationIDByUserID] in class [da_channel]. Details: " + ex.Message);
        }
        return channel_location_id;
    }

    //Function to get channel location list by channel_item_id
    public static List<bl_channel_location> GetChannelLocationListByChannelItemID(string channel_item_id)
    {
        List<bl_channel_location> channel_location_list = new List<bl_channel_location>();
        string connString = AppConfiguration.GetConnectionString();
        try
        {
            using (SqlConnection myConnection = new SqlConnection(connString))
            {

                SqlCommand myCommand = new SqlCommand();
                myConnection.Open();
                myCommand.Connection = myConnection;
                myCommand.CommandType = CommandType.StoredProcedure;
                myCommand.CommandText = "SP_Get_Channel_Location_List_By_Channel_Item_ID";
                myCommand.Parameters.AddWithValue("@Channel_Item_ID", channel_item_id);

                using (SqlDataReader myReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection))
                {
                    while (myReader.Read())
                    {
                        bl_channel_location channel_location = new bl_channel_location();

                        channel_location.Channel_Location_ID = myReader.GetString(myReader.GetOrdinal("Channel_Location_ID"));
                        channel_location.Office_Code = myReader.GetString(myReader.GetOrdinal("Office_Code"));

                        channel_location_list.Add(channel_location);
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
            Log.AddExceptionToLog("Error in function [GetChannelLocationListByChannelItemID] in class [da_channel]. Details: " + ex.Message);
        }
        return channel_location_list;
    }
}