using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for da_fixed_deposit_beneficiary
/// </summary>
public class da_fixed_deposit_beneficiary
{
	

    private static da_fixed_deposit_beneficiary mytitle = null;

    #region "Constructors"

      public da_fixed_deposit_beneficiary()
    {
        if (mytitle == null)
        {
            mytitle = new da_fixed_deposit_beneficiary();
        }
    }

    #endregion

      #region "Public Functions"

      //Insert new flexi term primary data
      public static bool InsertFixedDepositBeneficiary(bl_fixed_deposit_beneficiary fixed_deposit_beneficiary)
      {
          bool result = false;

          string connString = AppConfiguration.GetConnectionString();
          using (SqlConnection con = new SqlConnection(connString))
          {
              SqlCommand cmd = new SqlCommand();
              cmd.CommandType = CommandType.StoredProcedure;
              cmd.CommandText = "SP_Insert_fixed_deposit_Beneficiary";

              //get new primary key for the row to be inserted
              fixed_deposit_beneficiary.fixed_deposit_Beneficiary_ID = Helper.GetNewGuid("SP_Check_fixed_deposit_Beneficiary_ID", "@fixed_deposit_Beneficiary_ID").ToString();

              cmd.Parameters.AddWithValue("@fixed_deposit_Beneficiary_ID", fixed_deposit_beneficiary.fixed_deposit_Beneficiary_ID);
              cmd.Parameters.AddWithValue("@fixed_deposit_Primary_Data_ID", fixed_deposit_beneficiary.fixed_deposit_Primary_Data_ID);
              cmd.Parameters.AddWithValue("@Beneficiary_First_Name", fixed_deposit_beneficiary.Beneficiary_First_Name);
              cmd.Parameters.AddWithValue("@Beneficiary_Last_Name", fixed_deposit_beneficiary.Beneficiary_Last_Name);
              cmd.Parameters.AddWithValue("@Beneficiary_ID_Type", fixed_deposit_beneficiary.Beneficiary_ID_Type);
              cmd.Parameters.AddWithValue("@Beneficiary_ID_Card", fixed_deposit_beneficiary.Beneficiary_ID_Card);
              cmd.Parameters.AddWithValue("@Beneficiary_Relationship", fixed_deposit_beneficiary.Beneficiary_Relationship);
              cmd.Parameters.AddWithValue("@Family_Book", fixed_deposit_beneficiary.Family_Book);
              cmd.Parameters.AddWithValue("@Benefits", fixed_deposit_beneficiary.Benefits);

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


      //Update Ct_fixed_deposit_Beneficiary
      public static bool UpdateFixedDepositBeneficiary(bl_fixed_deposit_beneficiary fixed_deposit_beneficiary)
      {
          bool result = false;
          string connString = AppConfiguration.GetConnectionString();
          using (SqlConnection con = new SqlConnection(connString))
          {
              SqlCommand cmd = new SqlCommand();
              cmd.CommandType = CommandType.StoredProcedure;
              cmd.CommandText = "SP_Update_fixed_deposit_Beneficiary";

              cmd.Parameters.AddWithValue("@fixed_deposit_Beneficiary_ID", fixed_deposit_beneficiary.fixed_deposit_Beneficiary_ID);
              cmd.Parameters.AddWithValue("@fixed_deposit_Primary_Data_ID", fixed_deposit_beneficiary.fixed_deposit_Primary_Data_ID);
              cmd.Parameters.AddWithValue("@Beneficiary_First_Name", fixed_deposit_beneficiary.Beneficiary_First_Name);
              cmd.Parameters.AddWithValue("@Beneficiary_Last_Name", fixed_deposit_beneficiary.Beneficiary_Last_Name);
              cmd.Parameters.AddWithValue("@Beneficiary_ID_Type", fixed_deposit_beneficiary.Beneficiary_ID_Type);
              cmd.Parameters.AddWithValue("@Beneficiary_ID_Card", fixed_deposit_beneficiary.Beneficiary_ID_Card);
              cmd.Parameters.AddWithValue("@Beneficiary_Relationship", fixed_deposit_beneficiary.Beneficiary_Relationship);
              cmd.Parameters.AddWithValue("@Family_Book", fixed_deposit_beneficiary.Family_Book);
              cmd.Parameters.AddWithValue("@Benefits", fixed_deposit_beneficiary.Benefits);


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
                  Log.AddExceptionToLog("Error in function [UpdateFixedDepositBeneficiary] in class [da_fixed_deposit_beneficiary]. Details: " + ex.Message);
              }
          }
          return result;
      }
    //Delete FixedDepositBeneficiary
      public static bool DeleteFixedDepositBeneficiary(string fixed_deposit_Primary_Data_ID)
      {
          bool result = false;
          string connString = AppConfiguration.GetConnectionString();
          using (SqlConnection con = new SqlConnection(connString))
          {
              SqlCommand cmd = new SqlCommand();
              cmd.CommandType = CommandType.StoredProcedure;
              cmd.CommandText = "SP_Delete_fixed_deposit_Beneficiary";

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
                  con.Close();
                  //Add error to log 
                  Log.AddExceptionToLog("Error in function [UpdateFixedDepositBeneficiary] in class [da_fixed_deposit_beneficiary]. Details: " + ex.Message);
              }
          }
          return result;
      }


      #endregion
}