using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for bl_beneficiary
/// </summary>
public class bl_fixed_deposit_beneficiary
{
    #region "Private Variable"

    private string _fixed_deposit_Beneficiary_ID;
    private string _fixed_deposit_Primary_Data_ID;
    private string _Beneficiary_First_Name;
    private string _Beneficiary_Last_Name;
    private string _Beneficiary_ID_Type;
    private string _Beneficiary_ID_Card;
    private string _Beneficiary_Relationship;
    private string _Family_Book;
    private string _benefits;


    #endregion
	

    #region "Constructor"
    public bl_fixed_deposit_beneficiary()
	{
	}
	#endregion

    #region "Public Properties"
    public string fixed_deposit_Beneficiary_ID
    {
        get { return _fixed_deposit_Beneficiary_ID; }
        set { _fixed_deposit_Beneficiary_ID = value; }
    }
    public string fixed_deposit_Primary_Data_ID
    {
        get { return _fixed_deposit_Primary_Data_ID; }
        set { _fixed_deposit_Primary_Data_ID = value; }
    }

    public string Beneficiary_First_Name
    {
        get { return _Beneficiary_First_Name; }
        set { _Beneficiary_First_Name = value; }
    }

    public string Beneficiary_Last_Name
    {
        get { return _Beneficiary_Last_Name; }
        set { _Beneficiary_Last_Name = value; }
    }

    public string Beneficiary_ID_Type
    {
        get { return _Beneficiary_ID_Type; }
        set { _Beneficiary_ID_Type = value; }
    }

    public string Beneficiary_ID_Card
    {
        get { return _Beneficiary_ID_Card; }
        set { _Beneficiary_ID_Card = value; }
    }

    public string Beneficiary_Relationship
    {
        get { return _Beneficiary_Relationship; }
        set { _Beneficiary_Relationship = value; }
    }

    public string Family_Book
    {
        get { return _Family_Book; }
        set { _Family_Book = value; }
    }


    public string Benefits
    {
        get { return _benefits; }
        set { _benefits = value; }
    }


    #endregion
}