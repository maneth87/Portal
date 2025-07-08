using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Services;

/// <summary>
/// Summary description for CalculationWebService
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class CalculationWebService : System.Web.Services.WebService {

    public CalculationWebService () {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    //Get Premium Flexi Term By Customer Age and Sum Insured
    //[WebMethod]
    //public string GetPremium(string sum_insured, string dob)
    //{

    //    DateTimeFormatInfo dtfi = new DateTimeFormatInfo();
    //    dtfi.ShortDatePattern = "dd/MM/yyyy";
    //    dtfi.DateSeparator = "/";

    //    DateTime date_of_birth = Convert.ToDateTime(dob, dtfi);

    //    int customer_age = Calculation.Culculate_Customer_Age(date_of_birth, System.DateTime.Now.AddDays(1));

    //    string Premium = Calculation.CalculatePremium(customer_age, Convert.ToDouble(sum_insured)).ToString();

    //    return Premium;
    //}

    [WebMethod]
    public int GetCustomerAge(string dob, string date_of_entry)
    {
        DateTimeFormatInfo dtfi = new DateTimeFormatInfo();
        dtfi.ShortDatePattern = "dd/MM/yyyy";
        dtfi.DateSeparator = "/";

        DateTime my_date_of_entry = System.DateTime.Now;
        DateTime my_date_of_birth = System.DateTime.Now;

        //if (date_of_entry != "")
        //{
        //    my_date_of_entry = Convert.ToDateTime(date_of_entry, dtfi);
        //}

        if (dob != "")
        {
            my_date_of_birth = Convert.ToDateTime(dob, dtfi);
        }

        int customer_age = Calculation.Culculate_Customer_Age(my_date_of_birth, my_date_of_entry);
        return customer_age;
    }

    //Get Premium Flexi Term By effective date, maturity date and Sum Insured
    [WebMethod]
    public string GetPremium(string sum_insured, string effective_date, string maturity_date)
    {

        DateTimeFormatInfo dtfi = new DateTimeFormatInfo();
        dtfi.ShortDatePattern = "dd/MM/yyyy";
        dtfi.DateSeparator = "/";
        string Premium = "0";

        if (effective_date != "" && maturity_date != "" && maturity_date != "undefined")
        {
            DateTime datEffectiveDate = DateTime.ParseExact(effective_date, "dd/MM/yyyy", CultureInfo.InvariantCulture);
            DateTime datMaturityDate = DateTime.ParseExact(maturity_date, "dd/MM/yyyy", CultureInfo.InvariantCulture);

            int intDays = datMaturityDate.Subtract(datEffectiveDate).Days;

            double dblPremium = Math.Round(double.Parse(sum_insured) * 0.005 * intDays / 365, 2);

            Premium = dblPremium.ToString();
        }


        return Premium;
    }

    //Get Premium Flexi Term By Customer Age and Sum Insured
    [WebMethod]
    public string GetSumInsured(string customer_id, string fixed_deposit_amount)
    {

        bl_fixed_deposit_primary_data fixed_deposit_primary_data = new bl_fixed_deposit_primary_data();
        double dblSumInsuredPerLife = 20000;
        string SumInsured= "";
        try
        {
            if (customer_id != "")
            {
                double TotalSumInsured = da_fixed_deposit_primary_data.GetTotalSumInsuredFixedDepositPrimaryDataByCustomerID(customer_id);
                double dblFixedDepositAmount = double.Parse(fixed_deposit_amount);

                if (TotalSumInsured > 0)
                {
                    double dblRemainSumInsured = dblSumInsuredPerLife - TotalSumInsured;
                    if (dblRemainSumInsured > dblFixedDepositAmount)
                    {
                        SumInsured = dblFixedDepositAmount.ToString();
                    }
                    else
                    {
                        SumInsured = dblRemainSumInsured.ToString();
                    }
                }
                else
                {
                    SumInsured = dblFixedDepositAmount > dblSumInsuredPerLife ? dblSumInsuredPerLife.ToString() : dblFixedDepositAmount.ToString();
                }
            }
        }
        catch
        { 
           
        }
        


        return SumInsured;
    }
   
}
