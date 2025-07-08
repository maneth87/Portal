<%@ Page Title="" Language="C#" MasterPageFile="~/Pages/Content.master" AutoEventWireup="true" CodeFile="frmAppPendingIssuePolicy.aspx.cs" Inherits="Pages_frmAppPendingIssuePolicy" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Main" runat="Server">

    <%-- export to excel --%>
    <script src="../../Scripts/jquery.battatech.excelexport.min.js"></script>
    <script src="../../Scripts/jquery.battatech.excelexport.js"></script>

    <link href="../../Scripts/bootstrap/datepicker/css/datepicker.css" rel="stylesheet" />
    <script src="../../Scripts/bootstrap/datepicker/js/bootstrap-datepicker.js"></script>
    <script src="../../Scripts/moment.js"></script>
    <script src="../../Scripts/js/custom.js"></script>


    <script type="text/javascript">
        var objSession = null;
        var pubPageAccess = null;
        $(document).ready(function () {

            /*hide*/
            $('#btnExport').hide();

            $('#Main_txtDateFrom').datepicker();
            $('#Main_txtDateTo').datepicker();

            var d = new Date();

            var month = d.getMonth() + 1;
            var day = d.getDate();

            var output = (day < 10 ? '0' : '') + day + '/' +
                (month < 10 ? '0' : '') + month + '/' + d.getFullYear();


            $('#Main_txtDateFrom').val(output);
            $('#Main_txtDateTo').val(output);

            var pagePathName = window.location.pathname;
            var pName = pagePathName.substring(pagePathName.lastIndexOf("/") + 1);


            objSession = JSON.parse(sessionStorage.getItem('SESSION_LOGIN'));
            if (objSession != null) {
                if (Date.parse(new Date()) < Date.parse(objSession.Token.expire_at)) {
                    pubPageAccess = GetPageAccess(pName);
                    if (pubPageAccess != undefined) {
                        if (pubPageAccess.IsView != 1) {

                            /*user no have permisssion */
                            ShowErrorRedirect('You do not have permission to access this page.', 'Re-Load', '../../default.aspx');
                        }

                    }
                    else {
                        /*page not found*/
                        ShowErrorRedirect('Page is prohibited.', 'Close', '../../default.aspx');
                    }
                }
                else /*token expired*/ {
                    ShowErrorRedirect('TOKEN WAS EXPIRED', 'RE-LOAD', '../../default.aspx');
                }

            }
            else {
                /*session login not found*/
                ShowErrorRedirect('SESSION LOGIN NOT FOUND.', 'Re-Load', '../../default.aspx');
            }

            /*button search*/
            $('#btnSearch').click(function () {
                var objAppDateF = $('#Main_txtDateFrom');
                var objAppDateT = $('#Main_txtDateTo');
      
                var objResult = $('#tblResult');
                var objResultRow = $('#tblResult tbody tr');
                var objResultRowCount = $('#dvResultCount');
                var ch = [];
                var count = 0;

                if (objSession != null) {
                    if (Date.parse(new Date()) < Date.parse(objSession.Token.expire_at)) {
                        $.each(objSession.Agent.Channels, function (i, v) {
                            ch.push(v.ChannelLocationId);
                        });

                        var sendData = {
                            ChannelLocationId: ch,
                        
                            FromDate: objAppDateF.val(),
                            Todate: objAppDateT.val()
                        };

                        $.ajax({
                            url: objSession.APIUrl + 'Reports/AppPendingIssuePolicy',
                            method: 'POST',
                            headers: { 'content-Type': 'application/json', 'Authorization': 'Bearer ' + objSession.Token.access_token },
                            contentType: 'application/json; charset=utf-8',
                            dataType: "json",
                            data: JSON.stringify(sendData),
                            success: function (data) {
                                if (data.StatusCode == 200) {
                                    var row = '';
                                    objResultRow.remove();
                                    if (data.Detail != null) {
                                        $.each(data.Detail, function (index, val) {
                                            if (val.PolicyNumber != '') {
                                                count += 1;
                                                row += '<tr>';
                                                row += '<td class="col-xs-1">' + count + '</td>';
                                                row += '<td class="col-xs-2">' + val.BranchCode + '</td>';
                                                row += '<td class="col-xs-2 ">' + val.BranchName + '</td>';
                                                row += '<td class="col-xs-2">' + moment(val.ApplicationDate).format('DD-MMM-YYYY') + '</td>';

                                              /*  row += '<td class="col-xs-2">' + val.ApplicationNumber + '</td>';*/
                                                row += '<td>  <a href="../NB/frmAppForm.aspx?APP_ID=' + val.ApplicationNumber + '" title="Edit Application" > <span>' + val.ApplicationNumber + '</span></a></td>';
                                                row += '<td class="col-xs-2">' + val.Package + '</td>';
                                                row += '<td class="col-xs-2" align="right">' + val.Premium + '</td>';
                                                row += '<td class="col-xs-2">' + val.CreatedBy + '</td>';
                                                row += '</tr>';
                                            }
                                        });
                                        objResult.append(row);

                                        /* show result count */
                                        objResultRowCount.html('Result - ' + count);
                                        if (count > 0) {
                                            $('#btnExport').show();
                                        }
                                        else {
                                            $('#btnExport').hide();
                                        }
                                    }
                                    else {
                                        ShowWarning(data.Message);
                                        $('#btnExport').hide();
                                    }
                                }
                                else if (data.StatusCode = 500) {

                                    ShowError(data.Message);
                                }
                                HideProgress();
                            },
                            //async: false,
                            error: function (err) {
                                ShowError(err.statusText);
                            },
                            xhr: function () {
                                var fileXhr = $.ajaxSettings.xhr();
                                if (fileXhr.upload) {

                                    ShowProgressWithMessage('Getting application information.');

                                }
                                return fileXhr;
                            }
                        });
                    }
                    else /*token expired*/ {
                        ShowErrorRedirect('TOKEN WAS EXPIRED', 'RE-LOAD', '../../default.aspx');
                    }

                }
                else {
                    ShowErrorRedirect("SESSION LOGIN NOT FOUND.", "Reload", "../../default.aspx");
                }

            });

            /*button export*/
            $('#btnExport').click(function () {
                
                if (Date.parse(new Date()) < Date.parse(objSession.Token.expire_at)) {
                    $("#dvList").btechco_excelexport({
                        containerid: "dvList"
                   , datatype: $datatype.Table
                    });
                }
                else /*token expired*/ {
                    ShowErrorRedirect('TOKEN WAS EXPIRED', 'RE-LOAD', '../../default.aspx');
                }
            });
        });
    </script>
    <div class="row">
       
        <div id="dvApplicationInfo">

            <div class="col-md-12 div-title1 ">Criterials To Generate Application Pending Issue Policy Report</div>
         
            <div class="col-md-3">
                <asp:Label runat="server" ID="Label2">APP-DATE FROM</asp:Label><span class="star">*</span>
                <div class="input-group">
                    <span class="input-group-addon"><span class="glyphicon glyphicon-calendar" aria-hidden="true"></span></span>
                    <asp:TextBox ID="txtDateFrom" runat="server" CssClass="form-control" ReadOnly="true">
                    </asp:TextBox>
                </div>
            </div>
            <div class="col-md-3">
                <asp:Label runat="server" ID="Label3">TO</asp:Label><span class="star">*</span>
                <div class="input-group">
                    <span class="input-group-addon"><span class="glyphicon glyphicon-calendar" aria-hidden="true"></span></span>
                    <asp:TextBox ID="txtDateTo" runat="server" CssClass="form-control" ReadOnly="true">
                    </asp:TextBox>
                </div>
            </div>


            <div class="col-md-12 right ">
                <div class="btn-group right" role="group">
                    <button type="button" id="btnSearch" class="btn btn-primary button-space"><span class="glyphicon glyphicon-search"></span>&nbsp;&nbsp;Search</button>
                    <button type="button" id="btnExport" class="btn btn-primary button-space"><span class="glyphicon glyphicon-download"></span>&nbsp;&nbsp;Excel</button>
                </div>
            </div>


        </div>
    </div>
    <div class="row">
        <%-- <div class="col-md-12">--%>
        <div id="dvResult" class="col-md-12 margin-top-5">
            <div class="col-md-12 div-title1" id="dvResultCount">Result</div>
            <div id="dvList" class="col-md-12">
                <table id="tblResult" class="table ">
                    <thead>
                        <tr>
                            <th class="col-xs-1 ">No.</th>
                             <th class="col-xs-2">BranchCode</th>
                             <th class="col-xs-2">BranchName</th>
                            <th class="col-xs-2">App Date</th>
                            <th class="col-xs-2">App No.</th>
                            <th class="col-xs-2">Package</th>
                            <th class="col-xs-2">Prem.(USD)</th>
                            <th class="col-xs-2">UserName</th>
                        </tr>
                    </thead>
                </table>
            </div>
        </div>

        <%--        </div>--%>
    </div>
    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static">
        <div class="modal-dialog">
            <div class="modal-content">
                <%--  <div class="modal-header">
                    <h1><span class="glyphicon glyphicon-time"></span>Progressing...</h1>
                </div>--%>
                <div class="modal-header">
                    <div style="display: flexbox; flex-direction: row; flex-align: center;">

                        <div id="spinner"></div>
                        <h1 style="margin-left: 35px;">Progressing...</h1>
                    </div>
                </div>
                <div class="modal-body">
                    <p id="pMessage">Please wait while device is conneting to server.</p>
                    <div class="progress">
                        <div class="progress-bar progress-bar-striped active" role="progressbar" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100" style="width: 100%">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
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

</asp:Content>

