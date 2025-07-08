using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_NB_frmTranFileUpload : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            UploadFile(sender, e);
        }
    }
    protected void UploadFile(object sender, EventArgs e)
    {
        try
        {
            HttpFileCollection fileCollection = Request.Files;
            string savedfile = "";
            for (int i = 0; i < fileCollection.Count; i++)
            {
                try
                {
                    HttpPostedFile upload = fileCollection[i];
                    int f = fileCollection[i].ContentLength;
                    string newName = "hi.xlsx";
                    string filename = "../../Upload/" + newName;// fileCollection[i].FileName;
                    filename = Server.MapPath(filename);
                    upload.SaveAs(filename);
                   savedfile += fileCollection[i].FileName;
                }
                catch (Exception ex)
                {
                    Log.AddExceptionToLog("Error function [UploadFile] in class [frmUploadDocs], detail:" + ex.Message);
                }

            }
        }
        catch (Exception ex)
        {
            Log.AddExceptionToLog("Error function [UploadFile] in class [frmUploadDocs], detail:" + ex.Message);
        }

    }

}