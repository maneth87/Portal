using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_NB_frmUploadDocs_View : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string strResponse = "";
        string url = "";
        string filePath = "";
        string docType = "";
        string token = "";
        if (Request.QueryString.Count > 0 && Request.QueryString.Count == 3)
        {
            try
            {
                var qu = Request.QueryString;
                filePath = qu[0].ToString();

                token = qu[1].ToString();
                docType = qu[2].ToString();
                url = AppConfiguration.GetCamlifeAPIURL() + "Document/GetFile?filePath=" + filePath + "&docType=" + docType;
                System.Net.WebRequest request = System.Net.WebRequest.Create(url);

                request.Method = "GET";
                request.Headers.Add("Authorization", "Bearer " + token);
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
                ResponseRequest res = Newtonsoft.Json.JsonConvert.DeserializeObject<ResponseRequest>(responseFromServer);
                if (res.Detail != null)
                {
                    string conType = "";
                    string[] img = new string[] { ".JPG", ".JPEG", ".PNG" };

                    if (img.Contains(res.Detail.Ext.ToUpper()))
                    {
                        conType = "image/jpeg";
                    }
                    else if (res.Detail.Ext.ToUpper() == ".PDF")
                    {
                        conType = "application/pdf";
                    }

                    byte[] file = res.Detail.File;
                    Context.Response.Clear();
                    Context.Response.ContentType = conType;// "application/pdf";
                    Context.Response.Buffer = true;
                    Context.Response.BinaryWrite(file);
                    Context.Response.Flush();
                    //Context.Response.Close();
                }
                else
                {
                    Response.Write(ShowError(res.Message));
                }
            }
            catch (Exception ex)
            {
                Log.AddExceptionToLog("Error function [Page_Load] in class [eApplication_V.aspx], detail:" + ex.Message);
                Response.Write(ShowError("Unexpected error."));
            }
        }

        else
        {
            Response.Write(ShowError("Invalid URL"));
        }
    }
    private string ShowError(string Error)
    {
        string response = "<div class=\"row\" id=\"dvRow\"> <div class=\"col-md-12\">  <div class=\"alert alert-danger\" role=\"alert\"> <h4 class=\"alert-heading\"> <span class=\"glyphicon glyphicon-remove\"></span>&nbsp;&nbsp;ERROR</h4> <p id=\"pMessage\">" + Error + "</p></div></div></div>";
        return response;
    }
    private string ShowSuccess(string sms)
    {
        string response = "<div class=\"row\" id=\"dvRow\"> <div class=\"col-md-12\">  <div class=\"alert alert-success\" role=\"alert\"> <h4 class=\"alert-heading\"> <span class=\"glyphicon glyphicon-ok\"></span>&nbsp;&nbsp;Success</h4> <p id=\"pMessage\">" + sms + "</p></div></div></div>";
        return response;
    }
    class ResponseRequest
    {
        public string Status { get; set; }
        public int StatusCode { get; set; }
        public string Message { get; set; }
        //public byte[] Detail { get; set; }
        public ResponseFile Detail { get; set; }

    }
    class ResponseFile
    {
        public string Ext { get; set; }
        public byte[] File { get; set; }
    }
}