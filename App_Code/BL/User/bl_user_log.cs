using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for bl_User_log
/// </summary>
public class bl_User_log
{
	#region "Private Variable"

        private string _User_Log_ID;
        private string _User_ID;       
        private DateTime _Login_On;
        private string _Login_By;
        private string _Application_ID;

    #endregion


    #region "Constructor"
        public bl_User_log()
        {

        }
        #endregion

    #region "Public Property"

    public string User_Log_ID
    {
        get { return _User_Log_ID; }
        set { _User_Log_ID = value; }
    }

    public string User_ID
    {
        get { return _User_ID; }
        set { _User_ID = value; }
    }

    public DateTime Login_On
    {
        get { return _Login_On; }
        set { _Login_On = value; }
    }

    public string Login_By
    {
        get { return _Login_By; }
        set { _Login_By = value; }
    }

    public string Application_ID
    {
        get { return _Application_ID; }
        set { _Application_ID = value; }
    }

    #endregion
}