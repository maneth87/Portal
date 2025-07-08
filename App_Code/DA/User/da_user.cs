using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for da_user
/// </summary>
public class da_user
{
	private static da_user mytitle = null;
    public da_user()
    {
        if (mytitle == null)
        {
            mytitle = new da_user();
        }

    }

    #region "Public Functions"

    //Function to get user id by user name
    public static string GetUserIDByUserName(string user_name)
    {
        string user_id = "";

        string connString = AppConfiguration.GetAccountConnectionString();

        using (SqlConnection con = new SqlConnection(connString))
        {
            SqlCommand cmd = new SqlCommand("SP_Get_User_ID_By_User_Name", con);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@User_Name", user_name);
           
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {

                if (rdr.HasRows)
                {
                    user_id = rdr.GetGuid(rdr.GetOrdinal("UserId")).ToString();
                         
                }

            }

        }
        return user_id;
    }
      

    #endregion

}