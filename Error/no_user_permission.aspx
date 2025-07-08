<%@ Page Language="C#" AutoEventWireup="true" CodeFile="no_user_permission.aspx.cs" Inherits="Pages_Error_no_user_permission" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>NO PERMISSION | CAMMBODIAN LIFE</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <%-- <h1 style="color:red">User account does not have permission to access this page!</h1>--%>
    <table style="width:100%">
        <tr>
            <td></td>
        </tr>
        <tr>
            <td></td>
        </tr>
        <tr>
            <td></td>
        </tr>
        <tr>
            <td></td>
        </tr>
        <tr>
            <td></td>
        </tr>
        <tr>
            <td align="center">
                <img src="../App_Themes/images/no_permission.jpg"
            </td>
        </tr>
        <tr>
            <td align="center">
                <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="~/App_Themes/images/back-button.png" Width="50px" Height="50px" OnClick="ImageButton1_Click" />
                <br /><p style="font-family: Arial;">Click arrow button to go back...</p>
            </td>
        </tr>
        <tr>
            <td></td>
        </tr>
        <tr>
            <td></td>
        </tr>
        <tr>
            <td></td>
        </tr>
        <tr>
            <td></td>
        </tr>
    </table>
    </div>
    </form>
</body>
</html>
