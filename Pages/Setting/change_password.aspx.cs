
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Net.Configuration;
using System.Web;
using System.Web.Configuration;
using System.Web.Script.Services;
using System.Web.Security;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;


[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]

public partial class Pages_Setting_change_password : System.Web.UI.Page
{

    //Button Change password click
    protected void ImgBtnChange_Click(object sender, ImageClickEventArgs e)
    {
        //try
        //{
        //    MembershipUser myUser = Membership.GetUser();
        //    string user_id = myUser.ProviderUserKey.ToString();

        // //   get channel, channel item and channel location
        //    string sale_agent_id = da_sale_agent.GetSaleAgentIDByUserID(user_id);

        //    if (sale_agent_id == "")
        //    {
        //        //False User return to login
        //        Response.Redirect("~/login.aspx");
        //    }

        //    string strOldPass = null;
        //    string strNewPass = null;
        //    string strConfirmPass = null;
        //    string user_name = User.Identity.Name;

        //    strOldPass = txtOldPassword.Text;

        //  //  check if old pass provided is correct
        //    if (Membership.ValidateUser(user_name, strOldPass))
        //    {
        //        strNewPass = txtNewPassword.Text;
        //        strConfirmPass = txtConfirmNewPassword.Text;

        //        int result = 0;
        //        result = string.Compare(strNewPass, strConfirmPass);


        //        if (result == 0)
        //        {
        //            if (strNewPass.Length < 8)
        //            {
        //                lblmessage.Text = "New password requires at least 8 characters.";
        //                lblmessage.ForeColor = System.Drawing.Color.Red;
        //                return;
        //            }

        //            MembershipUser myuser = Membership.GetUser(user_name);
        //            if (!myuser.ChangePassword(strOldPass, strNewPass))
        //            {
        //                lblmessage.Text = "Change password failed!";
        //                lblmessage.ForeColor = System.Drawing.Color.Red;
        //            }
        //            else
        //            {

        //                lblmessage.Text = "Your password has been changed.";
        //                lblmessage.ForeColor = System.Drawing.Color.Green;
        //            }

        //            MembershipUser u = Membership.GetUser(user_name, false);

        //            if(u.Email.Substring(0, 4) != "demo")
        //            {
        //                //Start send mail
        //                DateTime date_created = default(DateTime);
        //                date_created = System.DateTime.Now;                

        //                string senderEmail = "webmaster@cambodianlife.com.kh";

        //                // get the email address from the web.conf
        //                //Configuration configurationFile = WebConfigurationManager.OpenWebConfiguration("~\\Web.config");
        //                MailSettingsSectionGroup mailSettings = ConfigurationManager.GetSection("system.net/mailSettings/smtp") as MailSettingsSectionGroup;
        //                if (mailSettings != null)
        //                {
        //                    int port = mailSettings.Smtp.Network.Port;
        //                    string host = mailSettings.Smtp.Network.Host;
        //                    string password = mailSettings.Smtp.Network.Password;
        //                    string username = mailSettings.Smtp.Network.UserName;
        //                    senderEmail = mailSettings.Smtp.From;
        //                }

        //                string emailtopic = null;
        //                string emailmessage = null;

        //                emailtopic = "Password Reset on " + System.DateTime.Now.ToLongDateString() + " at " + System.DateTime.Now.ToLongTimeString();

        //                emailmessage = "<span style=\"font-family:Calibri; font-size: 15px;\">Dear " + user_name + ", <br /><br />";
        //                emailmessage += "Your password has been changed. Your new password is <span style=\"font-weight: bold;\">" + strNewPass + "</span><br /><br />";

        //                emailmessage += "Thank you, <br/>Flexi Term Insurance System</span>";

        //                //Send mail to sales and service

        //                //EmailSender.SendMailMessage(senderEmail, u.Email, "vatanak.sok@cambodianlife.com.kh", emailtopic, emailmessage);

        //                //Send mail to the right person
        //            }
        //            txtOldPassword.Text = "";
        //            txtNewPassword.Text = "";
        //            txtConfirmNewPassword.Text = "";
        //        }
        //        else
        //        {
        //            lblmessage.Text = "New password and confirm password mismatched. Please check your input again.";
        //            lblmessage.ForeColor = System.Drawing.Color.Red;
        //        }

        //        old password provided mismatched password in db
        //    }
        //    else
        //    {
        //        lblmessage.Text = "The old password you supplied is incorrect. Please check your input again.";
        //        lblmessage.ForeColor = System.Drawing.Color.Red;
        //    }

        //}
        //catch (Exception ex)
        //{

        //    lblmessage.Text = "Error ! Details: " + ex.Message;
        //    lblmessage.ForeColor = System.Drawing.Color.Red;
        //    Log.AddExceptionToLog("Error in function [btnChangePassword_Click], class [account.aspx.vb]. Details: " + ex.Message);
        //}
    }


    protected void btnChange_Click(object sender, EventArgs e)
    {
        try
        {
            MembershipUser myUser = Membership.GetUser();
            string user_id = myUser.ProviderUserKey.ToString();
            string userName = User.Identity.Name;
            string currentPassword= txtCurrentPassword.Text;
            string newPassword=txtNewPassword.Text;
            string confirmPassword = txtConfirmPassword.Text;

            //  check if old pass provided is correct
            if (Membership.ValidateUser(userName, currentPassword))
            {

                int result = 0;
                result = string.Compare(newPassword, confirmPassword);

                if (result == 0)/*match*/
                {
                    if (newPassword.Length < 8)
                    {

                        ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowError", "ShowError('New password requires at least 8 characters.');", true);
                    }

                    MembershipUser myuser = Membership.GetUser(userName);
                    if (!myuser.ChangePassword(currentPassword, newPassword))
                    {

                        ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowError", "ShowError('Change password fail.');", true);

                    }
                    else
                    {
                      
                        //ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "scr", "javascript:ShowSuccess('Your password has been changed.');", true);
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowSuccessRedirect", "ShowSuccessRedirect('Your password has been changed.','Re-login','../../login.aspx');", true);

                    }
                }
                else
                {
                
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowError", "ShowError('New password and confirm password mismatched. Please check your input again.');", true);
                }
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowError", "ShowError('The old password you supplied is incorrect. Please check your input again.');", true);
            }

        }
        catch (Exception ex)
        {
            Log.AddExceptionToLog("Error Function [ChangePassword(string currentPassword, string newPassword, string confirmPassword)] in class [change_password.aspx.cs], detail: " + ex.Message);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowError", "ShowError('Unexpected Error.');", true);

        }

    }
}