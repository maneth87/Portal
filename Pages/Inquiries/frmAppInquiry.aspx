<%@ Page Title="" Language="C#" MasterPageFile="~/Pages/Content.master" AutoEventWireup="true" CodeFile="frmAppInquiry.aspx.cs" Inherits="Pages_Inquiries_frmAppInquiry" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Main" runat="Server">
    <script src="../../Scripts/moment.js"></script>
    <script src="../../Scripts/js/custom.js"></script>
    <link href="../../Scripts/bootstrap/datepicker/css/datepicker.css" rel="stylesheet" />
    <script src="../../Scripts/bootstrap/datepicker/js/bootstrap-datepicker.js"></script>
<%--    <link href="../../Scripts/css/custom.css" rel="stylesheet" />--%>
    <style>
        .selected {
            background-color: #d1e7dd; /*#cce5ff*/
        }
    </style>
    <script type="text/javascript">
        var objSession;

        document.onreadystatechange = function () {
            if (document.readyState !== "complete") {
                ShowProgress();
            } else {
                HideProgress();
            }
        };

        var pubPageAccess = null;
        $(document).ready(function () {

            EnablePrint(false);

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
                ShowErrorRedirect("SESSION LOGIN NOT FOUND.", "RE-LOAD", "../../default.aspx");
            }
            else {
                if (Date.parse(new Date()) < Date.parse(objSession.Token.expire_at)) {
                    pubPageAccess = GetPageAccess('frmAppInquiry.aspx');
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
                Search();
            });

            $('#btnPrintApplication').click(function () {

                $('#dvConfirm').modal('show');

            });

            $('#btnPrintCertificate').click(function () {

                $('#dvConfirmCert').modal('show');

            });

            $('#btnPrintFirstYear').click(function () {
                PrintApplication(true);
            });

            $('#btnPrintAll').click(function () {
                PrintApplication(false);
            });

            $('#btnPrintCertAll').click(function () {
                PrintCertificate(true);
            });
            $('#btnPrintCert').click(function () {
                PrintCertificate(false);
            });

        });

        function toggleRowHighlight(checkbox) {
            var row = checkbox.closest('tr');

            if (checkbox.checked) {
                row.classList.add('selected');
            } else {
                row.classList.remove('selected');
            }

            var tblRow = $('#tblResult tbody tr').length;

            var checkboxes = document.querySelectorAll('tbody input[type="checkbox"]:checked').length;

            if (tblRow == checkboxes) {

                $('#ckbAll').prop('checked', true);
            }
            else {
                $('#ckbAll').prop('checked', false);
            }

            if (checkboxes == 0) {
                EnablePrint(false);
            }
            else {
                EnablePrint(true);
            }
        }

        function EnablePrint(t) {
            if (t == false) {
                $('#btnPrintApplication').prop('disabled', 'disabled');
                $('#btnPrintCertificate').prop('disabled', 'disabled');
            }
            else {
                $('#btnPrintApplication').removeProp("disabled");
                $('#btnPrintCertificate').removeProp("disabled");
            }
        }

        function selectAll(checkbox) {
            var checkboxes = document.querySelectorAll('tbody input[type="checkbox"]');
            checkboxes.forEach(function (cb) {
                cb.checked = checkbox.checked;
                // toggleRowHighlight(cb);
                var row = cb.closest('tr');
                if (cb.checked) {
                    row.classList.add('selected');
                } else {
                    row.classList.remove('selected');
                }
            });
            var intSelected = document.querySelectorAll('tbody input[type="checkbox"]:checked').length;

            if (intSelected > 0) {
                EnablePrint(true);
            }
            else {
                EnablePrint(false);
            }
        }

        function Search() {
            var objResult = $('#tblResult');
            var objAppNo = $('#Main_txtApplicationNumber');
            var objPolNo = $('#Main_txtPolicyNumber');
            var objCustName = $('#Main_txtCustomerName');
            var objIdNo = $('#Main_txtIdNumber');
            var objResultRow = $('#tblResult tbody tr');
            var objResultRowCount = $('#dvResultCount');
            var objAppDateF = $('#Main_txtDateFrom');
            var objAppDateT = $('#Main_txtDateTo');
            var count = 0;

            if (objSession != null) {
                if (Date.parse(new Date()) < Date.parse(objSession.Token.expire_at)) {
                    /*validat*/
                    if (objAppDateF.val() != '' || objAppDateT.val() != '' || objAppNo.val() != '' || objPolNo.val() != '' || objCustName.val() != '' || objIdNo.val() != '') {

                        var newDateF = objAppDateF.val();
                        var newDateT = objAppDateT.val();
                        if (objAppNo.val() != '' || objPolNo.val() != '' || objCustName.val() != '' || objIdNo.val() != '') {
                            newDateF = '01/01/1999';
                            newDateT = '01/01/2099';
                        }
                        var chLocation = [];
                        $(objSession.Agent.Channels).each(function (index, val) {

                            chLocation.push(val.ChannelLocationId);


                        });

                        var sendData = {
                            ChannelLocationId: chLocation,//objSession.Agent.Channels[0].ChannelLocationId,
                            ApplicationNumber: objAppNo.val(),
                            FullNameEn: objCustName.val(),
                            IdNumber: objIdNo.val(),
                            PolicyNumber: objPolNo.val(),
                            ApplicationDateFrom: newDateF,
                            ApplicationDateTo: newDateT
                        };

                        $.ajax({
                            url: objSession.APIUrl + 'Application/ApplicationInquiry',
                            method: 'POST',
                            headers: { 'content-Type': 'application/json', 'Authorization': 'Bearer ' + objSession.Token.access_token },
                            contentType: 'application/json; charset=utf-8',
                            dataType: "json",
                            data: JSON.stringify(sendData),
                            success: function (data) {
                                if (data.status == "200") {
                                    var row = '';
                                    objResultRow.remove();
                                    if (data.detail.length > 0) {
                                        var lableApp = "";
                                        $.each(data.detail, function (index, val) {
                                            if (val.ApplicationType == "N") {
                                                lableApp = "<span class='labelAppTypeN' >" + val.ApplicationType + "</span>";
                                            }
                                            else if (val.ApplicationType == "R") {
                                                lableApp = "<span class='labelAppTypeR' >" + val.ApplicationType + "</span>";
                                            }

                                            count += 1;
                                            row += '<tbody><tr>';
                                            row += '<td>' + val.BranchCode + '</td>';
                                            row += '<td class="hidden">' + val.BranchName + '</td>';
                                            row += '<td class="hidden">' + val.ChannelLocationId + '</td>';

                                            /* row += '<td class="khmer-font">' + val.ApplicationNumber + '</td>';*/
                                            row += '<td class="khmer-font"><a href="../Cert/eApplication_V.aspx?applicationId=' + val.ApplicationId + '&applicationType=IND&token=' + objSession.Token.access_token + '" target="_blank" title="Print Application" > <span>' + val.ApplicationNumber + '</span></a></td>';
                                            row += "<td class='col-xs-1'>" + lableApp + "</td>";
                                            row += '<td>' + moment(val.ApplicationDate).format('DD-MM-YYYY') + '</td>';
                                            row += '<td class="khmer-font">' + val.FullNameEn + ' / ' + val.FullNameKh + '</td>';
                                            row += '<td class="hidden">' + val.IdNumber + '</td>';
                                            row += '<td>' + val.PhoneNumber + '</td>';
                                            row += '<td>' + val.PolicyNumber + '</td>';
                                            //row += '<td class="khmer-font"><a href="../Cert/eCertificate_V.aspx?policyId=' + val.PolicyId + '&policyType=IND&token=' + objSession.Token.access_token + '" target="_blank" title="Print Certificate" > <span>' + val.PolicyNumber + '</span></a></td>';
                                            row += '<td class="hidden">' + val.PolicyId + '</td>';
                                            row += '<td class="hidden">' + val.PolicyStatus + '</td>';
                                            row += '<td style="text-align:center;">  <a href="../NB/frmAppForm.aspx?APP_ID=' + val.ApplicationNumber + '" title="Edit Application" > <span class="glyphicon glyphicon-edit"></span></a>  &nbsp;&nbsp;&nbsp; <a href="frmAppFormView.aspx?APP_ID=' + val.ApplicationNumber + '"  title="View Application"> <span class="glyphicon glyphicon-eye-open"></span></a>  &nbsp;&nbsp;&nbsp; <a href="../Documents/frmUploadDocs.aspx?APP_ID=' + val.ApplicationNumber + '"  title="Attached Documents"> <span class="glyphicon glyphicon-paperclip"></span></a> &nbsp;&nbsp;&nbsp; <input type="checkbox" name="chkb" value=' + val.ApplicationNumber + ' onclick="toggleRowHighlight(this)" class="row-select" /></td>';
                                            row += '</tr></tbody>';
                                        });
                                        objResult.append(row);

                                        /* show result count */
                                        objResultRowCount.html('Result - ' + count);
                                    }
                                    else {
                                        ShowWarning(data.message);
                                    }
                                }
                                else {

                                    ShowError(data.detail[0].message);
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
                    else {
                        ShowWarning('Please input any criterias.');
                    }
                }
                else /*token expired*/ {
                    ShowErrorRedirect('TOKEN WAS EXPIRED', 'RE-LOAD', '../../default.aspx');
                }
            }
            else
                /*session login not found*/ {
                ShowErrorRedirect('SESSION LOGIN NOT FOUND.', 'Re-Load', '../../default.aspx');
            }
        }

        var pubSelectedApplication = [];
        var pubSelectedPolicy = [];

        function PrintApplication(t) {
            var appList = $('#tblResult tbody tr');
            pubSelectedApplication = new Array();

            $(appList).each(function (index, element) {

                if ($(this).find('.row-select').is(':checked')) {

                    //  alert($(this).find('td:eq(3)').text() + ' ' + $(this).find('td:eq(9)').text());
                    if ($(this).find('td:eq(3)').text().trim() != "") {
                        // ObjectSelectedApp = { ApplicationNumber: $(this).find('td:eq(3)').text() };
                        pubSelectedApplication.push($(this).find('td:eq(3)').text().trim());
                    }

                }
            });

            if (pubSelectedApplication.length > 0) {
                var sendData = {
                    ApplicationNumber: pubSelectedApplication,
                    onlyFirstYear: t,
                    ApplicationType: 'IND'
                };

                setCookie("CK_APP_NO_TEMP", JSON.stringify(sendData), 1);
                window.open("../Cert/eApplication_V.aspx?applicationId=&applicationType=IND&token=" + objSession.Token.access_token, "_blank");

            }
            else {
                ShowWarning('Application number is not found.');
            }


        }

        function PrintCertificate(t) {
            var appList = $('#tblResult tbody tr');
            pubSelectedPolicy = new Array();

            $(appList).each(function (index, element) {

                if ($(this).find('.row-select').is(':checked')) {

                    if ($(this).find('td:eq(10)').text().trim() != "") {

                        pubSelectedPolicy.push($(this).find('td:eq(10)').text().trim());
                    }

                }
            });

            if (pubSelectedPolicy.length > 0) {
                var sendData = {
                    PolicyId: pubSelectedPolicy,
                    PolicyType: 'IND',
                    PrintPolicyInsurance:t
                };
                setCookie("CK_POL_ID_TEMP", JSON.stringify(sendData), 1);
                window.open("../Cert/eCertificate_V.aspx?policyId=&policyType=IND&token=" + objSession.Token.access_token, "_blank");
            }
            else {
                ShowWarning('Selected Application (s) is not yet converted to policy.');
            }
        }
    </script>
    <div class="row">

        <div id="dvApplicationInfo">

            <div class="col-md-12 div-title1">Application Information</div>

            <div class="col-md-3">
                <asp:Label runat="server" ID="Label2">Application Date From</asp:Label>
                <div class="input-group">
                    <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                    <asp:TextBox ID="txtDateFrom" runat="server" CssClass="form-control" ReadOnly="true">
                    </asp:TextBox>
                </div>
            </div>
            <div class="col-md-3">
                <asp:Label runat="server" ID="Label3">TO</asp:Label>
                <div class="input-group">
                    <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                    <asp:TextBox ID="txtDateTo" runat="server" CssClass="form-control" ReadOnly="true">
                    </asp:TextBox>
                </div>
            </div>

            <div class="col-md-3">
                <asp:Label runat="server" ID="lblClientType">Application Number</asp:Label>
                <div class="input-group">
                    <span class="input-group-addon">APP</span>
                    <asp:TextBox ID="txtApplicationNumber" runat="server" CssClass="form-control">
                    </asp:TextBox>
                </div>
            </div>
            <div class="col-md-3">
                <asp:Label runat="server" ID="Label1">Policy Number</asp:Label>
                <div class="input-group">
                    <span class="input-group-addon">CERSO</span>
                    <asp:TextBox ID="txtPolicyNumber" runat="server" CssClass="form-control">
                    </asp:TextBox>
                </div>
            </div>
            <div class="col-md-3" id="colClientTypeRemarks">
                <asp:Label runat="server" ID="lblClientTypeRemarks">Customer Name</asp:Label>
                <asp:TextBox ID="txtCustomerName" runat="server" CssClass="form-control khmer-font"></asp:TextBox>
            </div>
            <div class="col-md-3" id="colClientTypeRelation">
                <asp:Label runat="server" ID="lblClientTypeRelation">Id Number</asp:Label>
                <asp:TextBox ID="txtIdNumber" runat="server" CssClass="form-control">
                </asp:TextBox>
            </div>
            <div class="col-md-12 right ">
                <div class="btn-group right" role="group">
                    <button type="button" id="btnSearch" class="btn btn-primary button-space"><span class="glyphicon glyphicon-search"></span>&nbsp;&nbsp;Search</button>

                    <button type="button" id="btnPrintApplication" class="btn btn-primary button-space"><span class="glyphicon glyphicon-print"></span>&nbsp;&nbsp;Application</button>
                    <button type="button" id="btnPrintCertificate"  class="btn btn-primary button-space"><span class="glyphicon glyphicon-print"></span>&nbsp;&nbsp;Certificate</button>
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
                            <th class="col-sm-2 hidden">No.</th>
                            <th class="col-sm-1">BranchCode</th>
                            <th class="col-sm-2 hidden">BranchName</th>

                            <th class="col-sm-2">App No.</th>
                            <th class="col-xs-1">Type</th>
                            <th class="col-sm-1">App Date</th>
                            <th class="col-sm-2">Cust. Name</th>
                            <th class="col-sm-2 hidden">ID No.</th>
                            <th class="col-sm-2">Contact No.</th>
                            <th class="col-sm-1">Policy No.</th>
                            <th class="hidden">Policy ID</th>
                            <th class="col-sm-2 hidden">Policy Status</th>
                            <th class="col-sm-4" style="text-align: center;">Action | All
                                <input type="checkbox" value="hi" id="ckbAll" onclick="selectAll(this)" /></th>
                        </tr>
                    </thead>
                </table>
            </div>
        </div>

        <%--        </div>--%>
    </div>


    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" data-backdrop="static">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <div style="display: flexbox; flex-direction: row; flex-align: center;">

                        <div id="spinner"></div>
                        <%-- <h1><span class="glyphicon glyphicon-time"></span>Progressing...</h1>--%>
                        <h1 style="margin-left: 35px;">Progressing...</h1>
                    </div>
                  
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
    <div class="modal fade " id="modalAlert" data-backdrop="static" data-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel">
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

    <!-- Modal -->
    <div class="modal fade " id="dvConfirm" data-backdrop="static" data-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel">
        <div class="modal-dialog ">

            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">×</button>
                    <h1 class="modal-title" id="H1">CONFIRM!</h1>

                </div>
                <div class="modal-body">
                    <div class="alert alert-danger" role="alert" id="Div2">
                        <p id="pMessageConfirm">Do you print only first year?</p>
                    </div>

                </div>
                <div class="modal-footer " style="text-align: center;">
                    <button type="button" id="btnPrintFirstYear" class="btn btn-primary">YES</button>
                    <button type="button" id="btnPrintAll" class="btn btn-primary">NO</button>

                </div>
            </div>
        </div>
    </div>

     <!-- Modal -->
    <div class="modal fade " id="dvConfirmCert" data-backdrop="static" data-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel">
        <div class="modal-dialog ">

            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">×</button>
                    <h1 class="modal-title" id="H2">CONFIRM!</h1>

                </div>
                <div class="modal-body">
                    <div class="alert alert-danger" role="alert" id="Div3">
                        <p id="p1">Do you wish to include insurance policy with the Certificate Printing?</p>
                    </div>

                </div>
                <div class="modal-footer " style="text-align: center;">
                    <button type="button" id="btnPrintCertAll" class="btn btn-primary">YES</button>
                    <button type="button" id="btnPrintCert" class="btn btn-primary">NO</button>

                </div>
            </div>
        </div>
    </div>

</asp:Content>

