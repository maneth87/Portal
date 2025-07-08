using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for da_user_log
/// </summary>
public class da_user_log
{
    private static da_user_log mytitle = null;
    public da_user_log()
    {
        if (mytitle == null)
        {
            mytitle = new da_user_log();
        }

    }

    #region "Public Functions"


    //Insert new user log
    public static bool InsertUserLog(bl_User_log user_log)
    {
        bool result = false;

        string connString = AppConfiguration.GetConnectionString();
        using (SqlConnection con = new SqlConnection(connString))
        {
            SqlCommand cmd = new SqlCommand();
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "SP_Insert_User_Log";

            //get new primary key for the row to be inserted
            user_log.User_Log_ID = Helper.GetNewGuid("SP_Check_User_Log_ID", "@User_Log_ID").ToString();

            cmd.Parameters.AddWithValue("@User_Log_ID", user_log.User_Log_ID);
            cmd.Parameters.AddWithValue("@User_ID", user_log.User_ID);
            cmd.Parameters.AddWithValue("@Login_On", user_log.Login_On);
            cmd.Parameters.AddWithValue("@Login_By", user_log.Login_By);
            cmd.Parameters.AddWithValue("@Application_ID", user_log.Application_ID);

            cmd.Connection = con;
            con.Open();
            try
            {
                cmd.ExecuteNonQuery();
                con.Close();
                result = true;
            }
            catch (Exception ex)
            {
                //Add error to log 
                Log.AddExceptionToLog("Error in function [InsertUserLog] in class [da_user_log]. Details: " + ex.Message);
            }
        }
        return result;
    }
      

    #endregion

}