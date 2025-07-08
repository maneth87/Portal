using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Services;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Web.Script.Services;
using System.IO;

/// <summary>
/// Summary description for AppWebService
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class AppWebService : System.Web.Services.WebService {

    public AppWebService () {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    //[WebMethod]
    //public string HelloWorld() {
    //    return "Hello World";
    //}

    //Get Application Single Row Data
    [WebMethod]
    public bl_fixed_deposit_primary_data GetAppSingleRow(string customer_id)
    {
        bl_fixed_deposit_primary_data fixed_deposit_primary_data = new bl_fixed_deposit_primary_data();

        fixed_deposit_primary_data = da_fixed_deposit_primary_data.GetFixedDepositSingleRowData(customer_id);

        return fixed_deposit_primary_data;
    }

    //Get Application Single Row Data
    [WebMethod]
    public bl_fixed_deposit_primary_data GetAppInfoByCertificateNo(string certificate_no,string location_id)
    {
        bl_fixed_deposit_primary_data fixed_deposit_primary_data = new bl_fixed_deposit_primary_data();

        fixed_deposit_primary_data = da_fixed_deposit_primary_data.GetFixedDepositDataByCertificateNo(certificate_no, location_id);

        return fixed_deposit_primary_data;
    }

    //Get Application Single Row Data
    [WebMethod]
    public bool CheckDuplicateApp(string dob,string first_name,string last_name,string customer_id)
    {
        DateTimeFormatInfo dtfi = new DateTimeFormatInfo();
        dtfi.ShortDatePattern = "dd/MM/yyyy";
        dtfi.DateSeparator = "/";

        DateTime my_date_of_birth = System.DateTime.Now;

        if (dob != "")
        {
            my_date_of_birth = Convert.ToDateTime(dob, dtfi);
        }

        return da_fixed_deposit_primary_data.CheckDuplicateFixedDepositData(my_date_of_birth,first_name,last_name,customer_id);

    }

    //Get Benefits by app_id
    [WebMethod]
    public List<bl_app_benefit_item> GetBenefits(string app_id)
    {
        List<bl_app_benefit_item> benefits = new List<bl_app_benefit_item>();

        benefits = da_application.GetAppBenefitItem(app_id);

        return benefits;
    }

    //Save new benefits
    [WebMethod]
    public string SaveBenefiter(string app_id, string id_type, string id_no, string name, string relation, string share, string seq_number,string relation_reason)
    {
        try
        {

            string[] id_type_list = id_type.Split(',');

            string[] id_no_list = id_no.Split(',');

            string[] name_list = name.Split(',');

            string[] share_list = share.Split(',');

            string[] seq_number_list = seq_number.Split(',');

            string[] relation_list = relation.Split(',');
            string[] relation_reason_list = relation_reason.Split(',');

            for (int i = 0; i < id_type_list.Count() - 1; i++)
            {
                if (id_type_list[i].ToString() != "undefined")
                {
                    string my_name = name_list[i];
                    int my_id_type = Convert.ToInt32(id_type_list[i]);
                    string my_id_no = id_no_list[i];
                    double my_share = Convert.ToDouble(share_list[i]);
                    int my_seq_number = i + 1;
                    string my_relationship = relation_list[i];
                    string my_relationship_reason = relation_reason_list[i];

                    if (my_name != "")
                    {
                        string new_guid = Helper.GetNewGuid("SP_Check_App_Benefit_Item_ID", "@App_Benefit_Item_ID").ToString();

                        bl_app_benefit_item benefit_item = new bl_app_benefit_item();

                        benefit_item.App_Benefit_Item_ID = new_guid;
                        benefit_item.App_Register_ID = app_id;
                        benefit_item.Full_Name = my_name.Trim();
                        benefit_item.ID_Type = my_id_type;
                        benefit_item.ID_Card = my_id_no.Trim();
                        benefit_item.Percentage = my_share;
                        benefit_item.Relationship = my_relationship;
                        benefit_item.Relationship_Reason = my_relationship_reason;
                        benefit_item.Seq_Number = Convert.ToInt32(my_seq_number);
                        benefit_item.Relationship_Khmer = da_relationship.GetRelationshipKhmer(benefit_item.Relationship);

                        if (!da_application.InsertAppBenefitItem(benefit_item))
                        { //if saving failed rollback
                            Rollback(app_id);
                            return "0";
                        }
                    }
                }
            }

            return "1"; //successful         

        }
        catch (Exception ex)
        {
            //Add error to log 
            Log.AddExceptionToLog("Error in function [SaveBenefiter] in class [AppWebService]. Details: " + ex.Message);
            Rollback(app_id);
            return "0";
        }
    }

    public void Rollback(string app_id)
    {
        //da_fixed_deposit_primary_data
        //da_f.DeleteAppInfo(app_id);
        da_application.DeleteAppBenefitItem(app_id);
    }


    //Delete Benefit Items by app_id
    [WebMethod]
    public int DeleteBenefitItems(string app_id)
    {
        if (da_application.DeleteAppBenefitItem(app_id))
        {
            return 1;
        }
        else
        {
            return 0;
        }
    }

    //Save back Previous Benefits
    [WebMethod]
    public string SavePreviousBenefiter(string app_id, string id_type, string id_no, string name, string relation, string share)
    {
        try
        {

            string[] id_type_list = id_type.Split(',');

            string[] id_no_list = id_no.Split(',');

            string[] name_list = name.Split(',');

            string[] share_list = share.Split(',');

            string[] relation_list = relation.Split(',');
            int my_seq_number = 0;
            for (int i = 0; i < id_type_list.Count() - 1; i++)
            {
                if (id_type_list[i].ToString() != "undefined")
                {
                    string my_name = name_list[i];
                    int my_id_type = Convert.ToInt32(id_type_list[i]);
                    string my_id_no = id_no_list[i];
                    double my_share = Convert.ToDouble(share_list[i]);
                    my_seq_number += 1;
                    string my_relationship = relation_list[i];

                    if (my_name != "")
                    {
                        string new_guid = Helper.GetNewGuid("SP_Check_App_Benefit_Item_ID", "@App_Benefit_Item_ID").ToString();

                        bl_app_benefit_item benefit_item = new bl_app_benefit_item();

                        benefit_item.App_Benefit_Item_ID = new_guid;
                        benefit_item.App_Register_ID = app_id;
                        benefit_item.Full_Name = my_name.Trim();
                        benefit_item.ID_Type = my_id_type;
                        benefit_item.ID_Card = my_id_no.Trim();
                        benefit_item.Percentage = my_share;
                        benefit_item.Relationship = my_relationship;
                        benefit_item.Seq_Number = Convert.ToInt32(my_seq_number);
                        benefit_item.Relationship_Khmer = da_relationship.GetRelationshipKhmer(benefit_item.Relationship);

                        da_application.InsertAppBenefitItem(benefit_item);
                    }
                }
            }

            return "1"; //successful
        }
        catch (Exception ex)
        {
            //Add error to log 
            Log.AddExceptionToLog("Error in function [SavePreviousBenefiter] in class [AppWebService]. Details: " + ex.Message);
            return "0";
        }
    }



    //Get Maturity
    [WebMethod]
    public string GetMaturityDates(string effective_date, int account_period)
    {
        string maturityDate = "";
        DateTimeFormatInfo dtfi = new DateTimeFormatInfo();
        dtfi.ShortDatePattern = "dd/MM/yyyy";
        dtfi.DateSeparator = "/";

        DateTime newDate = Convert.ToDateTime(effective_date, dtfi);
        newDate = newDate.AddMonths(account_period);
        //marturity date = effective date - one day
        newDate = newDate.AddDays(-1);
        maturityDate = newDate.ToString("dd/MM/yyyy");

        return maturityDate;

    }

      
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)] 
    public void GetToken()
    {
        ResponsToken resToken = new ResponsToken();
        ResponsTokenError resError = new ResponsTokenError();
        System.Net.WebClient web = new WebClient();
        string strResponse = "";
        try
        {

            web.Headers.Add("content-type", "application/json");
            web.Encoding = System.Text.Encoding.UTF8;
            strResponse = web.UploadString(AppConfiguration.GetCamlifeTokenURL(), "userName="+ AppConfiguration.GetCamlifeTokenUser() +"&password="+ AppConfiguration.GetCamlifeTokenPWD() +"&grant_type=password");
            resError = JsonConvert.DeserializeObject<ResponsTokenError>(strResponse);
            if (resError.error != null)
            {
                strResponse = JsonConvert.SerializeObject(resError);
            }
        }
        catch (Exception ex)
        {
            resError = new ResponsTokenError() { error="ERROR", error_description="GET TOKEN ERROR." };
            strResponse = JsonConvert.SerializeObject(resError);
            Log.AddExceptionToLog("Error function [GetToken()] in class [AppWebService], detail:" + ex.Message);
        }
        Context.Response.Clear();
        Context.Response.ContentType = "application/json";
        Context.Response.Write(strResponse);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public void GetAPIURL()
    {
        string url = "";
        string strResponse = "";
        try
        {
            url = AppConfiguration.GetCamlifeAPIURL();
           
            strResponse = JsonConvert.SerializeObject(new ResponseRequest() {  StatusCode=200, Status="OK", Message="Success", Detail=url });

        }
        catch (Exception ex)
        {
           
            strResponse = JsonConvert.SerializeObject(new ResponseRequest() { StatusCode = 0, Status = "ERROR", Message = "Unexpected error", Detail = null });
            Log.AddExceptionToLog("Error function [GetAPIURL()] in class [AppWebService], detail:" + ex.Message);
        }
       
        Context.Response.Clear();
        Context.Response.ContentType = "application/json";
        Context.Response.Write(strResponse);


    }

    [WebMethod]
    public void GetCertificate(string policyId, string policyType, string token)
    {
        System.Net.WebClient web = new WebClient();

        string strResponse = "";
        string url = "";
      
       
        web.Headers[HttpRequestHeader.Authorization] = "Bearer " + token;
        web.Headers.Add("content-type", "application/json");
       
        web.Encoding = System.Text.Encoding.UTF8;
        url = AppConfiguration.GetCamlifeAPIURL() + "Certificate/GetCertificate";
        strResponse = web.UploadString(url, "policyId=" + policyId + "&policyType=" + policyType);
        var objCert = JsonConvert.DeserializeObject<ResponeCertificate>(strResponse);
        if (objCert.StatusCode == 200)
        {
            Context.Response.Clear();
            Context.Response.ContentType = "application/pdf";
            Context.Response.Buffer = true;
            Context.Response.BinaryWrite(objCert.Certificate);
            Context.Response.Flush();
            Context.Response.Close();
        }
    }

    [WebMethod]
    public void UploadFiles()
    {
     
        ResponseRequest resRequest;
        List<string> fileList = new List<string>();
        List<string> reqFileNameList = new List<string>();
        string reqFileName="";
        try
        {
            HttpFileCollection fileCollection = HttpContext.Current.Request.Files;
           
            
            reqFileName =  HttpContext.Current.Request.Form["fileName"];

            reqFileNameList = reqFileName.Split(',').ToList();


            //Create the Directory.
            string path = HttpContext.Current.Server.MapPath("~/TEMP_FILES/");
            if (!Directory.Exists(path))
            {
                Directory.CreateDirectory(path);
            }

            ////Fetch the File.
            //HttpPostedFile postedFile = HttpContext.Current.Request.Files[0];

            ////Fetch the File Name.
            //string fileName = HttpContext.Current.Request.Form["fileName"] + Path.GetExtension(postedFile.FileName);

            ////Save the File.
            //postedFile.SaveAs(path + fileName);

           

            for (int i = 0; i < fileCollection.Count; i++)
            {

                string newFileName = "";
                string ext = "";
                //switch (i)
                //{
                //    case 0:
                //        newFileName = "APP";
                //        break;
                //    case 1:
                //        newFileName = "CERT";
                //        break;
                //    case 2:
                //        newFileName = "ID";
                //        break;
                //    case 3:
                //        newFileName = "PAYSLIP";
                //        break;
                //    default:
                //        newFileName = "";
                //        break;

                //}

                newFileName = reqFileNameList[i];

                HttpPostedFile upload = fileCollection[i];
                ext = Path.GetExtension(upload.FileName);
                int f = fileCollection[i].ContentLength;
                string filename = upload.FileName;
                /*new file name with extention*/
                newFileName = newFileName + ext;
                upload.SaveAs(path + newFileName+ ext);

                fileList.Add(newFileName);
                
            }

            resRequest = new ResponseRequest()
            {
                StatusCode = (int)HttpStatusCode.OK,
                Status = "OK",
                Detail = fileList
            };

        }
        catch (Exception ex)
        {
          
            resRequest = new ResponseRequest()
            {
                StatusCode = (int)HttpStatusCode.InternalServerError,
                Status = "ERROR",
                Detail = null,
                Message=ex.Message
            };
        
        }
        Context.Response.Clear();
        Context.Response.ContentType = "application/json";
        Context.Response.Write(JsonConvert.SerializeObject(resRequest));
    }
    
   public class ResponsToken
    {
        public string access_token { get; set; }
        public string scope { get; set; }
        public string token_type { get; set; }
        public int expires_in { get; set; }
        public DateTime expire_at { get { return calcExpireDate(); } }
        private DateTime calcExpireDate()
        {
            if (expires_in > 0)
            {
                return DateTime.Now.AddSeconds(expires_in);
            }
            else
            {
                return DateTime.Now;
            }
        }
    }
   public class ResponsTokenError
   {
       public string error { get; set; }
       public string error_description { get; set; }
      
   }

   public class ResponseRequest
   {
       public string Status { get; set; }
       public int StatusCode { get; set; }
       public string Message { get; set; }
       public object Detail { get; set; }
   }
   public class ResponeCertificate
   {
       public int StatusCode { get; set; }
       public string Status { get; set; }
       public byte[] Certificate { get; set; }
       public string Message { get; set; }
   }
   public class ResponeApplicationForm
   {
       public int StatusCode { get; set; }
       public string Status { get; set; }
       public byte[] ApplicationForm { get; set; }
       public string Message { get; set; }
   }


    #region upload documents

    #endregion upload documents
}
