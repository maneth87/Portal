using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

/// <summary>
/// Summary description for da_ecert
/// </summary>
public class da_ecert
{
    private static string _message;
    private static bool _success;
	public da_ecert()
	{
		//
		// TODO: Add constructor logic here
		//
        _message = "";
        _success = false;
	}

    public static string Message { get { return _message; } }
    public static bool Success { get { return _success; } }

    public static bool Save(bl_ecert ecert)
    {
        try
        {
            DB db = new DB();

            _success = db.Execute(AppConfiguration.GetConnectionString(), "SP_TBL_G_CERT_INSERT", new string[,]{
            {"V_CUSTOMER_NAME_KH", ecert.CustomerNameKh} ,
                {"V_CUSTOMER_NAME_EN", ecert.CustomerNameEn} ,
                {"D_CUSTOMER_DOB", ecert.CustomerDob+""} ,
                {"V_CUSTOMER_GENDER", ecert.CustomerGender} ,
                {"V_CERTIFICATE_NUMBER", ecert.CertificateNumber} ,
                {"D_EFFECTIVE_DATE", ecert.EffectiveDate+""} ,
                {"D_EXPIRY_DATE", ecert.ExpiryDate+""} ,
                {"D_MATURITY_DATE", ecert.MaturityDate+""} ,
                {"I_STATUS", ecert.Status+""} ,
                {"V_CREATED_BY", ecert.CreatedBy} ,
                {"D_CREATED_ON", ecert.CreatedOn+""} , 
                {"V_OWNER", ecert.Owner}
            }, "da_ecert => Save(bl_ecert ecert)");
        }
        catch (Exception ex)
        {
            _success = false;
            Log.AddExceptionToLog("Error function [Save(bl_ecert ecert)] in class [da_cert] detail:" + ex.StackTrace + " => " + ex.Message);
        }
        
        return _success;
    }

    public static bl_ecert Get(string owner)
    {
        bl_ecert ecert = new bl_ecert();
        try
        {
            DB db = new DB();

            DataTable tbl = db.GetData(AppConfiguration.GetConnectionString(), "SP_TBL_G_CERT_GET", new string[,]{
            
                {"VAR_OWNER", owner}
            }, "da_cert => Get(string owner)");

            if (db.RowEffect < 0)
            {
                _success = false;
                _message = db.Message;
            }
            else {
                _success = true;
                foreach(DataRow r in tbl.Rows)
                {
                    ecert.ID= Convert.ToInt32( r["id"].ToString());
                    ecert.CustomerNameKh = r["customer_name_kh"].ToString();
                    ecert.CustomerNameEn = r["customer_name_en"].ToString();
                    ecert.CustomerGender = r["customer_gender"].ToString();
                    ecert.CustomerDob = Convert.ToDateTime(r["customer_dob"].ToString());
                    ecert.CertificateNumber = r["certificate_number"].ToString();
                    ecert.EffectiveDate = Convert.ToDateTime(r["effective_date"].ToString());
                    ecert.ExpiryDate = Convert.ToDateTime(r["expiry_date"].ToString());
                    ecert.MaturityDate = Convert.ToDateTime(r["maturity_date"].ToString());
                    ecert.Status = Convert.ToInt32(r["status"].ToString());
                    ecert.Owner = r["owner"].ToString();
                }
                
            }
        }
        catch (Exception ex)
        {
            ecert = new bl_ecert();
            _success = false;
            Log.AddExceptionToLog("Error function [Get(string owner)] in class [da_cert] detail:" + ex.StackTrace + " => " + ex.Message);
        }

        return ecert;
    }
}