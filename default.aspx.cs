using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Globalization;

public partial class _default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Request.IsAuthenticated)
        {
            Response.Redirect("login.aspx");
        }
        else
        {
            MembershipUser myUser = Membership.GetUser();
            string user_id = myUser.ProviderUserKey.ToString();
            string user_name = myUser.UserName;

            //Check user in roles
            //if (!Roles.IsUserInRole(user_name, "ExternalUser") && !Roles.IsUserInRole(user_name, "Administrator"))
            //{
            //    Response.Redirect("login.aspx");
            //}            

            
        }
       
    }
}