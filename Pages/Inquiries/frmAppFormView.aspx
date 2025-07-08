<%@ Page Title="" Language="C#" MasterPageFile="~/Pages/Content.master" AutoEventWireup="true" CodeFile="frmAppFormView.aspx.cs" Inherits="Pages_Inquiries_frmAppFormView" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Main" runat="Server">
    <script src="../../Scripts/js/jsApplicationView.js"></script>
    <script src="../../Scripts/moment.js"></script>
    <script src="../../Scripts/js/custom.js"></script>
    <script type="text/javascript">

        var objSession = null;
        var pubPageAccess = null;
        $(document).ready(function () {

            objSession = JSON.parse(sessionStorage.getItem('SESSION_LOGIN'));
            if (objSession != null) {
                if (Date.parse(new Date()) < Date.parse(objSession.Token.expire_at)) {
                    pubPageAccess = GetPageAccess('frmAppFormView.aspx');
                    if (pubPageAccess != undefined) {
                        if (pubPageAccess.IsView == 1) {
                            var searchPara = window.location.search;
                            var q = searchPara.split('?');
                            if (q.length == 2) {
                                var v2 = q[1].split('=');

                                if (v2[0] == 'APP_ID') {

                                    GetApplication(v2[1]);
                                }
                                else {
                                    ShowErrorRedirect('Bad URL.', 'Close', '../../default.aspx');
                                }

                            }
                            else {
                                ShowErrorRedirect('Bad URL.', 'Close', '../../default.aspx');
                            }


                        }
                        else {
                            /*user does not have permission to access the page*/
                            ShowErrorRedirect('You don\'t have permission to access the page.', 'Close', 'frmAppInquiry.aspx');
                        }
                    }
                    else {/*page not found*/
                        ShowErrorRedirect('This page is prohibited.', 'Close', '../../default.aspx');
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


            //  var q1 = q.split('&');


            //Button print application 
            $('#btnPrintApplication').click(function () {

                if (Date.parse(new Date()) < Date.parse(objSession.Token.expire_at)) {
                    window.open("../Cert/eApplication_V.aspx?applicationId=" + pubApplicationId + "&applicationType=IND&token=" + objSession.Token.access_token);
                }
                else /*token expired*/ {
                    ShowErrorRedirect('TOKEN WAS EXPIRED', 'RE-LOAD', '../../default.aspx');
                }

              

            });

            /*button prin certificate*/
            $('#btnPrintCertificate').click(function () {
                //if (objSession.Token.access_token == null) {
                //    ShowError('Token is not found, please reload page and try again.');
                //}
                //else {
                //    if (sessionStorage.hasOwnProperty('polId') == false || sessionStorage.getItem('polId') == null) {
                //        ShowError('Policy ID is required.');
                //    }
                //    else {
                //        /*open ecertificate page*/
                //        window.open("../Cert/eCertificate_V.aspx?policyId=" + pubPolicyId + "&policyType=IND&token=" + objSession.Token.access_token);
                //    }
                //}

                if (Date.parse(new Date()) < Date.parse(objSession.Token.expire_at)) {
                    /*open ecertificate page*/
                    window.open("../Cert/eCertificate_V.aspx?policyId=" + pubPolicyId + "&policyType=IND&token=" + objSession.Token.access_token);
                }
                else /*token expired*/ {
                    ShowErrorRedirect('TOKEN WAS EXPIRED', 'RE-LOAD', '../../default.aspx');
                }

            });

        });

        var pubPolicyId = '';
        var pubApplicationId = '';
        function GetApplication(applicationNumber) {
            var objClientType = $('#Main_txtClientType');
            var objClientTypeRemarks = $('#Main_txtClientTypeRemarks');
            var objClientTypeRelation = $('#Main_txtClientTypeRelation');
            var objApplicationDate = $('#Main_txtApplicationDate');
            var objApplicationNumber = $('#Main_txtApplicationNumber');
            var objPolicyNumber = $('#Main_txtCertificateNumber');
            var objPolicyStatus = $('#Main_txtPolicyStatus');
            var objAgentCode = $('#Main_txtAgentCode');
            var objAgentName = $('#Main_txtAgentName');
            var objReferrerId = $('#Main_txtReferrerId');
            var objChannelName = $('#Main_txtChannelName');
            var objBranchCode = $('#Main_txtBranchCode');
            var objBranchName = $('#Main_txtBranchName');

            var objIdType = $('#Main_txtIdType');
            var objIdNumber = $('#Main_txtIdNumber');
            var objSurnameKh = $('#Main_txtSurnameKh');
            var objSurnameEn = $('#Main_txtSurnameEn');
            var objFirstNameKh = $('#Main_txtFirstNameKh');
            var objFirstNameEn = $('#Main_txtFirstNameEn');
            var objNationality = $('#Main_txtNationality');
            var objGender = $('#Main_txtGender');
            var objDob = $('#Main_txtDob');
            var objAge = $('#Main_txtAge');
            var objMaritalStatus = $('#Main_txtMaritalStatus');
            var objOccupation = $('#Main_txtOccupation');
            var objPhoneNumber = $('#Main_txtPhoneNumber');
            var objEmail = $('#Main_txtEmail');
            var objHouseNo = $('#Main_txtHouseNo');
            var objStreetNo = $('#Main_txtStreetNo');
            var objProvince = $('#Main_txtProvince');
            var objDistrict = $('#Main_txtDistrict');
            var objCommune = $('#Main_txtCommune');
            var objVillage = $('#Main_txtVillage');

            var objPackage = $('#Main_txtPackage');
            var objProductName = $('#Main_txtProductName');
            var objCoverPeriod = $('#Main_txtCoverPeriod');
            var objPayPeriod = $('#Main_txtPaymentPeriod');
            var objBasicSA = $('#Main_txtSumAssure');
            var objPaymentMode = $('#Main_txtPaymentMode');
            var objAnnualPremium = $('#Main_txtAnnualPremium');
            var objPremium = $('#Main_txtPremium');
            var objBasicDiscount = $('#Main_txtDiscountAmount');
            var objPremiumAfterDiscount = $('#Main_txtPremiumAfterDiscount');

            var objRiderProductName = $('#Main_txtRiderProduct');
            var objRiderSA = $('#Main_txtRiderSA');
            var objRiderAnnualPremium = $('#Main_txtRiderAnnualPremium');
            var objRiderPremium = $('#Main_txtRiderPremium');
            var objRiderDiscount = $('#Main_txtRiderDiscountAmount');
            var objRiderPremiumAfterDiscount = $('#Main_txtRiderPremiumAfterDiscount');

            var objTotalAmount = $('#Main_txtTotalAmount');
            var objTotalDiscount = $('#Main_txtTotalDiscountAmount');
            var objTotalAmountAfterDiscount = $('#Main_txtTotalAmountAfterDiscount');

            //beneficiaries
            var objBen = $('#tblBenList');

            var objAnswer = $('#Main_txtAnswer');
            var objAnswerRemarks = $('#Main_txtAnswerRemarks');

            var objIssueDate = $('#Main_txtIssueDate');
            var objCollectedPremium = $('#Main_txtCollectedPremium');
            var objPaymentReferenceNo = $('#Main_txtPaymentReferenceNo');

            $.ajax({
                url: objSession.APIUrl + 'Application/GetApplicationDetail?applicationNumber=' + applicationNumber,
                method: 'GET',
                headers: { 'content-Type': 'application/json', 'Authorization': 'Bearer ' + objSession.Token.access_token },
                contentType: 'application/json; charset=utf-8',
                dataType: "json",
                success: function (data) {

                    if (data.status == "200")//save success
                    {
                        pubPolicyId = data.detail.PolicyId;
                        /*store policy id in session for using in eCertificate form*/
                        sessionStorage.setItem('polId', data.detail.PolicyId);

                        objPolicyNumber.val(data.detail.PolicyNumber);
                        objPolicyStatus.val(data.detail.PolicyStatus);
                        var cust = data.detail.Customer;
                        var app = data.detail.Application;
                        var channel = data.detail.Channel;
                        var agent = data.detail.Agent;
                        var address = data.detail.Customer.Address;
                        var insurance = data.detail.Insurance;
                        var benList = data.detail.Beneficiaries;
                        var rider = data.detail.Rider;
                        var question = data.detail.Questionaire;

                        var premium = 0;
                        var discountAmount = 0;
                        var totalPremium = 0;
                        var riderPremium = 0;
                        var riderDiscountAmount = 0;
                        var riderTotalPremium = 0;

                        pubApplicationId = app.ApplicationId;

                        objClientType.val(app.ClientType);
                        objClientTypeRemarks.val(app.ClientRemarks);
                        objClientTypeRelation.val(app.ClientTypeRelation);
                        objApplicationNumber.val(app.ApplicationNumber);
                        objApplicationDate.val(moment(app.ApplicationDate).format('DD-MM-YYYY'));
                        objAgentCode.val(agent.AgentCode);
                        objAgentName.val(agent.AgentNameEn);
                        objReferrerId.val(app.REFERRER_ID);
                        objChannelName.val(channel.ChannelItemName);
                        objBranchCode.val(channel.OfficeCode);
                        objBranchName.val(channel.OfficeName);

                        objIdType.val(cust.IdTypeKh);
                        objIdNumber.val(cust.IdNumber);
                        objSurnameEn.val(cust.LastNameEn);
                        objFirstNameEn.val(cust.FirstNameEn);
                        objSurnameKh.val(cust.LastNameKh);
                        objFirstNameKh.val(cust.FirstNameKh);
                        objNationality.val(cust.Nationality);
                        objGender.val(cust.GenderKh);
                        objDob.val(moment(cust.Dob).format('DD-MM-YYYY'));
                        objAge.val(data.detail.Age);
                        objMaritalStatus.val(cust.MaritalStatus);
                        objOccupation.val(cust.Occupation);
                        objPhoneNumber.val(cust.PhoneNumber);
                        objEmail.val(cust.Email);
                        objHouseNo.val(address.HouseNo);
                        objStreetNo.val(address.StreetNo);
                        objProvince.val(address.ProvinceKh);
                        objDistrict.val(address.DistrictKh);
                        objCommune.val(address.CommuneKh);
                        objVillage.val(address.VillageKh);

                        objPackage.val(insurance.Package);
                        objProductName.val(insurance.ProductName);
                        objCoverPeriod.val(insurance.CoverYear);
                        objPayPeriod.val(insurance.PaymentPeriod);
                        objPaymentMode.val(insurance.PaymentModeKh);
                        objAnnualPremium.val(insurance.AnnualPremium);
                        objPremium.val(insurance.Premium);
                        objBasicDiscount.val(insurance.DiscountAmount);
                        objPremiumAfterDiscount.val(insurance.TotalAmount);

                        premium = insurance.Premium;
                        discountAmount = insurance.DiscountAmount;
                        totalPremium = insurance.TotalAmount;

                        if (rider != null) {
                            objRiderProductName.val(rider.ProductName);
                            objRiderSA.val(rider.SumAssure);
                            objRiderPremium.val(rider.Premium);
                            objRiderAnnualPremium.val(rider.AnnualPremium);
                            objRiderDiscount.val(rider.DiscountAmount);
                            objRiderPremiumAfterDiscount.val(rider.TotalAmount);

                            riderPremium = rider.Premium;
                            riderDiscountAmount = rider.DiscountAmount;
                            riderTotalPremium = rider.TotalAmount;
                        }

                        objTotalDiscount.val(discountAmount + riderDiscountAmount);
                        objTotalAmount.val(premium + riderPremium);
                        objTotalAmountAfterDiscount.val(totalPremium + riderTotalPremium);

                        /*disable print certificate button if application is not covert to policy*/
                        if (data.detail.PolicyId == '') {
                            $('#btnPrintCertificate').prop('disabled', 'disabled');
                        }

                        var row = '';
                        $.each(benList, function (index, val) {
                            row += '<tr>';
                            row += '<td class="hidden">' + val.Id + '</td>';
                            row += '<td class="khmer-font">' + val.FullName + '</td>';
                            row += '<td>' + val.Age + '</td>';
                            row += '<td class="khmer-font">' + val.Relation + '</td>';
                            row += '<td>' + val.PercentageOfShare + '</td>';
                            row += '<td class="hidden">' + val.Address + '</td>';
                            row += '</tr>';
                        });

                        objBen.append(row);

                        if (question.Answer == 0)
                        { objAnswer.val('NO'); }
                        else
                        { objAnswer.val('YES'); }

                        objAnswerRemarks.val(question.AnswerRemarks);

                        objIssueDate.val(moment(data.detail.IssueDate).format('DD-MM-YYYY'));
                        objCollectedPremium.val(data.detail.CollectedPremium);
                        objPaymentReferenceNo.val(data.detail.PaymentReferenceNo);

                    } else if (data.status == "400")// save error
                    {
                        ShowError(data.message);
                    } else if (data.status == "500")// request is not valid
                    {
                        var strValidat = '';
                        $.each(data.detail, function (i, val) {
                            strValidat += val.field + ' : ' + val.message + '<br />';
                        });
                        ShowError(strValidat);
                    }
                    HideProgress();
                },
                error: function (err) {
                    ShowError('ERROR:' + err.statusText);
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
    </script>

    <div class="row">

        <div id="dvApplicationInfo">
              <div class="col-md-12   button-center margin-top-20 margin-bottom-30">
                <div class="btn-group" role="group">
                    <button type="button" id="btnPrintApplication" class="btn btn-info button-space"><span class="glyphicon glyphicon-print"></span>&nbsp;&nbsp;Application</button>
                    <button type="button" id="btnPrintCertificate" class="btn btn-primary button-space"><span class="glyphicon glyphicon-print"></span>&nbsp;&nbsp;Certificate</button>
                </div>
            </div>
            <div class="col-md-12 div-title1">Application Information</div>

            <div class="col-md-3">
                <asp:Label runat="server" ID="lblClientType">Client Type</asp:Label>
                <asp:TextBox ID="txtClientType" runat="server" CssClass="form-control">
                </asp:TextBox>
            </div>
            <div class="col-md-3" id="colClientTypeRemarks">
                <asp:Label runat="server" ID="lblClientTypeRemarks">Client Type Remarks</asp:Label>
                <asp:TextBox ID="txtClientTypeRemarks" runat="server" CssClass="form-control khmer-font"></asp:TextBox>
            </div>
            <div class="col-md-3" id="colClientTypeRelation">
                <asp:Label runat="server" ID="lblClientTypeRelation">Client Type Relation</asp:Label>
                <asp:TextBox ID="txtClientTypeRelation" runat="server" CssClass="form-control khmer-font">
                </asp:TextBox>
            </div>
            <div class="col-md-3"></div>

            <div class="col-md-3">

                <asp:Label runat="server" ID="lblAppDate">Application Date</asp:Label>
                <div class="input-group">
                    <span class="input-group-addon"><span class="glyphicon glyphicon-calendar" aria-hidden="true"></span></span>
                    <asp:TextBox ID="txtApplicationDate" ReadOnly="true" runat="server" CssClass="form-control"></asp:TextBox>

                </div>

            </div>
            <div class="col-md-3">
                <asp:Label ID="lblAppNo" runat="server">Application Number</asp:Label>
                <asp:TextBox ID="txtApplicationNumber" runat="server" placeHolder="Auto Generate" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblCertNo" runat="server">Certification Number</asp:Label>
                <asp:TextBox ID="txtCertificateNumber" runat="server" CssClass="form-control" placeHolder="Auto Generate"></asp:TextBox>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblPolicy" runat="server">Policy Status</asp:Label>
                <asp:TextBox ID="txtPolicyStatus" runat="server" CssClass="form-control" placeHolder="Auto Generate"></asp:TextBox>
            </div>


            <div class="col-md-3">
                <asp:Label ID="lblAgentcode" runat="server">Agent Code</asp:Label>
                <asp:TextBox ID="txtAgentCode" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblAgentName" runat="server">Agent Name</asp:Label>
                <asp:TextBox ID="txtAgentName" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblReferrerId" runat="server">Referrer Id</asp:Label>
                <asp:TextBox ID="txtReferrerId" runat="server" CssClass="form-control"></asp:TextBox>
            </div>

            <div class="col-md-3">
                <asp:Label ID="lblPartner" runat="server">Channel Name</asp:Label>
                <asp:TextBox ID="txtChannelName" runat="server" CssClass="form-control"> </asp:TextBox>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblBranchCode" runat="server">Branch Code</asp:Label>
                <asp:TextBox ID="txtBranchCode" runat="server" CssClass="form-control"> </asp:TextBox>
            </div>

            <div class="col-md-12">
                <asp:Label ID="lblBranchName" runat="server">Branch Name</asp:Label>
                <asp:TextBox ID="txtBranchName" runat="server" CssClass="form-control"></asp:TextBox>
            </div>

        </div>


        <div id="dvCustomerInfo" class="col-md-12 margin-top-10">

            <div class="col-md-12 div-title1">Customer Information</div>
            <div class="col-md-3">
                <asp:Label ID="lblIdType" runat="server">ID Type</asp:Label>
                <asp:TextBox ID="txtIdType" runat="server" CssClass="form-control khmer-font">
                </asp:TextBox>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblIdNo" runat="server">ID Number</asp:Label>
                <asp:TextBox ID="txtIdNumber" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblSurNameKh" runat="server">Surname (KH)</asp:Label>
                <asp:TextBox ID="txtSurnameKh" runat="server" CssClass="form-control khmer-font"></asp:TextBox>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblFirstNameKh" runat="server">First Name (KH)</asp:Label>
                <asp:TextBox ID="txtFirstNameKh" runat="server" CssClass="form-control khmer-font"></asp:TextBox>
            </div>

            <div class="col-md-3">
                <asp:Label ID="lblSurNameEn" runat="server">Surname (EN)</asp:Label>
                <asp:TextBox ID="txtSurnameEn" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblFirstNameEn" runat="server">First Name (EN)</asp:Label>
                <asp:TextBox ID="txtFirstNameEn" runat="server" CssClass="form-control "></asp:TextBox>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblNationality" runat="server">Nationality</asp:Label>
                <asp:TextBox ID="txtNationality" runat="server" CssClass="form-control  khmer-font"></asp:TextBox>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblGender" runat="server">Gender</asp:Label>
                <asp:TextBox ID="txtGender" runat="server" CssClass="form-control  khmer-font">
                </asp:TextBox>
            </div>

            <div class="col-md-3">
                <asp:Label ID="lblDob" runat="server">DOB</asp:Label>
                <div class="input-group">
                    <span class="input-group-addon"><span class="glyphicon glyphicon-calendar" aria-hidden="true"></span></span>
                    <asp:TextBox ID="txtDob" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                </div>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblAge" runat="server">Age</asp:Label>
                <div class="input-group">
                    <span class="input-group-addon">YEAR</span>
                    <asp:TextBox ID="txtAge" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblMaritalStatus" runat="server">Marital Status</asp:Label>
                <asp:TextBox ID="txtMaritalStatus" runat="server" CssClass="form-control khmer-font">
                </asp:TextBox>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblOccupation" runat="server">Occupation</asp:Label>
                <asp:TextBox ID="txtOccupation" runat="server" CssClass="form-control khmer-font"></asp:TextBox>
            </div>

            <div class="col-md-6">
                <asp:Label ID="lblPhoneNumber" runat="server">Phone Number</asp:Label>
                <asp:TextBox ID="txtPhoneNumber" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="col-md-6">
                <asp:Label ID="lblEmail" runat="server">Email</asp:Label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control"></asp:TextBox>
            </div>

            <div class="col-md-3">
                <asp:Label ID="lblHouseNo" runat="server">House No.</asp:Label>
                <asp:TextBox ID="txtHouseNo" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblStrNo" runat="server">Street No.</asp:Label>
                <asp:TextBox ID="txtStrNo" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblProvince" runat="server">Province</asp:Label>
                <asp:TextBox ID="txtProvince" runat="server" CssClass="form-control khmer-font"></asp:TextBox>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblDistrict" runat="server">District</asp:Label>
                <asp:TextBox ID="txtDistrict" runat="server" CssClass="form-control khmer-font"></asp:TextBox>
            </div>

            <div class="col-md-3">
                <asp:Label ID="lblCommune" runat="server">Commune</asp:Label>
                <asp:TextBox ID="txtCommune" runat="server" CssClass="form-control khmer-font"></asp:TextBox>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblVillage" runat="server">Village</asp:Label>
                <asp:TextBox ID="txtVillage" runat="server" CssClass="form-control khmer-font"></asp:TextBox>
            </div>
            <div class="col-md-3"></div>
            <div class="col-md-3"></div>

        </div>

        <div id="dvInsurance" class="col-md-12 margin-top-10">

            <div class="col-md-12 div-title1">Insurance Product and Detail</div>
            <div class="col-md-3">
                <asp:Label ID="lblPackage" runat="server" CssClass="lable-bold">Package</asp:Label>
                <asp:TextBox ID="txtPackage" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblProductName" runat="server">Product Name</asp:Label>
                <asp:TextBox ID="txtProductName" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblCoverPeriod" runat="server">Tearm of Cover</asp:Label>
                <div class="input-group">
                    <span class="input-group-addon">YEAR</span>
                    <asp:TextBox ID="txtCoverPeriod" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblPayPeriod" runat="server">Payment Period</asp:Label>
                <div class="input-group">
                    <span class="input-group-addon">YEAR</span>
                    <asp:TextBox ID="txtPaymentPeriod" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
            </div>

            <div class="col-md-3">
                <asp:Label ID="lblSA" runat="server">Sum Assure</asp:Label>
                <div class="input-group">
                    <span class="input-group-addon">USD</span>
                    <asp:TextBox ID="txtSumAssure" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblPaymentMode" runat="server">Payment Mode</asp:Label>
                <asp:TextBox ID="txtPaymentMode" runat="server" CssClass="form-control khmer-font"></asp:TextBox>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblAnnualPremium" runat="server">Annual Premium</asp:Label>
                <div class="input-group">
                    <span class="input-group-addon">USD</span>
                    <asp:TextBox ID="txtAnnualPremium" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblPremium" runat="server">Premium</asp:Label>
                <div class="input-group">
                    <span class="input-group-addon">USD</span>
                    <asp:TextBox ID="txtPremium" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
            </div>

            <div class="col-md-3">
                <asp:Label ID="lblDiscountAmount" runat="server">Discount Amount</asp:Label>
                <div class="input-group">
                    <span class="input-group-addon">USD</span>
                    <asp:TextBox ID="txtDiscountAmount" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblPremiumAfterDiscount" runat="server">Premium After Discount</asp:Label>
                <div class="input-group">
                    <span class="input-group-addon">USD</span>
                    <asp:TextBox ID="txtPremiumAfterDiscount" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
            </div>
            <div class="col-md-3"></div>
            <div class="col-md-3"></div>

            <div class="col-md-3">
                <asp:Label ID="lblRiderProduct" runat="server">Rider Product</asp:Label>
                <asp:TextBox ID="txtRiderProduct" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblRiderSA" runat="server">Rider Sum Assure</asp:Label>
                <div class="input-group">
                    <span class="input-group-addon">USD</span>
                    <asp:TextBox ID="txtRiderSA" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblRiderPremium" runat="server">Rider Premium</asp:Label>
                <div class="input-group">
                    <span class="input-group-addon">USD</span>
                    <asp:TextBox ID="txtRiderPremium" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblRiderDiscountAmount" runat="server">Rider Discount Amount</asp:Label>
                <div class="input-group">
                    <span class="input-group-addon">USD</span>
                    <asp:TextBox ID="txtRiderDiscountAmount" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
            </div>

            <div class="col-md-3">
                <asp:Label ID="lblRiderPremiumAfterDiscount" runat="server">Rider Premium After Discount</asp:Label>
                <div class="input-group">
                    <span class="input-group-addon">USD</span>
                    <asp:TextBox ID="txtRiderPremiumAfterDiscount" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
            </div>
            <div class="col-md-3"></div>
            <div class="col-md-3"></div>
            <div class="col-md-3"></div>

            <div class="col-md-3">
                <asp:Label ID="lblTotalAmount" runat="server">Total Amount</asp:Label>
                <div class="input-group">
                    <span class="input-group-addon">USD</span>
                    <asp:TextBox ID="txtTotalAmount" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblTotalDiscountAmount" runat="server">Total Discount Amount</asp:Label>
                <div class="input-group">
                    <span class="input-group-addon">USD</span>
                    <asp:TextBox ID="txtTotalDiscountAmount" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblTotalAmountAfterDiscount" runat="server">Total Amount After Discount</asp:Label>
                <div class="input-group">
                    <span class="input-group-addon">USD</span>
                    <asp:TextBox ID="txtTotalAmountAfterDiscount" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
            </div>
            <div class="col-md-3"></div>

        </div>

        <div id="dvBeneficiary" class="col-md-12 margin-top-10">
            <div class="col-md-12 div-title1">Beneficiary</div>

            <div class="col-md-12 div-beneficiary">

                <table id="tblBenList" class="table khmer-font">
                    <thead>
                        <tr>
                            <th class="col-sm-2 hidden">No.</th>
                            <th class="col-sm-2">Full Name</th>
                            <th class="col-sm-2">Age</th>
                            <th class="col-sm-2">Relation</th>
                            <th class="col-sm-2">Percentage</th>
                            <th class="col-sm-2"></th>
                        </tr>
                    </thead>
                </table>

            </div>

        </div>
        <div id="dvQuestion" class="col-md-12 margin-top-10">

            <div class="col-md-12 div-title1">Health Question of the Assured</div>
            <div class="col-md-8">
                <p class="khmer-font" style="padding-top: 10px;">១. តើអ្នកត្រូវបានធានារ៉ាប់រងកំពុងស្ថិតក្នុងលក្ខខណ្ឌណាមួយដែលមានស្រាប់មុនពេលបណ្ណសន្យារ៉ាប់រងមានសុពលភាពហើយត្រូវបានកំណត់ដូចជា៖ជំងឺមហារីក ជំងឺទឹកនោមផ្អែម ជំងឺបេះដូង ជំងឺថ្លើម ជំងឺដាច់សរសៃឈាមក្នុងខួរក្បាល ជំងឺសួត ជំងឺតំរងនោម ជំងឺរ៉ាំរ៉ៃ ជំងឺផ្សេងៗដែលកំពុងកើតមានឡើងឬកំពុងព្យាបាលមិនទាន់ជាសះស្បើយ ឬរបួសស្នាមរ៉ាំរ៉ៃដែរឬទេ? ប្រសិនបើប្រែប្រួលសូមបញ្ជាក់មូលហេតុ។</p>
                <p>1. Has the Life Assured is in the conditions which existed before effective date of insurance policy and defined as: Cancer, diabetes, heart disease, liver disease, stroke, lung disease, kidney disease or chronic injuries? If yes, please state the reason.:</p>
            </div>
            <div class="col-md-4">
                <asp:Label ID="lblAnswer" runat="server">Answer</asp:Label>
                <p>
                    <asp:TextBox ID="txtAnswer" runat="server" CssClass="form-control">
                    </asp:TextBox>
                </p>
                <p class="khmer-font">
                    <asp:TextBox ID="txtAnswerRemarks" placeHolder="Answer detail" TextMode="MultiLine" runat="server" CssClass="form-control"></asp:TextBox>
                </p>
            </div>
        </div>

        <div id="dvIssuePolicy" class="col-md-12 margin-top-10">

            <div class="col-md-12 div-title1">Issue Policy</div>
            <div class="col-md-3">
                <asp:Label ID="lblIssueDate" runat="server">Payment Date</asp:Label>
                <div class="input-group">
                    <span class="input-group-addon"><span class="glyphicon glyphicon-calendar" aria-hidden="true"></span></span>
                    <asp:TextBox ID="txtIssueDate" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblCollectedPremium" runat="server">Collected Premium</asp:Label>
                <div class="input-group">
                    <span class="input-group-addon">USD</span>
                    <asp:TextBox ID="txtCollectedPremium" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblPaymentReferenceNo" runat="server">Transaction ID</asp:Label>
                <asp:TextBox ID="txtPaymentReferenceNo" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="col-md-3">
            </div>
        </div>
    </div>
    <!-- Modal -->
    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" data-backdrop="static">
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

