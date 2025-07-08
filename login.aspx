<%@ Page Language="C#" AutoEventWireup="true" CodeFile="login.aspx.cs" Inherits="login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Camlife</title>
    <link href="~/Camlife_Icon.ico" rel="shortcut icon" type="image/x-icon" />
    <link href="Scripts/bootstrap/335/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <link href="Scripts/css/custom.css" rel="stylesheet" />
    <script src="Scripts/js/custom.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            /*button submit*/
            $('#btnSubmit').click(function () {
                //var objCheck = $('#chkRememberMe');
                //if (objCheck.val() == true)
                //{
                //    setCookie('CKNAME', 'maneth', 7);
                //}
                //alert(getCookie('CKNAME'));

            });
        });
    </script>
</head>

<body class="body-login">
    <form id="form1" runat="server">

      <%--  <div class="container">--%>


            <div class="cernter-page">
                <div>
                    <img src="App_Themes/images/new_logo.gif" class="login-logo" />
                </div>

                <h1 class="login-title">LOGIN</h1>
                <div class=" row ">

                    <div class="col-xs-11">
                        <asp:TextBox ID="txtusername" runat="server" placeholder="Username" Class="form-control"></asp:TextBox>
                    </div>

                    <div class="col-xs-11 margin-top-10">
                        <asp:TextBox ID="txtpassword" runat="server" placeholder="Password" TextMode="Password" Class="form-control"></asp:TextBox>
                    </div>
                    <div class="col-xs-11">
                        <label class="login-remember">
                            <asp:CheckBox ID="chkRememberMe" runat="server" />
                            Remember me on this device
         
                        </label>
                    </div>
                    <div class="col-xs-11">
                        <asp:Button ID="btnSubmit" name="commit" runat="server" Text="Login" OnClick="btnSubmit_Click" Class="form-control btn btn-primary" />
                    </div>
                    <div class="col-xs-11">
                        <asp:Label ID="lblResult" runat="server" Text="" ForeColor="Red"></asp:Label>
                    </div>

                </div>
            </div>

 <%--       </div>--%>
          
    </form>

</body>
</html>
