using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;

public partial class Pages_NB_frmAppForm : System.Web.UI.Page
{
    private string PrUserName { get { return ViewState["VS_PRUSERNAME"] + ""; } set { ViewState["VS_PRUSERNAME"] = value; } }
    protected void Page_Load(object sender, EventArgs e)
    {
        PrUserName = Membership.GetUser().UserName;
        hdfUserName.Value = PrUserName;
      
        if (!Page.IsPostBack)
        {
            hdfTokenUrl.Value = AppConfiguration.GetCamlifeTokenURL();
            hdfAPIUrl.Value = AppConfiguration.GetCamlifeAPIURL();
        
           txtApplicationDate.Text = DateTime.Now.ToString("dd/MM/yyyy");
           txtIssueDate.Text = DateTime.Now.ToString("dd/MM/yyyy");

        

        }

       
    }
  
  
}