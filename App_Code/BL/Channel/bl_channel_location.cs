using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for bl_channel_location
/// </summary>
public class bl_channel_location
{
	#region "Private Variable"

    private string _Channel_Location_ID;
    private string _Channel_Item_ID;
    private string _Address;
    private string _Created_By;
    private DateTime _Created_On;
    private string _Created_Note;
    private int _Status;
    private string _Office_Code;
    private string _Office_Name;
  
    #endregion

	#region "Constructor"
    public bl_channel_location()
	{
	}
	#endregion
    
	#region "Public Properties"

    public string Channel_Location_ID
    {
        get { return _Channel_Location_ID; }
        set { _Channel_Location_ID = value; }
	}

    public string Channel_Item_ID
    {
        get { return _Channel_Item_ID; }
        set { _Channel_Item_ID = value; }
	}

    public string Address
    {
        get { return _Address; }
        set { _Address = value; }
    }
       
    public int Status
    {
        get { return _Status; }
        set { _Status = value; }
    }

    public string Created_By
    {
        get { return _Created_By; }
        set { _Created_By = value; }
    }

    public DateTime Created_On
    {
        get { return _Created_On; }
        set { _Created_On = value; }
    }

    public string Office_Code
    {
        get { return _Office_Code; }
        set { _Office_Code = value; }
    }

    public string Office_Name
    {
        get { return _Office_Name; }
        set { _Office_Name = value; }
    }

	#endregion
}