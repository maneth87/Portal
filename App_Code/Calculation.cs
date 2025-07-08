using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for Calculation
/// </summary>
public class Calculation
{
    #region "Constructor(s)"

    private static Calculation mytitle = null;
    public Calculation()
    {
        if (mytitle == null)
        {
            mytitle = new Calculation();
        }

    }
    #endregion

    #region "Public Functions"
  

    //Calculate premium flexi term
    public static double CalculatePremium(int applicant_age, double sum_insured)
    {
        double myPremium = 0;
       
        string connString = AppConfiguration.GetConnectionString();

        using (SqlConnection con = new SqlConnection(connString))
        {
            SqlCommand cmd = new SqlCommand("SP_Get_fixed_deposit_Premium", con);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@Sum_Insured", sum_insured);
            cmd.Parameters.AddWithValue("@Age", applicant_age);
            
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {

                if (rdr.HasRows)
                {

                    myPremium = Convert.ToDouble(rdr.GetString(rdr.GetOrdinal("Premium")));

                }

            }
            con.Close();

        }

        return myPremium;

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

    //Get Customer Age
    public static int Culculate_Customer_Age(DateTime dob, DateTime compare_date)
    {
              
        TimeSpan mytimespan = compare_date.Subtract(dob);
        int no_of_day = mytimespan.Days;

        //Get leap year count
        int number_of_leap_year = Get_Number_Of_Leap_Year(dob.Year, compare_date.Year);

        double result = (Convert.ToDouble(no_of_day) - Convert.ToDouble(number_of_leap_year)) / 365;

        if (dob.Month.Equals(compare_date.Month) && dob.Day.Equals(compare_date.Day))
        {
            //round .99 age
            double round_result = Math.Ceiling(result);

            //minus rould result 0.1
            double sub_result = round_result - 0.02;

            //if result ~ #.99 then round up
            if (result >= sub_result)
            {
                result = Math.Ceiling(result);
            }
        }
        else
        {
            result = Math.Floor(result);
        }

        int customer_age = Convert.ToInt32(result);

        return customer_age;

    }

  
    #endregion
}