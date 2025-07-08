<%@ Page Language="C#" %>



<!DOCTYPE html>

<script runat="server">
   
    private string TOKEN { get { return ViewState["VS_TOKEN"] + ""; } set { ViewState["VS_TOKEN"] = value; } }

    protected void Page_Load(object sender, EventArgs e)
    {

        string strResponse = "";
        string url = "";
        string policyId = "";
        string policyType = "";
        string token = "";
        if (Request.QueryString.Count > 0 && Request.QueryString.Count == 3)
        {
            try
            {
                bl_sys_roles_access accObj = new bl_sys_roles_access();
                var pageAccess = accObj.GetSysRolesAccess(System.Web.Security.Membership.GetUser().UserName, "eApplication_V.aspx");
                if (pageAccess != null)
                {
                    if (pageAccess.IsView == 1)
                    {
                        var qu = Request.QueryString;
                        policyId = qu[0].ToString();
                        policyType = qu[1].ToString();
                        token = qu[2].ToString();
                        TOKEN = token;

                        if (policyId != "")
                        {
                            url = AppConfiguration.GetCamlifeAPIURL() + "Certificate/GetCertificate?policyId=" + policyId + "&policyType=" + policyType;
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
                            AppWebService.ResponeCertificate objCert = Newtonsoft.Json.JsonConvert.DeserializeObject<AppWebService.ResponeCertificate>(responseFromServer);
                            if (objCert.Certificate != null)
                            {
                                Context.Response.Buffer = true;
                                Context.Response.Clear();
                                Context.Response.ContentType = "application/pdf";
                                //Context.Response.AddHeader("content-disposition", "attachment; filename=ECERT" +DateTime.Now.ToString("YYMMddhhmmss") + ".pdf");
                                Context.Response.BinaryWrite(objCert.Certificate);
                                Context.Response.Flush();
                                //Context.Response.Close();
                            }
                            else
                            {
                                // Response.Write(ShowSuccess("No record found."));
                                ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowSuccess", "ShowSuccess('No record found.');", true);
                            }
                        }
                        else
                        {
                            PrintCertificates();
                        }


                    }
                    else
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowErrorRedirect", "ShowErrorRedirect('You do not have permission to view certificate.','Close','../../default.aspx');", true);
                    }
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowErrorRedirect", "ShowErrorRedirect('You do not have permission to access this page.','Close','../../default.aspx');", true);

                }


            }
            catch (Exception ex)
            {
                Log.AddExceptionToLog("Error function [Page_Load] in class [eCertificate_V.aspx], detail:" + ex.Message);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowError", "ShowError('Unexpected error.');", true);
            }
        }

        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowErrorRedirect", "ShowErrorRedirect('Invalid URL.','Close','../../default.aspx');", true);

        }
    }

    private void PrintCertificates()
    {
        try
        {
            var appObj = Request.Cookies["CK_POL_ID_TEMP"].Value;//get cookie from front end
            string url = AppConfiguration.GetCamlifeAPIURL() + "Certificate/GetCertificates";
            System.Net.WebRequest request = System.Net.WebRequest.Create(url);
            request.Method = "POST";
            request.ContentType = "application/json";
            request.Headers.Add("Authorization", "Bearer " + TOKEN);
            /*build body*/
            using (var streamWriter = new System.IO.StreamWriter(request.GetRequestStream()))
            {
                streamWriter.Write(appObj);
                streamWriter.Flush();
            }

            System.Net.WebResponse response = request.GetResponse();
            string strResponse = ((System.Net.HttpWebResponse)response).StatusDescription;//get status code
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
            AppWebService.ResponeCertificate objCert = Newtonsoft.Json.JsonConvert.DeserializeObject<AppWebService.ResponeCertificate>(responseFromServer);
            if (objCert.Certificate != null)
            {
                Context.Response.Buffer = true;
                Context.Response.Clear();
                Context.Response.ContentType = "application/pdf";
                //Context.Response.AddHeader("content-disposition", "attachment; filename=ECERT" +DateTime.Now.ToString("YYMMddhhmmss") + ".pdf");
                Context.Response.BinaryWrite(objCert.Certificate);
                Context.Response.Flush();
                //Context.Response.Close();
            }
            else if (objCert.Status == "OK")
            {
                // Response.Write(ShowSuccess("No record found."));
                ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowSuccess", "ShowSuccess('No record found.');", true);
            }
            else {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowError", "ShowError('" + objCert.Message + "');", true);
            }



        }
        catch (Exception ex)
        {
            Log.AddExceptionToLog("Error function [Page_Load] in class [eCertificate_V.aspx], detail:" + ex.Message);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowError", "ShowError('Unexpected error.');", true);
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
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>

    <link href="../../Scripts/bootstrap/335/css/bootstrap.min.css" rel="stylesheet" />
    <script src="../../Scripts/bootstrap/335/js/bootstrap.min.js"></script>
    <script src="../../Scripts/js/custom.js"></script>
    <link href="../../Scripts/css/custom.css" rel="stylesheet" />


</head>
<body>
    <form id="form1" runat="server">
        <!-- Modal Alert -->
        <div class="modal fade " id="modalAlert" data-backdrop="static" data-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog ">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title" id="modalTitle"></h1>

                    </div>
                    <div class="modal-body">
                        <div class="alert alert-danger" role="alert" id="dvMessage">
                            <p id="pErrorMessage"></p>
                        </div>

                    </div>
                    <div class="modal-footer">
                        <button type="button" id="btnUnderstood" class="btn btn-primary" data-dismiss="modal">Understood</button>

                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
