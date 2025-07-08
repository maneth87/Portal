<%@ Page Title="" Language="C#" MasterPageFile="~/Pages/Content.master" AutoEventWireup="true" CodeFile="frmRegistrationDocInquiry.aspx.cs" Inherits="Pages_Inquiries_frmRegistrationDocInquiry" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Main" runat="Server">
    <script src="../../Scripts/moment.js"></script>
    <script src="../../Scripts/js/custom.js"></script>
    <link href="../../Scripts/bootstrap/datepicker/css/datepicker.css" rel="stylesheet" />
    <script src="../../Scripts/bootstrap/datepicker/js/bootstrap-datepicker.js"></script>


    <script type="text/javascript">
        var objSession;
        var pubPageAccess = null;
        $(document).ready(function () {

            $('#Main_txtDateFrom').datepicker();
            $('#Main_txtDateTo').datepicker();
            var d = new Date();

            var month = d.getMonth() + 1;
            var day = d.getDate();

            var output = (day < 10 ? '0' : '') + day + '/' +
                (month < 10 ? '0' : '') + month + '/' + d.getFullYear();


            $('#Main_txtDateFrom').val(output);
            $('#Main_txtDateTo').val(output);

            objSession = JSON.parse(sessionStorage.getItem('SESSION_LOGIN'));
            if (objSession == null) {
                ShowErrorRedirect("SESSION LOGIN NOT FOUND.", "Reload", "../../default.aspx");
            }
            else {
                if (Date.parse(new Date()) < Date.parse(objSession.Token.expire_at)) {
                    pubPageAccess = GetPageAccess('frmRegistrationDocInquiry.aspx');
                    if (pubPageAccess != undefined) {
                        if (pubPageAccess.IsView == 0) {
                            ShowErrorRedirect('This page is prohibited.', 'Close', '../../default.aspx');
                        }
                    }
                    else {
                        ShowErrorRedirect('This page is prohibited.', 'Close', '../../default.aspx');
                    }
                }
                else /*token expired*/ {
                    ShowErrorRedirect('TOKEN WAS EXPIRED', 'RE-LOAD', '../../default.aspx');
                }

            }

            $('#btnSearch').click(function () {
                var objResult = $('#tblResult');
                var objResultRow = $('#tblResult tbody tr');
                var objResultRowCount = $('#dvResultCount');
                var objAppDateF = $('#Main_txtDateFrom');
                var objAppDateT = $('#Main_txtDateTo');
                var objFileDesc = $('#Main_txtFileDescription');
                var count = 0;
                if (objSession != null) {
                    if (Date.parse(new Date()) < Date.parse(objSession.Token.expire_at)) {
                        /*validat*/
                        if (objAppDateF.val() != '' && objAppDateT.val() != '') {

                            var newDateF = objAppDateF.val();
                            var newDateT = objAppDateT.val();

                            var sendData = {

                                FileDescription: objFileDesc.val(),
                                DateFrom: newDateF,
                                DateTo: newDateT
                            };

                            $.ajax({
                                url: objSession.APIUrl + 'Document/GetRegistrationDoc',
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
                                                count += 1;
                                                row += '<tr>';
                                                row += '<td >' + count + '</td>';
                                                row += '<td>' + val.DocName + '</td>';
                                                row += '<td>' + val.DocDescription + '</td>';
                                                row += '<td >' + moment(val.UploadedOn).format('DD-MM-YYYY') + '</td>';
                                                row += '<td> <a href="../Documents/frmUploadDocs_View.aspx?filePath=' + encodeURIComponent(val.DocPath) + '&ref=' + objSession.Token.access_token + '&docType=registation "target=_blank" " title="View Application"> <span class="glyphicon glyphicon-eye-open"></span></a> </td>';
                                                row += '</tr>';
                                            });
                                            objResult.append(row);

                                            /* show result count */
                                            objResultRowCount.html('Result - ' + count);
                                        }
                                        else {
                                            ShowWarning(data.Message);
                                        }
                                    }
                                    else {

                                        ShowError(data.Detail);
                                    }
                                    HideProgress();
                                },
                                async: false,
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
                        else {
                            ShowWarning('Please input any criterias.');
                        }
                    }
                    else /*token expired*/ {
                        ShowErrorRedirect('TOKEN WAS EXPIRED', 'RE-LOAD', '../../default.aspx');
                    }

                }

                else /*SESSION LOGIN NOT FOUND*/ {
                    ShowErrorRedirect("SESSION LOGIN NOT FOUND.", "Reload", "../../default.aspx");
                }
            });

        });
    </script>

    <div class="row">

        <div id="dvApplicationInfo">

            <div class="col-md-12 div-title1">Search Registration Documents</div>

            <div class="col-md-4">
                <label id="Label2">Upload Date From</label>
                <div class="input-group">
                    <span class="input-group-addon"><span class="glyphicon glyphicon-calendar" aria-hidden="true"></span></span>
                    <asp:TextBox ID="txtDateFrom" runat="server" CssClass="form-control" ReadOnly="true">
                    </asp:TextBox>
                </div>
            </div>
            <div class="col-md-4">
                <label id="Label3">TO</label>
                <div class="input-group">
                    <span class="input-group-addon"><span class="glyphicon glyphicon-calendar" aria-hidden="true"></span></span>
                    <asp:TextBox ID="txtDateTo" runat="server" CssClass="form-control" ReadOnly="true">
                    </asp:TextBox>
                </div>
            </div>
            <div class="col-md-4">
                <label id="Label4">File Description</label>

                <asp:TextBox ID="txtFileDescription" runat="server" CssClass="form-control">
                </asp:TextBox>

            </div>

            <div class="col-md-12 right ">
                <div class="btn-group right" role="group">
                    <button type="button" id="btnSearch" class="btn btn-primary button-space"><span class="glyphicon glyphicon-search"></span>&nbsp;&nbsp;Search</button>
                </div>
            </div>


        </div>
    </div>
    <div class="row">
        <%-- <div class="col-md-12">--%>
        <div id="dvResult" class="col-md-12 margin-top-5">
            <div class="col-md-12 div-title1" id="dvResultCount">Result</div>
            <div class="col-md-12">
                <table id="tblResult" class="table khmer-font">
                    <thead>
                        <tr>
                            <th class="col-sm-2 ">No.</th>
                            <th class="col-sm-3">File Name</th>
                            <th class="col-sm-4 ">Description</th>
                            <th class="col-sm-3">Action</th>
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

