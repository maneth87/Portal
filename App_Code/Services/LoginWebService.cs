using System;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Security;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Net;
using System.Collections.Generic;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class LoginWebService : System.Web.Services.WebService
{
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]

    public void Login(string userName, string password)
    {
        string url = "";
        string strResponse = "";

        ResponseLogin resLogin = new ResponseLogin();
        ResponseRequest resReq = new ResponseRequest();

        bool tranSuccess = true;
        try
        {
            //var dePassword = bl_security.StringCipher.Decrypt( password.Replace(" ","+"), "#!@$%&");
            var dePassword = bl_security.StringCipher.Decrypt(password, "#!@$%&");

           // var dePassword = bl_security.Encrypt64.DecrypeQuerystring(password);
          
            if (Membership.ValidateUser(userName, dePassword))
            {

                resLogin.UserName = userName;
                AppWebService.ResponsToken resToken = new AppWebService.ResponsToken();
                AppWebService.ResponsTokenError resError = new AppWebService.ResponsTokenError();
                System.Net.WebClient web = new WebClient();
                try
                {
                    web.Headers.Add("content-type", "application/json");
                    web.Encoding = System.Text.Encoding.UTF8;
                    strResponse = web.UploadString(AppConfiguration.GetCamlifeTokenURL(), "userName=" + AppConfiguration.GetCamlifeTokenUser() + "&password=" + AppConfiguration.GetCamlifeTokenPWD() + "&grant_type=password");
                    resError = JsonConvert.DeserializeObject<AppWebService.ResponsTokenError>(strResponse);
                    if (resError.error == null)
                    {
                        AppWebService.ResponsToken objToken = JsonConvert.DeserializeObject<AppWebService.ResponsToken>(strResponse);
                        resLogin.Token = objToken;

                        /*Get sale agent information*/
                        url = AppConfiguration.GetCamlifeAPIURL() + "SaleAgent/GetChannelSaleAgentByUserName?userName=" + userName;
                        System.Net.WebRequest request = System.Net.WebRequest.Create(url);

                        request.Method = "GET";
                        request.Headers.Add("Authorization", "Bearer " + objToken.access_token);
                        System.Net.WebResponse response = request.GetResponse();
                        strResponse = ((System.Net.HttpWebResponse)response).StatusDescription;//get status code
                        // Get the stream containing content returned by the server.  
                        System.IO.Stream dataStream = response.GetResponseStream();
                        // Open the stream using a StreamReader for easy access.  
                        System.IO.StreamReader reader = new System.IO.StreamReader(dataStream);
                        // Read the content.  
                        string responseFromServer = reader.ReadToEnd();
                        // Display the content.  
                        //Console.WriteLine(responseFromServer);  
                        // Clean up the streams and the response.  
                        reader.Close();
                        response.Close();
                        ResponseAgent agent = Newtonsoft.Json.JsonConvert.DeserializeObject<ResponseAgent>(responseFromServer);
                        if (agent.Detail != null)
                        {
                            var obj = agent.Detail;
                            AgentInfo agentInfo = new AgentInfo()
                            {
                                AgentCode = obj.SALE_AGENT_ID,
                                AgentNameEn = obj.AgentNameEn,
                                AgentNameKh = obj.AgentNameKh,
                                Channels = obj.Channels,
                                ChannelItems=obj.ChannelItems
                            };

                            resLogin.Agent = agentInfo;
                        }
                        else
                        {
                            resLogin.Agent = null;
                        }

                        /*get role access*/
                   
                        bl_sys_roles_access rObject = new bl_sys_roles_access();
                        List<bl_sys_roles_access> rAccess = new List<bl_sys_roles_access>();
                        rAccess = rObject.GetSysRolesAccessByUserName(userName);
                        resLogin.RoleAccess = rAccess;
                        tranSuccess = true;
                    }

                }
                catch (Exception ex)
                {
                    Log.AddExceptionToLog("Error block get token in class [LoginWebservice], detail:" + ex.Message);
                    tranSuccess = false;
                    resReq.Message = "Get token error.";
                    resReq.Status = HttpStatusCode.InternalServerError.ToString();
                    resReq.StatusCode = (int)HttpStatusCode.InternalServerError;
                    resLogin = null;
                }

                /*get api url*/
                try
                {
                    url = AppConfiguration.GetCamlifeAPIURL();
                    resLogin.APIUrl = url;
                    tranSuccess = true;
                }
                catch (Exception ex)
                {
                    Log.AddExceptionToLog("Error block get api url in class [LoginWebservice], detail:" + ex.Message);
                
                    tranSuccess = false;
                    resReq.Message = "Get API Url error.";
                    resReq.Status = HttpStatusCode.InternalServerError.ToString();
                    resReq.StatusCode = (int)HttpStatusCode.InternalServerError;
                    resLogin = null;
                   
                }

                /*get sale agent*/

            }
            else
            {
                /*login fail*/
                resReq.Status = HttpStatusCode.Unauthorized.ToString();
                resReq.StatusCode =(int) HttpStatusCode.Unauthorized;
                resReq.Message = "User name or password is not correct.";
                resLogin = null;// "User name or password is not correct.";
                tranSuccess = true;
            }
        }
        catch (Exception ex)
        {
            Log.AddExceptionToLog("Error function [Login(string userName, string password, bool rememberMe)] in class [LoginWebservice], detail:" + ex.Message);
         
            resReq.Status = HttpStatusCode.InternalServerError.ToString();
            resReq.StatusCode = (int)HttpStatusCode.InternalServerError;
            resReq.Message = "Unexpected error.";
            resLogin = null;// "User name or password is not correct.";
            tranSuccess = false;
        }

        if (tranSuccess)
        {
            resReq.Status = HttpStatusCode.OK.ToString();
            resReq.StatusCode =(int) HttpStatusCode.OK;
            resReq.Message = "Success";
        }

        resReq.Detail = resLogin;
        strResponse = JsonConvert.SerializeObject(resReq);

        Context.Response.Clear();
        Context.Response.ContentType = "application/json";
        Context.Response.Write(strResponse);

    }

    //[WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public void ChangePassword(string userName, string currentPassword, string newPassword, string confirmPassword)
    {
        ResponseRequest res = new ResponseRequest();
        try
        {
            MembershipUser myUser = Membership.GetUser();
            string user_id = myUser.ProviderUserKey.ToString();

            string user_name = userName;// User.Identity.Name;



            //  check if old pass provided is correct
            if (Membership.ValidateUser(user_name, currentPassword))
            {

                int result = 0;
                result = string.Compare(newPassword, confirmPassword);

                if (result == 0)/*match*/
                {
                    if (newPassword.Length < 8)
                    {

                        res = new ResponseRequest()
                        {
                            Status = HttpStatusCode.OK.ToString(),
                            StatusCode = (int)HttpStatusCode.OK,
                            Message = "New password requires at least 8 characters.",
                            Detail = null
                        };
                    }
                    else
                    {
                        MembershipUser myuser = Membership.GetUser(user_name);
                        if (!myuser.ChangePassword(currentPassword, newPassword))
                        {
                            res = new ResponseRequest()
                            {
                                Status = HttpStatusCode.OK.ToString(),
                                StatusCode = (int)HttpStatusCode.OK,
                                Message = "Change password fail.",
                                Detail = null
                            };
                        }
                        else
                        {
                            res = new ResponseRequest()
                            {
                                Status = HttpStatusCode.OK.ToString(),
                                StatusCode = (int)HttpStatusCode.OK,
                                Message = "Your password has been changed.",
                                Detail = null
                            };
                        }
                    }
                    
                }
                else
                {

                    res = new ResponseRequest()
                    {
                        Status = HttpStatusCode.OK.ToString(),
                        StatusCode = (int)HttpStatusCode.OK,
                        Message = "New password and confirm password mismatched. Please check your input again.",
                        Detail = null
                    };
                }


            }
            else
            {
                res = new ResponseRequest()
                {
                    Status = HttpStatusCode.OK.ToString(),
                    StatusCode = (int)HttpStatusCode.OK,
                    Message = "The old password you supplied is incorrect. Please check your input again.",
                    Detail = null
                };
            }

        }
        catch (Exception ex)
        {
            Log.AddExceptionToLog("Error Function [ChangePassword(string currentPassword, string newPassword, string confirmPassword)] in class [change_password.aspx.cs], detail: " + ex.Message);
            res = new ResponseRequest()
            {
                Status = HttpStatusCode.InternalServerError.ToString(),
                StatusCode = (int)HttpStatusCode.InternalServerError,
                Message = "Unexpected Error.",
                Detail = null
            };
        }

        string strResponse = JsonConvert.SerializeObject(res);

        Context.Response.Clear();
        Context.Response.ContentType = "application/json";
        Context.Response.Write(strResponse);

    }


    public class ResponseRequest
    {
        public string Status { get; set; }
        public int StatusCode { get; set; }
        public string Message { get; set; }
        public object Detail { get; set; }
    }

    public class ResponseLogin
    {
        public string UserName { get; set; }
        public string APIUrl { get; set; }
        public DateTime SysDate { get { return DateTime.Now; } }
        public AppWebService.ResponsToken Token { get; set; }
        public AgentInfo Agent { get; set; }
        public List<bl_sys_roles_access> RoleAccess { get; set; }
    }

    public class AgentInfo
    {
        public string AgentCode { get; set; }
        public string AgentNameEn { get; set; }
        public string AgentNameKh { get; set; }
      
        public List<AgentChannel> Channels { get; set; }
        public List<bl_channel_item> ChannelItems { get; set; }
    }

    public class bl_channel_sale_agent
    {

        public string ID { get; set; }
        public string USER_NAME { get; set; }
        public string SALE_AGENT_ID { get; set; }
        public string AgentNameEn { get; set; }
        public string AgentNameKh { get; set; }
        public string REMARKS { get; set; }
        public List<AgentChannel> Channels { get; set; }



    }
    public class AgentChannel
    {
        public string ChannelItemId { get; set; }
        public string ChannelName { get; set; }
        public string ChannelLocationId { get; set; }
        public string OfficeCode { get; set; }
        public string OfficeName { get; set; }
    }

    public class ResponseAgent
    {
        public string Status { get; set; }
        public int StatusCode { get; set; }
        public string Message { get; set; }
        public details Detail { get; set; }
    }

    public class details : bl_channel_sale_agent
    {
       public List<bl_channel_item> ChannelItems { get; set;   }
    }

}