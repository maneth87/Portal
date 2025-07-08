using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class login : System.Web.UI.Page
{
    private string URLKEY { get { return ViewState["VS_URLKEY"] + ""; } set { ViewState["VS_URLKEY"] = value; } }
    //private HttpCookie USERCOOK { get { return (HttpCookie)ViewState["VS_COOK"]; } set { ViewState["VS_COOK"] = value; } }
    HttpCookie USERCOOK;
    protected void Page_Load(object sender, EventArgs e)
    {
        //if (!Page.IsPostBack)
        //{
        //    try
        //    {
        //        if (Request.QueryString.Count > 0)
        //        {
        //            URLKEY = Request.QueryString["url_key"].ToString();
        //            if (da_user_permission.UrlKeyIsApprove(URLKEY))
        //            {
        //                form1.Visible = true;
        //            }
        //            else
        //            {
        //                form1.Visible = false;
        //                Response.Redirect("NotFound.html");
        //            }

        //        }
        //        else
        //        {
        //            form1.Visible = false;
        //            Response.Redirect("NotFound.html");
        //        }
        //    }
        //   catch( Exception ex )
        //    {
        //        Response.Write(ex.Message);
        //   }


        //}
        //  USERCOOK = Request.Cookies["COOK_USER"];
        if (!Page.IsPostBack)
        {

            if (Request.Cookies["CK_USERNAME"] != null && Request.Cookies["CK_PASSWORD"] != null)
            {
                var u = Request.Cookies["CK_USERNAME"].Value;
                var p = Request.Cookies["CK_PASSWORD"].Value;

                txtusername.Text = u;
                txtpassword.Text = p != null ? bl_security.StringCipher.Decrypt(p, "#!@$%&") : "";
                chkRememberMe.Checked = true;
            }



            //if (USERCOOK != null)
            //{
            //    string a = USERCOOK["UserName"];
            //    string b = USERCOOK["Password"] != null ? bl_security.StringCipher.Decrypt(USERCOOK["Password"], "#!@$%&") : "";
            //    chkRememberMe.Checked = true;
            //    txtusername.Text = a;
            //    txtpassword.Text = b;
            //}
        }

    }
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        try
        {
            string username, password;
            var p = "";

            var u = "";
            var a = Request.Cookies["CK_PASSWORD"];

            if (Request.Cookies["CK_PASSWORD"] != null && Request.Cookies["CK_USERNAME"] != null)
            {
                u = Request.Cookies["CK_USERNAME"].Value;/*cookie to remember in browser*/
                p = Request.Cookies["CK_PASSWORD"].Value;/*cookie to remember in browser*/

            }
            p = p!="" ? bl_security.StringCipher.Decrypt(p, "#!@$%&") :"";

            username = txtusername.Text.Trim();
            password = txtpassword.Text.Trim() == "" ? p : txtpassword.Text.Trim();

            #region blocked
            //MembershipProvider provider;
            //provider = Membership.Providers["SqlProvider"];
            //RoleProvider role = Roles.Providers["SqlRoleProvider"];
            //string[] roles = role.GetRolesForUser(username);


            //if (URLKEY != null && URLKEY!="")
            //{

            //    if (Membership.ValidateUser(username, password))
            //    {
            //        if (Roles.IsUserInRole(username, "ExternalUser") || Roles.IsUserInRole(username, "Administrator"))
            //        {

            //            //Check user in table user permission whether is allowed to use this application or not

            //            //  string user_id = Membership.GetUser().ProviderUserKey.ToString();
            //            // string user_name = username;

            //            //get application_id by application_code (AP-009 = Flexi Term System)
            //            //string application_id = da_application.GetApplicationIDByApplicationCode("AP-009");

            //            //bl_User_Permission user_permission = new bl_User_Permission();

            //            ////check user permission
            //            //if (!da_user_permission.CheckUserPermissionForThisApplication(application_id, user_id))
            //            //{
            //            //    //User no access right to this page then redirect to need permission for this application page
            //            //    //Response.Redirect("~/Error/no_user_permission.aspx");
            //            //    ClientScript.RegisterStartupScript(this.GetType(), "", "alert('No access permission!')", true);
            //            //}
            //            //else
            //            //{
            //            //    FormsAuthentication.SetAuthCookie(username, true);

            //            //    //Insert User Login info
            //            //    bl_User_log user_log = new bl_User_log();
            //            //    user_log.User_ID = user_id.ToUpper();
            //            //    user_log.Login_By = username;
            //            //    user_log.Login_On = DateTime.Now;
            //            //    user_log.Application_ID = application_id;

            //            //    da_user_log.InsertUserLog(user_log);

            //            //    Response.Redirect("~/default.aspx");
            //            //}
            //            FormsAuthentication.SetAuthCookie(username, true);

            //            //Insert User Login info
            //            //bl_User_log user_log = new bl_User_log();
            //            //user_log.User_ID = user_id.ToUpper();
            //            //user_log.Login_By = username;
            //            //user_log.Login_On = DateTime.Now;
            //            //user_log.Application_ID = application_id;

            //            //da_user_log.InsertUserLog(user_log);

            //           // Response.Redirect("~/default.aspx",false);
            //            FormsAuthentication.RedirectFromLoginPage(username, chkRememberMe.Checked);
            //            lblResult.Text = URLKEY;
            //        }
            //        else
            //        {
            //            ClientScript.RegisterStartupScript(this.GetType(), "", "alert('No access permission!')", true);
            //        }
            //    }
            //    else
            //    {
            //        lblResult.Text = "Login failed. Please try again!";
            //    }
            //}
            //else
            //{
            //    lblResult.Text = "Invalid link.";
            //}

            //FormsAuthentication.SetAuthCookie(username, true);

            //FormsAuthentication.RedirectFromLoginPage(username, chkRememberMe.Checked);
            #endregion

            if (Membership.ValidateUser(username, password))
            {
             
                //if (Roles.IsUserInRole(username, "ExternalUser") || Roles.IsUserInRole(username, "Administrator"))
                //{
                    HttpCookie cUser1 = new HttpCookie("CK_USERNAME_TEMP"); /*cookie for use in page default load*/
                    cUser1.Value = username;
                    cUser1.Expires = DateTime.Now.AddHours(1);
                    HttpCookie cPwd1 = new HttpCookie("CK_PASSWORD_TEMP");/*cookie for use in page default load*/
                    cPwd1.Value = bl_security.StringCipher.Encrypt(password, "#!@$%&");
                   // cPwd1.Value = Server.UrlEncode( bl_security.Encrypt64.EncrypeQuerystring(password));

                   
                    cPwd1.Expires = DateTime.Now.AddHours(1);
                    Response.Cookies.Add(cUser1);
                    Response.Cookies.Add(cPwd1);

                    if (chkRememberMe.Checked)
                    {
                        if (string.IsNullOrWhiteSpace( u)  && string.IsNullOrWhiteSpace( p ))// if existing cookie is null then create new cookie
                        {
                            HttpCookie cUser = new HttpCookie("CK_USERNAME");
                            cUser.Value = username;
                            cUser.Expires = DateTime.Now.AddDays(7);
                            HttpCookie cPwd = new HttpCookie("CK_PASSWORD");
                           cPwd.Value = bl_security.StringCipher.Encrypt(password, "#!@$%&");
                          //  cPwd.Value = bl_security.Encrypt64.EncrypeQuerystring(password);

                            cPwd.Expires = DateTime.Now.AddDays(7);

                            Response.Cookies.Add(cUser);
                            Response.Cookies.Add(cPwd);
                        }

                    }
                    else
                    {
                        //  clear existing cookie
                        HttpCookie cUser = new HttpCookie("CK_USERNAME");
                        cUser.Expires = DateTime.Now.AddDays(-1);
                        HttpCookie cPwd = new HttpCookie("CK_PASSWORD");
                        cPwd.Expires = DateTime.Now.AddDays(-1);
                        Response.Cookies.Add(cUser);
                        Response.Cookies.Add(cPwd);
                    }
                    
                    FormsAuthentication.SetAuthCookie(username, true);
                    FormsAuthentication.RedirectFromLoginPage(username, chkRememberMe.Checked);

                //}
                //else
                //{
                //    lblResult.Text = "User name is not exist in the role.";
                //}

            }
            else
            {
                lblResult.Text = "Login failed. Please try again!";
            }

        }

        catch (Exception ex)
        {
            Log.AddExceptionToLog("Error occured on page login. Details: " + ex.Message + "=>" + ex.StackTrace);
        }
        
    }
    
}