<%@ Page Title="Camlife" Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="default.aspx.cs" Inherits="_default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Main" runat="Server">
    <script src="Scripts/js/custom.js"></script>
    <script type="text/javascript" >
       
        /*page loading */
        document.onreadystatechange = function () {
            if (document.readyState !== "complete") {
                ShowProgress();
            } else {
                HideProgress();
            }
        };

        $(document).ready(function () {
         
            var u=  GetCookieValue('CK_USERNAME_TEMP');
            var p = GetCookieValue('CK_PASSWORD_TEMP');
         
            /*get login parameters*/
            if (u != '' && p != '') {

              //  if (sessionStorage.hasOwnProperty("SESSION_LOGIN") == false) {

                    p = encodeURIComponent(p);
                    $.ajax({
                        url: "LoginWebService.asmx/Login?userName=" + u + "&password=" + p,
                        method: 'GET',
                        headers: { 'Content-Type': 'text/plain' },
                        contentType: 'application/json',
                        dataType: 'Json',
                        success: function (response) {

                            if (response.Detail != null) {
                                sessionStorage.setItem('SESSION_LOGIN', JSON.stringify(response.Detail));
                                                               
                            }
                            else {

                                ShowErrorRedirect("Access token not found.", "Re-Load", "default.aspx");

                            }
                            HideProgress();
                        },
                        async: false,
                        error: function (err) {
                            ShowError(err);
                        }
                        ,/*progressing*/
                        xhr: function () {
                            var fileXhr = $.ajaxSettings.xhr();
                            if (fileXhr.upload) {

                                ShowProgressWithMessage('Getting application information.');

                            }
                            return fileXhr;
                        }
                    });

               // }
            }
            else {
                /*cookie expiry*/
                ShowErrorRedirect("Login was expired.", "Re-Login", "login.aspx");
            }
          
         
        });
    </script>
    <div class="container">
        <div class="row">
            <div style="width:auto; height:400px; text-align:center; ">
                <div class="col-md-12 camlife-color">

                    <h3><strong> Welcome to Camlife application!</strong></h3>
                 

                </div>
                <div>
                    <img src="App_Themes/images/new_logo.png" />
                </div>
            </div>
        </div>

     <!-- Modal progressing -->
          <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h1> <span class="glyphicon glyphicon-time"></span>  Progressing...</h1>
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
     <!-- Modal -->
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

    </div>
</asp:Content>


