<%@ Page Title="" Language="C#" MasterPageFile="~/Pages/Content.master" AutoEventWireup="true" CodeFile="frmUploadDocs.aspx.cs" Inherits="Pages_NB_frmUploadDocs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Main" runat="Server">
    <script src="../../Scripts/js/custom.js"></script>
    <script type="text/javascript">
        var pubAppNo = '';
        var pubObjApplicationNumber;
        var pubObjCertificateNumber;
        var objSession = null;
        var pubPageAccess = null;
        $(document).ready(function () {

            DisableAttacheDocument(true);

            pubObjApplicationNumber = $('#txtApplicationNumber');
            pubObjCertificateNumber = $('#txtCertificateNumber');

            objSession = JSON.parse(sessionStorage.getItem('SESSION_LOGIN'));
            if (objSession != null) {
                if (Date.parse(new Date()) < Date.parse(objSession.Token.expire_at)) {
                    pubPageAccess = GetPageAccess('frmUploadDocs.aspx');
                    if (pubPageAccess != undefined) {
                        if (pubPageAccess.IsView == 1) {
                            var searchPara = window.location.search;
                            var q = searchPara.split('?');

                            if (q.length == 2) {
                                var v2 = q[1].split('=');
                                if (v2[0] == 'APP_ID') {

                                    pubAppNo = v2[1];
                                    pubObjApplicationNumber.val(pubAppNo);

                                    /*check application convert to policy or not*/
                                    if (GetApplicationDetail(pubAppNo)) {
                                        /*enable attach document*/
                                        DisableAttacheDocument(false);
                                        /*hide button proceed*/
                                        $('#btnProceed').hide();
                                    }
                                    else {
                                        DisableAttacheDocument(true);
                                        HideViewFile(true);
                                    }

                                }
                            }
                            else {
                                HideViewFile(true);
                            }
                        }
                        else {
                            /* page is prohibited*/
                            ShowErrorRedirect('This page is prohibited.', 'Close', '../../default.aspx');
                        }


                    }
                    else {
                        /* page name not found*/
                        ShowErrorRedirect('This page is prohibited.', 'Close', '../../default.aspx');
                    }

                }
                else /*token expired*/ {
                    ShowErrorRedirect('TOKEN WAS EXPIRED', 'RE-LOAD', '../../default.aspx');
                }
            }
            else {
                /*no session login, reload defaul page*/

                //  window.open("../../default.aspx", "_self");
                ShowErrorRedirect('SESSION LOGIN NOT FOUND.', 'Re-Load', '../../default.aspx');
            }

            /*button proceed*/
            $('#btnProceed').click(function () {
                if (Date.parse(new Date()) < Date.parse(objSession.Token.expire_at)) {
                    if (pubObjApplicationNumber.val().length == 11) {
                        if (pubObjApplicationNumber.val().trim() != '') {
                            if (GetApplicationDetail(pubObjApplicationNumber.val())) {
                                DisableAttacheDocument(false);
                            }
                            else {
                                DisableAttacheDocument(true);
                            }
                       
                        }
                        else {
                            /*nothing input application number*/
                            ShowWarning('Please input application number.');
                        }
                    }
                    else {
                        ShowWarning('Application Number is not correct format. APP{8-digits}');
                    }
                }
                else /*token expired*/ {
                    ShowErrorRedirect('TOKEN WAS EXPIRED', 'RE-LOAD', '../../default.aspx');
                }

            });


            /*button upload*/
            $('#btnUpload1').click(function () {
                if (objSession != null) {

                    var objFileApp = $('#fileApp');
                    var objFileCert = $('#fileCert');
                    var objFileIdCard = $('#fileIdCard');
                    var objFilePayslip = $('#filePayslip');


                    if (Date.parse(new Date()) < Date.parse(objSession.Token.expire_at)) {
                      
                        if (pubIsExistDoc == true) {
                            if (objFileApp.get(0).files.length == 0 && objFileCert.get(0).files.length == 0 && objFileIdCard.get(0).files.length == 0 && objFilePayslip.get(0).files.length == 0) {
                                ShowWarning('Please select attached files for update.');
                                return;
                            }

                        }
                        else {
                            /*upload new documents*/
                            if (objFileApp.get(0).files.length == 0) {
                                ShowWarning('Please select Application Form file.');
                                return;
                            }
                            else if (objFileIdCard.get(0).files.length == 0) {
                                ShowWarning('Please select ID Card file.');
                                return;
                            } else if (objFilePayslip.get(0).files.length == 0) {
                                ShowWarning('Please select Payslip file.');
                                return;
                            }

                        }

                        if (pubPageAccess.IsAdd == 1) {

                            var formData = new FormData();

                            if (objFileApp.get(0).files.length > 0) {
                                formData.append("fileName", pubObjApplicationNumber.val() + "-APP");
                                formData.append("file", objFileApp[0].files[0]);
                            }
                            if (objFileCert.get(0).files.length > 0) {
                                formData.append("fileName", pubObjApplicationNumber.val() + "-CERT");
                                formData.append("file", objFileCert[0].files[0]);
                            }
                            if (objFileIdCard.get(0).files.length > 0) {
                                formData.append("fileName", pubObjApplicationNumber.val() + "-ID");
                                formData.append("file", objFileIdCard[0].files[0]);
                            }
                            if (objFilePayslip.get(0).files.length > 0) {
                                formData.append("fileName", pubObjApplicationNumber.val() + "-PAYSLIP");
                                formData.append("file", objFilePayslip[0].files[0]);
                            }

                            $.ajax({
                                //  url: '../../AppWebService.asmx/UploadFiles',
                                url: objSession.APIUrl + 'Document/UploadFiles?userName=' + objSession.UserName + '&applicationNumber=' + pubObjApplicationNumber.val(),
                                method: 'POST',
                                headers: { 'Authorization': 'Bearer ' + objSession.Token.access_token },
                                cache: false,
                                contentType: false,
                                processData: false,
                                mimeType: "multipart/form-data",
                                dataType: 'Json',
                                data: formData,
                                success: function (data) {

                                    //$("#lblMessage").html("<b>" + fileName + "</b> has been uploaded.");
                                    var obj = data;// JSON.parse(data);
                                    if (obj.StatusCode == 200) {
                                        ShowSuccess("Files uploaded successfully.");

                                        /*reload doc*/
                                        GetApplicationDetail(pubObjApplicationNumber.val());
                                    }
                                    else {
                                        ShowError(obj.Message);
                                    }
                                    $("#fileProgress").hide();
                                    HideProgress();
                                },
                                xhr: function () {
                                    var fileXhr = $.ajaxSettings.xhr();
                                    if (fileXhr.upload) {
                                        $("progress").show();
                                        ShowProgressWithMessage('Uploading files.');
                                        fileXhr.upload.addEventListener("progress", function (e) {
                                            if (e.lengthComputable) {
                                                $("#fileProgress").attr({
                                                    value: e.loaded,
                                                    max: e.total
                                                });
                                            }
                                        }, false);
                                    }
                                    return fileXhr;
                                }
                            });
                        }
                        else {
                            ShowError('You don\'t have permission to uload files.');
                        }
                    }
                    else /*token expired*/ {
                        ShowErrorRedirect('TOKEN WAS EXPIRED', 'RE-LOAD', '../../default.aspx');
                    }
                }
                else {
                    /*some file are not selected*/
                    //  ShowWarning('Please selecte all attached files.');
                    ShowErrorRedirect('SESSION LOGIN not found', 'Close', '../../default.aspx');
                }
               
            });


            /*button upload*/
            $('#btnUpload').click(function () {
                if (objSession != null) {

                    var objFileApp = $('#fileApp');

                    if (Date.parse(new Date()) < Date.parse(objSession.Token.expire_at)) {

                        if (pubIsExistDoc == true) {
                            //if (objFileApp.get(0).files.length == 0 && objFileCert.get(0).files.length == 0 && objFileIdCard.get(0).files.length == 0 && objFilePayslip.get(0).files.length == 0) {
                            if (objFileApp.get(0).files.length == 0) {
                                ShowWarning('Please select attached files for update.');
                                return;
                            }

                        }
                        else {
                            /*upload new documents*/
                            if (objFileApp.get(0).files.length == 0) {
                                ShowWarning('Please select Application Form file.');
                                return;
                            }

                        }

                        if (pubPageAccess.IsAdd == 1) {

                            var formData = new FormData();

                            if (objFileApp.get(0).files.length > 0) {
                                var files = objFileApp[0].files;
                                for (i = 0; i < files.length; i++) {
                                    formData.append("fileName", pubObjApplicationNumber.val() + '_' + i);
                                    formData.append("file", files[i]);
                                }

                            }
                           
                            $.ajax({
                                //  url: '../../AppWebService.asmx/UploadFiles',
                                url: objSession.APIUrl + 'Document/UploadMultiFiles?userName=' + objSession.UserName + '&applicationNumber=' + pubObjApplicationNumber.val(),
                                method: 'POST',
                                headers: { 'Authorization': 'Bearer ' + objSession.Token.access_token },
                                cache: false,
                                contentType: false,
                                processData: false,
                                mimeType: "multipart/form-data",
                                dataType: 'Json',
                                data: formData,
                                success: function (data) {

                                    var obj = data;
                                    var strFileName = '';
                                    if (obj.StatusCode == 200) {
                                        $.each(obj.Detail, function (i, v) {
                                            strFileName += v + "<br />";
                                        });
                                        ShowSuccess(obj.Message + '<br /> File Name:'+ strFileName);

                                        /*reload doc*/
                                        GetApplicationDetail(pubObjApplicationNumber.val());
                                    }
                                    else {
                                        ShowError(obj.Message);
                                    }
                                    $("#fileProgress").hide();
                                    HideProgress();
                                },
                                xhr: function () {
                                    var fileXhr = $.ajaxSettings.xhr();
                                    if (fileXhr.upload) {
                                        $("progress").show();
                                        ShowProgressWithMessage('Uploading files.');
                                        fileXhr.upload.addEventListener("progress", function (e) {
                                            if (e.lengthComputable) {
                                                $("#fileProgress").attr({
                                                    value: e.loaded,
                                                    max: e.total
                                                });
                                            }
                                        }, false);
                                    }
                                    return fileXhr;
                                }
                            });
                        }
                        else {
                            ShowError('You don\'t have permission to uload files.');
                        }
                    }
                    else /*token expired*/ {
                        ShowErrorRedirect('TOKEN WAS EXPIRED', 'RE-LOAD', '../../default.aspx');
                    }
                }
                else {
                    /*some file are not selected*/

                    ShowErrorRedirect('SESSION LOGIN not found', 'Close', '../../default.aspx');
                }

            });

        });




        function DisableAttacheDocument(t) {
            if (t) {
                $('#fileApp').prop('disabled', 'disabled');
                $('#fileCert').prop('disabled', 'disabled');
                $('#fileIdCard').prop('disabled', 'disabled');
                $('#filePayslip').prop('disabled', 'disabled');
                $('#btnUpload').prop('disabled', 'disabled');
            }
            else {
                $('#fileApp').removeProp('disabled');
                $('#fileCert').removeProp('disabled');
                $('#fileIdCard').removeProp('disabled');
                $('#filePayslip').removeProp('disabled');
                $('#btnUpload').removeProp('disabled');
            }
        }

        function HideViewFile(t) {
            if (t) {
                $('#AppView').hide();
                $('#CertView').hide();
                $('#IdCardView').hide();
                $('#payslipView').hide();
            }
            else {
                $('#AppView').show();
                $('#CertView').show();
                $('#IdCardView').show();
                $('#payslipView').show();
            }
        }

        var pubIsExistDoc = false;
        /*get application detail*/
        function GetApplicationDetail(appNumber) {
            var result;

            if (Date.parse(new Date()) < Date.parse(objSession.Token.expire_at)) {

                $.ajax({
                    url: objSession.APIUrl + 'Application/GetApplicationDetail?applicationNumber=' + appNumber,
                    method: 'GET',
                    headers: { 'content-Type': 'application/json', 'Authorization': 'Bearer ' + objSession.Token.access_token },
                    contentType: 'application/json; charset=utf-8',
                    dataType: "json",
                    success: function (data) {

                        if (data.status == "200")//save success
                        {
                            var objAppView = $('#AppView');
                            var objCertView = $('#CertView');
                            var objIdCardView = $('#IdCardView');
                            var objPayslipView = $('#payslipView');

                            var appDocPath = '';
                            var certDocPath = '';
                            var idCardDocPath = '';
                            var payslipDocPath = '';

                            var appDocName = '';
                            var certDocName = '';
                            var idDocName = '';
                            var payslipDocName = '';

                            var appDocStatus = '';
                            var certDocStatus = '';
                            var idDocStatus = '';
                            var payslipDocStatus = '';

                            var appDocStatusRemarks = '';
                            var certDocStatusRemarks = '';
                            var idDocStatusRemarks = '';
                            var payslipDocStatusRemarks = '';

                            //  if (data.detail.PolicyNumber != null && data.detail.PolicyNumber != '') {
                            pubObjCertificateNumber.val(data.detail.PolicyNumber);

                            /*get existing documents*/

                            var ch = [];
                            $.each(objSession.Agent.Channels, function (i, v) {
                                ch.push(v.ChannelLocationId);
                            });

                            var dataTosend = {
                                "ApplicationId": data.detail.Application.ApplicationId,
                                "ChannelLocationId": ch
                            }

                            var datat2 = JSON.stringify(dataTosend);

                            $.ajax({
                                url: objSession.APIUrl + 'Document/GetDocuments',
                                method: 'POST',
                                headers: { 'content-Type': 'application/json', 'Authorization': 'Bearer ' + objSession.Token.access_token },
                                contentType: 'application/json; charset=utf-8',
                                dataType: "json",
                                data: datat2,
                                success: function (data) {
                                    if (data.StatusCode == 200) {

                                        var objDoc = data.Detail;
                                        var file;
                                        if (objDoc != null) {
                                            pubIsExistDoc = true;
                                            $.each(objDoc, function (index, val) {
                                                if (val.DocCode == 'APP') {
                                                    appDocPath = val.DocPath;
                                                    appDocName = val.DocName;
                                                    appDocStatus = val.ReviewedStatus;
                                                    appDocStatusRemarks = val.ReviewedRamarks;
                                                }
                                                else if (val.DocCode == 'CERT') {
                                                    certDocPath = val.DocPath;
                                                    certDocName = val.DocName;
                                                    certDocStatus = val.ReviewedStatus;
                                                    certDocStatusRemarks = val.ReviewedRamarks;
                                                }
                                                else if (val.DocCode == 'ID_CARD') {
                                                    idCardDocPath = val.DocPath;
                                                    idDocName = val.DocName;
                                                    idDocStatus = val.ReviewedStatus;
                                                    idDocStatusRemarks = val.ReviewedRamarks;
                                                }
                                                else if (val.DocCode == 'PAY_SLIP') {
                                                    payslipDocPath = val.DocPath;
                                                    payslipDocName = val.DocName;
                                                    payslipDocStatus = val.ReviewedStatus;
                                                    payslipDocStatusRemarks = val.ReviewedRamarks;
                                                }

                                            });

                                            if (appDocStatus == 'confirm') {
                                                $('#fileApp').prop('disabled', 'disabled');
                                                $('#appDocCurStatus').addClass('text-success glyphicon glyphicon-ok');
                                                $('#btnUpload').prop('disabled', 'disabled');
                                                ShowWarning('Document was confirmed, system is not allowed to upload.');
                                            }
                                            else if (appDocStatus == 'reject') {
                                                $('#appDocCurStatus').addClass('text-danger glyphicon glyphicon-remove');
                                                $('#appDocCurStatusRemarks').addClass('text-danger');
                                                $('#appDocCurStatusRemarks').text(appDocStatusRemarks);
                                            }
                                            else if (appDocStatus == '' || appDocStatus == null) {
                                                $('#appDocCurStatus').addClass(' text-warning glyphicon glyphicon-warning-sign');
                                                $('#appDocCurStatusRemarks').addClass('text-warning');
                                                $('#appDocCurStatusRemarks').text('Pending review');
                                            }

                                            if (certDocStatus == 'confirm') {
                                                $('#fileCert').prop('disabled', 'disabled');
                                                $('#certDocCurStatus').addClass('text-success glyphicon glyphicon-ok');
                                            }
                                            else if (certDocStatus == 'reject') {
                                                $('#certDocCurStatusRemarks').text(certDocStatusRemarks);
                                                $('#certDocCurStatusRemarks').addClass('text-danger')
                                                $('#certDocCurStatus').addClass('text-danger glyphicon glyphicon-remove ');
                                            }
                                            else if (certDocStatus == '' || certDocStatus == null) {
                                                //$('#certDocCurStatus').addClass(' text-warning glyphicon glyphicon-warning-sign');
                                                //$('#certDocCurStatusRemarks').addClass('text-warning');
                                                //$('#certDocCurStatusRemarks').text('Pending review');

                                                if (certDocName != '' && certDocName != null) {

                                                    $('#certDocCurStatus').addClass(' text-warning glyphicon glyphicon-warning-sign');
                                                    $('#certDocCurStatusRemarks').addClass('text-warning');
                                                    $('#certDocCurStatusRemarks').text('Pending review');

                                                }
                                                else {
                                                    $('#certDocCurStatus').removeClass(' text-warning glyphicon glyphicon-warning-sign');
                                                    $('#certDocCurStatusRemarks').removeClass('text-warning');
                                                    $('#certDocCurStatusRemarks').text('');
                                                }
                                            }


                                            if (idDocStatus == 'confirm') {
                                                $('#fileIdCard').prop('disabled', 'disabled');
                                                $('#IdCardDocCurStatus').addClass('text-success glyphicon glyphicon-ok');
                                            }
                                            else if (idDocStatus == 'reject') {
                                                $('#IdCardDocCurStatus').addClass('text-danger glyphicon glyphicon-remove');
                                                $('#IdCardDocCurStatusRemarks').addClass('text-danger');
                                                $('#IdCardDocCurStatusRemarks').text(idDocStatusRemarks);
                                            }
                                            else if (certDocStatus == '' || certDocStatus == null) {
                                                $('#IdCardDocCurStatus').addClass(' text-warning glyphicon glyphicon-warning-sign');
                                                $('#IdCardDocCurStatusRemarks').addClass('text-warning');
                                                $('#IdCardDocCurStatusRemarks').text('Pending review');
                                            }

                                            if (payslipDocStatus == 'confirm') {
                                                $('#filePayslip').prop('disabled', 'disabled');

                                                $('#PayslipDocCurStatus').addClass('text-success glyphicon glyphicon-ok');
                                            }
                                            else if (payslipDocStatus == 'reject') {
                                                $('#PayslipDocCurStatus').addClass('text-danger glyphicon glyphicon-remove');
                                                $('#PayslipDocCurStatusRemarks').addClass('text-danger');
                                                $('#PayslipDocCurStatusRemarks').text(payslipDocStatusRemarks);
                                            }
                                            else if (payslipDocStatus == '' || payslipDocStatus == null) {
                                                $('#PayslipDocCurStatus').addClass(' text-warning glyphicon glyphicon-warning-sign');
                                                $('#PayslipDocCurStatusRemarks').addClass('text-warning');
                                                $('#PayslipDocCurStatusRemarks').text('Pending review');
                                            }

                                            if (appDocStatus == 'confirm' && certDocStatus == 'confirm' && idDocStatus == 'confirm' && payslipDocStatus == 'confirm') {
                                                $('#btnUpload').prop('disabled', 'disabled');
                                                ShowWarning('Documents were reviewed and confirmed, System is not allowed to make change.');
                                            }
                                          
                                            $('#AppDocName').text(appDocName);
                                            $('#CertDocName').text(certDocName);
                                            $('#IdCardDocName').text(idDocName);
                                            $('#PayslipDocName').text(payslipDocName);

                                            objAppView.attr("href", "frmUploadDocs_View.aspx?filePath=" + encodeURIComponent(appDocPath) + "&ref=" + objSession.Token.access_token + "&docType=policycontract");
                                            objCertView.attr("href", "frmUploadDocs_View.aspx?filePath=" + encodeURIComponent(certDocPath) + "&ref=" + objSession.Token.access_token + "&docType=policycontract");
                                            objIdCardView.attr("href", "frmUploadDocs_View.aspx?filePath=" + encodeURIComponent(idCardDocPath) + "&ref=" + objSession.Token.access_token + "&docType=policycontract");
                                            objPayslipView.attr("href", "frmUploadDocs_View.aspx?filePath=" + encodeURIComponent(payslipDocPath) + "&ref=" + objSession.Token.access_token + "&docType=policycontract");
                                            HideViewFile(false);
                                        }
                                        else {
                                            /*not existing doc, hide view file*/
                                            HideViewFile(true);
                                        }


                                    }
                                    else {
                                        ShowError(data.Message);
                                    }
                                }
                            });

                            result = true;
                           

                            HideProgress();

                        } else if (data.status == "400")// save error
                        {
                            ShowError(data.message);
                            result = false;
                        } else if (data.status == "500")// request is not valid
                        {
                            var strValidat = '';
                            $.each(data.detail, function (i, val) {
                                strValidat += val.field + ' : ' + val.message + '<br />';
                            });
                            ShowError(strValidat);
                            result = false;
                        }
                    },
                    async: false,
                    error: function (err) {

                        ShowError('ERROR:' + err.statusText);
                        result = false;
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
                result = false;
                ShowErrorRedirect('TOKEN WAS EXPIRED', 'RE-LOAD', '../../default.aspx');
            }
            return result;
        }
    </script>

    <div class="row">
        <div>
            <div class="alert alert-success" role="alert">
                <h4 class="alert-heading">Please upload documents here!</h4>
                <p><span class="star">*</span>Input all required files with .jpg .jpeg .png . pdf </p>

            </div>

            <div class="col-md-12 div-title1">Search Application</div>
            <div class="col-md-4">
                <label>Application Number</label><span class="star">*</span>
                <input type="text" class="form-control" placeholder="APPxxxxxxxx" id="txtApplicationNumber" />
            </div>
            <div class="col-md-4">
                <label>Certificate Number</label>
                <input type="text" class="form-control" readonly="true" id="txtCertificateNumber" />
            </div>
            <div class="col-md-4">
                <div class="btn-group" role="group">
                    <br />
                    <button type="button" class="btn  btn-primary " id="btnProceed">Proceed <span class="glyphicon glyphicon-forward"></span></button>
                </div>
            </div>

            <div class="col-md-12 div-title1 margin-top-10">Attach Documents</div>
            <div class="col-md-12">

                <label>Files</label><span class="star">*</span>  <a href="#" id="AppView" target="_blank"><span id="AppDocName"></span></a>&nbsp;&nbsp;<span id="appDocCurStatus"></span>&nbsp;&nbsp;<span id="appDocCurStatusRemarks"></span>
                <input type="file" class="form-control" id="fileApp" multiple="multiple"  />

            </div>


            <div class="col-md-12 hidden">
                <label>Certificate</label>
                <a href="#" id="CertView" target="_blank"><span id="CertDocName"></span></a>&nbsp;&nbsp;<span id="certDocCurStatus"></span>&nbsp;&nbsp;<span id="certDocCurStatusRemarks"></span>
                <input type="file" class="form-control" id="fileCert" />

            </div>
            <div class="col-md-12 hidden" >
                <label>ID Card</label><span class="star">*</span> <a href="#" id="IdCardView" target="_blank"><span id="IdCardDocName"></span></a>&nbsp;&nbsp;<span id="IdCardDocCurStatus"></span>&nbsp;&nbsp;<span id="IdCardDocCurStatusRemarks"></span>
                <input type="file" class="form-control" id="fileIdCard" />

            </div>
            <div class="col-md-12 hidden" >
                <label>PaySlip</label><span class="star">*</span> <a href="#" id="payslipView" target="_blank"><span id="PayslipDocName"></span></a>&nbsp;&nbsp;<span id="PayslipDocCurStatus"></span>&nbsp;&nbsp;<span id="PayslipDocCurStatusRemarks"></span>
                <input type="file" class="form-control" id="filePayslip" />

            </div>
            <div class="col-md-12">
                <progress id="fileProgress" style="display: none; width: 100%;"></progress>
            </div>
            <div class="col-md-12">
                <div class="btn-group" role="group">
                    <button type="button" id="btnUpload" class=" btn btn-primary button-space">Upload&nbsp;&nbsp;<span class="glyphicon glyphicon-upload"></span></button>
                </div>

            </div>
        </div>
        <!-- Modal progressing -->
        <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static">
            <div class="modal-dialog">
                <div class="modal-content">
                      <div class="modal-header">
                    <div style="display: flexbox; flex-direction: row; flex-align: center;">

                        <div id="spinner"></div>
                     
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

    </div>
</asp:Content>

