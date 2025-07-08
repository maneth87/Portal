using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Collections;
using System.Data;
using System.Configuration;

/// <summary>
/// Get connection string from web.config
/// </summary>
public class AppConfiguration
{
	public AppConfiguration()
	{
       
	}

    public static string GetConnectionString()
    {
        string connString = ConfigurationManager.ConnectionStrings["CAMLIFEPORTAL"].ConnectionString.ToString();
        return connString;
    }

    public static string GetAccountConnectionString()
    {
        string connString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString.ToString();
        return connString;
    }
    public static string GetCamlifeTokenURL()
    {
        return ConfigurationManager.AppSettings["TOKEN-URL"].ToString();
    }
    public static string GetCamlifeTokenUser()
    {
        return ConfigurationManager.AppSettings["TOKEN-USER"].ToString();
    }
    public static string GetCamlifeTokenPWD()
    {
        return ConfigurationManager.AppSettings["TOKEN-PWD"].ToString();
    }
    public static string GetCamlifeAPIURL()
    {
        return ConfigurationManager.AppSettings["API-URL"].ToString();
    }
}