<%@ Page Language="C#" Title="Upload Registration Documents" AutoEventWireup="true" CodeFile="frmRegistrationDocuments.aspx.cs" Inherits="Pages_NB_frmTranFileUpload" MasterPageFile="~/Pages/Content.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Main" runat="Server">
    <script src="../../Scripts/js/custom.js"></script>
    <script type="text/javascript">

        var objSession = null;
        var pubPageAccess = null;
        $(document).ready(function () {

            objSession = JSON.parse(sessionStorage.getItem('SESSION_LOGIN'));
            if (objSession != null) {
                if (Date.parse(new Date()) < Date.parse(objSession.Token.expire_at)) {
                    pubPageAccess = GetPageAccess('frmRegistrationDocuments.aspx');
                    if (pubPageAccess != undefined) {
                        if (pubPageAccess.IsView != 1) {
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
                ShowErrorRedirect('SESSION LOGIN NOT FOUND.', 'Re-Load', '../../default.aspx');
            }


            /*button upload*/
            $('#btnUpload').click(function () {
                if (objSession != null) {
                    if (Date.parse(new Date()) < Date.parse(objSession.Token.expire_at)) {
                        var objFile = $('#fUpload');
                        var objFileDescription = $('#txtFileDescription');


                        if (objFile.get(0).files.length == 0) {

                            ShowWarning('Please selecte file(s) to upload.');

                            return;
                        }
                        else if (objFileDescription.val().trim() == '') {
                            ShowWarning('Please input file description.');

                            return;
                        }

                        if (pubPageAccess.IsAdd == 1) {

                            var formData = new FormData();
                            var i = 0;
                            while (i < objFile.get(0).files.length) {
                                formData.append("file", objFile[0].files[i]);
                                i++;
                            }

                            formData.append("fileDescription", objFileDescription.val());

                            $.ajax({
                                url: objSession.APIUrl + 'Document/UploadTransactionFiles?userName=' + objSession.UserName + '&folderName=RegistrationDocument',
                                method: 'POST',
                                headers: { 'Authorization': 'Bearer ' + objSession.Token.access_token },
                                cache: false,
                                contentType: false,
                                processData: false,
                                mimeType: "multipart/form-data",
                                dataType: 'Json',
                                data: formData,
                                success: function (data) {
                                    var obj = data;// JSON.parse(data);
                                    if (obj.StatusCode == 200) {
                                        ShowSuccess("Files uploaded successfully.");

                                        objFile.val('');
                                        objFileDescription.val('');
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
                            ShowError('You do not have permission to uload files.');
                        }
                    }
                    else /*token expired*/ {
                        ShowErrorRedirect('TOKEN WAS EXPIRED', 'RE-LOAD', '../../default.aspx');
                    }

                }
                else {
                    /*some file are not selected*/
                    ShowErrorRedirect('SESSION LOGIN NOT FOUND.', 'Close', '../../default.aspx');
                }

            });

        });

    </script>

    <div class="row">
        <div>
            <div class="alert alert-success" role="alert">
                <h4 class="alert-heading">Please upload document here!</h4>
                <p><span class="star">*</span>Supported File .pdf </p>

            </div>

            <div class="col-md-12 div-title1 margin-top-10">Attach Document</div>
            <div class="col-md-6">
                <label>File</label><span class="star">*</span>  <a href="#" id="AppView" target="_blank"><span id="AppDocName"></span></a>&nbsp;&nbsp;<span id="appDocCurStatus"></span>&nbsp;&nbsp;<span id="appDocCurStatusRemarks"></span>
                <input type="file" class="form-control" multiple="multiple" id="fUpload" />

            </div>
            <div class="col-md-6">
                <label>File Description</label><span class="star">*</span>  <a href="#" id="A1" target="_blank"><span id="Span1"></span></a>&nbsp;&nbsp;<span id="Span2"></span>&nbsp;&nbsp;<span id="Span3"></span>
                <input type="text" class="form-control" id="txtFileDescription" />

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

    </div>
</asp:Content>
