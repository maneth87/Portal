using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;

/// <summary>
/// Summary description for da_fixed_deposit_primary_data
/// </summary>
public class da_fixed_deposit_primary_data
{
    private static da_fixed_deposit_primary_data mytitle = null;

    #region "Constructors"

    public da_fixed_deposit_primary_data()
    {
        if (mytitle == null)
        {
            mytitle = new da_fixed_deposit_primary_data();
        }
    }

    #endregion

    #region "Public Functions"

    //Insert new flexi term primary data
    public static bool InsertFlexiTermPrimaryData(bl_fixed_deposit_primary_data fixed_deposit_primary_data)
    {
        bool result = false;

        string connString = AppConfiguration.GetConnectionString();
        using (SqlConnection con = new SqlConnection(connString))
        {
            SqlCommand cmd = new SqlCommand();
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "SP_Insert_fixed_deposit_Primary_Data";

            //get new primary key for the row to be inserted
            fixed_deposit_primary_data.fixed_deposit_Primary_Data_ID = Helper.GetNewGuid("SP_Check_fixed_deposit_Primary_Data_ID", "@fixed_deposit_Primary_Data_ID").ToString();
            
            cmd.Parameters.AddWithValue("@fixed_deposit_Primary_Data_ID", fixed_deposit_primary_data.fixed_deposit_Primary_Data_ID);
            cmd.Parameters.AddWithValue("@Age_Insured", fixed_deposit_primary_data.Age_Insured);
            cmd.Parameters.AddWithValue("@Assure_Up_To_Age", fixed_deposit_primary_data.Assure_Up_To_Age);
            cmd.Parameters.AddWithValue("@Effective_Date", fixed_deposit_primary_data.Effective_Date);
            cmd.Parameters.AddWithValue("@Maturity_Date", fixed_deposit_primary_data.Maturity_Date);
            cmd.Parameters.AddWithValue("@Agreement_Date", fixed_deposit_primary_data.Agreement_Date);
            cmd.Parameters.AddWithValue("@Issue_Date", fixed_deposit_primary_data.Issue_Date);
            cmd.Parameters.AddWithValue("@Maturity_Month", fixed_deposit_primary_data.Maturity_Month);
            cmd.Parameters.AddWithValue("@Assure_Year", fixed_deposit_primary_data.Assure_Year);
            cmd.Parameters.AddWithValue("@Bank_Number", fixed_deposit_primary_data.Bank_Number);
            cmd.Parameters.AddWithValue("@Prev_Bank_Number", fixed_deposit_primary_data.Prev_Bank_Number);
            cmd.Parameters.AddWithValue("@Customer_ID", fixed_deposit_primary_data.Customer_ID);
            cmd.Parameters.AddWithValue("@Branch", fixed_deposit_primary_data.Branch);
            cmd.Parameters.AddWithValue("@Channel_Channel_Item_ID", fixed_deposit_primary_data.Channel_Channel_Item_ID);
            cmd.Parameters.AddWithValue("@Channel_Location_ID", fixed_deposit_primary_data.Channel_Location_ID);
            cmd.Parameters.AddWithValue("@Created_On", fixed_deposit_primary_data.Created_On);
            cmd.Parameters.AddWithValue("@Created_By", fixed_deposit_primary_data.Created_By);
            cmd.Parameters.AddWithValue("@Created_Note", fixed_deposit_primary_data.Created_Note);
            cmd.Parameters.AddWithValue("@DOB", fixed_deposit_primary_data.DOB);
            cmd.Parameters.AddWithValue("@Expiry_Date", fixed_deposit_primary_data.Expiry_Date);
            cmd.Parameters.AddWithValue("@First_Name", fixed_deposit_primary_data.First_Name);
            cmd.Parameters.AddWithValue("@ID_Card", fixed_deposit_primary_data.ID_Card);
            cmd.Parameters.AddWithValue("@ID_Type", fixed_deposit_primary_data.ID_Type);
            cmd.Parameters.AddWithValue("@Last_Name", fixed_deposit_primary_data.Last_Name);
            cmd.Parameters.AddWithValue("@Pay_Up_To_Age", fixed_deposit_primary_data.Pay_Up_To_Age);
            cmd.Parameters.AddWithValue("@Pay_Year", fixed_deposit_primary_data.Pay_Year);
            cmd.Parameters.AddWithValue("@Premium", fixed_deposit_primary_data.Premium);
            cmd.Parameters.AddWithValue("@Deposit_Amount", fixed_deposit_primary_data.Deposit_Amount);
            cmd.Parameters.AddWithValue("@Sum_Insured", fixed_deposit_primary_data.Sum_Insured);
            cmd.Parameters.AddWithValue("@Status_Code", fixed_deposit_primary_data.Status_Code);

            cmd.Parameters.AddWithValue("@Updated_By", fixed_deposit_primary_data.Updated_By);
            cmd.Parameters.AddWithValue("@Updated_On", fixed_deposit_primary_data.Updated_On);
            cmd.Parameters.AddWithValue("@Approved_By", fixed_deposit_primary_data.Approved_By);
            cmd.Parameters.AddWithValue("@Approved_On", fixed_deposit_primary_data.Approved_On);
            cmd.Parameters.AddWithValue("@Is_Update", fixed_deposit_primary_data.Is_Update);

            cmd.Parameters.AddWithValue("@Gender", fixed_deposit_primary_data.Gender);
            cmd.Parameters.AddWithValue("@Application_Resident", fixed_deposit_primary_data.Application_Resident);

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
                Log.AddExceptionToLog("Error in function [InsertFlexiTermPrimaryData] in class [da_fixed_deposit_primary_data]. Details: " + ex.Message);
            }
        }
        return result;
    }

    //Delete Ct_App_Register
    public static bool DeleteFlexiTermPrimaryData(string fixed_deposit_Primary_Data_ID)
    {
        bool result = false;
        string connString = AppConfiguration.GetConnectionString();
        using (SqlConnection con = new SqlConnection(connString))
        {
            SqlCommand cmd = new SqlCommand();
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "SP_Delete_fixed_deposit_Primary_Data";

            cmd.Parameters.AddWithValue("@fixed_deposit_Primary_Data_ID", fixed_deposit_Primary_Data_ID);

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
                con.Close();
                Log.AddExceptionToLog("Error in function [DeleteFlexiTermPrimaryData] in class [da_fixed_deposit_primary_data]. Details: " + ex.Message);
            }
        }
        return result;
    }

    //Function to get flexi term primary data list by params
    public static List<bl_fixed_deposit_primary_data> GetFlexiTermPrimaryDataListByParams(string by_branch, string by_company, string bank_no, DateTime from_date, DateTime to_date, string status_code)
    {
        List<bl_fixed_deposit_primary_data> fixed_deposit_primary_data_list = new List<bl_fixed_deposit_primary_data>();

        string connString = AppConfiguration.GetConnectionString();

        using (SqlConnection con = new SqlConnection(connString))
        {
            string sql = "";

            //From Date To Date
            if (from_date != DateTime.Parse("01/01/1900") && to_date != DateTime.Parse("01/01/1900"))
            {
                sql = @"select * from V_Report_Primary_Data where 
                                convert(VARCHAR, V_Report_Primary_Data.Created_On, 110) between @from_date and @to_date";
            }
            else
            {
                sql = @"select * from V_Report_Primary_Data where V_Report_Primary_Data.fixed_deposit_primary_data_id != '' ";

            }

            sql += "  and V_Report_Primary_Data.Status_Code = 'Approved' ";

            //Bank no
            if (bank_no != "")
            {
                sql += " And V_Report_Primary_Data.Bank_Number = @Bank_Number ";
            }

            //by_branch
            if(by_branch != ""){
                sql += " And V_Report_Primary_Data.Channel_Location_ID = @Channel_Location_ID ";
            }
           
            ////by_company
            //if (by_company != "")
            //{
            //    sql += " And V_Report_Primary_Data.Channel_Item_ID = @Channel_Item_ID ";
            //}

            //status_code
            if (status_code != "")
            {

                if (status_code == "Both")
                {

                    sql += " And V_Report_Primary_Data.Status_Code = 'Pending' OR V_Report_Primary_Data.Status_Code = 'Updated'";

                }
                else
                {

                    sql += " And V_Report_Primary_Data.Status_Code = @Status_Code ";
                }
            }



            sql += " order by Effective_Date ASC, Branch ASC, Bank_Number ASC, Approved_On ASC ";

            SqlCommand cmd = new SqlCommand(sql, con);
            
            cmd.CommandText = sql;

            if (from_date != DateTime.Parse("01/01/1900") && to_date != DateTime.Parse("01/01/1900"))
            {               

                cmd.Parameters.AddWithValue("@from_date", from_date.ToString("MM-dd-yyyy"));
                cmd.Parameters.AddWithValue("@to_date", to_date.ToString("MM-dd-yyyy"));
            }

            if (bank_no != "")
            {
                cmd.Parameters.AddWithValue("@Bank_Number", bank_no);
            }

            if (by_branch != "")
            {
                cmd.Parameters.AddWithValue("@Channel_Location_ID", by_branch);
            }

            //if (by_company != "")
            //{
            //    cmd.Parameters.AddWithValue("@Channel_Item_ID", by_company);
            //}

            if (status_code != "")
            {
                cmd.Parameters.AddWithValue("@Status_Code", status_code);
            }
            
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
          
            while (rdr.Read())
            {

                if (rdr.HasRows)
                {
                    bl_fixed_deposit_primary_data fixed_deposit_primary_data = new bl_fixed_deposit_primary_data();

                    fixed_deposit_primary_data.fixed_deposit_Primary_Data_ID = rdr.GetString(rdr.GetOrdinal("fixed_deposit_Primary_Data_ID"));
                    fixed_deposit_primary_data.Bank_Number = rdr.GetString(rdr.GetOrdinal("Bank_Number"));

                    fixed_deposit_primary_data.Customer_ID = rdr.GetString(rdr.GetOrdinal("Customer_ID"));
                    fixed_deposit_primary_data.Branch = rdr.GetString(rdr.GetOrdinal("Branch"));
                    fixed_deposit_primary_data.Branch_Name = rdr.GetString(rdr.GetOrdinal("Branch_Name"));
                    fixed_deposit_primary_data.Channel_Location_ID = rdr.GetString(rdr.GetOrdinal("Channel_Location_ID"));
                    
                    //Get Company
                    string channel_item_id = da_channel.GetChannelItemIDByChannelLocationID(fixed_deposit_primary_data.Channel_Location_ID);
                    fixed_deposit_primary_data.Company = da_channel.GetChannelItemNameByID(channel_item_id);

                    fixed_deposit_primary_data.Created_On = rdr.GetDateTime(rdr.GetOrdinal("Created_On"));
                    fixed_deposit_primary_data.Created_By = rdr.GetString(rdr.GetOrdinal("Created_By"));
                    fixed_deposit_primary_data.DOB = rdr.GetDateTime(rdr.GetOrdinal("DOB"));
                    fixed_deposit_primary_data.Effective_Date = rdr.GetDateTime(rdr.GetOrdinal("Effective_Date"));
                    fixed_deposit_primary_data.Maturity_Date = rdr.GetDateTime(rdr.GetOrdinal("Maturity_Date"));
                    fixed_deposit_primary_data.Issue_Date = rdr.GetDateTime(rdr.GetOrdinal("Issue_Date"));
                    fixed_deposit_primary_data.Status_Code = rdr.GetString(rdr.GetOrdinal("Status_Code"));
                    fixed_deposit_primary_data.ID_Type = rdr.GetInt32(rdr.GetOrdinal("ID_Type"));


                    fixed_deposit_primary_data.Updated_On = rdr.GetDateTime(rdr.GetOrdinal("Updated_On"));
                    fixed_deposit_primary_data.Updated_By = rdr.GetString(rdr.GetOrdinal("Updated_By"));
                    fixed_deposit_primary_data.Is_Update = rdr.GetInt32(rdr.GetOrdinal("Is_Update"));
                    fixed_deposit_primary_data.Approved_On = rdr.GetDateTime(rdr.GetOrdinal("Approved_On"));
                    fixed_deposit_primary_data.Approved_By = rdr.GetString(rdr.GetOrdinal("Approved_By"));

                    switch (fixed_deposit_primary_data.ID_Type)
                    {
                        case 0:
                            fixed_deposit_primary_data.Str_ID_Type = "I.D Card";
                            break;
                        case 1:
                            fixed_deposit_primary_data.Str_ID_Type = "Passport";
                            break;
                        case 2:
                            fixed_deposit_primary_data.Str_ID_Type = "Visa";
                            break;
                        case 3:
                            fixed_deposit_primary_data.Str_ID_Type = "Birth Certificate";
                            break;
                        case 4:
                            fixed_deposit_primary_data.Str_ID_Type = "Police / Civil Service Card";
                            break;
                        case 5:
                            fixed_deposit_primary_data.Str_ID_Type = "Employment Book";
                            break;
                        case 6:
                            fixed_deposit_primary_data.Str_ID_Type = "Residential Book";
                            break;
                        default:
                            fixed_deposit_primary_data.Str_ID_Type = "";
                            break;
                    }//End switch

                    fixed_deposit_primary_data.First_Name = rdr.GetString(rdr.GetOrdinal("First_Name"));
                    fixed_deposit_primary_data.ID_Card = rdr.GetString(rdr.GetOrdinal("ID_Card"));
                    fixed_deposit_primary_data.Last_Name = rdr.GetString(rdr.GetOrdinal("Last_Name"));
                    fixed_deposit_primary_data.Premium = rdr.GetDouble(rdr.GetOrdinal("Premium"));
                    fixed_deposit_primary_data.Sum_Insured = rdr.GetDouble(rdr.GetOrdinal("Sum_Insured"));

                    fixed_deposit_primary_data.Gender = rdr.GetInt32(rdr.GetOrdinal("Gender"));

                    if (fixed_deposit_primary_data.Gender == 1)
                    {
                        fixed_deposit_primary_data.Str_Gender = "M"; //Male
                    }
                    else if(fixed_deposit_primary_data.Gender == 0)
                    {
                        fixed_deposit_primary_data.Str_Gender = "F"; //Female
                    }

                    fixed_deposit_primary_data.Application_Resident = rdr.GetInt32(rdr.GetOrdinal("Application_Resident"));

                    if (fixed_deposit_primary_data.Application_Resident == 1)
                    {
                        fixed_deposit_primary_data.Str_Application_Resident = "Y"; //Yes
                    }
                    else if (fixed_deposit_primary_data.Application_Resident == 0)
                    {
                        fixed_deposit_primary_data.Str_Application_Resident = "N"; //No
                    }

                    //fixed_deposit_primary_data.Family_Book = rdr.GetString(rdr.GetOrdinal("Family_Book"));

                    //fixed_deposit_primary_data.Str_Family_Book = fixed_deposit_primary_data.Family_Book;

                    

                
                    fixed_deposit_primary_data_list.Add(fixed_deposit_primary_data);

                }//End Read

            }
            con.Close();
        }
        return fixed_deposit_primary_data_list;
    }

    //Function to get flexi term primary data list by params
    public static List<bl_fixed_deposit_primary_data> GetFlexiTermPrimaryDataListDetailByParams(string by_branch, string by_company, string bank_no, DateTime from_date, DateTime to_date, string status_code)
    {
        List<bl_fixed_deposit_primary_data> fixed_deposit_primary_data_list = new List<bl_fixed_deposit_primary_data>();

        string connString = AppConfiguration.GetConnectionString();

        using (SqlConnection con = new SqlConnection(connString))
        {
            string sql = "";

            //From Date To Date
            if (from_date != DateTime.Parse("01/01/1900") && to_date != DateTime.Parse("01/01/1900"))
            {
                sql = @"select * from V_Report_Detail_Primary_Data where 
                                convert(VARCHAR, V_Report_Detail_Primary_Data.Created_On, 110) between @from_date and @to_date";
            }
            else
            {
                sql = @"select * from V_Report_Primary_Data where V_Report_Primary_Data.fixed_deposit_primary_data_id != '' ";

            }

            sql += "  and V_Report_Detail_Primary_Data.Status_Code = 'Approved' ";

            //Bank no
            if (bank_no != "")
            {
                sql += " And V_Report_Detail_Primary_Data.Bank_Number = @Bank_Number ";
            }

            //by_branch
            if (by_branch != "")
            {
                sql += " And V_Report_Detail_Primary_Data.Channel_Location_ID = @Channel_Location_ID ";
            }

            ////by_company
            //if (by_company != "")
            //{
            //    sql += " And V_Report_Detail_Primary_Data.Channel_Item_ID = @Channel_Item_ID ";
            //}

            //status_code
            if (status_code != "")
            {

                if (status_code == "Both")
                {

                    sql += " And V_Report_Detail_Primary_Data.Status_Code = 'Pending' OR V_Report_Detail_Primary_Data.Status_Code = 'Updated'";

                }
                else
                {

                    sql += " And V_Report_Detail_Primary_Data.Status_Code = @Status_Code ";
                }
            }



            sql += " order by Effective_Date ASC, Branch ASC, Bank_Number ASC, Approved_On ASC ";

            SqlCommand cmd = new SqlCommand(sql, con);

            cmd.CommandText = sql;

            if (from_date != DateTime.Parse("01/01/1900") && to_date != DateTime.Parse("01/01/1900"))
            {

                cmd.Parameters.AddWithValue("@from_date", from_date.ToString("MM-dd-yyyy"));
                cmd.Parameters.AddWithValue("@to_date", to_date.ToString("MM-dd-yyyy"));
            }

            if (bank_no != "")
            {
                cmd.Parameters.AddWithValue("@Bank_Number", bank_no);
            }

            if (by_branch != "")
            {
                cmd.Parameters.AddWithValue("@Channel_Location_ID", by_branch);
            }

            //if (by_company != "")
            //{
            //    cmd.Parameters.AddWithValue("@Channel_Item_ID", by_company);
            //}

            if (status_code != "")
            {
                cmd.Parameters.AddWithValue("@Status_Code", status_code);
            }

            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();

            while (rdr.Read())
            {

                if (rdr.HasRows)
                {
                    bl_fixed_deposit_primary_data fixed_deposit_primary_data = new bl_fixed_deposit_primary_data();

                    fixed_deposit_primary_data.fixed_deposit_Primary_Data_ID = rdr.GetString(rdr.GetOrdinal("fixed_deposit_Primary_Data_ID"));
                    fixed_deposit_primary_data.Bank_Number = rdr.GetString(rdr.GetOrdinal("Bank_Number"));
                    fixed_deposit_primary_data.Customer_ID = rdr.GetString(rdr.GetOrdinal("Customer_ID"));
                    fixed_deposit_primary_data.Branch = rdr.GetString(rdr.GetOrdinal("Branch"));
                    fixed_deposit_primary_data.Channel_Location_ID = rdr.GetString(rdr.GetOrdinal("Channel_Location_ID"));

                    //Get Company
                    string channel_item_id = da_channel.GetChannelItemIDByChannelLocationID(fixed_deposit_primary_data.Channel_Location_ID);
                    fixed_deposit_primary_data.Company = da_channel.GetChannelItemNameByID(channel_item_id);

                    fixed_deposit_primary_data.Created_On = rdr.GetDateTime(rdr.GetOrdinal("Created_On"));
                    fixed_deposit_primary_data.Created_By = rdr.GetString(rdr.GetOrdinal("Created_By"));
                    fixed_deposit_primary_data.DOB = rdr.GetDateTime(rdr.GetOrdinal("DOB"));
                    fixed_deposit_primary_data.Effective_Date = rdr.GetDateTime(rdr.GetOrdinal("Effective_Date"));
                    fixed_deposit_primary_data.Maturity_Date = rdr.GetDateTime(rdr.GetOrdinal("Maturity_Date"));
                    fixed_deposit_primary_data.Issue_Date = rdr.GetDateTime(rdr.GetOrdinal("Issue_Date"));
                    fixed_deposit_primary_data.Status_Code = rdr.GetString(rdr.GetOrdinal("Status_Code"));
                    fixed_deposit_primary_data.ID_Type = rdr.GetInt32(rdr.GetOrdinal("ID_Type"));


                    fixed_deposit_primary_data.Updated_On = rdr.GetDateTime(rdr.GetOrdinal("Updated_On"));
                    fixed_deposit_primary_data.Updated_By = rdr.GetString(rdr.GetOrdinal("Updated_By"));
                    fixed_deposit_primary_data.Is_Update = rdr.GetInt32(rdr.GetOrdinal("Is_Update"));
                    fixed_deposit_primary_data.Approved_On = rdr.GetDateTime(rdr.GetOrdinal("Approved_On"));
                    fixed_deposit_primary_data.Approved_By = rdr.GetString(rdr.GetOrdinal("Approved_By"));

                    switch (fixed_deposit_primary_data.ID_Type)
                    {
                        case 0:
                            fixed_deposit_primary_data.Str_ID_Type = "I.D Card";
                            break;
                        case 1:
                            fixed_deposit_primary_data.Str_ID_Type = "Passport";
                            break;
                        case 2:
                            fixed_deposit_primary_data.Str_ID_Type = "Visa";
                            break;
                        case 3:
                            fixed_deposit_primary_data.Str_ID_Type = "Birth Certificate";
                            break;
                        case 4:
                            fixed_deposit_primary_data.Str_ID_Type = "Police / Civil Service Card";
                            break;
                        case 5:
                            fixed_deposit_primary_data.Str_ID_Type = "Employment Book";
                            break;
                        case 6:
                            fixed_deposit_primary_data.Str_ID_Type = "Residential Book";
                            break;
                        default:
                            fixed_deposit_primary_data.Str_ID_Type = "";
                            break;
                    }//End switch

                    fixed_deposit_primary_data.First_Name = rdr.GetString(rdr.GetOrdinal("First_Name"));
                    fixed_deposit_primary_data.ID_Card = rdr.GetString(rdr.GetOrdinal("ID_Card"));
                    fixed_deposit_primary_data.Last_Name = rdr.GetString(rdr.GetOrdinal("Last_Name"));
                    fixed_deposit_primary_data.Premium = rdr.GetDouble(rdr.GetOrdinal("Premium"));
                    fixed_deposit_primary_data.Sum_Insured = rdr.GetDouble(rdr.GetOrdinal("Sum_Insured"));

                    fixed_deposit_primary_data.Gender = rdr.GetInt32(rdr.GetOrdinal("Gender"));

                    if (fixed_deposit_primary_data.Gender == 1)
                    {
                        fixed_deposit_primary_data.Str_Gender = "M"; //Male
                    }
                    else if (fixed_deposit_primary_data.Gender == 0)
                    {
                        fixed_deposit_primary_data.Str_Gender = "F"; //Female
                    }

                    fixed_deposit_primary_data.Application_Resident = rdr.GetInt32(rdr.GetOrdinal("Application_Resident"));

                    if (fixed_deposit_primary_data.Application_Resident == 1)
                    {
                        fixed_deposit_primary_data.Str_Application_Resident = "Y"; //Yes
                    }
                    else if (fixed_deposit_primary_data.Application_Resident == 0)
                    {
                        fixed_deposit_primary_data.Str_Application_Resident = "N"; //No
                    }

                    //fixed_deposit_primary_data.Family_Book = rdr.GetString(rdr.GetOrdinal("Family_Book"));

                    //fixed_deposit_primary_data.Str_Family_Book = fixed_deposit_primary_data.Family_Book;

                    

                    fixed_deposit_primary_data.Beneficiary_Full_Name = rdr.GetString(rdr.GetOrdinal("Benefit_Full_Name"));

                    fixed_deposit_primary_data.Beneficiary_ID_Type = rdr.GetInt32(rdr.GetOrdinal("Benefit_ID_Type"));
                    fixed_deposit_primary_data.Beneficiary_ID_Card = rdr.GetString(rdr.GetOrdinal("Benefit_ID_Card"));

                    switch (fixed_deposit_primary_data.Beneficiary_ID_Type)
                    {
                        case 0:
                            fixed_deposit_primary_data.Str_Beneficiary_ID_Type = "I.D Card";
                            break;
                        case 1:
                            fixed_deposit_primary_data.Str_Beneficiary_ID_Type = "Passport";
                            break;
                        case 2:
                            fixed_deposit_primary_data.Str_Beneficiary_ID_Type = "Visa";
                            break;
                        case 3:
                            fixed_deposit_primary_data.Str_Beneficiary_ID_Type = "Birth Certificate";
                            break;
                        case 4:
                            fixed_deposit_primary_data.Str_Beneficiary_ID_Type = "Police / Civil Service Card";
                            break;
                        case 5:
                            fixed_deposit_primary_data.Str_Beneficiary_ID_Type = "Employment Book";
                            break;
                        case 6:
                            fixed_deposit_primary_data.Str_Beneficiary_ID_Type = "Residential Book";
                            break;
                        default:
                            fixed_deposit_primary_data.Str_Beneficiary_ID_Type = "";
                            break;
                    }//End switch

                    fixed_deposit_primary_data.Beneficiary_Relationship = rdr.GetString(rdr.GetOrdinal("Benefit_Relationship"));
                    fixed_deposit_primary_data.Benefits = rdr.GetDouble(rdr.GetOrdinal("Benefit_Percentage"));


                    fixed_deposit_primary_data_list.Add(fixed_deposit_primary_data);

                }//End Read

            }
            con.Close();
        }
        return fixed_deposit_primary_data_list;
    }

    //Update Ct_fixed_deposit_Primary_Data
    public static bool UpdateFlexiTermPrimaryData(bl_fixed_deposit_primary_data fixed_deposit_primary_data)
    {
        bool result = false;
        string connString = AppConfiguration.GetConnectionString();
        using (SqlConnection con = new SqlConnection(connString))
        {
            SqlCommand cmd = new SqlCommand();
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "SP_Update_fixed_deposit_Primary_Data";

            cmd.Parameters.AddWithValue("@fixed_deposit_Primary_Data_ID", fixed_deposit_primary_data.fixed_deposit_Primary_Data_ID);
            cmd.Parameters.AddWithValue("@Age_Insured", fixed_deposit_primary_data.Age_Insured);
            cmd.Parameters.AddWithValue("@Assure_Up_To_Age", fixed_deposit_primary_data.Assure_Up_To_Age);
            cmd.Parameters.AddWithValue("@Bank_Number", fixed_deposit_primary_data.Bank_Number);
            cmd.Parameters.AddWithValue("@DOB", fixed_deposit_primary_data.DOB);
            cmd.Parameters.AddWithValue("@First_Name", fixed_deposit_primary_data.First_Name);
            cmd.Parameters.AddWithValue("@ID_Card", fixed_deposit_primary_data.ID_Card);
            cmd.Parameters.AddWithValue("@ID_Type", fixed_deposit_primary_data.ID_Type);
            cmd.Parameters.AddWithValue("@Last_Name", fixed_deposit_primary_data.Last_Name);
            cmd.Parameters.AddWithValue("@Premium", fixed_deposit_primary_data.Premium);
            cmd.Parameters.AddWithValue("@Sum_Insured", fixed_deposit_primary_data.Sum_Insured);

            cmd.Parameters.AddWithValue("@Updated_By", fixed_deposit_primary_data.Updated_By);
            cmd.Parameters.AddWithValue("@Updated_On", fixed_deposit_primary_data.Updated_On);
            cmd.Parameters.AddWithValue("@Is_Update", fixed_deposit_primary_data.Is_Update);

            cmd.Parameters.AddWithValue("@Gender", fixed_deposit_primary_data.Gender);
            cmd.Parameters.AddWithValue("@Application_Resident", fixed_deposit_primary_data.Application_Resident);
            cmd.Parameters.AddWithValue("@Status_Code", fixed_deposit_primary_data.Status_Code);

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
                con.Close();
                //Add error to log 
                Log.AddExceptionToLog("Error in function [UpdateFlexiTermPrimaryData] in class [da_fixed_deposit_primary_data]. Details: " + ex.Message);
            }
        }
        return result;
    }

    //Update Ct_fixed_deposit_Primary_Data to approve this application
    public static bool UpdateFlexiTermPrimaryDataStatusCodeForApprove(string fixed_deposit_primary_data_id, string status_code, string approve_by, DateTime approved_on)
    {
        bool result = false;
        string connString = AppConfiguration.GetConnectionString();
        using (SqlConnection con = new SqlConnection(connString))
        {
            SqlCommand cmd = new SqlCommand();
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "SP_Update_fixed_deposit_Primary_Data_Status_Code_For_Approve";

            cmd.Parameters.AddWithValue("@fixed_deposit_Primary_Data_ID", fixed_deposit_primary_data_id);

            cmd.Parameters.AddWithValue("@Status_Code", status_code);
            cmd.Parameters.AddWithValue("@Approved_By", approve_by);
            cmd.Parameters.AddWithValue("@Approved_On", approved_on);

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
                con.Close();
                //Add error to log 
                Log.AddExceptionToLog("Error in function [UpdateFlexiTermPrimaryDataStatusCodeForApprove] in class [da_fixed_deposit_primary_data]. Details: " + ex.Message);
            }
        }
        return result;
    }

    public static double GetTotalSumInsuredFixedDepositPrimaryDataByCustomerID(string customer_id)
    {
        double dblTotalSumInsured = 0;
        string connString = AppConfiguration.GetConnectionString();

        using (SqlConnection con = new SqlConnection(connString))
        {
            string sql = "";
            SqlCommand cmd = new SqlCommand(sql, con);
            sql = @"SELECT ISNULL(Sum(Sum_Insured),0) as TotalSumInsured  From Ct_Fixed_Deposit_Primary_Data where Customer_ID = @CustomerID AND Maturity_Date > GETDATE() ";


            cmd.Parameters.AddWithValue("@CustomerID", customer_id);
            cmd.CommandText = sql;

            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {

                if (rdr.HasRows)
                {
                    dblTotalSumInsured += rdr.GetDouble(rdr.GetOrdinal("TotalSumInsured"));
                }
            }
        }

        return dblTotalSumInsured;

    }

    //Function to get flexi term primary data list for print to camlife
    public static List<bl_fixed_deposit_primary_data> GetFlexiTermPrimaryDataList(string channel_location_id, string user_role)
    {
        List<bl_fixed_deposit_primary_data> fixed_deposit_primary_data_list = new List<bl_fixed_deposit_primary_data>();

        string connString = AppConfiguration.GetConnectionString();

        using (SqlConnection con = new SqlConnection(connString))
        {
            string sql = "";
            SqlCommand cmd = new SqlCommand(sql, con);

            sql = @"select top 20 * from V_Report_Primary_Data where V_Report_Primary_Data.fixed_deposit_primary_data_id != ''  and V_Report_Primary_Data.Status_Code = 'Approved' ";
          
            //User Roles
            if (user_role == "External Sale Branch Manager" || user_role == "External Sale Approver" || user_role == "External Sale Operator")
            {
                sql += " And V_Report_Primary_Data.Channel_Location_ID = @Channel_Location_ID ";
                cmd.Parameters.AddWithValue("@Channel_Location_ID", channel_location_id);
            }

            sql += " order by Effective_Date ASC, Branch ASC, Bank_Number ASC, Approved_On ASC ";

            cmd.CommandText = sql;

            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();

            while (rdr.Read())
            {

                if (rdr.HasRows)
                {
                    bl_fixed_deposit_primary_data fixed_deposit_primary_data = new bl_fixed_deposit_primary_data();

                    fixed_deposit_primary_data.fixed_deposit_Primary_Data_ID = rdr.GetString(rdr.GetOrdinal("fixed_deposit_Primary_Data_ID"));
                    fixed_deposit_primary_data.Bank_Number = rdr.GetString(rdr.GetOrdinal("Bank_Number"));
                    fixed_deposit_primary_data.Branch = rdr.GetString(rdr.GetOrdinal("Branch"));
                    fixed_deposit_primary_data.Channel_Location_ID = rdr.GetString(rdr.GetOrdinal("Channel_Location_ID"));

                    //Get Company
                    string channel_item_id = da_channel.GetChannelItemIDByChannelLocationID(fixed_deposit_primary_data.Channel_Location_ID);
                    fixed_deposit_primary_data.Company = da_channel.GetChannelItemNameByID(channel_item_id);

                    fixed_deposit_primary_data.Created_On = rdr.GetDateTime(rdr.GetOrdinal("Created_On"));
                    fixed_deposit_primary_data.Created_By = rdr.GetString(rdr.GetOrdinal("Created_By"));
                    fixed_deposit_primary_data.DOB = rdr.GetDateTime(rdr.GetOrdinal("DOB"));
                    fixed_deposit_primary_data.Effective_Date = rdr.GetDateTime(rdr.GetOrdinal("Effective_Date"));
                    fixed_deposit_primary_data.Maturity_Date = rdr.GetDateTime(rdr.GetOrdinal("Maturity_Date"));
                    fixed_deposit_primary_data.Issue_Date = rdr.GetDateTime(rdr.GetOrdinal("Issue_Date"));
                    fixed_deposit_primary_data.Status_Code = rdr.GetString(rdr.GetOrdinal("Status_Code"));
                    fixed_deposit_primary_data.ID_Type = rdr.GetInt32(rdr.GetOrdinal("ID_Type"));


                    fixed_deposit_primary_data.Updated_On = rdr.GetDateTime(rdr.GetOrdinal("Updated_On"));
                    fixed_deposit_primary_data.Updated_By = rdr.GetString(rdr.GetOrdinal("Updated_By"));
                    fixed_deposit_primary_data.Is_Update = rdr.GetInt32(rdr.GetOrdinal("Is_Update"));
                    fixed_deposit_primary_data.Approved_On = rdr.GetDateTime(rdr.GetOrdinal("Approved_On"));
                    fixed_deposit_primary_data.Approved_By = rdr.GetString(rdr.GetOrdinal("Approved_By"));

                    switch (fixed_deposit_primary_data.ID_Type)
                    {
                        case 0:
                            fixed_deposit_primary_data.Str_ID_Type = "I.D Card";
                            break;
                        case 1:
                            fixed_deposit_primary_data.Str_ID_Type = "Passport";
                            break;
                        case 2:
                            fixed_deposit_primary_data.Str_ID_Type = "Visa";
                            break;
                        case 3:
                            fixed_deposit_primary_data.Str_ID_Type = "Birth Certificate";
                            break;
                        case 4:
                            fixed_deposit_primary_data.Str_ID_Type = "Police / Civil Service Card";
                            break;
                        case 5:
                            fixed_deposit_primary_data.Str_ID_Type = "Employment Book";
                            break;
                        case 6:
                            fixed_deposit_primary_data.Str_ID_Type = "Residential Book";
                            break;
                        default:
                            fixed_deposit_primary_data.Str_ID_Type = "";
                            break;
                    }//End switch

                    fixed_deposit_primary_data.First_Name = rdr.GetString(rdr.GetOrdinal("First_Name"));
                    fixed_deposit_primary_data.ID_Card = rdr.GetString(rdr.GetOrdinal("ID_Card"));
                    fixed_deposit_primary_data.Last_Name = rdr.GetString(rdr.GetOrdinal("Last_Name"));
                    fixed_deposit_primary_data.Premium = rdr.GetDouble(rdr.GetOrdinal("Premium"));
                    fixed_deposit_primary_data.Sum_Insured = rdr.GetDouble(rdr.GetOrdinal("Sum_Insured"));

                    fixed_deposit_primary_data.Gender = rdr.GetInt32(rdr.GetOrdinal("Gender"));

                    if (fixed_deposit_primary_data.Gender == 1)
                    {
                        fixed_deposit_primary_data.Str_Gender = "M"; //Male
                    }
                    else if (fixed_deposit_primary_data.Gender == 0)
                    {
                        fixed_deposit_primary_data.Str_Gender = "F"; //Female
                    }

                    fixed_deposit_primary_data.Application_Resident = rdr.GetInt32(rdr.GetOrdinal("Application_Resident"));

                    if (fixed_deposit_primary_data.Application_Resident == 1)
                    {
                        fixed_deposit_primary_data.Str_Application_Resident = "Y"; //Yes
                    }
                    else if (fixed_deposit_primary_data.Application_Resident == 0)
                    {
                        fixed_deposit_primary_data.Str_Application_Resident = "N"; //No
                    }


                    fixed_deposit_primary_data_list.Add(fixed_deposit_primary_data);

                }//End Read

            }
            con.Close();
        }
        return fixed_deposit_primary_data_list;
    }

    //Function to get flexi term primary data list by params for rejected
    public static List<bl_fixed_deposit_primary_data> GetFlexiTermPrimaryDataListByParamsRejected(string by_branch, string by_company, string bank_no, DateTime from_date, DateTime to_date, string status_code)
    {
        List<bl_fixed_deposit_primary_data> fixed_deposit_primary_data_list = new List<bl_fixed_deposit_primary_data>();

        string connString = AppConfiguration.GetConnectionString();

        using (SqlConnection con = new SqlConnection(connString))
        {
            string sql = "";

            //From Date To Date
            if (from_date != DateTime.Parse("01/01/1900") && to_date != DateTime.Parse("01/01/1900"))
            {
                sql = @"select * from V_Report_Primary_Data where 
                                convert(VARCHAR, V_Report_Primary_Data.Created_On, 110) between @from_date and @to_date and V_Report_Primary_Data.Status_Code = 'Rejected' ";
            }
            else
            {
                sql = @"select * from V_Report_Primary_Data where V_Report_Primary_Data.fixed_deposit_primary_data_id != '' and V_Report_Primary_Data.Status_Code = 'Rejected' ";

            }

            //Bank no
            if (bank_no != "")
            {
                sql += " And V_Report_Primary_Data.Bank_Number = @Bank_Number ";
            }

            //by_branch
            if (by_branch != "")
            {
                sql += " And V_Report_Primary_Data.Channel_Location_ID = @Channel_Location_ID ";
            }

            ////by_company
            //if (by_company != "")
            //{
            //    sql += " And V_Report_Primary_Data.Channel_Item_ID = @Channel_Item_ID ";
            //}

            //status_code
            if (status_code != "")
            {
                sql += " And V_Report_Primary_Data.Status_Code = @Status_Code ";
            }

            sql += " order by Branch ASC, Bank_Number ASC, Approved_On ASC ";

            SqlCommand cmd = new SqlCommand(sql, con);

            cmd.CommandText = sql;

            if (from_date != DateTime.Parse("01/01/1900") && to_date != DateTime.Parse("01/01/1900"))
            {

                cmd.Parameters.AddWithValue("@from_date", from_date.ToString("MM-dd-yyyy"));
                cmd.Parameters.AddWithValue("@to_date", to_date.ToString("MM-dd-yyyy"));
            }

            if (bank_no != "")
            {
                cmd.Parameters.AddWithValue("@Bank_Number", bank_no);
            }

            if (by_branch != "")
            {
                cmd.Parameters.AddWithValue("@Channel_Location_ID", by_branch);
            }

            //if (by_company != "")
            //{
            //    cmd.Parameters.AddWithValue("@Channel_Item_ID", by_company);
            //}

            if (status_code != "")
            {
                cmd.Parameters.AddWithValue("@Status_Code", status_code);
            }

            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();

            while (rdr.Read())
            {

                if (rdr.HasRows)
                {
                    bl_fixed_deposit_primary_data fixed_deposit_primary_data = new bl_fixed_deposit_primary_data();

                    fixed_deposit_primary_data.fixed_deposit_Primary_Data_ID = rdr.GetString(rdr.GetOrdinal("fixed_deposit_Primary_Data_ID"));
                    fixed_deposit_primary_data.Bank_Number = rdr.GetString(rdr.GetOrdinal("Bank_Number"));
                    fixed_deposit_primary_data.Branch = rdr.GetString(rdr.GetOrdinal("Branch"));
                    fixed_deposit_primary_data.Branch_Name = rdr.GetString(rdr.GetOrdinal("Branch_Name"));
                    fixed_deposit_primary_data.Channel_Location_ID = rdr.GetString(rdr.GetOrdinal("Channel_Location_ID"));

                    //Get Company
                    string channel_item_id = da_channel.GetChannelItemIDByChannelLocationID(fixed_deposit_primary_data.Channel_Location_ID);
                    fixed_deposit_primary_data.Company = da_channel.GetChannelItemNameByID(channel_item_id);

                    fixed_deposit_primary_data.Created_On = rdr.GetDateTime(rdr.GetOrdinal("Created_On"));
                    fixed_deposit_primary_data.Created_By = rdr.GetString(rdr.GetOrdinal("Created_By"));
                    fixed_deposit_primary_data.DOB = rdr.GetDateTime(rdr.GetOrdinal("DOB"));
                    fixed_deposit_primary_data.Effective_Date = rdr.GetDateTime(rdr.GetOrdinal("Effective_Date"));
                    fixed_deposit_primary_data.Maturity_Date = rdr.GetDateTime(rdr.GetOrdinal("Maturity_Date"));
                    fixed_deposit_primary_data.Issue_Date = rdr.GetDateTime(rdr.GetOrdinal("Issue_Date"));
                    fixed_deposit_primary_data.Status_Code = rdr.GetString(rdr.GetOrdinal("Status_Code"));
                    fixed_deposit_primary_data.ID_Type = rdr.GetInt32(rdr.GetOrdinal("ID_Type"));


                    fixed_deposit_primary_data.Updated_On = rdr.GetDateTime(rdr.GetOrdinal("Updated_On"));
                    fixed_deposit_primary_data.Updated_By = rdr.GetString(rdr.GetOrdinal("Updated_By"));
                    fixed_deposit_primary_data.Is_Update = rdr.GetInt32(rdr.GetOrdinal("Is_Update"));
                    fixed_deposit_primary_data.Approved_On = rdr.GetDateTime(rdr.GetOrdinal("Approved_On"));
                    fixed_deposit_primary_data.Approved_By = rdr.GetString(rdr.GetOrdinal("Approved_By"));

                    switch (fixed_deposit_primary_data.ID_Type)
                    {
                        case 0:
                            fixed_deposit_primary_data.Str_ID_Type = "I.D Card";
                            break;
                        case 1:
                            fixed_deposit_primary_data.Str_ID_Type = "Passport";
                            break;
                        case 2:
                            fixed_deposit_primary_data.Str_ID_Type = "Visa";
                            break;
                        case 3:
                            fixed_deposit_primary_data.Str_ID_Type = "Birth Certificate";
                            break;
                        case 4:
                            fixed_deposit_primary_data.Str_ID_Type = "Police / Civil Service Card";
                            break;
                        case 5:
                            fixed_deposit_primary_data.Str_ID_Type = "Employment Book";
                            break;
                        case 6:
                            fixed_deposit_primary_data.Str_ID_Type = "Residential Book";
                            break;
                        default:
                            fixed_deposit_primary_data.Str_ID_Type = "";
                            break;
                    }//End switch

                    fixed_deposit_primary_data.First_Name = rdr.GetString(rdr.GetOrdinal("First_Name"));
                    fixed_deposit_primary_data.ID_Card = rdr.GetString(rdr.GetOrdinal("ID_Card"));
                    fixed_deposit_primary_data.Last_Name = rdr.GetString(rdr.GetOrdinal("Last_Name"));
                    fixed_deposit_primary_data.Premium = rdr.GetDouble(rdr.GetOrdinal("Premium"));
                    fixed_deposit_primary_data.Sum_Insured = rdr.GetDouble(rdr.GetOrdinal("Sum_Insured"));

                    fixed_deposit_primary_data.Gender = rdr.GetInt32(rdr.GetOrdinal("Gender"));

                    if (fixed_deposit_primary_data.Gender == 1)
                    {
                        fixed_deposit_primary_data.Str_Gender = "M"; //Male
                    }
                    else if (fixed_deposit_primary_data.Gender == 0)
                    {
                        fixed_deposit_primary_data.Str_Gender = "F"; //Female
                    }

                    fixed_deposit_primary_data.Application_Resident = rdr.GetInt32(rdr.GetOrdinal("Application_Resident"));

                    if (fixed_deposit_primary_data.Application_Resident == 1)
                    {
                        fixed_deposit_primary_data.Str_Application_Resident = "Y"; //Yes
                    }
                    else if (fixed_deposit_primary_data.Application_Resident == 0)
                    {
                        fixed_deposit_primary_data.Str_Application_Resident = "N"; //No
                    }

                    //fixed_deposit_primary_data.Family_Book = rdr.GetString(rdr.GetOrdinal("Family_Book"));
                    //fixed_deposit_primary_data.Str_Family_Book = fixed_deposit_primary_data.Family_Book;


                    fixed_deposit_primary_data_list.Add(fixed_deposit_primary_data);

                }//End Read

            }
            con.Close();
        }
        return fixed_deposit_primary_data_list;
    }

    //Function to get flexi term primary data list by params
    public static List<bl_fixed_deposit_primary_data> GetFlexiTermPrimaryDataListDetailByParamsRejected(string by_branch, string by_company, string bank_no, DateTime from_date, DateTime to_date, string status_code)
    {
        List<bl_fixed_deposit_primary_data> fixed_deposit_primary_data_list = new List<bl_fixed_deposit_primary_data>();

        string connString = AppConfiguration.GetConnectionString();

        using (SqlConnection con = new SqlConnection(connString))
        {
            string sql = "";

            //From Date To Date
            if (from_date != DateTime.Parse("01/01/1900") && to_date != DateTime.Parse("01/01/1900"))
            {
                sql = @"select * from V_Report_Detail_Primary_Data where 
                                convert(VARCHAR, V_Report_Detail_Primary_Data.Created_On, 110) between @from_date and @to_date";
            }
            else
            {
                sql = @"select * from V_Report_Primary_Data where V_Report_Primary_Data.fixed_deposit_primary_data_id != '' ";

            }

            sql += "  and V_Report_Detail_Primary_Data.Status_Code = 'Rejected' ";

            //Bank no
            if (bank_no != "")
            {
                sql += " And V_Report_Detail_Primary_Data.Bank_Number = @Bank_Number ";
            }

            //by_branch
            if (by_branch != "")
            {
                sql += " And V_Report_Detail_Primary_Data.Channel_Location_ID = @Channel_Location_ID ";
            }

            ////by_company
            //if (by_company != "")
            //{
            //    sql += " And V_Report_Detail_Primary_Data.Channel_Item_ID = @Channel_Item_ID ";
            //}

            //status_code
            if (status_code != "")
            {

                if (status_code == "Both")
                {

                    sql += " And V_Report_Detail_Primary_Data.Status_Code = 'Pending' OR V_Report_Detail_Primary_Data.Status_Code = 'Updated'";

                }
                else
                {

                    sql += " And V_Report_Detail_Primary_Data.Status_Code = @Status_Code ";
                }
            }



            sql += " order by Effective_Date ASC, Branch ASC, Bank_Number ASC, Approved_On ASC ";

            SqlCommand cmd = new SqlCommand(sql, con);

            cmd.CommandText = sql;

            if (from_date != DateTime.Parse("01/01/1900") && to_date != DateTime.Parse("01/01/1900"))
            {

                cmd.Parameters.AddWithValue("@from_date", from_date.ToString("MM-dd-yyyy"));
                cmd.Parameters.AddWithValue("@to_date", to_date.ToString("MM-dd-yyyy"));
            }

            if (bank_no != "")
            {
                cmd.Parameters.AddWithValue("@Bank_Number", bank_no);
            }

            if (by_branch != "")
            {
                cmd.Parameters.AddWithValue("@Channel_Location_ID", by_branch);
            }

            //if (by_company != "")
            //{
            //    cmd.Parameters.AddWithValue("@Channel_Item_ID", by_company);
            //}

            if (status_code != "")
            {
                cmd.Parameters.AddWithValue("@Status_Code", status_code);
            }

            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();

            while (rdr.Read())
            {

                if (rdr.HasRows)
                {
                    bl_fixed_deposit_primary_data fixed_deposit_primary_data = new bl_fixed_deposit_primary_data();

                    fixed_deposit_primary_data.fixed_deposit_Primary_Data_ID = rdr.GetString(rdr.GetOrdinal("fixed_deposit_Primary_Data_ID"));
                    fixed_deposit_primary_data.Bank_Number = rdr.GetString(rdr.GetOrdinal("Bank_Number"));
                    fixed_deposit_primary_data.Customer_ID = rdr.GetString(rdr.GetOrdinal("Customer_ID"));
                    fixed_deposit_primary_data.Branch = rdr.GetString(rdr.GetOrdinal("Branch"));
                    fixed_deposit_primary_data.Channel_Location_ID = rdr.GetString(rdr.GetOrdinal("Channel_Location_ID"));

                    //Get Company
                    string channel_item_id = da_channel.GetChannelItemIDByChannelLocationID(fixed_deposit_primary_data.Channel_Location_ID);
                    fixed_deposit_primary_data.Company = da_channel.GetChannelItemNameByID(channel_item_id);

                    fixed_deposit_primary_data.Created_On = rdr.GetDateTime(rdr.GetOrdinal("Created_On"));
                    fixed_deposit_primary_data.Created_By = rdr.GetString(rdr.GetOrdinal("Created_By"));
                    fixed_deposit_primary_data.DOB = rdr.GetDateTime(rdr.GetOrdinal("DOB"));
                    fixed_deposit_primary_data.Effective_Date = rdr.GetDateTime(rdr.GetOrdinal("Effective_Date"));
                    fixed_deposit_primary_data.Maturity_Date = rdr.GetDateTime(rdr.GetOrdinal("Maturity_Date"));
                    fixed_deposit_primary_data.Issue_Date = rdr.GetDateTime(rdr.GetOrdinal("Issue_Date"));
                    fixed_deposit_primary_data.Status_Code = rdr.GetString(rdr.GetOrdinal("Status_Code"));
                    fixed_deposit_primary_data.ID_Type = rdr.GetInt32(rdr.GetOrdinal("ID_Type"));


                    fixed_deposit_primary_data.Updated_On = rdr.GetDateTime(rdr.GetOrdinal("Updated_On"));
                    fixed_deposit_primary_data.Updated_By = rdr.GetString(rdr.GetOrdinal("Updated_By"));
                    fixed_deposit_primary_data.Is_Update = rdr.GetInt32(rdr.GetOrdinal("Is_Update"));
                    fixed_deposit_primary_data.Approved_On = rdr.GetDateTime(rdr.GetOrdinal("Approved_On"));
                    fixed_deposit_primary_data.Approved_By = rdr.GetString(rdr.GetOrdinal("Approved_By"));

                    switch (fixed_deposit_primary_data.ID_Type)
                    {
                        case 0:
                            fixed_deposit_primary_data.Str_ID_Type = "I.D Card";
                            break;
                        case 1:
                            fixed_deposit_primary_data.Str_ID_Type = "Passport";
                            break;
                        case 2:
                            fixed_deposit_primary_data.Str_ID_Type = "Visa";
                            break;
                        case 3:
                            fixed_deposit_primary_data.Str_ID_Type = "Birth Certificate";
                            break;
                        case 4:
                            fixed_deposit_primary_data.Str_ID_Type = "Police / Civil Service Card";
                            break;
                        case 5:
                            fixed_deposit_primary_data.Str_ID_Type = "Employment Book";
                            break;
                        case 6:
                            fixed_deposit_primary_data.Str_ID_Type = "Residential Book";
                            break;
                        default:
                            fixed_deposit_primary_data.Str_ID_Type = "";
                            break;
                    }//End switch

                    fixed_deposit_primary_data.First_Name = rdr.GetString(rdr.GetOrdinal("First_Name"));
                    fixed_deposit_primary_data.ID_Card = rdr.GetString(rdr.GetOrdinal("ID_Card"));
                    fixed_deposit_primary_data.Last_Name = rdr.GetString(rdr.GetOrdinal("Last_Name"));
                    fixed_deposit_primary_data.Premium = rdr.GetDouble(rdr.GetOrdinal("Premium"));
                    fixed_deposit_primary_data.Sum_Insured = rdr.GetDouble(rdr.GetOrdinal("Sum_Insured"));

                    fixed_deposit_primary_data.Gender = rdr.GetInt32(rdr.GetOrdinal("Gender"));

                    if (fixed_deposit_primary_data.Gender == 1)
                    {
                        fixed_deposit_primary_data.Str_Gender = "M"; //Male
                    }
                    else if (fixed_deposit_primary_data.Gender == 0)
                    {
                        fixed_deposit_primary_data.Str_Gender = "F"; //Female
                    }

                    fixed_deposit_primary_data.Application_Resident = rdr.GetInt32(rdr.GetOrdinal("Application_Resident"));

                    if (fixed_deposit_primary_data.Application_Resident == 1)
                    {
                        fixed_deposit_primary_data.Str_Application_Resident = "Y"; //Yes
                    }
                    else if (fixed_deposit_primary_data.Application_Resident == 0)
                    {
                        fixed_deposit_primary_data.Str_Application_Resident = "N"; //No
                    }

                    //fixed_deposit_primary_data.Family_Book = rdr.GetString(rdr.GetOrdinal("Family_Book"));

                    //fixed_deposit_primary_data.Str_Family_Book = fixed_deposit_primary_data.Family_Book;



                    fixed_deposit_primary_data.Beneficiary_Full_Name = rdr.GetString(rdr.GetOrdinal("Benefit_Full_Name"));

                    fixed_deposit_primary_data.Beneficiary_ID_Type = rdr.GetInt32(rdr.GetOrdinal("Benefit_ID_Type"));
                    fixed_deposit_primary_data.Beneficiary_ID_Card = rdr.GetString(rdr.GetOrdinal("Benefit_ID_Card"));

                    switch (fixed_deposit_primary_data.Beneficiary_ID_Type)
                    {
                        case 0:
                            fixed_deposit_primary_data.Str_Beneficiary_ID_Type = "I.D Card";
                            break;
                        case 1:
                            fixed_deposit_primary_data.Str_Beneficiary_ID_Type = "Passport";
                            break;
                        case 2:
                            fixed_deposit_primary_data.Str_Beneficiary_ID_Type = "Visa";
                            break;
                        case 3:
                            fixed_deposit_primary_data.Str_Beneficiary_ID_Type = "Birth Certificate";
                            break;
                        case 4:
                            fixed_deposit_primary_data.Str_Beneficiary_ID_Type = "Police / Civil Service Card";
                            break;
                        case 5:
                            fixed_deposit_primary_data.Str_Beneficiary_ID_Type = "Employment Book";
                            break;
                        case 6:
                            fixed_deposit_primary_data.Str_Beneficiary_ID_Type = "Residential Book";
                            break;
                        default:
                            fixed_deposit_primary_data.Str_Beneficiary_ID_Type = "";
                            break;
                    }//End switch

                    fixed_deposit_primary_data.Beneficiary_Relationship = rdr.GetString(rdr.GetOrdinal("Benefit_Relationship"));
                    fixed_deposit_primary_data.Benefits = rdr.GetDouble(rdr.GetOrdinal("Benefit_Percentage"));


                    fixed_deposit_primary_data_list.Add(fixed_deposit_primary_data);

                }//End Read

            }
            con.Close();
        }
        return fixed_deposit_primary_data_list;
    }

    //Function to get flexi term primary data list Rejected
    public static List<bl_fixed_deposit_primary_data> GetFlexiTermPrimaryDataListRejected(string channel_location_id, string user_role)
    {
        List<bl_fixed_deposit_primary_data> fixed_deposit_primary_data_list = new List<bl_fixed_deposit_primary_data>();

        string connString = AppConfiguration.GetConnectionString();

        using (SqlConnection con = new SqlConnection(connString))
        {
            string sql = "";
            SqlCommand cmd = new SqlCommand(sql, con);

            sql = @"select top 20 * from V_Report_Primary_Data where V_Report_Primary_Data.fixed_deposit_primary_data_id != '' and V_Report_Primary_Data.Status_Code = 'Rejected' ";

             //User Roles
            if (user_role == "External Sale Branch Manager" || user_role == "External Sale Approver" || user_role == "External Sale Operator")
            {
                sql += " And V_Report_Primary_Data.Channel_Location_ID = @Channel_Location_ID ";
                cmd.Parameters.AddWithValue("@Channel_Location_ID", channel_location_id);
            }

            sql += " order by Branch ASC, Bank_Number ASC, Approved_On ASC ";

            cmd.CommandText = sql;

            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();

            while (rdr.Read())
            {

                if (rdr.HasRows)
                {
                    bl_fixed_deposit_primary_data fixed_deposit_primary_data = new bl_fixed_deposit_primary_data();

                    fixed_deposit_primary_data.fixed_deposit_Primary_Data_ID = rdr.GetString(rdr.GetOrdinal("fixed_deposit_Primary_Data_ID"));
                    fixed_deposit_primary_data.Bank_Number = rdr.GetString(rdr.GetOrdinal("Bank_Number"));
                    fixed_deposit_primary_data.Branch = rdr.GetString(rdr.GetOrdinal("Branch"));
                    fixed_deposit_primary_data.Channel_Location_ID = rdr.GetString(rdr.GetOrdinal("Channel_Location_ID"));

                    //Get Company
                    string channel_item_id = da_channel.GetChannelItemIDByChannelLocationID(fixed_deposit_primary_data.Channel_Location_ID);
                    fixed_deposit_primary_data.Company = da_channel.GetChannelItemNameByID(channel_item_id);

                    fixed_deposit_primary_data.Created_On = rdr.GetDateTime(rdr.GetOrdinal("Created_On"));
                    fixed_deposit_primary_data.Created_By = rdr.GetString(rdr.GetOrdinal("Created_By"));
                    fixed_deposit_primary_data.DOB = rdr.GetDateTime(rdr.GetOrdinal("DOB"));
                    fixed_deposit_primary_data.Effective_Date = rdr.GetDateTime(rdr.GetOrdinal("Effective_Date"));
                    fixed_deposit_primary_data.Maturity_Date = rdr.GetDateTime(rdr.GetOrdinal("Maturity_Date"));
                    fixed_deposit_primary_data.Issue_Date = rdr.GetDateTime(rdr.GetOrdinal("Issue_Date"));
                    fixed_deposit_primary_data.Status_Code = rdr.GetString(rdr.GetOrdinal("Status_Code"));
                    fixed_deposit_primary_data.ID_Type = rdr.GetInt32(rdr.GetOrdinal("ID_Type"));


                    fixed_deposit_primary_data.Updated_On = rdr.GetDateTime(rdr.GetOrdinal("Updated_On"));
                    fixed_deposit_primary_data.Updated_By = rdr.GetString(rdr.GetOrdinal("Updated_By"));
                    fixed_deposit_primary_data.Is_Update = rdr.GetInt32(rdr.GetOrdinal("Is_Update"));
                    fixed_deposit_primary_data.Approved_On = rdr.GetDateTime(rdr.GetOrdinal("Approved_On"));
                    fixed_deposit_primary_data.Approved_By = rdr.GetString(rdr.GetOrdinal("Approved_By"));

                    switch (fixed_deposit_primary_data.ID_Type)
                    {
                        case 0:
                            fixed_deposit_primary_data.Str_ID_Type = "I.D Card";
                            break;
                        case 1:
                            fixed_deposit_primary_data.Str_ID_Type = "Passport";
                            break;
                        case 2:
                            fixed_deposit_primary_data.Str_ID_Type = "Visa";
                            break;
                        case 3:
                            fixed_deposit_primary_data.Str_ID_Type = "Birth Certificate";
                            break;
                        case 4:
                            fixed_deposit_primary_data.Str_ID_Type = "Police / Civil Service Card";
                            break;
                        case 5:
                            fixed_deposit_primary_data.Str_ID_Type = "Employment Book";
                            break;
                        case 6:
                            fixed_deposit_primary_data.Str_ID_Type = "Residential Book";
                            break;
                        default:
                            fixed_deposit_primary_data.Str_ID_Type = "";
                            break;
                    }//End switch

                    fixed_deposit_primary_data.First_Name = rdr.GetString(rdr.GetOrdinal("First_Name"));
                    fixed_deposit_primary_data.ID_Card = rdr.GetString(rdr.GetOrdinal("ID_Card"));
                    fixed_deposit_primary_data.Last_Name = rdr.GetString(rdr.GetOrdinal("Last_Name"));
                    fixed_deposit_primary_data.Premium = rdr.GetDouble(rdr.GetOrdinal("Premium"));
                    fixed_deposit_primary_data.Sum_Insured = rdr.GetDouble(rdr.GetOrdinal("Sum_Insured"));

                    fixed_deposit_primary_data.Gender = rdr.GetInt32(rdr.GetOrdinal("Gender"));

                    if (fixed_deposit_primary_data.Gender == 1)
                    {
                        fixed_deposit_primary_data.Str_Gender = "M"; //Male
                    }
                    else if (fixed_deposit_primary_data.Gender == 0)
                    {
                        fixed_deposit_primary_data.Str_Gender = "F"; //Female
                    }

                    fixed_deposit_primary_data.Application_Resident = rdr.GetInt32(rdr.GetOrdinal("Application_Resident"));

                    if (fixed_deposit_primary_data.Application_Resident == 1)
                    {
                        fixed_deposit_primary_data.Str_Application_Resident = "Y"; //Yes
                    }
                    else if (fixed_deposit_primary_data.Application_Resident == 0)
                    {
                        fixed_deposit_primary_data.Str_Application_Resident = "N"; //No
                    }

                    fixed_deposit_primary_data_list.Add(fixed_deposit_primary_data);

                }//End Read

            }
            con.Close();
        }
        return fixed_deposit_primary_data_list;
    }

    //Function to get flexi term primary data list by params for Edit
    public static List<bl_fixed_deposit_primary_data> GetFlexiTermPrimaryDataListByParamsEdit(string by_branch, string by_company, string bank_no, DateTime from_date, DateTime to_date, string status_code, string user_role, string user_name)
    {
        List<bl_fixed_deposit_primary_data> fixed_deposit_primary_data_list = new List<bl_fixed_deposit_primary_data>();

        string connString = AppConfiguration.GetConnectionString();

        using (SqlConnection con = new SqlConnection(connString))
        {
            string sql = "";

            //From Date To Date
            if (from_date != DateTime.Parse("01/01/1900") && to_date != DateTime.Parse("01/01/1900"))
            {
                sql = @"select * from V_Report_Primary_Data where 
                                convert(VARCHAR, V_Report_Primary_Data.Created_On, 110) between @from_date and @to_date and V_Report_Primary_Data.Status_Code != 'Rejected' ";
            }
            else
            {
                sql = @"select * from V_Report_Primary_Data where V_Report_Primary_Data.fixed_deposit_primary_data_id != '' and V_Report_Primary_Data.Status_Code != 'Rejected' ";

            }

            //Bank no
            if (bank_no != "")
            {
                sql += " And V_Report_Primary_Data.Bank_Number = @Bank_Number ";
            }

            //by_branch
            if (by_branch != "")
            {
                //User Roles
                if (user_role == "External Sale Approver" || user_role == "External Sale Operator")
                {

                    sql += " And V_Report_Primary_Data.Channel_Location_ID = @Channel_Location_ID ";
                    if (user_role == "External Sale Operator")
                    {

                        sql += " And V_Report_Primary_Data.Created_By = @Created_By ";
                    }
                }
            }

            //by_company
            if (by_company != "")
            {
                sql += " And V_Report_Primary_Data.Channel_Item_ID = @Channel_Item_ID ";
            }

            //status_code
            if (status_code != "")
            {
                sql += " And V_Report_Primary_Data.Status_Code = @Status_Code ";
            }

            sql += " order by Branch ASC, Bank_Number ASC, Approved_On ASC ";

            SqlCommand cmd = new SqlCommand(sql, con);

            cmd.CommandText = sql;

            cmd.Parameters.AddWithValue("@Created_By", user_name);

            if (from_date != DateTime.Parse("01/01/1900") && to_date != DateTime.Parse("01/01/1900"))
            {

                cmd.Parameters.AddWithValue("@from_date", from_date.ToString("MM-dd-yyyy"));
                cmd.Parameters.AddWithValue("@to_date", to_date.ToString("MM-dd-yyyy"));
            }

            if (bank_no != "")
            {
                cmd.Parameters.AddWithValue("@Bank_Number", bank_no);
            }

            if (by_branch != "")
            {
                cmd.Parameters.AddWithValue("@Channel_Location_ID", by_branch);
            }

            if (by_company != "")
            {
                cmd.Parameters.AddWithValue("@Channel_Item_ID", by_company);
            }

            if (status_code != "")
            {
                cmd.Parameters.AddWithValue("@Status_Code", status_code);
            }

            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();

            while (rdr.Read())
            {

                if (rdr.HasRows)
                {
                    bl_fixed_deposit_primary_data fixed_deposit_primary_data = new bl_fixed_deposit_primary_data();

                    fixed_deposit_primary_data.fixed_deposit_Primary_Data_ID = rdr.GetString(rdr.GetOrdinal("fixed_deposit_Primary_Data_ID"));
                    fixed_deposit_primary_data.Bank_Number = rdr.GetString(rdr.GetOrdinal("Bank_Number"));
                    fixed_deposit_primary_data.Customer_ID = rdr.GetString(rdr.GetOrdinal("Customer_ID"));
                    fixed_deposit_primary_data.Branch = rdr.GetString(rdr.GetOrdinal("Branch"));
                    fixed_deposit_primary_data.Channel_Location_ID = rdr.GetString(rdr.GetOrdinal("Channel_Location_ID"));

                    //Get Company
                    string channel_item_id = da_channel.GetChannelItemIDByChannelLocationID(fixed_deposit_primary_data.Channel_Location_ID);
                    fixed_deposit_primary_data.Company = da_channel.GetChannelItemNameByID(channel_item_id);

                    fixed_deposit_primary_data.Created_On = rdr.GetDateTime(rdr.GetOrdinal("Created_On"));
                    fixed_deposit_primary_data.Created_By = rdr.GetString(rdr.GetOrdinal("Created_By"));
                    fixed_deposit_primary_data.DOB = rdr.GetDateTime(rdr.GetOrdinal("DOB"));
                    fixed_deposit_primary_data.Effective_Date = rdr.GetDateTime(rdr.GetOrdinal("Effective_Date"));
                    fixed_deposit_primary_data.Maturity_Date = rdr.GetDateTime(rdr.GetOrdinal("Maturity_Date"));
                    fixed_deposit_primary_data.Issue_Date = rdr.GetDateTime(rdr.GetOrdinal("Issue_Date"));
                    fixed_deposit_primary_data.Status_Code = rdr.GetString(rdr.GetOrdinal("Status_Code"));
                    fixed_deposit_primary_data.ID_Type = rdr.GetInt32(rdr.GetOrdinal("ID_Type"));


                    fixed_deposit_primary_data.Updated_On = rdr.GetDateTime(rdr.GetOrdinal("Updated_On"));
                    fixed_deposit_primary_data.Updated_By = rdr.GetString(rdr.GetOrdinal("Updated_By"));
                    fixed_deposit_primary_data.Is_Update = rdr.GetInt32(rdr.GetOrdinal("Is_Update"));
                    fixed_deposit_primary_data.Approved_On = rdr.GetDateTime(rdr.GetOrdinal("Approved_On"));
                    fixed_deposit_primary_data.Approved_By = rdr.GetString(rdr.GetOrdinal("Approved_By"));

                    switch (fixed_deposit_primary_data.ID_Type)
                    {
                        case 0:
                            fixed_deposit_primary_data.Str_ID_Type = "I.D Card";
                            break;
                        case 1:
                            fixed_deposit_primary_data.Str_ID_Type = "Passport";
                            break;
                        case 2:
                            fixed_deposit_primary_data.Str_ID_Type = "Visa";
                            break;
                        case 3:
                            fixed_deposit_primary_data.Str_ID_Type = "Birth Certificate";
                            break;
                        case 4:
                            fixed_deposit_primary_data.Str_ID_Type = "Police / Civil Service Card";
                            break;
                        case 5:
                            fixed_deposit_primary_data.Str_ID_Type = "Employment Book";
                            break;
                        case 6:
                            fixed_deposit_primary_data.Str_ID_Type = "Residential Book";
                            break;
                        default:
                            fixed_deposit_primary_data.Str_ID_Type = "";
                            break;
                    }//End switch

                    fixed_deposit_primary_data.First_Name = rdr.GetString(rdr.GetOrdinal("First_Name"));
                    fixed_deposit_primary_data.ID_Card = rdr.GetString(rdr.GetOrdinal("ID_Card"));
                    fixed_deposit_primary_data.Last_Name = rdr.GetString(rdr.GetOrdinal("Last_Name"));
                    fixed_deposit_primary_data.Deposit_Amount = rdr.GetDouble(rdr.GetOrdinal("Deposit_Amount"));
                    fixed_deposit_primary_data.Premium = rdr.GetDouble(rdr.GetOrdinal("Premium"));
                    fixed_deposit_primary_data.Sum_Insured = rdr.GetDouble(rdr.GetOrdinal("Sum_Insured"));

                    fixed_deposit_primary_data.Gender = rdr.GetInt32(rdr.GetOrdinal("Gender"));

                    if (fixed_deposit_primary_data.Gender == 1)
                    {
                        fixed_deposit_primary_data.Str_Gender = "M"; //Male
                    }
                    else if (fixed_deposit_primary_data.Gender == 0)
                    {
                        fixed_deposit_primary_data.Str_Gender = "F"; //Female
                    }

                    fixed_deposit_primary_data.Application_Resident = rdr.GetInt32(rdr.GetOrdinal("Application_Resident"));

                    if (fixed_deposit_primary_data.Application_Resident == 1)
                    {
                        fixed_deposit_primary_data.Str_Application_Resident = "Y"; //Yes
                    }
                    else if (fixed_deposit_primary_data.Application_Resident == 0)
                    {
                        fixed_deposit_primary_data.Str_Application_Resident = "N"; //No
                    }



                    fixed_deposit_primary_data_list.Add(fixed_deposit_primary_data);

                }//End Read

            }
            con.Close();
        }
        return fixed_deposit_primary_data_list;
    }

    //Function to get flexi term primary data list for Edit
    public static List<bl_fixed_deposit_primary_data> GetFlexiTermPrimaryDataListEdit(string channel_location_id, string user_role,string user_name)
    {
        List<bl_fixed_deposit_primary_data> fixed_deposit_primary_data_list = new List<bl_fixed_deposit_primary_data>();

        string connString = AppConfiguration.GetConnectionString();

        using (SqlConnection con = new SqlConnection(connString))
        {
            string sql = "";
            SqlCommand cmd = new SqlCommand(sql, con);

            sql = @"select top 20 * from V_Report_Primary_Data where V_Report_Primary_Data.fixed_deposit_primary_data_id != '' and V_Report_Primary_Data.Status_Code != 'Rejected' ";

            //User Roles
            if (user_role == "External Sale Approver" || user_role == "External Sale Operator")
            {
                
                sql += " And V_Report_Primary_Data.Channel_Location_ID = @Channel_Location_ID ";
                cmd.Parameters.AddWithValue("@Channel_Location_ID", channel_location_id);
                if (user_role == "External Sale Operator") {

                    sql += " And V_Report_Primary_Data.Created_By = @Created_By ";
                    cmd.Parameters.AddWithValue("@Created_By", user_name);
                }
            }
            

            sql += " order by Branch ASC, Bank_Number ASC, Approved_On ASC ";

            cmd.CommandText = sql;

            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();

            while (rdr.Read())
            {

                if (rdr.HasRows)
                {
                    bl_fixed_deposit_primary_data fixed_deposit_primary_data = new bl_fixed_deposit_primary_data();

                    fixed_deposit_primary_data.fixed_deposit_Primary_Data_ID = rdr.GetString(rdr.GetOrdinal("fixed_deposit_Primary_Data_ID"));
                    //fixed_deposit_primary_data.fixed_deposit_Beneficiary_ID = rdr.GetString(rdr.GetOrdinal("fixed_deposit_Beneficiary_ID"));
                    fixed_deposit_primary_data.Bank_Number = rdr.GetString(rdr.GetOrdinal("Bank_Number"));
                    fixed_deposit_primary_data.Customer_ID = rdr.GetString(rdr.GetOrdinal("Customer_ID"));
                    fixed_deposit_primary_data.Branch = rdr.GetString(rdr.GetOrdinal("Branch"));
                    fixed_deposit_primary_data.Channel_Location_ID = rdr.GetString(rdr.GetOrdinal("Channel_Location_ID"));

                    //Get Company
                    string channel_item_id = da_channel.GetChannelItemIDByChannelLocationID(fixed_deposit_primary_data.Channel_Location_ID);
                    fixed_deposit_primary_data.Company = da_channel.GetChannelItemNameByID(channel_item_id);

                    fixed_deposit_primary_data.Created_On = rdr.GetDateTime(rdr.GetOrdinal("Created_On"));
                    fixed_deposit_primary_data.Created_By = rdr.GetString(rdr.GetOrdinal("Created_By"));
                    fixed_deposit_primary_data.DOB = rdr.GetDateTime(rdr.GetOrdinal("DOB"));
                    fixed_deposit_primary_data.Effective_Date = rdr.GetDateTime(rdr.GetOrdinal("Effective_Date"));
                    fixed_deposit_primary_data.Maturity_Date = rdr.GetDateTime(rdr.GetOrdinal("Maturity_Date"));
                    fixed_deposit_primary_data.Maturity_Month = rdr.GetInt32(rdr.GetOrdinal("Maturity_Month"));
                    fixed_deposit_primary_data.Expiry_Date = rdr.GetDateTime(rdr.GetOrdinal("Expiry_Date"));
                    fixed_deposit_primary_data.Issue_Date = rdr.GetDateTime(rdr.GetOrdinal("Issue_Date"));
                    fixed_deposit_primary_data.Status_Code = rdr.GetString(rdr.GetOrdinal("Status_Code"));
                    fixed_deposit_primary_data.ID_Type = rdr.GetInt32(rdr.GetOrdinal("ID_Type"));


                    fixed_deposit_primary_data.Updated_On = rdr.GetDateTime(rdr.GetOrdinal("Updated_On"));
                    fixed_deposit_primary_data.Updated_By = rdr.GetString(rdr.GetOrdinal("Updated_By"));
                    fixed_deposit_primary_data.Is_Update = rdr.GetInt32(rdr.GetOrdinal("Is_Update"));
                    fixed_deposit_primary_data.Approved_On = rdr.GetDateTime(rdr.GetOrdinal("Approved_On"));
                    fixed_deposit_primary_data.Approved_By = rdr.GetString(rdr.GetOrdinal("Approved_By"));

                    switch (fixed_deposit_primary_data.ID_Type)
                    {
                        case 0:
                            fixed_deposit_primary_data.Str_ID_Type = "I.D Card";
                            break;
                        case 1:
                            fixed_deposit_primary_data.Str_ID_Type = "Passport";
                            break;
                        case 2:
                            fixed_deposit_primary_data.Str_ID_Type = "Visa";
                            break;
                        case 3:
                            fixed_deposit_primary_data.Str_ID_Type = "Birth Certificate";
                            break;
                        case 4:
                            fixed_deposit_primary_data.Str_ID_Type = "Police / Civil Service Card";
                            break;
                        case 5:
                            fixed_deposit_primary_data.Str_ID_Type = "Employment Book";
                            break;
                        case 6:
                            fixed_deposit_primary_data.Str_ID_Type = "Residential Book";
                            break;
                        default:
                            fixed_deposit_primary_data.Str_ID_Type = "";
                            break;
                    }//End switch

                    fixed_deposit_primary_data.First_Name = rdr.GetString(rdr.GetOrdinal("First_Name"));
                    fixed_deposit_primary_data.ID_Card = rdr.GetString(rdr.GetOrdinal("ID_Card"));
                    fixed_deposit_primary_data.Last_Name = rdr.GetString(rdr.GetOrdinal("Last_Name"));
                    fixed_deposit_primary_data.Deposit_Amount = rdr.GetDouble(rdr.GetOrdinal("Deposit_Amount"));
                    fixed_deposit_primary_data.Premium = rdr.GetDouble(rdr.GetOrdinal("Premium"));
                    fixed_deposit_primary_data.Sum_Insured = rdr.GetDouble(rdr.GetOrdinal("Sum_Insured"));

                    fixed_deposit_primary_data.Gender = rdr.GetInt32(rdr.GetOrdinal("Gender"));

                    if (fixed_deposit_primary_data.Gender == 1)
                    {
                        fixed_deposit_primary_data.Str_Gender = "M"; //Male
                    }
                    else if (fixed_deposit_primary_data.Gender == 0)
                    {
                        fixed_deposit_primary_data.Str_Gender = "F"; //Female
                    }

                    fixed_deposit_primary_data.Application_Resident = rdr.GetInt32(rdr.GetOrdinal("Application_Resident"));

                    if (fixed_deposit_primary_data.Application_Resident == 1)
                    {
                        fixed_deposit_primary_data.Str_Application_Resident = "Y"; //Yes
                    }
                    else if (fixed_deposit_primary_data.Application_Resident == 0)
                    {
                        fixed_deposit_primary_data.Str_Application_Resident = "N"; //No
                    }

                    fixed_deposit_primary_data_list.Add(fixed_deposit_primary_data);

                }//End Read

            }
            con.Close();
        }
        return fixed_deposit_primary_data_list;
    }

    //Function to get flexi term primary data list for Edit
    public static bl_fixed_deposit_primary_data GetFlexiTermPrimaryData(string fixed_deposit_Primary_Data_ID)
    {
        bl_fixed_deposit_primary_data fixed_deposit_primary_data = new bl_fixed_deposit_primary_data();

        string connString = AppConfiguration.GetConnectionString();

        using (SqlConnection con = new SqlConnection(connString))
        {
            string sql = "";
            SqlCommand cmd = new SqlCommand(sql, con);

            sql = @"select top 20 * from V_Report_Primary_Data where V_Report_Primary_Data.fixed_deposit_primary_data_id != '' and V_Report_Primary_Data.Status_Code != 'Rejected' AND fixed_deposit_Primary_Data_ID=@fixed_deposit_Primary_Data_ID ";

            cmd.Parameters.AddWithValue("@fixed_deposit_Primary_Data_ID", fixed_deposit_Primary_Data_ID);
            

            sql += " order by Branch ASC, Bank_Number ASC, Approved_On ASC ";

            cmd.CommandText = sql;

            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();

            while (rdr.Read())
            {

                if (rdr.HasRows)
                {
                    //bl_fixed_deposit_primary_data fixed_deposit_primary_data = new bl_fixed_deposit_primary_data();

                    fixed_deposit_primary_data.fixed_deposit_Primary_Data_ID = rdr.GetString(rdr.GetOrdinal("fixed_deposit_Primary_Data_ID"));
                    //fixed_deposit_primary_data.fixed_deposit_Beneficiary_ID = rdr.GetString(rdr.GetOrdinal("fixed_deposit_Beneficiary_ID"));
                    fixed_deposit_primary_data.Bank_Number = rdr.GetString(rdr.GetOrdinal("Bank_Number"));
                    fixed_deposit_primary_data.Customer_ID = rdr.GetString(rdr.GetOrdinal("Customer_ID"));
                    fixed_deposit_primary_data.Branch = rdr.GetString(rdr.GetOrdinal("Branch"));
                    fixed_deposit_primary_data.Channel_Location_ID = rdr.GetString(rdr.GetOrdinal("Channel_Location_ID"));

                    //Get Company
                    string channel_item_id = da_channel.GetChannelItemIDByChannelLocationID(fixed_deposit_primary_data.Channel_Location_ID);
                    fixed_deposit_primary_data.Company = da_channel.GetChannelItemNameByID(channel_item_id);

                    fixed_deposit_primary_data.Created_On = rdr.GetDateTime(rdr.GetOrdinal("Created_On"));
                    fixed_deposit_primary_data.Created_By = rdr.GetString(rdr.GetOrdinal("Created_By"));
                    fixed_deposit_primary_data.DOB = rdr.GetDateTime(rdr.GetOrdinal("DOB"));
                    fixed_deposit_primary_data.Effective_Date = rdr.GetDateTime(rdr.GetOrdinal("Effective_Date"));
                    fixed_deposit_primary_data.Maturity_Date = rdr.GetDateTime(rdr.GetOrdinal("Maturity_Date"));
                    fixed_deposit_primary_data.Issue_Date = rdr.GetDateTime(rdr.GetOrdinal("Issue_Date"));
                    fixed_deposit_primary_data.Status_Code = rdr.GetString(rdr.GetOrdinal("Status_Code"));
                    fixed_deposit_primary_data.ID_Type = rdr.GetInt32(rdr.GetOrdinal("ID_Type"));


                    fixed_deposit_primary_data.Updated_On = rdr.GetDateTime(rdr.GetOrdinal("Updated_On"));
                    fixed_deposit_primary_data.Updated_By = rdr.GetString(rdr.GetOrdinal("Updated_By"));
                    fixed_deposit_primary_data.Is_Update = rdr.GetInt32(rdr.GetOrdinal("Is_Update"));
                    fixed_deposit_primary_data.Approved_On = rdr.GetDateTime(rdr.GetOrdinal("Approved_On"));
                    fixed_deposit_primary_data.Approved_By = rdr.GetString(rdr.GetOrdinal("Approved_By"));

                    switch (fixed_deposit_primary_data.ID_Type)
                    {
                        case 0:
                            fixed_deposit_primary_data.Str_ID_Type = "I.D Card";
                            break;
                        case 1:
                            fixed_deposit_primary_data.Str_ID_Type = "Passport";
                            break;
                        case 2:
                            fixed_deposit_primary_data.Str_ID_Type = "Visa";
                            break;
                        case 3:
                            fixed_deposit_primary_data.Str_ID_Type = "Birth Certificate";
                            break;
                        case 4:
                            fixed_deposit_primary_data.Str_ID_Type = "Police / Civil Service Card";
                            break;
                        case 5:
                            fixed_deposit_primary_data.Str_ID_Type = "Employment Book";
                            break;
                        case 6:
                            fixed_deposit_primary_data.Str_ID_Type = "Residential Book";
                            break;
                        default:
                            fixed_deposit_primary_data.Str_ID_Type = "";
                            break;
                    }//End switch

                    fixed_deposit_primary_data.First_Name = rdr.GetString(rdr.GetOrdinal("First_Name"));
                    fixed_deposit_primary_data.ID_Card = rdr.GetString(rdr.GetOrdinal("ID_Card"));
                    fixed_deposit_primary_data.Last_Name = rdr.GetString(rdr.GetOrdinal("Last_Name"));
                    fixed_deposit_primary_data.Deposit_Amount = rdr.GetDouble(rdr.GetOrdinal("Deposit_Amount"));
                    fixed_deposit_primary_data.Premium = rdr.GetDouble(rdr.GetOrdinal("Premium"));
                    fixed_deposit_primary_data.Sum_Insured = rdr.GetDouble(rdr.GetOrdinal("Sum_Insured"));

                    fixed_deposit_primary_data.Gender = rdr.GetInt32(rdr.GetOrdinal("Gender"));

                    if (fixed_deposit_primary_data.Gender == 1)
                    {
                        fixed_deposit_primary_data.Str_Gender = "M"; //Male
                    }
                    else if (fixed_deposit_primary_data.Gender == 0)
                    {
                        fixed_deposit_primary_data.Str_Gender = "F"; //Female
                    }

                    fixed_deposit_primary_data.Application_Resident = rdr.GetInt32(rdr.GetOrdinal("Application_Resident"));

                    if (fixed_deposit_primary_data.Application_Resident == 1)
                    {
                        fixed_deposit_primary_data.Str_Application_Resident = "Y"; //Yes
                    }
                    else if (fixed_deposit_primary_data.Application_Resident == 0)
                    {
                        fixed_deposit_primary_data.Str_Application_Resident = "N"; //No
                    }


                }//End Read

            }
            con.Close();
        }
        return fixed_deposit_primary_data;
    }
    
    //Function to get flexi term primary data list history
    public static List<bl_fixed_deposit_primary_data> GetFlexiTermPrimaryDataListHistory(string channel_location_id, string user_role)
    {
        List<bl_fixed_deposit_primary_data> fixed_deposit_primary_data_list = new List<bl_fixed_deposit_primary_data>();

        string connString = AppConfiguration.GetConnectionString();

        using (SqlConnection con = new SqlConnection(connString))
        {
            string sql = "";
            SqlCommand cmd = new SqlCommand(sql, con);

            sql = @"select top 20 * from V_Report_Primary_Data where V_Report_Primary_Data.fixed_deposit_primary_data_id != '' ";

            //User Roles
            if (user_role == "External Sale Branch Manager" || user_role == "External Sale Approver" || user_role == "External Sale Operator")
            {
                sql += " And V_Report_Primary_Data.Channel_Location_ID = @Channel_Location_ID ";
                cmd.Parameters.AddWithValue("@Channel_Location_ID", channel_location_id);
            }

            sql += " order by Branch ASC, Bank_Number ASC, Approved_On ASC ";

            cmd.CommandText = sql;

            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();

            while (rdr.Read())
            {

                if (rdr.HasRows)
                {
                    bl_fixed_deposit_primary_data fixed_deposit_primary_data = new bl_fixed_deposit_primary_data();

                    fixed_deposit_primary_data.fixed_deposit_Primary_Data_ID = rdr.GetString(rdr.GetOrdinal("fixed_deposit_Primary_Data_ID"));
                    fixed_deposit_primary_data.Bank_Number = rdr.GetString(rdr.GetOrdinal("Bank_Number"));
                    fixed_deposit_primary_data.Customer_ID = rdr.GetString(rdr.GetOrdinal("Customer_ID"));
                    fixed_deposit_primary_data.Branch = rdr.GetString(rdr.GetOrdinal("Branch"));
                    fixed_deposit_primary_data.Channel_Location_ID = rdr.GetString(rdr.GetOrdinal("Channel_Location_ID"));

                    //Get Company
                    string channel_item_id = da_channel.GetChannelItemIDByChannelLocationID(fixed_deposit_primary_data.Channel_Location_ID);
                    fixed_deposit_primary_data.Company = da_channel.GetChannelItemNameByID(channel_item_id);

                    fixed_deposit_primary_data.Created_On = rdr.GetDateTime(rdr.GetOrdinal("Created_On"));
                    fixed_deposit_primary_data.Created_By = rdr.GetString(rdr.GetOrdinal("Created_By"));
                    fixed_deposit_primary_data.DOB = rdr.GetDateTime(rdr.GetOrdinal("DOB"));
                    fixed_deposit_primary_data.Effective_Date = rdr.GetDateTime(rdr.GetOrdinal("Effective_Date"));
                    fixed_deposit_primary_data.Maturity_Date = rdr.GetDateTime(rdr.GetOrdinal("Maturity_Date"));
                    fixed_deposit_primary_data.Issue_Date = rdr.GetDateTime(rdr.GetOrdinal("Issue_Date"));
                    fixed_deposit_primary_data.Status_Code = rdr.GetString(rdr.GetOrdinal("Status_Code"));
                    fixed_deposit_primary_data.ID_Type = rdr.GetInt32(rdr.GetOrdinal("ID_Type"));


                    fixed_deposit_primary_data.Updated_On = rdr.GetDateTime(rdr.GetOrdinal("Updated_On"));
                    fixed_deposit_primary_data.Updated_By = rdr.GetString(rdr.GetOrdinal("Updated_By"));
                    fixed_deposit_primary_data.Is_Update = rdr.GetInt32(rdr.GetOrdinal("Is_Update"));
                    fixed_deposit_primary_data.Approved_On = rdr.GetDateTime(rdr.GetOrdinal("Approved_On"));
                    fixed_deposit_primary_data.Approved_By = rdr.GetString(rdr.GetOrdinal("Approved_By"));

                    switch (fixed_deposit_primary_data.ID_Type)
                    {
                        case 0:
                            fixed_deposit_primary_data.Str_ID_Type = "I.D Card";
                            break;
                        case 1:
                            fixed_deposit_primary_data.Str_ID_Type = "Passport";
                            break;
                        case 2:
                            fixed_deposit_primary_data.Str_ID_Type = "Visa";
                            break;
                        case 3:
                            fixed_deposit_primary_data.Str_ID_Type = "Birth Certificate";
                            break;
                        case 4:
                            fixed_deposit_primary_data.Str_ID_Type = "Police / Civil Service Card";
                            break;
                        case 5:
                            fixed_deposit_primary_data.Str_ID_Type = "Employment Book";
                            break;
                        case 6:
                            fixed_deposit_primary_data.Str_ID_Type = "Residential Book";
                            break;
                        default:
                            fixed_deposit_primary_data.Str_ID_Type = "";
                            break;
                    }//End switch

                    fixed_deposit_primary_data.First_Name = rdr.GetString(rdr.GetOrdinal("First_Name"));
                    fixed_deposit_primary_data.ID_Card = rdr.GetString(rdr.GetOrdinal("ID_Card"));
                    fixed_deposit_primary_data.Last_Name = rdr.GetString(rdr.GetOrdinal("Last_Name"));
                    fixed_deposit_primary_data.Premium = rdr.GetDouble(rdr.GetOrdinal("Premium"));
                    fixed_deposit_primary_data.Sum_Insured = rdr.GetDouble(rdr.GetOrdinal("Sum_Insured"));

                    fixed_deposit_primary_data.Gender = rdr.GetInt32(rdr.GetOrdinal("Gender"));

                    if (fixed_deposit_primary_data.Gender == 1)
                    {
                        fixed_deposit_primary_data.Str_Gender = "M"; //Male
                    }
                    else if (fixed_deposit_primary_data.Gender == 0)
                    {
                        fixed_deposit_primary_data.Str_Gender = "F"; //Female
                    }

                    fixed_deposit_primary_data.Application_Resident = rdr.GetInt32(rdr.GetOrdinal("Application_Resident"));

                    if (fixed_deposit_primary_data.Application_Resident == 1)
                    {
                        fixed_deposit_primary_data.Str_Application_Resident = "Y"; //Yes
                    }
                    else if (fixed_deposit_primary_data.Application_Resident == 0)
                    {
                        fixed_deposit_primary_data.Str_Application_Resident = "N"; //No
                    }

                    fixed_deposit_primary_data_list.Add(fixed_deposit_primary_data);

                }//End Read

            }
            con.Close();
        }
        return fixed_deposit_primary_data_list;
    }

    //Function to get flexi term primary data list by params history
    public static List<bl_fixed_deposit_primary_data> GetFlexiTermPrimaryDataListByParamsHistory(string by_branch, string by_company, string bank_no, DateTime from_date, DateTime to_date, string status_code)
    {
        List<bl_fixed_deposit_primary_data> fixed_deposit_primary_data_list = new List<bl_fixed_deposit_primary_data>();

        string connString = AppConfiguration.GetConnectionString();

        using (SqlConnection con = new SqlConnection(connString))
        {
            string sql = "";

            //From Date To Date
            if (from_date != DateTime.Parse("01/01/1900") && to_date != DateTime.Parse("01/01/1900"))
            {
                sql = @"select * from V_Report_Primary_Data where 
                                convert(VARCHAR, V_Report_Primary_Data.Created_On, 110) between @from_date and @to_date";
            }
            else
            {
                sql = @"select * from V_Report_Primary_Data where V_Report_Primary_Data.fixed_deposit_primary_data_id != '' ";

            }

            //Bank no
            if (bank_no != "")
            {
                sql += " And V_Report_Primary_Data.Bank_Number = @Bank_Number ";
            }

            //by_branch
            if (by_branch != "")
            {
                
                sql += " And V_Report_Primary_Data.Channel_Location_ID = @Channel_Location_ID ";
            }

            //by_company
            //if (by_company != "")
            //{
            //    sql += " And V_Report_Primary_Data.Channel_Item_ID = @Channel_Item_ID ";
            //}

            //status_code
            if (status_code != "")
            {

                if (status_code == "Both")
                {

                    sql += " And V_Report_Primary_Data.Status_Code = 'Pending' OR V_Report_Primary_Data.Status_Code = 'Updated'";

                }
                else
                {

                    sql += " And V_Report_Primary_Data.Status_Code = @Status_Code ";
                }
            }



            sql += " order by Branch ASC, Bank_Number ASC, Approved_On ASC ";

            SqlCommand cmd = new SqlCommand(sql, con);

            cmd.CommandText = sql;

            if (from_date != DateTime.Parse("01/01/1900") && to_date != DateTime.Parse("01/01/1900"))
            {

                cmd.Parameters.AddWithValue("@from_date", from_date.ToString("MM-dd-yyyy"));
                cmd.Parameters.AddWithValue("@to_date", to_date.ToString("MM-dd-yyyy"));
            }

            if (bank_no != "")
            {
                cmd.Parameters.AddWithValue("@Bank_Number", bank_no);
            }

            if (by_branch != "")
            {
                cmd.Parameters.AddWithValue("@Channel_Location_ID", by_branch);
            }

            //if (by_company != "")
            //{
            //    cmd.Parameters.AddWithValue("@Channel_Item_ID", by_company);
            //}

            if (status_code != "")
            {
                cmd.Parameters.AddWithValue("@Status_Code", status_code);
            }

            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();

            while (rdr.Read())
            {

                if (rdr.HasRows)
                {
                    bl_fixed_deposit_primary_data fixed_deposit_primary_data = new bl_fixed_deposit_primary_data();

                    fixed_deposit_primary_data.fixed_deposit_Primary_Data_ID = rdr.GetString(rdr.GetOrdinal("fixed_deposit_Primary_Data_ID"));
                    fixed_deposit_primary_data.Bank_Number = rdr.GetString(rdr.GetOrdinal("Bank_Number"));
                    fixed_deposit_primary_data.Customer_ID = rdr.GetString(rdr.GetOrdinal("Customer_ID"));
                    fixed_deposit_primary_data.Branch = rdr.GetString(rdr.GetOrdinal("Branch"));
                    fixed_deposit_primary_data.Branch_Name = rdr.GetString(rdr.GetOrdinal("Branch_Name"));
                    fixed_deposit_primary_data.Channel_Location_ID = rdr.GetString(rdr.GetOrdinal("Channel_Location_ID"));

                    //Get Company
                    string channel_item_id = da_channel.GetChannelItemIDByChannelLocationID(fixed_deposit_primary_data.Channel_Location_ID);
                    fixed_deposit_primary_data.Company = da_channel.GetChannelItemNameByID(channel_item_id);

                    fixed_deposit_primary_data.Created_On = rdr.GetDateTime(rdr.GetOrdinal("Created_On"));
                    fixed_deposit_primary_data.Created_By = rdr.GetString(rdr.GetOrdinal("Created_By"));
                    fixed_deposit_primary_data.DOB = rdr.GetDateTime(rdr.GetOrdinal("DOB"));
                    fixed_deposit_primary_data.Effective_Date = rdr.GetDateTime(rdr.GetOrdinal("Effective_Date"));
                    fixed_deposit_primary_data.Maturity_Date = rdr.GetDateTime(rdr.GetOrdinal("Maturity_Date"));
                    fixed_deposit_primary_data.Issue_Date = rdr.GetDateTime(rdr.GetOrdinal("Issue_Date"));
                    fixed_deposit_primary_data.Status_Code = rdr.GetString(rdr.GetOrdinal("Status_Code"));
                    fixed_deposit_primary_data.ID_Type = rdr.GetInt32(rdr.GetOrdinal("ID_Type"));


                    fixed_deposit_primary_data.Updated_On = rdr.GetDateTime(rdr.GetOrdinal("Updated_On"));
                    fixed_deposit_primary_data.Updated_By = rdr.GetString(rdr.GetOrdinal("Updated_By"));
                    fixed_deposit_primary_data.Is_Update = rdr.GetInt32(rdr.GetOrdinal("Is_Update"));
                    fixed_deposit_primary_data.Approved_On = rdr.GetDateTime(rdr.GetOrdinal("Approved_On"));
                    fixed_deposit_primary_data.Approved_By = rdr.GetString(rdr.GetOrdinal("Approved_By"));

                    switch (fixed_deposit_primary_data.ID_Type)
                    {
                        case 0:
                            fixed_deposit_primary_data.Str_ID_Type = "I.D Card";
                            break;
                        case 1:
                            fixed_deposit_primary_data.Str_ID_Type = "Passport";
                            break;
                        case 2:
                            fixed_deposit_primary_data.Str_ID_Type = "Visa";
                            break;
                        case 3:
                            fixed_deposit_primary_data.Str_ID_Type = "Birth Certificate";
                            break;
                        case 4:
                            fixed_deposit_primary_data.Str_ID_Type = "Police / Civil Service Card";
                            break;
                        case 5:
                            fixed_deposit_primary_data.Str_ID_Type = "Employment Book";
                            break;
                        case 6:
                            fixed_deposit_primary_data.Str_ID_Type = "Residential Book";
                            break;
                        default:
                            fixed_deposit_primary_data.Str_ID_Type = "";
                            break;
                    }//End switch

                    fixed_deposit_primary_data.First_Name = rdr.GetString(rdr.GetOrdinal("First_Name"));
                    fixed_deposit_primary_data.ID_Card = rdr.GetString(rdr.GetOrdinal("ID_Card"));
                    fixed_deposit_primary_data.Last_Name = rdr.GetString(rdr.GetOrdinal("Last_Name"));
                    fixed_deposit_primary_data.Deposit_Amount = rdr.GetDouble(rdr.GetOrdinal("Deposit_Amount"));
                    fixed_deposit_primary_data.Premium = rdr.GetDouble(rdr.GetOrdinal("Premium"));
                    fixed_deposit_primary_data.Sum_Insured = rdr.GetDouble(rdr.GetOrdinal("Sum_Insured"));

                    fixed_deposit_primary_data.Gender = rdr.GetInt32(rdr.GetOrdinal("Gender"));

                    if (fixed_deposit_primary_data.Gender == 1)
                    {
                        fixed_deposit_primary_data.Str_Gender = "M"; //Male
                    }
                    else if (fixed_deposit_primary_data.Gender == 0)
                    {
                        fixed_deposit_primary_data.Str_Gender = "F"; //Female
                    }

                    fixed_deposit_primary_data.Application_Resident = rdr.GetInt32(rdr.GetOrdinal("Application_Resident"));

                    if (fixed_deposit_primary_data.Application_Resident == 1)
                    {
                        fixed_deposit_primary_data.Str_Application_Resident = "Y"; //Yes
                    }
                    else if (fixed_deposit_primary_data.Application_Resident == 0)
                    {
                        fixed_deposit_primary_data.Str_Application_Resident = "N"; //No
                    }


                    fixed_deposit_primary_data_list.Add(fixed_deposit_primary_data);

                }//End Read

            }
            con.Close();
        }
        return fixed_deposit_primary_data_list;
    }

    //Function to get flexi term primary data list by params history
    public static List<bl_fixed_deposit_primary_data> GetFlexiTermPrimaryDataListDetailByParamsHistory(string by_branch, string by_company, string bank_no, DateTime from_date, DateTime to_date, string status_code)
    {
        List<bl_fixed_deposit_primary_data> fixed_deposit_primary_data_list = new List<bl_fixed_deposit_primary_data>();

        string connString = AppConfiguration.GetConnectionString();

        using (SqlConnection con = new SqlConnection(connString))
        {
            string sql = "";

            //From Date To Date
            if (from_date != DateTime.Parse("01/01/1900") && to_date != DateTime.Parse("01/01/1900"))
            {
                sql = @"select * from V_Report_Detail_Primary_Data where 
                                convert(VARCHAR, V_Report_Detail_Primary_Data.Created_On, 110) between @from_date and @to_date";
            }
            else
            {
                sql = @"select * from V_Report_Detail_Primary_Data where V_Report_Detail_Primary_Data.fixed_deposit_primary_data_id != '' ";

            }

            //Bank no
            if (bank_no != "")
            {
                sql += " And V_Report_Detail_Primary_Detail_Data.Bank_Number = @Bank_Number ";
            }

            //by_branch
            if (by_branch != "")
            {
                    
                sql += " And V_Report_Detail_Primary_Data.Channel_Location_ID = @Channel_Location_ID ";
                
            }

            //by_company
            //if (by_company != "")
            //{
            //    sql += " And V_Report_Detail_Primary_Data.Channel_Item_ID = @Channel_Item_ID ";
            //}

            //status_code
            if (status_code != "")
            {

                if (status_code == "Both")
                {

                    sql += " And V_Report_Detail_Primary_Data.Status_Code = 'Pending' OR V_Report_Detail_Primary_Data.Status_Code = 'Updated'";

                }
                else
                {

                    sql += " And V_Report_Detail_Primary_Data.Status_Code = @Status_Code ";
                }
            }



            sql += " order by Branch ASC, Bank_Number ASC, Approved_On ASC ";

            SqlCommand cmd = new SqlCommand(sql, con);

            cmd.CommandText = sql;

            if (from_date != DateTime.Parse("01/01/1900") && to_date != DateTime.Parse("01/01/1900"))
            {

                cmd.Parameters.AddWithValue("@from_date", from_date.ToString("MM-dd-yyyy"));
                cmd.Parameters.AddWithValue("@to_date", to_date.ToString("MM-dd-yyyy"));
            }

            if (bank_no != "")
            {
                cmd.Parameters.AddWithValue("@Bank_Number", bank_no);
            }

            if (by_branch != "")
            {
                cmd.Parameters.AddWithValue("@Channel_Location_ID", by_branch);
            }

            if (by_company != "")
            {
                cmd.Parameters.AddWithValue("@Channel_Item_ID", by_company);
            }

            if (status_code != "")
            {
                cmd.Parameters.AddWithValue("@Status_Code", status_code);
            }

            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();

            while (rdr.Read())
            {

                if (rdr.HasRows)
                {
                    bl_fixed_deposit_primary_data fixed_deposit_primary_data = new bl_fixed_deposit_primary_data();

                    fixed_deposit_primary_data.fixed_deposit_Primary_Data_ID = rdr.GetString(rdr.GetOrdinal("fixed_deposit_Primary_Data_ID"));
                    fixed_deposit_primary_data.Bank_Number = rdr.GetString(rdr.GetOrdinal("Bank_Number"));
                    fixed_deposit_primary_data.Customer_ID = rdr.GetString(rdr.GetOrdinal("Customer_ID"));
                    fixed_deposit_primary_data.Branch = rdr.GetString(rdr.GetOrdinal("Branch"));
                    fixed_deposit_primary_data.Channel_Location_ID = rdr.GetString(rdr.GetOrdinal("Channel_Location_ID"));

                    //Get Company
                    string channel_item_id = da_channel.GetChannelItemIDByChannelLocationID(fixed_deposit_primary_data.Channel_Location_ID);
                    fixed_deposit_primary_data.Company = da_channel.GetChannelItemNameByID(channel_item_id);

                    fixed_deposit_primary_data.Created_On = rdr.GetDateTime(rdr.GetOrdinal("Created_On"));
                    fixed_deposit_primary_data.Created_By = rdr.GetString(rdr.GetOrdinal("Created_By"));
                    fixed_deposit_primary_data.DOB = rdr.GetDateTime(rdr.GetOrdinal("DOB"));
                    fixed_deposit_primary_data.Effective_Date = rdr.GetDateTime(rdr.GetOrdinal("Effective_Date"));
                    fixed_deposit_primary_data.Maturity_Date = rdr.GetDateTime(rdr.GetOrdinal("Maturity_Date"));
                    fixed_deposit_primary_data.Issue_Date = rdr.GetDateTime(rdr.GetOrdinal("Issue_Date"));
                    fixed_deposit_primary_data.Status_Code = rdr.GetString(rdr.GetOrdinal("Status_Code"));
                    fixed_deposit_primary_data.ID_Type = rdr.GetInt32(rdr.GetOrdinal("ID_Type"));


                    fixed_deposit_primary_data.Updated_On = rdr.GetDateTime(rdr.GetOrdinal("Updated_On"));
                    fixed_deposit_primary_data.Updated_By = rdr.GetString(rdr.GetOrdinal("Updated_By"));
                    fixed_deposit_primary_data.Is_Update = rdr.GetInt32(rdr.GetOrdinal("Is_Update"));
                    fixed_deposit_primary_data.Approved_On = rdr.GetDateTime(rdr.GetOrdinal("Approved_On"));
                    fixed_deposit_primary_data.Approved_By = rdr.GetString(rdr.GetOrdinal("Approved_By"));

                    switch (fixed_deposit_primary_data.ID_Type)
                    {
                        case 0:
                            fixed_deposit_primary_data.Str_ID_Type = "I.D Card";
                            break;
                        case 1:
                            fixed_deposit_primary_data.Str_ID_Type = "Passport";
                            break;
                        case 2:
                            fixed_deposit_primary_data.Str_ID_Type = "Visa";
                            break;
                        case 3:
                            fixed_deposit_primary_data.Str_ID_Type = "Birth Certificate";
                            break;
                        case 4:
                            fixed_deposit_primary_data.Str_ID_Type = "Police / Civil Service Card";
                            break;
                        case 5:
                            fixed_deposit_primary_data.Str_ID_Type = "Employment Book";
                            break;
                        case 6:
                            fixed_deposit_primary_data.Str_ID_Type = "Residential Book";
                            break;
                        default:
                            fixed_deposit_primary_data.Str_ID_Type = "";
                            break;
                    }//End switch

                    fixed_deposit_primary_data.First_Name = rdr.GetString(rdr.GetOrdinal("First_Name"));
                    fixed_deposit_primary_data.ID_Card = rdr.GetString(rdr.GetOrdinal("ID_Card"));
                    fixed_deposit_primary_data.Last_Name = rdr.GetString(rdr.GetOrdinal("Last_Name"));
                    fixed_deposit_primary_data.Deposit_Amount = rdr.GetDouble(rdr.GetOrdinal("Deposit_Amount"));
                    fixed_deposit_primary_data.Premium = rdr.GetDouble(rdr.GetOrdinal("Premium"));
                    fixed_deposit_primary_data.Sum_Insured = rdr.GetDouble(rdr.GetOrdinal("Sum_Insured"));

                    fixed_deposit_primary_data.Gender = rdr.GetInt32(rdr.GetOrdinal("Gender"));

                    if (fixed_deposit_primary_data.Gender == 1)
                    {
                        fixed_deposit_primary_data.Str_Gender = "M"; //Male
                    }
                    else if (fixed_deposit_primary_data.Gender == 0)
                    {
                        fixed_deposit_primary_data.Str_Gender = "F"; //Female
                    }

                    fixed_deposit_primary_data.Application_Resident = rdr.GetInt32(rdr.GetOrdinal("Application_Resident"));

                    if (fixed_deposit_primary_data.Application_Resident == 1)
                    {
                        fixed_deposit_primary_data.Str_Application_Resident = "Y"; //Yes
                    }
                    else if (fixed_deposit_primary_data.Application_Resident == 0)
                    {
                        fixed_deposit_primary_data.Str_Application_Resident = "N"; //No
                    }

                    

                    fixed_deposit_primary_data.Beneficiary_Full_Name = rdr.GetString(rdr.GetOrdinal("Benefit_Full_Name"));

                    fixed_deposit_primary_data.Beneficiary_ID_Type = rdr.GetInt32(rdr.GetOrdinal("Benefit_ID_Type"));
                    fixed_deposit_primary_data.Beneficiary_ID_Card = rdr.GetString(rdr.GetOrdinal("Benefit_ID_Card"));

                    switch (fixed_deposit_primary_data.Beneficiary_ID_Type)
                    {
                        case 0:
                            fixed_deposit_primary_data.Str_Beneficiary_ID_Type = "I.D Card";
                            break;
                        case 1:
                            fixed_deposit_primary_data.Str_Beneficiary_ID_Type = "Passport";
                            break;
                        case 2:
                            fixed_deposit_primary_data.Str_Beneficiary_ID_Type = "Visa";
                            break;
                        case 3:
                            fixed_deposit_primary_data.Str_Beneficiary_ID_Type = "Birth Certificate";
                            break;
                        case 4:
                            fixed_deposit_primary_data.Str_Beneficiary_ID_Type = "Police / Civil Service Card";
                            break;
                        case 5:
                            fixed_deposit_primary_data.Str_Beneficiary_ID_Type = "Employment Book";
                            break;
                        case 6:
                            fixed_deposit_primary_data.Str_Beneficiary_ID_Type = "Residential Book";
                            break;
                        default:
                            fixed_deposit_primary_data.Str_Beneficiary_ID_Type = "";
                            break;
                    }//End switch 

                    fixed_deposit_primary_data.Beneficiary_Relationship = rdr.GetString(rdr.GetOrdinal("Benefit_Relationship"));

                    fixed_deposit_primary_data.Benefits = rdr.GetDouble(rdr.GetOrdinal("Benefit_Percentage"));


                    fixed_deposit_primary_data_list.Add(fixed_deposit_primary_data);

                }//End Read

            }
            con.Close();
        }
        return fixed_deposit_primary_data_list;
    }

    //Function to get flexi term primary data list by params for List to be approve
    public static List<bl_fixed_deposit_primary_data> GetFlexiTermPrimaryDataListByParamsForApproval(string by_branch, string by_company, string bank_no, DateTime from_date, DateTime to_date, string status_code)
    {
        List<bl_fixed_deposit_primary_data> fixed_deposit_primary_data_list = new List<bl_fixed_deposit_primary_data>();

        string connString = AppConfiguration.GetConnectionString();

        using (SqlConnection con = new SqlConnection(connString))
        {
            string sql = "";

            //From Date To Date
            if (from_date != DateTime.Parse("01/01/1900") && to_date != DateTime.Parse("01/01/1900"))
            {
                sql = @"select * from V_Report_Primary_Data where 
                                convert(VARCHAR, V_Report_Primary_Data.Created_On, 110) between @from_date and @to_date";
            }
            else
            {
                sql = @"select * from V_Report_Primary_Data where V_Report_Primary_Data.fixed_deposit_primary_data_id != '' ";

            }

            sql += "  and V_Report_Primary_Data.Status_Code != 'Approved' and V_Report_Primary_Data.Status_Code != 'Rejected' ";

            //Bank no
            if (bank_no != "")
            {
                sql += " And V_Report_Primary_Data.Bank_Number = @Bank_Number ";
            }

            //by_branch
            if (by_branch != "")
            {
                sql += " And V_Report_Primary_Data.Channel_Location_ID = @Channel_Location_ID ";
            }

            //by_company
            if (by_company != "")
            {
                sql += " And V_Report_Primary_Data.Channel_Item_ID = @Channel_Item_ID ";
            }

            //status_code
            if (status_code != "")
            {

                if (status_code == "Both")
                {

                    sql += " And (V_Report_Primary_Data.Status_Code = 'Pending' OR V_Report_Primary_Data.Status_Code = 'Updated')";

                }
                else
                {

                    sql += " And V_Report_Primary_Data.Status_Code = @Status_Code ";
                }
            }



            sql += " order by Branch ASC, Bank_Number ASC, Approved_On ASC ";

            SqlCommand cmd = new SqlCommand(sql, con);

            cmd.CommandText = sql;

            if (from_date != DateTime.Parse("01/01/1900") && to_date != DateTime.Parse("01/01/1900"))
            {

                cmd.Parameters.AddWithValue("@from_date", from_date.ToString("MM-dd-yyyy"));
                cmd.Parameters.AddWithValue("@to_date", to_date.ToString("MM-dd-yyyy"));
            }

            if (bank_no != "")
            {
                cmd.Parameters.AddWithValue("@Bank_Number", bank_no);
            }

            if (by_branch != "")
            {
                cmd.Parameters.AddWithValue("@Channel_Location_ID", by_branch);
            }

            if (by_company != "")
            {
                cmd.Parameters.AddWithValue("@Channel_Item_ID", by_company);
            }

            if (status_code != "")
            {
                cmd.Parameters.AddWithValue("@Status_Code", status_code);
            }

            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();

            while (rdr.Read())
            {

                if (rdr.HasRows)
                {
                    bl_fixed_deposit_primary_data fixed_deposit_primary_data = new bl_fixed_deposit_primary_data();

                    fixed_deposit_primary_data.fixed_deposit_Primary_Data_ID = rdr.GetString(rdr.GetOrdinal("fixed_deposit_Primary_Data_ID"));
                    fixed_deposit_primary_data.Bank_Number = rdr.GetString(rdr.GetOrdinal("Bank_Number"));
                    fixed_deposit_primary_data.Customer_ID = rdr.GetString(rdr.GetOrdinal("Customer_ID"));

                    fixed_deposit_primary_data.Branch = rdr.GetString(rdr.GetOrdinal("Branch"));
                    fixed_deposit_primary_data.Channel_Location_ID = rdr.GetString(rdr.GetOrdinal("Channel_Location_ID"));

                    //Get Company
                    string channel_item_id = da_channel.GetChannelItemIDByChannelLocationID(fixed_deposit_primary_data.Channel_Location_ID);
                    fixed_deposit_primary_data.Company = da_channel.GetChannelItemNameByID(channel_item_id);

                    fixed_deposit_primary_data.Created_On = rdr.GetDateTime(rdr.GetOrdinal("Created_On"));
                    fixed_deposit_primary_data.Created_By = rdr.GetString(rdr.GetOrdinal("Created_By"));
                    fixed_deposit_primary_data.DOB = rdr.GetDateTime(rdr.GetOrdinal("DOB"));
                    fixed_deposit_primary_data.Effective_Date = rdr.GetDateTime(rdr.GetOrdinal("Effective_Date"));
                    fixed_deposit_primary_data.Maturity_Date = rdr.GetDateTime(rdr.GetOrdinal("Maturity_Date"));
                    fixed_deposit_primary_data.Issue_Date = rdr.GetDateTime(rdr.GetOrdinal("Issue_Date"));
                    fixed_deposit_primary_data.Status_Code = rdr.GetString(rdr.GetOrdinal("Status_Code"));
                    fixed_deposit_primary_data.ID_Type = rdr.GetInt32(rdr.GetOrdinal("ID_Type"));


                    fixed_deposit_primary_data.Updated_On = rdr.GetDateTime(rdr.GetOrdinal("Updated_On"));
                    fixed_deposit_primary_data.Updated_By = rdr.GetString(rdr.GetOrdinal("Updated_By"));
                    fixed_deposit_primary_data.Is_Update = rdr.GetInt32(rdr.GetOrdinal("Is_Update"));
                    fixed_deposit_primary_data.Approved_On = rdr.GetDateTime(rdr.GetOrdinal("Approved_On"));
                    fixed_deposit_primary_data.Approved_By = rdr.GetString(rdr.GetOrdinal("Approved_By"));

                    switch (fixed_deposit_primary_data.ID_Type)
                    {
                        case 0:
                            fixed_deposit_primary_data.Str_ID_Type = "I.D Card";
                            break;
                        case 1:
                            fixed_deposit_primary_data.Str_ID_Type = "Passport";
                            break;
                        case 2:
                            fixed_deposit_primary_data.Str_ID_Type = "Visa";
                            break;
                        case 3:
                            fixed_deposit_primary_data.Str_ID_Type = "Birth Certificate";
                            break;
                        case 4:
                            fixed_deposit_primary_data.Str_ID_Type = "Police / Civil Service Card";
                            break;
                        case 5:
                            fixed_deposit_primary_data.Str_ID_Type = "Employment Book";
                            break;
                        case 6:
                            fixed_deposit_primary_data.Str_ID_Type = "Residential Book";
                            break;
                        default:
                            fixed_deposit_primary_data.Str_ID_Type = "";
                            break;
                    }//End switch

                    fixed_deposit_primary_data.First_Name = rdr.GetString(rdr.GetOrdinal("First_Name"));
                    fixed_deposit_primary_data.ID_Card = rdr.GetString(rdr.GetOrdinal("ID_Card"));
                    fixed_deposit_primary_data.Last_Name = rdr.GetString(rdr.GetOrdinal("Last_Name"));
                    fixed_deposit_primary_data.Deposit_Amount = rdr.GetDouble(rdr.GetOrdinal("Deposit_Amount"));
                    fixed_deposit_primary_data.Premium = rdr.GetDouble(rdr.GetOrdinal("Premium"));
                    fixed_deposit_primary_data.Sum_Insured = rdr.GetDouble(rdr.GetOrdinal("Sum_Insured"));

                    fixed_deposit_primary_data.Gender = rdr.GetInt32(rdr.GetOrdinal("Gender"));

                    if (fixed_deposit_primary_data.Gender == 1)
                    {
                        fixed_deposit_primary_data.Str_Gender = "M"; //Male
                    }
                    else if (fixed_deposit_primary_data.Gender == 0)
                    {
                        fixed_deposit_primary_data.Str_Gender = "F"; //Female
                    }

                    fixed_deposit_primary_data.Application_Resident = rdr.GetInt32(rdr.GetOrdinal("Application_Resident"));

                    if (fixed_deposit_primary_data.Application_Resident == 1)
                    {
                        fixed_deposit_primary_data.Str_Application_Resident = "Y"; //Yes
                    }
                    else if (fixed_deposit_primary_data.Application_Resident == 0)
                    {
                        fixed_deposit_primary_data.Str_Application_Resident = "N"; //No
                    }


                    fixed_deposit_primary_data_list.Add(fixed_deposit_primary_data);

                }//End Read

            }
            con.Close();
        }
        return fixed_deposit_primary_data_list;
    }

    //Function to get app single row data by id
    public static bl_fixed_deposit_primary_data GetFixedDepositSingleRowData(string customer_id)
    {

        bl_fixed_deposit_primary_data fixed_deposit_primary_data = new bl_fixed_deposit_primary_data();

        string connString = AppConfiguration.GetConnectionString();

        using (SqlConnection con = new SqlConnection(connString))
        {
            SqlCommand cmd = new SqlCommand("select Top 1 * from V_Report_Primary_Data where Customer_ID LIKE @Customer_ID", con);
            cmd.CommandType = CommandType.Text;

            cmd.Parameters.AddWithValue("@Customer_ID", customer_id);

            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {

                if (rdr.HasRows)
                {

                    fixed_deposit_primary_data.fixed_deposit_Primary_Data_ID = rdr.GetString(rdr.GetOrdinal("fixed_deposit_Primary_Data_ID"));
                    fixed_deposit_primary_data.Bank_Number = rdr.GetString(rdr.GetOrdinal("Bank_Number"));
                    fixed_deposit_primary_data.Customer_ID = rdr.GetString(rdr.GetOrdinal("Customer_ID"));

                    fixed_deposit_primary_data.Branch = rdr.GetString(rdr.GetOrdinal("Branch"));
                    fixed_deposit_primary_data.Channel_Location_ID = rdr.GetString(rdr.GetOrdinal("Channel_Location_ID"));

                    //Get Company
                    string channel_item_id = da_channel.GetChannelItemIDByChannelLocationID(fixed_deposit_primary_data.Channel_Location_ID);
                    fixed_deposit_primary_data.Company = da_channel.GetChannelItemNameByID(channel_item_id);

                    fixed_deposit_primary_data.Created_On = rdr.GetDateTime(rdr.GetOrdinal("Created_On"));
                    fixed_deposit_primary_data.Created_By = rdr.GetString(rdr.GetOrdinal("Created_By"));
                    fixed_deposit_primary_data.DOB = rdr.GetDateTime(rdr.GetOrdinal("DOB"));
                    fixed_deposit_primary_data.Effective_Date = rdr.GetDateTime(rdr.GetOrdinal("Effective_Date"));
                    fixed_deposit_primary_data.Maturity_Date = rdr.GetDateTime(rdr.GetOrdinal("Maturity_Date"));
                    fixed_deposit_primary_data.Issue_Date = rdr.GetDateTime(rdr.GetOrdinal("Issue_Date"));
                    fixed_deposit_primary_data.Status_Code = rdr.GetString(rdr.GetOrdinal("Status_Code"));
                    fixed_deposit_primary_data.ID_Type = rdr.GetInt32(rdr.GetOrdinal("ID_Type"));


                    fixed_deposit_primary_data.Updated_On = rdr.GetDateTime(rdr.GetOrdinal("Updated_On"));
                    fixed_deposit_primary_data.Updated_By = rdr.GetString(rdr.GetOrdinal("Updated_By"));
                    fixed_deposit_primary_data.Is_Update = rdr.GetInt32(rdr.GetOrdinal("Is_Update"));
                    fixed_deposit_primary_data.Approved_On = rdr.GetDateTime(rdr.GetOrdinal("Approved_On"));
                    fixed_deposit_primary_data.Approved_By = rdr.GetString(rdr.GetOrdinal("Approved_By"));

                    switch (fixed_deposit_primary_data.ID_Type)
                    {
                        case 0:
                            fixed_deposit_primary_data.Str_ID_Type = "I.D Card";
                            break;
                        case 1:
                            fixed_deposit_primary_data.Str_ID_Type = "Passport";
                            break;
                        case 2:
                            fixed_deposit_primary_data.Str_ID_Type = "Visa";
                            break;
                        case 3:
                            fixed_deposit_primary_data.Str_ID_Type = "Birth Certificate";
                            break;
                        case 4:
                            fixed_deposit_primary_data.Str_ID_Type = "Police / Civil Service Card";
                            break;
                        case 5:
                            fixed_deposit_primary_data.Str_ID_Type = "Employment Book";
                            break;
                        case 6:
                            fixed_deposit_primary_data.Str_ID_Type = "Residential Book";
                            break;
                        default:
                            fixed_deposit_primary_data.Str_ID_Type = "";
                            break;
                    }//End switch

                    fixed_deposit_primary_data.First_Name = rdr.GetString(rdr.GetOrdinal("First_Name"));
                    fixed_deposit_primary_data.ID_Card = rdr.GetString(rdr.GetOrdinal("ID_Card"));
                    fixed_deposit_primary_data.Last_Name = rdr.GetString(rdr.GetOrdinal("Last_Name"));
                    fixed_deposit_primary_data.Deposit_Amount = rdr.GetDouble(rdr.GetOrdinal("Deposit_Amount"));
                    fixed_deposit_primary_data.Premium = rdr.GetDouble(rdr.GetOrdinal("Premium"));
                    fixed_deposit_primary_data.Sum_Insured = rdr.GetDouble(rdr.GetOrdinal("Sum_Insured"));

                    fixed_deposit_primary_data.Gender = rdr.GetInt32(rdr.GetOrdinal("Gender"));

                    if (fixed_deposit_primary_data.Gender == 1)
                    {
                        fixed_deposit_primary_data.Str_Gender = "M"; //Male
                    }
                    else if (fixed_deposit_primary_data.Gender == 0)
                    {
                        fixed_deposit_primary_data.Str_Gender = "F"; //Female
                    }

                    fixed_deposit_primary_data.Application_Resident = rdr.GetInt32(rdr.GetOrdinal("Application_Resident"));

                    if (fixed_deposit_primary_data.Application_Resident == 1)
                    {
                        fixed_deposit_primary_data.Str_Application_Resident = "Y"; //Yes
                    }
                    else if (fixed_deposit_primary_data.Application_Resident == 0)
                    {
                        fixed_deposit_primary_data.Str_Application_Resident = "N"; //No
                    }

                    //fixed_deposit_primary_data.Family_Book = rdr.GetString(rdr.GetOrdinal("Family_Book"));
                    //fixed_deposit_primary_data.Str_Family_Book = fixed_deposit_primary_data.Family_Book;


                    
                }
            }
            con.Close();
        }
        return fixed_deposit_primary_data;
    }

    //Function to get app single row data by certificate no
    public static bl_fixed_deposit_primary_data GetFixedDepositDataByCertificateNo(string certificate_no,string location_id)
    {

        bl_fixed_deposit_primary_data fixed_deposit_primary_data = new bl_fixed_deposit_primary_data();

        string connString = AppConfiguration.GetConnectionString();

        using (SqlConnection con = new SqlConnection(connString))
        {
            string sql = "select Top 1 * from V_Report_Primary_Data where Bank_Number LIKE '" + certificate_no + "' AND V_Report_Primary_Data.Channel_Location_ID = '" + location_id + "' AND V_Report_Primary_Data.Status_Code = 'Approved'";
            SqlCommand cmd = new SqlCommand(sql, con);
            cmd.CommandType = CommandType.Text;

            //cmd.Parameters.AddWithValue("@Bank_Number", certificate_no);
            //cmd.Parameters.AddWithValue("@Channel_Location_ID", location_id);

            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {

                if (rdr.HasRows)
                {

                    fixed_deposit_primary_data.fixed_deposit_Primary_Data_ID = rdr.GetString(rdr.GetOrdinal("fixed_deposit_Primary_Data_ID"));
                    fixed_deposit_primary_data.Bank_Number = rdr.GetString(rdr.GetOrdinal("Bank_Number"));
                    fixed_deposit_primary_data.Customer_ID = rdr.GetString(rdr.GetOrdinal("Customer_ID"));

                    fixed_deposit_primary_data.Branch = rdr.GetString(rdr.GetOrdinal("Branch"));
                    fixed_deposit_primary_data.Channel_Location_ID = rdr.GetString(rdr.GetOrdinal("Channel_Location_ID"));

                    //Get Company
                    string channel_item_id = da_channel.GetChannelItemIDByChannelLocationID(fixed_deposit_primary_data.Channel_Location_ID);
                    fixed_deposit_primary_data.Company = da_channel.GetChannelItemNameByID(channel_item_id);

                    fixed_deposit_primary_data.Created_On = rdr.GetDateTime(rdr.GetOrdinal("Created_On"));
                    fixed_deposit_primary_data.Created_By = rdr.GetString(rdr.GetOrdinal("Created_By"));
                    fixed_deposit_primary_data.DOB = rdr.GetDateTime(rdr.GetOrdinal("DOB"));
                    fixed_deposit_primary_data.Effective_Date = rdr.GetDateTime(rdr.GetOrdinal("Effective_Date"));
                    fixed_deposit_primary_data.Maturity_Date = rdr.GetDateTime(rdr.GetOrdinal("Maturity_Date"));
                    fixed_deposit_primary_data.Maturity_Month = rdr.GetInt32(rdr.GetOrdinal("Maturity_Month"));
                    fixed_deposit_primary_data.Expiry_Date = rdr.GetDateTime(rdr.GetOrdinal("Expiry_Date"));
                    fixed_deposit_primary_data.Issue_Date = rdr.GetDateTime(rdr.GetOrdinal("Issue_Date"));
                    fixed_deposit_primary_data.Status_Code = rdr.GetString(rdr.GetOrdinal("Status_Code"));
                    fixed_deposit_primary_data.ID_Type = rdr.GetInt32(rdr.GetOrdinal("ID_Type"));


                    fixed_deposit_primary_data.Updated_On = rdr.GetDateTime(rdr.GetOrdinal("Updated_On"));
                    fixed_deposit_primary_data.Updated_By = rdr.GetString(rdr.GetOrdinal("Updated_By"));
                    fixed_deposit_primary_data.Is_Update = rdr.GetInt32(rdr.GetOrdinal("Is_Update"));
                    fixed_deposit_primary_data.Approved_On = rdr.GetDateTime(rdr.GetOrdinal("Approved_On"));
                    fixed_deposit_primary_data.Approved_By = rdr.GetString(rdr.GetOrdinal("Approved_By"));

                    switch (fixed_deposit_primary_data.ID_Type)
                    {
                        case 0:
                            fixed_deposit_primary_data.Str_ID_Type = "I.D Card";
                            break;
                        case 1:
                            fixed_deposit_primary_data.Str_ID_Type = "Passport";
                            break;
                        case 2:
                            fixed_deposit_primary_data.Str_ID_Type = "Visa";
                            break;
                        case 3:
                            fixed_deposit_primary_data.Str_ID_Type = "Birth Certificate";
                            break;
                        case 4:
                            fixed_deposit_primary_data.Str_ID_Type = "Police / Civil Service Card";
                            break;
                        case 5:
                            fixed_deposit_primary_data.Str_ID_Type = "Employment Book";
                            break;
                        case 6:
                            fixed_deposit_primary_data.Str_ID_Type = "Residential Book";
                            break;
                        default:
                            fixed_deposit_primary_data.Str_ID_Type = "";
                            break;
                    }//End switch

                    fixed_deposit_primary_data.First_Name = rdr.GetString(rdr.GetOrdinal("First_Name"));
                    fixed_deposit_primary_data.ID_Card = rdr.GetString(rdr.GetOrdinal("ID_Card"));
                    fixed_deposit_primary_data.Last_Name = rdr.GetString(rdr.GetOrdinal("Last_Name"));
                    fixed_deposit_primary_data.Deposit_Amount = rdr.GetDouble(rdr.GetOrdinal("Deposit_Amount"));
                    fixed_deposit_primary_data.Premium = rdr.GetDouble(rdr.GetOrdinal("Premium"));
                    fixed_deposit_primary_data.Sum_Insured = rdr.GetDouble(rdr.GetOrdinal("Sum_Insured"));

                    fixed_deposit_primary_data.Gender = rdr.GetInt32(rdr.GetOrdinal("Gender"));

                    if (fixed_deposit_primary_data.Gender == 1)
                    {
                        fixed_deposit_primary_data.Str_Gender = "M"; //Male
                    }
                    else if (fixed_deposit_primary_data.Gender == 0)
                    {
                        fixed_deposit_primary_data.Str_Gender = "F"; //Female
                    }

                    fixed_deposit_primary_data.Application_Resident = rdr.GetInt32(rdr.GetOrdinal("Application_Resident"));

                    if (fixed_deposit_primary_data.Application_Resident == 1)
                    {
                        fixed_deposit_primary_data.Str_Application_Resident = "Y"; //Yes
                    }
                    else if (fixed_deposit_primary_data.Application_Resident == 0)
                    {
                        fixed_deposit_primary_data.Str_Application_Resident = "N"; //No
                    }

                    //fixed_deposit_primary_data.Family_Book = rdr.GetString(rdr.GetOrdinal("Family_Book"));
                    //fixed_deposit_primary_data.Str_Family_Book = fixed_deposit_primary_data.Family_Book;



                }
            }
            con.Close();
        }
        return fixed_deposit_primary_data;
    }

    //Function to check duplicate app single row data by id,dob,first name,last name
    public static bool CheckDuplicateFixedDepositData(DateTime dob,string first_name,string last_name,string customer_id)
    {
        bool blnResult = false;
        bl_fixed_deposit_primary_data fixed_deposit_primary_data = new bl_fixed_deposit_primary_data();

        string connString = AppConfiguration.GetConnectionString();

        using (SqlConnection con = new SqlConnection(connString))
        {
            SqlCommand cmd = new SqlCommand("select Top 1 * from V_Report_Primary_Data where ((First_Name = @Fist_Name AND Last_Name = @Last_Name and DOB = @DOB) OR (First_Name = @Last_Name AND Last_Name = @Fist_Name and DOB = @DOB)) AND Customer_ID NOT LIKE @Customer_ID", con);
            cmd.CommandType = CommandType.Text;

            cmd.Parameters.AddWithValue("@Customer_ID", customer_id);
            cmd.Parameters.AddWithValue("@DOB", dob);
            cmd.Parameters.AddWithValue("@Fist_Name", first_name);
            cmd.Parameters.AddWithValue("@Last_Name", last_name);

            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {

                if (rdr.HasRows)
                {
                    blnResult = true;
                }
            }
            con.Close();
        }
        return blnResult;
    }



    #endregion

}