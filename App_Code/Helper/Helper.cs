using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using Microsoft.Reporting.WebForms;
/// <summary>
/// Summary description for Helper
/// </summary>
public class Helper
{
	#region "Constructor(s)"

    private static Helper mytitle = null;
    public Helper()
    {
        if (mytitle == null)
        {
            mytitle = new Helper();
        }

    }
    #endregion

    #region "Public Functions"


    
    private static string conn = ConfigurationManager.ConnectionStrings["ApplicationDBContext"].ConnectionString;
    //
    // TODO: Add constructor logic here
    //

    

    public static DataTable GetData(string query)
    {
        DataTable dt = new DataTable();
        //Dim constr As String = ConfigurationManager.ConnectionStrings("constr").ConnectionString
        using(SqlConnection con = new SqlConnection(conn))
        {
            using(SqlCommand cmd = new SqlCommand(query))
            {
                using(SqlDataAdapter sda = new SqlDataAdapter())
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.Connection = con;
                    sda.SelectCommand = cmd;
                    sda.Fill(dt);
                }
            }
            return dt;
        }
    }
    public static string GetNewGuid(string stored_procedure_name, string paramenter_name)
    {
        Guid myGuid = default(Guid);
        do
        {
            myGuid = Guid.NewGuid();

        } while (CheckGuid(myGuid.ToString().ToUpper(), stored_procedure_name, paramenter_name));

        return myGuid.ToString().ToUpper();
    }

    //Check existing guid id in the table
    public static bool CheckGuid(string myGuid, string stored_procedure_name, string parameter_name)
    {
        string connString = AppConfiguration.GetConnectionString();
        bool result = false;
        using (SqlConnection con = new SqlConnection(connString))
        {
            SqlCommand cmd = new SqlCommand(stored_procedure_name, con);
            cmd.CommandType = CommandType.StoredProcedure;

            SqlParameter paramName1 = new SqlParameter();
            paramName1.ParameterName = parameter_name;
            paramName1.Value = myGuid;
            cmd.Parameters.Add(paramName1);

            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {

                if (rdr.HasRows)
                {

                    result = true; //exist

                }

            }
            rdr.Close();
            con.Close();

        }
        return result;
    }


    //Get Leap Year Count
    public static int Get_Number_Of_Leap_Year(int dob_year, int this_year)
    {

        int number_of_year = 0;
        int i = dob_year;


        while ((i <= this_year))
        {
            if (((i % 4 == 0) && (i % 100 != 0) || (i % 400 == 0)))
            {
                number_of_year += 1;
            }

            i += 1;
        }

        return number_of_year;
    }

    //Check Leap Year
    public static bool Check_Leap_Year(int year)
    {

        bool result = false;

        if (((year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0)))
        {
            result = true;
        }

        return result;
    }

    //Function to check date format
    public static bool CheckDateFormat(string check_date)
    {
        bool valid = true;

        string[] dArr = check_date.Split('/');

        int month = Convert.ToInt32(dArr[1]);
        int day = Convert.ToInt32(dArr[0]);
        int year = Convert.ToInt32(dArr[2].Substring(0, 4));

        //check valid month
        if (month > 12)
        {
            //invalid month
            valid = false;
            //valid month
        }
        else
        {
            //check valid day
            switch (month)
            {
                case 4:
                case 6:
                case 9:
                case 11:
                    //30 days
                    //invalid day
                    if (day > 30)
                    {
                        valid = false;
                    }
                    break;
                case 1:
                case 3:
                case 5:
                case 7:
                case 8:
                case 10:
                case 12:
                    //31 days
                    //invalid day
                    if (day > 31)
                    {
                        valid = false;
                    }
                    break;
                case 2:
                    //check leap year
                    if (Check_Leap_Year(year))
                    {
                        //is leap year
                        //invalid day
                        if (day > 29)
                        {
                            valid = false;
                        }
                    }
                    else
                    {
                        //not leap year
                        //invalid day
                        if (day > 28)
                        {
                            valid = false;
                        }
                    }
                    break;
            }
        }
        return valid;
    }
    
    //Get the first day of the month
    public static DateTime FirstDayOfMonth(DateTime sourceDate)
    {
        return new DateTime(sourceDate.Year, sourceDate.Month, 1);
    }

    //Get the last day of the month
    public static DateTime LastDayOfMonth(DateTime sourceDate)
    {
        DateTime lastDay = new DateTime(sourceDate.Year, sourceDate.Month, 1);
        return lastDay.AddMonths(1).AddDays(-1);
    }

   
    #endregion

    /// <summary>
    /// 
    /// </summary>
    /// <param name="context"></param>
    /// <param name="my_report_viewer"></param>
    /// <param name="file_name"></param>
    /// <param name="download"></param>
    /// <param name="type">[PDF, WORD]</param>
    public static void Export(HttpContext context, ReportViewer my_report_viewer, string file_name, bool download, string type)
    {
        //pdf view
        Warning[] warnings;
        string[] streamIds;
        string mimeType = string.Empty;
        string encoding = string.Empty;
        string extension = string.Empty;

        byte[] bytes = my_report_viewer.LocalReport.Render(type, null, out mimeType, out encoding, out extension, out streamIds, out warnings);
        context.Response.Buffer = true;
        context.Response.Clear();
        context.Response.ContentType = mimeType;

        if (download)
        {
            //client download
            string ext = type == "PDF" ? ".pdf" : type == "WORD" ? ".docx" : type == "EXCEL" ? ".xlsx" : "";
            context.Response.AddHeader("content-disposition", "attachment; filename=" + file_name + type);
        }
        context.Response.BinaryWrite(bytes); // create the file
        context.Response.Flush();

    }
        /// <summary>
    /// Convert RDCL Report to PDF
    /// </summary>
    /// <param name="context"></param>
    /// <param name="my_report_viewer"></param>
    /// <param name="file_name">Only file name without extension</param>
    /// <param name="download">Todownload file set vaule = True</param>
    public static void ExportToPDF(HttpContext context, ReportViewer my_report_viewer, string file_name, bool download)
    {
        //pdf view
        Warning[] warnings;
        string[] streamIds;
        string mimeType = string.Empty;
        string encoding = string.Empty;
        string extension = string.Empty;

        byte[] bytes = my_report_viewer.LocalReport.Render("PDF", null, out mimeType, out encoding, out extension, out streamIds, out warnings);
        context.Response.Buffer = true;
        context.Response.Clear();
        context.Response.ContentType = mimeType;

        if (download)
        {
            //client download
            context.Response.AddHeader("content-disposition", "attachment; filename=" + file_name + ".pdf");
        }
        context.Response.BinaryWrite(bytes); // create the file
        context.Response.Flush();
      
    }

    public static string ShowSuccess(string sms)
    {
        string response = "<div class=\"row\" id=\"dvRow\"> <div class=\"col-md-12\">  <div class=\"alert alert-success\" role=\"alert\"> <h4 class=\"alert-heading\"> <span class=\"glyphicon glyphicon-ok\"></span>&nbsp;&nbsp;Success</h4> <p id=\"pMessage\">" + sms + "</p></div></div></div>";
        return response;
    }
}