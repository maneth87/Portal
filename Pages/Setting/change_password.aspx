<%@ Page Title="Change Password" Language="C#" MasterPageFile="~/Pages/Content.master" AutoEventWireup="true" CodeFile="change_password.aspx.cs" Inherits="Pages_Setting_change_password" %>



<asp:Content ID="Content1" ContentPlaceHolderID="Main" runat="Server">

    <script src="../../Scripts/js/custom.js"></script>
    <link href="../../Scripts/css/custom.css" rel="stylesheet" />

    <script type="text/javascript">
        var objSession = null;
        var pubPageAccess = null;
        $(document).ready(function () {
           
            objSession = JSON.parse(sessionStorage.getItem('SESSION_LOGIN'));
            if (objSession != null) {
                pubPageAccess = GetPageAccess('change_password.aspx');
                if (pubPageAccess != undefined)
                {
                    if (pubPageAccess.IsView != 1) {
                        ShowErrorRedirect('This page is prohibited.', 'Close', '../../default.aspx');
                    }
                    if (pubPageAccess.IsUpdate != 1)
                    {
                        ShowWarning('You don\'t have permission to change password.');
                        $('#Main_btnChange').prop('disabled', 'disabled');
                        $('#Main_txtCurrentPassword').prop('disabled', 'disabled');
                        $('#Main_txtNewPassword').prop('disabled', 'disabled');
                        $('#Main_txtConfirmPassword').prop('disabled', 'disabled');
                    }
                    
                }
                else
                {
                    ShowErrorRedirect('This page is prohibited.', 'Close', '../../default.aspx');
                }
            }
            else {
                ShowErrorRedirect('SESSION LOGIN not found', 'Close', '../../default.aspx');
            }
        });
        

    </script>
 
    <div class="row row">
        <div class="col-md-7 div-title1">Change Password</div>
        <div class="col-md-7">
            <label>Current Password</label><span class="star">*</span>
            <asp:TextBox runat="server" ID="txtCurrentPassword" TextMode="Password" class="form-control" ></asp:TextBox>
        </div>
        <div class="col-md-7">
            <label>New Password</label><span class="star">*</span>
              <asp:TextBox runat="server" ID="txtNewPassword"  TextMode="Password" class="form-control" ></asp:TextBox>
        </div>
        <div class="col-md-7">
            <label>Confirm New Password</label><span class="star">*</span>
             <asp:TextBox runat="server" ID="txtConfirmPassword"  TextMode="Password" class="form-control" ></asp:TextBox>
        </div>
         <div class="col-md-7">
            <div class="btn-group right" role="group">
                  
                    <asp:Button runat="server" id="btnChange" Text="Change" class=" btn btn-primary button-space" OnClick="btnChange_Click" />
                </div>
        </div>
    </div>
 
  <!-- Modal progressing -->
        <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1><span class="glyphicon glyphicon-time"></span>Progressing...</h1>
                    </div>
                    <div class="modal-body">
                        <p id="pMessage"></p>
                        <div class="progress">
                            <div class="progress-bar progress-bar-striped active" role="progressbar" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100" style="width: 100%">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
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

 
</asp:Content>
