<%@ Page Title="" Language="C#" MasterPageFile="~/Pages/Content.master" AutoEventWireup="true" CodeFile="frmAppForm.aspx.cs" Inherits="Pages_NB_frmAppForm" EnableEventValidation="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Main" runat="Server">

    <link href="../../Scripts/bootstrap/datepicker/css/datepicker.css" rel="stylesheet" />
    <script src="../../Scripts/bootstrap/datepicker/js/bootstrap-datepicker.js"></script>
    <script src="../../Scripts/moment.js"></script>
    <script src="../../Scripts/js/custom.js"></script>
    <script type="text/javascript">


        //public variables
        /*Policyholder*/
        var pubPolicyholderName = '';
        var pubPolicyholderDob = '';
        var pubPolicyholderGender = '';
        var pubPolicyholderIdType = '';
        var pubPolicyholderIdNo = '';
        var pubPolicyholderAddress = '';
        var pubPolicyholderPhonenumber = '';
        var pubPolicyholderEmail = '';

        //application
        var pubClientType = '';
        var pubClientTypeRemarks = '';
        var pubClientTypeRelation = '';
        var pubApplicationDate = '';
        var pubChannelId = '';
        var pubChannelItemId = '';
        var pubChannelLocationId = '';
        var pubAgentCode = '';
        var pubReferrerId = '';
        var pubApplicationNumber = '';
        var pubNumberofPurchasingYear = 0;
        var pubNumberofApplication = 0;
        var pubLoanNumber = '';

        //customer
        var pubIdType = -1;
        var pubIdNumber = '';
        var pubFirstNameEn = '';
        var pubLastNameEn = '';
        var pubFirstNameKh = '';
        var pubLastNameKh = '';
        var pubGender = -1;
        var pubDob = '';
        var pubNationality = '';
        var pubMaritalStatus = '';
        var pubOccupation = '';
        var pubHouseNo = '';
        var pubStreetNo = '';
        var pubVillage = '';
        var pubCommune = '';
        var pubDistrict = '';
        var pubProvince = '';
        var pubPhoneNumber = '';
        var pubEmail = '';
        var pubCreatedBy = '';
        var pubCustRemarks = '';
        var pubCustAge = 0;

        //application insurance
        var pubPackage = '';
        var pubProductId = '';
        var pubBasicSA = 0;
        var pubPaymentMode = -1;
        var pubAnnualPremium = 0;
        var pubBasicPremium = 0;
        var pubBasicDiscount = 0;
        var pubBasicAfterDiscount = 0;
        var pubRiderProductId = '';
        var pubRiderSA = 0;
        var pubRiderPremium = 0;
        var pubRiderAnnualPremium = 0;
        var pubRiderDiscount = 0;
        var pubRiderAfterDiscount = 0;
        var pubTotalDiscount = 0;
        var pubTotalPremium = 0;
        var pubTotalPremiumAfterDiscount = 0;
        var pubCoverage = 0;
        var pubPaymentPeriod = 0;
        var pubCoverType = '';
        var pubSumAssurePremium = new Array();

        var pubApplicationList = [];

        //beneficiary
        var pubBeneficiaryList = [];

        /*Primary beneficiary*/
        pubPrimaryBenName = '';
        pubPrimaryBenAddress = '';
        pubPrimaryBenLoanNumber = '';

        //question
        var pubQuestionId = '';
        var pubAnswer = -1;
        var pubAnswerRemarks = '';
        var pubBeneficiaryRemarks = '';

        var pubIsExisting = false;
        var pubApplicationId = '';
        var pubCustomerId = '';

        /*track transection*/
        var pubIsFirstIssue = false;/*true if user first click issue policy*/

        var objSession;

        var objBeneficairyFilter = null;

        document.onreadystatechange = function () {
            if (document.readyState !== "complete") {
                ShowProgress();
            } else {
                HideProgress();
            }
        };

        var pubPageAccess = null;

        function CalBackDate() {
            var d1 = $('#Main_txtIssueDate').val();// new Date(2024, 12, 23);
            var d2 = moment(objSession.SysDate).format("DD/MM/YYYY");

            var a = d1.split("/");
            var b = d2.split("/");
            var oneDay = 24 * 60 * 60 * 1000;

            var date1 = new Date(a[2], a[1], a[0]);
            var date2 = new Date(b[2], b[1], b[0]);
            var diffDays = Math.round(Math.abs((date1 - date2) / oneDay))
            if (date1 > date2)//selected greater  than current system date
            {
                diffDays *= 1;
            }
            else if (date1 < date2)//selected smaller  than current system date
            {
                diffDays *= -1;
            }
            return (diffDays);
        }
        function CalBackDate2(d1, d2) {
            //var d1 = $('#Main_txtIssueDate').val();// new Date(2024, 12, 23);
            //var d2 = moment(objSession.SysDate).format("DD/MM/YYYY");

            var a = (d1.replace(/(\d{2})\/(\d{2})\/(\d{4})/g, "$1-$2-$3")).split("-");
            var b = (d2.replace(/(\d{2})\/(\d{2})\/(\d{4})/g, "$1-$2-$3")).split("-");
            var oneDay = 24 * 60 * 60 * 1000;

            var date1 = new Date(a[2], a[1], a[0]);
            var date2 = new Date(b[2], b[1], b[0]);
            var diffDays = Math.round(Math.abs((date1 - date2) / oneDay))
            if (date1 > date2)//selected greater  than current system date
            {
                diffDays *= 1;
            }
            else if (date1 < date2)//selected smaller  than current system date
            {
                diffDays *= -1;
            }
            return (diffDays);
        }

        function EnableCustomerInfor(status) {

            if (!status) {
                $('#Main_txtSurnameKh').prop('disabled', 'disabled');
                $('#Main_txtFirstNameKh').prop('disabled', 'disabled');
                $('#Main_txtSurnameEn').prop('disabled', 'disabled');
                $('#Main_txtFirstNameEn').prop('disabled', 'disabled');

                $('#Main_ddlNationality').prop('disabled', 'disabled');
                $('#Main_ddlGender').prop('disabled', 'disabled');
                $('#Main_txtDob').prop('disabled', 'disabled');

                $('#Main_ddlMaritalStatus').prop('disabled', 'disabled');
                $('#Main_ddlOccupation').prop('disabled', 'disabled');

                $('#Main_txtPhoneNumber').prop('disabled', 'disabled');
                $('#Main_txtEmail').prop('disabled', 'disabled');

                $('#Main_txtHouseNo').prop('disabled', 'disabled');
                $('#Main_txtStrNo').prop('disabled', 'disabled');

                $('#Main_ddlProvince').prop('disabled', 'disabled');

                $('#Main_ddlDistrict').prop('disabled', 'disabled');

                $('#Main_ddlCommune').prop('disabled', 'disabled');
                $('#Main_ddlVillage').prop('disabled', 'disabled');
            }
            else {
                $('#Main_txtSurnameKh').removeProp('disabled');
                $('#Main_txtFirstNameKh').removeProp('disabled');
                $('#Main_txtSurnameEn').removeProp('disabled');
                $('#Main_txtFirstNameEn').removeProp('disabled');

                $('#Main_ddlNationality').removeProp('disabled');
                $('#Main_ddlGender').removeProp('disabled');
                $('#Main_txtDob').removeProp('disabled');


                $('#Main_ddlMaritalStatus').removeProp('disabled');
                $('#Main_ddlOccupation').removeProp('disabled');

                $('#Main_txtPhoneNumber').removeProp('disabled');
                $('#Main_txtEmail').removeProp('disabled');

                $('#Main_txtHouseNo').removeProp('disabled');
                $('#Main_txtStrNo').removeProp('disabled');

                $('#Main_ddlProvince').removeProp('disabled');

                $('#Main_ddlDistrict').removeProp('disabled');

                $('#Main_ddlCommune').removeProp('disabled');
                $('#Main_ddlVillage').removeProp('disabled');
            }
        }

        $(document).ready(function () {

            $('#Main_txtApplicationDate').datepicker();
            $('#Main_txtDob').datepicker();
            $('#Main_txtPolicyholderDOB').datepicker();
            $('#Main_txtBenDOB').datepicker();

            $('#Main_txtDob').datepicker().on('changeDate', function (dob) {
                ValidateGetAge();
            });

            $('#Main_txtApplicationDate').datepicker().on('changeDate', function (dob) {
                ValidateGetAge();
            });

            $('#Main_txtBenDOB').datepicker().on('changeDate', function (dob) {

                var d = $('#Main_txtBenDOB').val();
                var appDate = $('#Main_txtApplicationDate').val();
                var objAge = $('#Main_txtBenAge');

                if (d != '' && appDate != '') {
                    var age = GetAge(d, appDate);
                    objAge.val(age);
                } else { objAge.val(''); }

            });

            $('#Main_txtIssueDate').datepicker();

            $('#Main_txtIssueDate').datepicker().on('changeDate', function (issue_date) {

                var backDays = (CalBackDate());
                if (backDays < -3) {
                    ShowError("Back date is allowed only 3 days.");
                    $('#btnIssue').prop('disabled', 'disabled');
                }
                else if (backDays > 0) {
                    ShowError("Issue date is greater than current system date is not allowed.");
                    $('#btnIssue').prop('disabled', 'disabled');
                }
                else {
                    $('#btnIssue').removeProp('disabled');
                }
            });

            HideCust(true);
            HideInsurance(true);
            HideQuestion(true);
            HideBen(true);
            HideIssuePolicy(true);
            Initial();

            objSession = JSON.parse(sessionStorage.getItem('SESSION_LOGIN'));
            if (objSession != null) {
                if (objSession.Token != null) {
                    if (Date.parse(new Date()) < Date.parse(objSession.Token.expire_at)) {
                        pubPageAccess = GetPageAccess('frmAppForm.aspx');
                        if (pubPageAccess != undefined) {
                            if (pubPageAccess.IsAdd == 1 || pubPageAccess.IsUpdate == 1) {
                                webapiUrl = objSession.APIUrl;

                                DisableApplicationInfo(false);

                                if (objSession.Agent != null) {
                                    GetSaleAgentInfo(objSession);
                                    /*Bind channel*/
                                    if (BindChannelLocation(objSession)) {
                                        LoadClientType();
                                        GetClientTypeRelation();
                                        LoadNationality();
                                        LoadOccupation();
                                        LoadProvince();
                                        LoadBeneficiaryRelation();
                                        LoadIdType();
                                        LoadGender();
                                        LoadMaritalStatus();
                                        /*page load check existing data*/
                                        var searchPara = window.location.search;
                                        var q = searchPara.split('?');
                                        if (q.length == 2) {
                                            var v2 = q[1].split('=');
                                            if (v2[0] == 'APP_ID' && v2[1] != '') {
                                                LoadExistingApplication(v2[1]);
                                            }
                                            else {
                                                pubIsExisting = false;
                                            };
                                        }
                                        else {
                                            pubIsExisting = false;
                                        }
                                    }
                                    else {
                                        ShowErrorRedirect("User is not found in channel location mapping.", "Close", "../../default.aspx");
                                    }
                                }
                                else {
                                    ShowErrorRedirect("User is not found in agent mapping.", "Close", "../../default.aspx");
                                }
                                /*hide progress*/
                                HideProgress();
                            }
                            else {
                                /*page is prohibited*/
                                ShowErrorRedirect('This page is prohibited.', 'Close', '../../default.aspx');
                            }
                        }
                        else {
                            /*page is not found*/
                            ShowErrorRedirect('This page is prohibited.', 'Close', '../../default.aspx');
                        }

                    }
                    else {/*token expired*/
                        HideProgress();
                        ShowErrorRedirect("TOKEN IS EXPIRED.", "Reload", "../../default.aspx");
                    }
                }
                else { /*token is null*/
                    HideProgress();

                    ShowErrorRedirect("TOKEN IS NOT FOUND.", "Reload", "../../default.aspx");
                }
            }
            else {
                ShowErrorRedirect("LOGIN SESSION IS NOT FOUND.", "Reload", "../../default.aspx");
                DisableApplicationInfo(true);
            }
            //hide error message
            //$('#dvError').hide();

            //button AppNext
            $('#btnAppNext').click(function () {
                var err = '';
                var chName = $('#Main_ddlChannelItem').find('option:selected').val();
                var branchCode = $('#Main_ddlBranchCode').find('option:selected').val();
                var clientType = $('#Main_ddlClientType').find('option:selected').val();
                var clientTypeRemarks = $('#Main_txtClientTypeRemarks').val();
                var clientTypeRelation = $('#Main_ddlClientTypeRelation').find('option:selected').val();
                /* var agentCode = $('#Main_txtAgentCode').val();*/
                var agentCode = $('#Main_ddlAgentCode').find('option:selected').val();
                var referrerId = $('#Main_txtReferrerId').val();
                var appDate = $('#Main_txtApplicationDate').val();
                var loanNumber = $('#Main_txtLoanNumber').val();
                if (clientType == 'CLIENT_FAMILY') {
                    if (clientTypeRemarks == '') {
                        err += '* Client name is required. <br />';
                    }
                    if (clientTypeRelation == '') {
                        err += '* Client relation is required. <br />';
                    }
                } else if (clientType == 'BANK_STAFF_FAMILY') {
                    if (clientTypeRemarks == '') {
                        err += '* Bank staff name is required. <br />';
                    }
                    if (clientTypeRelation == '') {
                        err += '* Bank staff relation is required. <br />';
                    }
                }

                if (appDate == '') {
                    err += '* Application date is required. Formate [DD/MM/YYYY]. <br />';

                }
                if (chName == '' || chName == null) {
                    err += '* Channel name is required. <br />';
                }
                if (branchCode == '' || branchCode == null) {
                    err += '* Branch code is required. <br />';
                }

                if (clientType != "INDIVIDUAL") {
                    if (loanNumber == '' || loanNumber == null) {
                        err += '* Loan Number is required. <br />';
                    }
                }

                if (err == '') {
                    //store data for saving
                    pubChannelId = '0152DF80-BA95-46A9-BB7A-E71966A34089';
                    pubChannelItemId = chName;
                    pubChannelLocationId = branchCode;
                    pubClientType = clientType
                    pubClientTypeRemarks = clientTypeRemarks;
                    pubClientTypeRelation = clientTypeRelation;
                    pubAgentCode = agentCode;
                    pubReferrerId = referrerId;
                    pubApplicationDate = appDate;

                    pubLoanNumber = loanNumber;

                    AppNext();

                }
                else {
                    ShowError(err);
                }
            });

            var proCode = '';
            var distCode = '';
            var commCode = '';
            var villCode = '';
            var idType = '';
            var gender = '';
            var maritalStatus = '';
            var nationality = '';
            var occupation = '';

            //Button CustNext
            $('#btnCustNext').click(function () {
                //button next customer
                var objIdNumber = $('#<%=txtIdNumber.ClientID%>');
                var objIdType = $('#<%=ddlIdType.ClientID%>');
                var objSurNameKh = $('#<%=txtSurnameKh.ClientID%>');
                var objSurNameEn = $('#<%=txtSurnameEn.ClientID%>');
                var objFirstNameKh = $('#<%= txtFirstNameKh.ClientID%>');
                var objFirstNameEn = $('#<%=txtFirstNameEn.ClientID%>');
                var objNationality = $('#<%=ddlNationality.ClientID%>');
                var objGender = $('#<%=ddlGender.ClientID%>');
                var objDob = $('#<%=txtDob.ClientID%>');
                var objAge = $('#<%=txtAge.ClientID%>');
                var objMaritalStatus = $('#<%=ddlMaritalStatus.ClientID%>');
                var objOccupation = $('#<%=ddlOccupation.ClientID%>');
                var ObjPhoneNumber = $('#<%=txtPhoneNumber.ClientID%>');
                var objEmail = $('#<%=txtEmail.ClientID%>');
                var objHouseNo = $('#<%=txtHouseNo.ClientID%>');
                var objStreetNo = $('#<%=txtStrNo.ClientID%>');
                var objProvince = $('#<%=ddlProvince.ClientID%>');
                var objDiscrit = $('#<%=ddlDistrict.ClientID%>');
                var objCommune = $('#<%=ddlCommune.ClientID%>');
                var objVillage = $('#<%=ddlVillage.ClientID%>');

                var err = '';
                proCode = objProvince.find('option:selected').val();
                distCode = objDiscrit.find('option:selected').val();
                commCode = objCommune.find('option:selected').val();
                villCode = objVillage.find('option:selected').val();

                idType = objIdType.find('option:selected').val();
                gender = objGender.find('option:selected').val();
                maritalStatus = objMaritalStatus.find('option:selected').val();
                nationality = objNationality.find('option:selected').val();
                occupation = objOccupation.find('option:selected').val();

                if (idType == '' || idType == null) {
                    err += '* ID Type is required. <br />';
                }
                if (objIdNumber.val() == '') {
                    err += '* ID Number is required.  <br />';

                }
                if (objSurNameEn.val() == '') {
                    err += '* Surname (KH) is required.  <br />';
                }
                if (objFirstNameKh.val() == '') {
                    err += '* First Name (KH) is required.  <br />';
                }
                if (objSurNameEn.val() == '') {
                    err += '* Surname (EN) is required.  <br />';
                }
                if (objFirstNameEn.val() == '') {
                    err += '* First Name (EN) is required.  <br />';
                }
                if (nationality == '' || nationality == null) {
                    err += '* Nationality is required.  <br />';
                }
                if (gender == '-1' || gender == null) {
                    err += '* Gender is required.  <br />';
                }
                if (objDob.val() == '') {
                    err += '* DOB is required. Format [DD/MM/YYYY]. <br />';
                }
                if (maritalStatus == '' || maritalStatus == null) {
                    err += '* Marital Status is required.  <br />';
                }
                if (occupation == '' || occupation == null) {
                    err += '* Occupation is required.  <br />';
                }
                if (ObjPhoneNumber.val() == '') {
                    err += '* Phone number is required.  <br />';
                }
                if (proCode == '' || proCode == null) {
                    err += '* Province is required.  <br />';
                }
                if (err != '') {
                    ShowError(err);
                    return false;
                }
                else {
                    if (Date.parse(new Date()) < Date.parse(objSession.Token.expire_at)) {
                        var chId = $('#Main_hdfChannelItemId').val();
                        var objPackage = $('#Main_ddlPackage');
                        var agentId = $('#Main_ddlAgentCode').val();
                        var getPro = true;

                        if (getPro == true) {
                            //store data for saving
                            pubIdType = parseInt(idType);
                            pubIdNumber = objIdNumber.val();
                            pubFirstNameEn = objFirstNameEn.val();
                            pubLastNameEn = objSurNameEn.val();
                            pubFirstNameKh = objFirstNameKh.val();
                            pubLastNameKh = objSurNameKh.val();
                            pubGender = parseInt(gender);
                            pubDob = objDob.val();
                            pubNationality = nationality;
                            pubMaritalStatus = maritalStatus;
                            pubOccupation = occupation;
                            pubHouseNo = objHouseNo.val();
                            pubStreetNo = objStreetNo.val();
                            pubVillage = villCode;
                            pubCommune = commCode;
                            pubDistrict = distCode;
                            pubProvince = proCode;
                            pubPhoneNumber = ObjPhoneNumber.val();
                            pubEmail = objEmail.val();
                            pubCreatedBy = objSession.UserName; //'MANETH.SOM'; // PRODUCTION PLEASE SET ACTUAL USER NAME
                            pubCustRemarks = '';
                            pubCustAge = parseInt(objAge.val());

                            objPackage.val(pubProductId);

                            if (pubProductConfig.length > 0) { //found information in product config
                                var minAge = pubProductConfig[0].AgeMin;
                                var maxAge = pubProductConfig[0].AgeMax;
                                if (pubCustAge < minAge || pubCustAge > maxAge) {
                                    err += '* Age must be [' + minAge + ' To ' + maxAge + '].';
                                }
                                else {
                                    err = "";
                                }
                            }
                            else {
                                err = "";
                            }

                            if (err != '') {
                                ShowError(err);
                                return false;
                            }
                            else {
                                /*call event select changed package*/

                                if (pubProductConfig.length == 1) {/*if list product config has only one, call event changepackage to populate proudct detial*/
                                    changedPackage();
                                }

                                changedTotalSumAssure();
                                CustNext();
                                ShowError('');
                            }
                        }
                        else {
                            ShowError('Ooop! Get product configuration error.');
                        }
                    }
                    else/*token expired*/ {
                        ShowErrorRedirect('TOKEN WAS EXPIRED', 'RE-LOAD', '../../default.aspx');
                    }
                }
            });

            //Button InsuranceNext
            $('#bInsuranceNext').click(function () {
                var err = '';
                var objCoverage = $('#Main_txtCoverPeriod');
                var objPaymentPeriod = $('#Main_txtPaymentPeriod');
                var objReferralId = $('#Main_txtReferrerId');
                var objNumberOfPurchasingYear = $('#Main_ddlNumberOfPurchasingYear');
                var objNumberOfApplications = $('#Main_ddlNumberOfApplications');
                var objTotalSumAssure = $('#Main_txtTotalSumAssure');
                /*Policyholder information*/
                var holderName = $('#Main_txtPolicyholderName').val();
                var holderGender = $('#Main_ddlPolicyholderGender').find('option:selected').val();
                var holderDob = $('#Main_txtPolicyholderDOB').val();
                var holderSelectedIdType = $('#Main_ddlPolicyholderIDType').find('option:selected').val();
                var holderIdType = holderSelectedIdType == '' ? -1 : holderSelectedIdType;
                var holderIDNo = $('#Main_txtPolicyholderIDNo').val().trim();
                var holderAddress = $('#Main_txtPolicyHolderAddress').val();

                if (Date.parse(new Date()) < Date.parse(objSession.Token.expire_at)) {
                    if (pubProductDetail == null) {
                        err += '* Package is required. <br />';
                    }
                    if (pubPaymentMode == -1) {
                        err += '* Payment mode is required. <br />';
                    }
                    if (pubBasicPremium == 0) {
                        err += '* Premium is required. <br />';
                    }

                    if (objNumberOfApplications.val() == '0') {
                        err += '* Number of Application is required. <br />';
                    } else { pubNumberofApplication = objNumberOfApplications.find('option:selected').val(); }
                    if (objNumberOfPurchasingYear.val() == '0') {
                        err += '* Number of Year is required. <br />';
                    } else { pubNumberofPurchasingYear = objNumberOfPurchasingYear.find('option:selected').val(); }
                    if (pubProductDetail.ProductId == 'RSSP2025001') {
                        if (objTotalSumAssure.val() == '') {
                            err += '* Total Sum Assure is required. <br />';
                        }
                    }

                    /*product type*/
                    if (pubProductDetail.ProductType == "MICRO_LOAN") {
                        if (holderName == '')
                            err += '* Policyholder name is required. <br />';
                        if (holderIdType >= 0 && holderIDNo == '') {
                            err += '* ID No is required. <br />';
                        }
                        else {
                            pubPolicyholderName = holderName;
                            pubPolicyholderDob = holderDob;
                            pubPolicyholderGender = holderGender;
                            pubPolicyholderIdType = holderIdType;
                            pubPolicyholderIdNo = holderIDNo;
                            pubPolicyholderAddress = holderAddress;

                            /*paste policy holder in primary beneficiary*/
                            $('#Main_txtPrimaryBenName').val(holderName);
                            $('#Main_txtPrimaryBenLoanNumber').val(pubLoanNumber);
                            $('#Main_txtPrimaryBenAddress').val(holderAddress);

                            pubPrimaryBenName = holderName;
                            pubPrimaryBenAddress = holderAddress;
                            pubPrimaryBenLoanNumber = pubLoanNumber;

                            /*show primary beneficiary*/
                            $('#dvPrimaryBeneficiary').css('display', 'block');

                            $('#dvContingentBeneficiary').html('Contingent beneficiary');

                            /*Remove red * of all beneficiary fields */
                            $(".star-ben").text("");
                        }

                        /*build SumAssure Premium*/
                        pubSumAssurePremium = new Array();

                        for (i = 0; i < pubNumberofApplication; i++) {
                            var obj = {
                                SumAssure: pubBasicSA,
                                Premium: pubBasicPremium,
                                DiscountAmount: pubBasicDiscount,
                                TotalAmount: pubBasicAfterDiscount,
                                AnnualPremium: pubAnnualPremium
                            };
                            pubSumAssurePremium.push(obj);
                        }
                    }
                    else {
                        /*some coding here*/
                        pubPolicyholderName = '';
                        pubPolicyholderDob = '';
                        pubPolicyholderGender = '';
                        pubPolicyholderIdType = '';
                        pubPolicyholderIdNo = '';
                        pubPolicyholderAddress = '';

                        /*paste policy holder in primary beneficiary*/
                        $('#Main_txtPrimaryBenName').val('');
                        $('#Main_txtPrimaryBenLoanNumber').val('');
                        $('#Main_txtPrimaryBenAddress').val('');

                        pubPrimaryBenName = '';
                        pubPrimaryBenAddress = '';
                        pubPrimaryBenLoanNumber = '';

                        $('#dvContingentBeneficiary').html('Beneficiary');
                        /*set red * of all beneficiary required fields */
                        $(".star-ben").text("*");


                        /*hide primary beneficiary*/
                        $('#dvPrimaryBeneficiary').css('display', 'none');
                    }
                    //check rider option
                    if (pubProductDetail.IsRequiredRider == true) {
                        if (pubRiderProductId == '') {
                            err += '* Rider (DHC) is required. <br />';
                        }
                        if (pubRiderSA == 0) {
                            err += '* Rider (DHC) sum assure is required. <br />';
                        }
                        if (pubRiderPremium == 0) {
                            err += '* Rider (DHC) premium is required. <br />';
                        }
                        if (pubRiderAfterDiscount == 0) {
                            err += '* Rider (DHC) premium after discount is required. <br />';
                        }
                    }
                    else { //rider is optional
                        if (pubProductDetail.RiderProductID != '') {
                            if (pubRiderSA != 0) {
                                if (pubRiderPremium == 0) {
                                    err += '* Rider (DHC) premium is required. <br />';
                                }
                                if (pubRiderAfterDiscount == 0) {
                                    err += '* Rider (DHC) premium after discount is required. <br />';
                                }
                            }
                        }
                    }

                    if (pubBasicAfterDiscount == 0) {
                        err += '* Premium after discount is required. <br />';
                    }
                    if (pubTotalPremium == 0) {
                        err += '* Total amount is required. <br />';
                    }
                    if (pubTotalPremiumAfterDiscount == 0) {
                        err += '* Total amount after discount is required. <br />';
                    }

                    if (pubCustAge < pubProductDetail.AgeMin || pubCustAge > pubProductDetail.AgeMax) {
                        err += '* Age must be [' + pubProductDetail.AgeMin + ' To ' + pubProductDetail.AgeMax + ']. <br />';
                    }

                    if (pubProductDetail.AllowRefer == true && objReferralId.val().trim() == '') {
                        err += '* Referral Id is required. <br />';
                    }

                    if (err == '') {
                        //store data for saving
                        pubProductId = pubProductDetail.ProductId;

                        pubPackage = pubProductDetail.MarketingName;

                        if (pubProductDetail.ProductId == 'RSSP2025001') {

                            var arrCover = $('#Main_ddlCoverPeriod').find('option:selected').val().split(':');
                            var coverType = arrCover[0];
                            var coverPeriod = arrCover[1];

                            pubPaymentPeriod = parseInt(coverPeriod);
                            pubCoverage = parseInt(coverPeriod);
                            pubCoverType = coverType;
                        }
                        else {
                            pubPaymentPeriod = parseInt(objPaymentPeriod.val());
                            pubCoverage = parseInt(objCoverage.val());
                            pubCoverType = 'Y';
                        }

                        InsuranceNext();//go to beneficiary screen
                    }
                    else {
                        ShowError(err);
                    }
                }
                else {/*token expired*/
                    ShowErrorRedirect('TOKEN WAS EXPIRED', 'RE-LOAD', '../../default.aspx');
                }
            });

            //drop downlist province select index change event.
            $('#<%=ddlProvince.ClientID%>').change(function () {
                var proCode = $('#<%=ddlProvince.ClientID%>').val();
                if (proCode != '') {


                    if (Date.parse(new Date()) < Date.parse(objSession.Token.expire_at)) {
                        LoadDistrict(proCode);
                        $('#<%=ddlCommune.ClientID%>').find('option').remove();
                        $('#<%=ddlVillage.ClientID%>').find('option').remove();
                    }
                    else {
                        ShowErrorRedirect('TOKEN WAS EXPIRED', 'RE-LOAD', '../../default.aspx');
                    }
                }
                else {
                    $('#<%=ddlDistrict.ClientID%>').find('option').remove();
                    $('#<%=ddlCommune.ClientID%>').find('option').remove();
                    $('#<%=ddlVillage.ClientID%>').find('option').remove();
                }
            });

            //drop downlist district select index change event.
            $('#<%=ddlDistrict.ClientID%>').change(function () {
                var distCode = $('#<%=ddlDistrict.ClientID%>').val();
                if (distCode != '') {


                    if (Date.parse(new Date()) < Date.parse(objSession.Token.expire_at)) {
                        LoadCommune(distCode);
                        $('#<%=ddlVillage.ClientID%>').find('option').remove();
                    }
                    else {
                        ShowErrorRedirect('TOKEN WAS EXPIRED', 'RE-LOAD', '../../default.aspx');
                    }

                }
                else {
                    $('#<%=ddlCommune.ClientID%>').find('option').remove();
                    $('#<%=ddlVillage.ClientID%>').find('option').remove();
                }

            });

            //drop downlist district select index change event.
            $('#<%=ddlCommune.ClientID%>').change(function () {
                var commCode = $('#<%=ddlCommune.ClientID%>').val();
                if (commCode != '') {

                    if (Date.parse(new Date()) < Date.parse(objSession.Token.expire_at)) {
                        LoadVillage(commCode);
                    }
                    else {
                        ShowErrorRedirect('TOKEN WAS EXPIRED', 'RE-LOAD', '../../default.aspx');
                    }

                }
                else {
                    $('#<%=ddlVillage.ClientID%>').find('option').remove();
                }
            });

            //drop downlist channel item select index change event.
            $('#<%=ddlChannelItem.ClientID%>').change(function () {
                var chId = $('#<%=ddlChannelItem.ClientID%>').val();
                if (chId != '') {
                    $('#<%=hdfChannelItemId.ClientID%>').val(chId);
                    if (GetBranchCodeList(chId) == false) {
                        ShowError('Ooop! Get branch code is error.');
                        $('#btnAppNext').prop('disabled', 'disabled');
                    }
                    else {
                        $('#btnAppNext').removeProp('disabled');
                    }
                }
                else {
                    $('#<%=ddlBranchCode.ClientID%>').find('option').remove();
                    $('#<%=txtBranchName.ClientID%>').val('');
                }
            });

            //drop downlist branch code select index change event.
            $('#Main_ddlAgentCode').change(function () {
                var agentName = $('#Main_ddlAgentCode').find('option:selected').val();
                $('#Main_txtAgentName').val(agentName);

                var agentCode = $('#Main_ddlAgentCode').val();
                if (agentCode != '' && agentCode != null) {
                    $.ajax({
                        url: webapiUrl + 'SaleAgent/Get?saleAgentId=' + agentCode,
                        method: 'GET',
                        headers: { 'content-Type': 'application/json', 'Authorization': 'Bearer ' + objSession.Token.access_token },// sessionStorage.getItem('accessToken') },
                        contentType: 'application/json; charset=utf-8',
                        dataType: "json",

                        success: function (data) {

                            if (data.StatusCode == "200")//save success
                            {

                                var d1 = moment(data.Detail.ValidTo).format("DD-MM-YYYY");
                                var d2 = $('#Main_txtApplicationDate').val();//moment(objSession.SysDate).format("DD/MM/YYYY");
                                var diff = CalBackDate2(d1, d2);

                                if (diff > 0 && diff <= 30) {
                                    ShowWarning('Sale agent license is going to expire in ' + (diff == 1 ? '1 day.' : diff + ' days.'));
                                    $('#btnAppNext').removeProp('disabled');
                                }
                                if (diff > 0) {
                                    GetProductConfig($('#Main_ddlChannelItem').find('option:selected').val(), $('#Main_ddlAgentCode').find('option:selected').val());
                                    if (pubProductConfig.length == 0) {
                                        ShowWarning('Sale agent has no access to insurance product.');
                                        $('#btnAppNext').prop('disabled', 'disabled');
                                    }
                                    else {
                                        $('#btnAppNext').removeProp('disabled');
                                    }
                                }
                                else if (diff == 0) {

                                    ShowWarning('Sale agent license is expired, system is not allow to proceed the next step.');
                                    $('#btnAppNext').prop('disabled', 'disabled');
                                }
                                else if (diff < 0) {
                                    ShowWarning('Sale agent license was expired, system is not allow to proceed the next step.');

                                    $('#btnAppNext').prop('disabled', 'disabled');
                                }


                            } else {
                                ShowError(data.Message);
                            }

                        },
                        error: function (err) {
                            ShowError(err);
                        }
                    });
                }


            });

            //drop downlist branch code select index change event.
            $('#Main_ddlBranchCode').change(function () {
                var locationId = $('#Main_ddlBranchCode').find('option:selected').val();
                var branchName = '';
                $.each(pubChannelLocation, function (index, val) {
                    if (val.Channel_Location_ID == locationId) {
                        branchName = val.Office_Name;
                        return false;
                    }
                });
                $('#<%=txtBranchName.ClientID%>').val(branchName);

                var branchCode = $('#Main_ddlBranchCode').find('option:selected').text();

                /*load saleAgent*/
                var objddlAgentCode = $('#Main_ddlAgentCode');
                var objChannelItemId = $('#Main_hdfChannelItemId');

                if (objSession.RoleAccess[0].RoleName == "ExternalLoanAdmin" || objSession.RoleAccess[0].RoleName == "administrator") {
                    $.ajax({
                        url: webapiUrl + 'SaleAgent/GetSaleAgentByChannelItemIdBranchCode?channelItemId=' + objChannelItemId.val() + '&branchCode=' + branchCode,
                        method: 'GET',
                        headers: { 'content-Type': 'application/json', 'Authorization': 'Bearer ' + objSession.Token.access_token },
                        contentType: 'application/json; charset=utf-8',
                        dataType: "json",
                        success: function (data) {
                            var option = '';
                            objddlAgentCode.find('option').remove();
                            option = '<option value="">---Select---</option>';
                            $.each(data.Detail, function (index, val) {
                                //bind to drop downlist
                                option += '<option value="' + val.SaleAgentId + '">' + val.SaleAgentId + ' - ' + val.FullNameEn + '</option>';
                            });

                            objddlAgentCode.append(option);

                        },
                        async: false,
                        error: function (err) {
                            return false;
                        }
                    });
                }

            });


            $('#Main_ddlCoverPeriod').change(function () {


                $('#Main_ddlPaymentPeriod').val($('#Main_ddlCoverPeriod').val());

                if ($('#Main_ddlCoverPeriod').val() != 'Y:1') {
                    $('#Main_ddlNumberOfPurchasingYear').val('1');
                    $('#Main_ddlNumberOfPurchasingYear').prop('disabled', 'disabled');

                    if ($('#Main_ddlCoverPeriod').val() == 'M:3') {
                        $('#Main_ddlPaymentMode').val('3');
                    }
                    else if ($('#Main_ddlCoverPeriod').val() == 'M:6') {
                        $('#Main_ddlPaymentMode').val('2');
                    }
                    else {
                        $('#Main_ddlPaymentMode').val('4');
                    }
                    $('#Main_ddlPaymentMode').prop('disabled', 'disabled');

                }

                else {
                    $('#Main_ddlNumberOfPurchasingYear').removeProp('disabled');
                    $('#Main_ddlPaymentMode').val('1');
                }

                pubPaymentMode = $('#Main_ddlPaymentMode').find('option:selected').val();
                /*recall premium calculation*/
                if (pubProductDetail.ProductId == 'RSSP2025001') {
                    PopulateRaksmeyPremium();
                }


            });


            //drop downlist package select index change event.
            $('#Main_ddlPackage').change(function () {

                changedPackage();

            });

            $('#Main_ddlRiderSA').change(function () {

                ValidateCalcRiderPremium();

            });

            $('#Main_txtApplicationDate').change(function () {

                //var dob = $('#Main_txtDob').val();
                //var appDate = $('#Main_txtApplicationDate').val();
                //var age = 0;
                //if (ValidateGetAge() == true)
                //{
                //    age = GetAge(dob, appDate);
                //}
                //alert(age);
                ValidateGetAge();
            });
            $('#Main_txtDob').change(function () {


                ValidateGetAge();
            });

            ///Package select change
            //$('#Main_ddlPackage').change(function () {
            //    ValidateCalcPremium();
            //});


            function PopulateCustomer(idType, idNo) {
                var sendData = {
                    "IdType": idType,
                    "IdNumber": idNo
                };

                $.ajax({
                    url: webapiUrl + 'customer/Get',
                    method: 'POST',
                    headers: { 'content-Type': 'application/json', 'Authorization': 'Bearer ' + objSession.Token.access_token },
                    contentType: 'application/json; charset=utf-8',
                    dataType: "json",
                    data: JSON.stringify(sendData),
                    success: function (data) {

                        if (data.status == "200")//save success
                        {

                            if (data.detail != null && data.detail != 'Customer not found.') {
                                var objCus = data.detail;

                                $('#Main_txtSurnameKh').val(objCus.LAST_NAME_IN_KHMER);
                                $('#Main_txtFirstNameKh').val(objCus.FIRST_NAME_IN_KHMER);
                                $('#Main_txtSurnameEn').val(objCus.LAST_NAME_IN_ENGLISH);
                                $('#Main_txtFirstNameEn').val(objCus.FIRST_NAME_IN_ENGLISH);
                                $('#Main_ddlNationality').val(objCus.NATIONALITY);
                                $('#Main_ddlGender').val(objCus.GENDER);
                                $('#Main_txtDob').val(moment(objCus.DATE_OF_BIRTH).format("DD/MM/YYYY"));

                                /*calculate age*/
                                ValidateGetAge();

                                $('#Main_ddlMaritalStatus').val(objCus.MARITAL_STATUS);
                                $('#Main_ddlOccupation').val(objCus.OCCUPATION);

                                $('#Main_txtPhoneNumber').val(objCus.PHONE_NUMBER);
                                $('#Main_txtEmail').val(objCus.EMAIL);

                                $('#Main_txtHouseNo').val(objCus.HOUSE_NO);
                                $('#Main_txtStrNo').val(objCus.STREET_NO);

                                $('#Main_ddlProvince').val(objCus.PROVINCE);
                                LoadDistrict(objCus.PROVINCE);
                                $('#Main_ddlDistrict').val(objCus.DISTRICT);
                                if (objCus.DISTRICT != '')
                                { LoadCommune(objCus.DISTRICT); }

                                $('#Main_ddlCommune').val(objCus.COMMUNE);
                                if (objCus.COMMUNE != '') {
                                    LoadVillage(objCus.COMMUNE);
                                }
                                $('#Main_ddlVillage').val(objCus.VILLAGE);


                                EnableCustomerInfor(false);

                            }

                            else {
                                EnableCustomerInfor(true);
                                $('#Main_txtSurnameKh').val('');
                                $('#Main_txtFirstNameKh').val('');
                                $('#Main_txtSurnameEn').val('');
                                $('#Main_txtFirstNameEn').val('');

                                $('#Main_ddlNationality').val('');
                                $('#Main_ddlGender').val('-1');
                                $('#Main_txtDob').val('');
                                $('#Main_txtAge').val('');

                                $('#Main_ddlMaritalStatus').val('');
                                $('#Main_ddlOccupation').val('');

                                $('#Main_txtPhoneNumber').val('');
                                $('#Main_txtEmail').val('');

                                $('#Main_txtHouseNo').val('');
                                $('#Main_txtStrNo').val('');

                                $('#Main_ddlProvince').val('');
                                LoadDistrict();
                                $('#Main_ddlDistrict').empty();

                                $('#Main_ddlCommune').empty();

                                $('#Main_ddlVillage').empty();
                            }

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
                        ShowError(err);
                    },/*progressing*/
                    xhr: function () {
                        var fileXhr = $.ajaxSettings.xhr();
                        if (fileXhr.upload) {
                            ShowProgressWithMessage('Getting customer information.');
                        }
                        return fileXhr;
                    }
                });
            }

            $('#Main_ddlIdType').change(function () {

                var idType = $('#Main_ddlIdType').find('option:selected').val();
                var idNo = $('#Main_txtIdNumber').val();
                if (idType != '' && idNo != '') {
                    PopulateCustomer(idType, idNo);
                }
                else {
                    /*clear custome informatin*/
                }
            });

            $('#Main_txtIdNumber').change(function () {

                var idType = $('#Main_ddlIdType').find('option:selected').val();
                var idNo = $('#Main_txtIdNumber').val();
                if (idType != '' && idNo != '') {
                    PopulateCustomer(idType, idNo);
                }
                else {
                    /*clear custome informatin*/
                }
            });

            ///Basic Sum Assured select change
            $('#Main_ddlSumAssure').change(function () {
                ValidateCalcPremium();
            });


            $('#Main_txtTotalSumAssure').change(function () {
                //var totalSA = $('#Main_txtTotalSumAssure').val();

                //var premium = [];
                //if (totalSA >= pubProductDetail.SumAssuredMin) {
                //    if (totalSA <= 25000) {
                //        var countApp = Math.ceil(totalSA / 5000);
                //        $('#Main_ddlNumberOfApplications').val(countApp);
                //        if (totalSA >= 5000) {
                //            $('#Main_txtSumAssure').val(5000);
                //            var remainSA = 5000 - ((5000 * countApp) - totalSA);


                //            /*call function calculate premium*/
                //            //    premium = GetPremium(pubProductDetail.ProductId, pubGender, 18, 5000, pubPaymentMode);
                //            if (ValidateCalcPremium(5000)) {

                //                for (i = 1; i <= countApp - (remainSA > 0 ? 1 : 0) ; i++) {

                //                    obj = {
                //                        SumAssure: 5000,
                //                        Premium: pubBasicPremium,
                //                        DiscountAmount: pubBasicDiscount,
                //                        TotalAmount: pubBasicAfterDiscount
                //                    };
                //                    pubSumAssurePremium.push(obj);
                //                }
                //            }

                //            if (remainSA > 0) {
                //                if (ValidateCalcPremium(remainSA)) {
                //                    //  premium = GetPremium(pubProductDetail.ProductId, pubGender, 18, remainSA, pubPaymentMode);
                //                    obj = {
                //                        SumAssure: remainSA,
                //                        Premium: pubBasicPremium,
                //                        DiscountAmount: pubBasicDiscount,
                //                        TotalAmount: pubBasicAfterDiscount
                //                    };
                //                    pubSumAssurePremium.push(obj);
                //                }
                //            }
                //        }
                //        else {
                //            $('#Main_txtSumAssure').val(totalSA);
                //            // premium = GetPremium(pubProductDetail.ProductId, pubGender, 18, totalSA, pubPaymentMode);
                //            if (ValidateCalcPremium(totalSA)) {
                //                //  premium = GetPremium(pubProductDetail.ProductId, pubGender, 18, remainSA, pubPaymentMode);
                //                obj = {
                //                    SumAssure: remainSA,
                //                    Premium: pubBasicPremium,
                //                    DiscountAmount: pubBasicDiscount,
                //                    TotalAmount: pubBasicAfterDiscount
                //                };
                //                pubSumAssurePremium.push(obj);
                //            }

                //        }

                //    }
                //    else {

                //        ShowError('Maximum SA must be equal to [2,5000]');
                //        $('#Main_txtTotalSumAssure').val(0);
                //    }

                //} else {
                //    ShowError('Minimum SA must be equal to [' + pubProductDetail.SumAssuredMin + ']');
                //    $('#Main_txtTotalSumAssure').val(0);
                //}

                PopulateRaksmeyPremium();
            });

            ///Payment Mode select change
            $('#Main_ddlPaymentMode').change(function () {
                pubPaymentMode = $('#Main_ddlPaymentMode').find('option:selected').val();
                if (pubProductDetail.ProductId == 'RSSP2025001') {
                    PopulateRaksmeyPremium();
                } else {
                    ValidateCalcPremium();
                }
            });

            //Client type select change
            $('#Main_ddlClientType').change(function () {
                var clientType = $('#Main_ddlClientType').find('option:selected').val();
                var objLclientRemarks = $('#Main_lblClientTypeRemarks');
                //var objTclientRemarks = $('#Main_txtClientTypeRemarks');
                var objLclientRelation = $('#Main_lblClientTypeRelation');
                //var objDclientRelation = $('#Main_ddlClientTypeRelation');

                if (clientType == 'CLIENT_FAMILY') {
                    objLclientRemarks.html('Client Name <span class="star">*</span>');
                    objLclientRelation.html('Client Relation <span class="star">*</span>');

                    ShowClientTypeRemarks(true);

                }
                else if (clientType == 'BANK_STAFF_FAMILY') {
                    objLclientRemarks.html('Bank Staff Name <span class="star">*</span>');
                    objLclientRelation.html('Bank Staff Relation <span class="star">*</span>');

                    ShowClientTypeRemarks(true);
                }
                else if (clientType == 'CO_BORROWER') {
                    objLclientRemarks.html('Borrower Name <span class="star">*</span>');
                    objLclientRelation.html('Borrower Relation <span class="star">*</span>');

                    ShowClientTypeRemarks(true);
                }
                else if (clientType == 'INDIVIDUAL') {
                    $('#dvLoanNumber').val('');
                    $('#dvLoanNumber').css('display', 'none');
                }
                else {
                    $('#dvLoanNumber').css('display', 'block');
                    ShowClientTypeRemarks(false);
                }
            });

            //btnAddBeneficiary
            $('#btnAdd').click(function () {
                var resultAdd = AddBeneficiary();
                ShowError(resultAdd);
            });

            //btnBeneficiary next
            $('#btnBenNext').click(function () {
                pubBeneficiaryList = new Array();

                var benList = $('#tblBenList tbody tr');
                var myBen = [];
                var totalPercentage = 0;
                var village = '';
                var commune = '';
                var district = '';
                var province = '';

                var objVillage = $('#Main_ddlVillage');
                var objCommune = $('#Main_ddlCommune');
                var objDistrict = $('#Main_ddlDistrict');
                var objProvince = $('#Main_ddlProvince');

                village = (objVillage.find('option:selected').val());
                commune = objCommune.find('option:selected').val();
                district = objDistrict.find('option:selected').val();
                province = objProvince.find('option:selected').val();
                if (Date.parse(new Date()) < Date.parse(objSession.Token.expire_at)) {

                    if (pubProvince != '12') {// is not phnom penh
                        if (village == undefined || village == '') {
                            village = '';
                        }
                        else {
                            village = 'ភូមិ ' + objVillage.find('option:selected').text();
                        }
                        if (commune != undefined && commune != '') {
                            commune = 'ឃុំ ' + objCommune.find('option:selected').text();
                        }
                        else {
                            commune = '';
                        }
                        if (district != undefined && district != '') {
                            district = 'ស្រុក ' + objDistrict.find('option:selected').text();
                        }
                        else {
                            district = '';
                        }
                        if (province != undefined && province != '') {
                            province = 'ខេត្ត ' + objProvince.find('option:selected').text();
                        }
                        else {
                            province = '';
                        }
                    }
                    else {
                        if (village != undefined && village != '') {
                            village = 'ភូមិ ' + objVillage.find('option:selected').text();
                        }
                        else {
                            village = '';
                        }
                        if (commune != undefined && commune != '') {
                            commune = 'សង្កាត់ ' + objCommune.find('option:selected').text();
                        }
                        else {
                            commune = '';
                        }
                        if (district != undefined && district != '') {
                            district = 'ខណ្ឌ ' + objDistrict.find('option:selected').text();
                        }
                        else {
                            district = '';
                        }
                        if (province != undefined && province != '') {
                            province = 'រាជធានី ' + objProvince.find('option:selected').text();
                        }
                        else {
                            province = '';
                        }

                    }

                    var address = village + ' ' + commune + ' ' + district + ' ' + province;

                    $(benList).each(function (index, element) {

                        Beneficiary = {
                            Id: $(this).find('td:eq(0)').text(),
                            FULL_NAME: $(this).find('td:eq(1)').text().trim(),
                            Gender: $(this).find('td:eq(2) label[id^="benGender' + index + '"]').text(),
                            DOB: $(this).find('td:eq(3)').text() == "" ? '01-01-1900' : $(this).find('td:eq(3)').text().trim(),
                            IdType: $(this).find('td:eq(4)  label[id^="benIdType' + index + '"]').text(),
                            IdNo: $(this).find('td:eq(5)').text().trim(),
                            AGE: $(this).find('td:eq(6)').text().trim(),
                            RELATION: $(this).find('td:eq(7)').text(),
                            PERCENTAGE_OF_SHARE: $(this).find('td:eq(8)').text(),
                            ADDRESS: address.trim(),
                            REMARKS: ''
                        };
                        totalPercentage += parseFloat(Beneficiary.PERCENTAGE_OF_SHARE);
                        pubBeneficiaryList.push(Beneficiary);

                    });

                    if (pubProductDetail.ProductType == 'MICRO_LOAN') {
                        if (benList.length > 0) {
                            if (totalPercentage != 100) {
                                ShowError('* Total percentage of sharing must be equal to 100%.');
                            }
                            else {
                                BenNext();
                            }
                        } else {
                            /*allow empty*/
                            pubBeneficiaryList = null;
                            BenNext();
                        }
                    }
                    else {/*other product type*/
                        if (totalPercentage != 100) {
                            ShowError('* Total percentage of sharing must be equal to 100%.');
                        }
                        else {
                            BenNext();
                        }
                    }

                }
                else {
                    ShowErrorRedirect('TOKEN WAS EXPIRED', 'RE-LOAD', '../../default.aspx');
                }

            });

            //button next save application
            $('#btnSaveApplication').click(function () {
                var objAnswer = $('#Main_ddlAnswer');
                var objAnswerRemarks = $('#Main_txtAnswerRemarks');
                var err = '';

                if (objAnswer.val() == '1') {
                    if (objAnswerRemarks.val() == '') {
                        err = '* Answer detail is required.';
                    }
                }
                if (err == '') {
                    //process save application
                    if (Date.parse(new Date()) < Date.parse(objSession.Token.expire_at)) {
                        var Customer = {
                            "ID_TYPE": parseInt(pubIdType),
                            "ID_NUMBER": pubIdNumber,
                            "FIRST_NAME_IN_ENGLISH": pubFirstNameEn,
                            "LAST_NAME_IN_ENGLISH": pubLastNameEn,
                            "FIRST_NAME_IN_KHMER": pubFirstNameKh,
                            "LAST_NAME_IN_KHMER": pubLastNameKh,
                            "GENDER": pubGender,
                            "DATE_OF_BIRTH": pubDob,
                            "NATIONALITY": pubNationality,
                            "MARITAL_STATUS": pubMaritalStatus,
                            "OCCUPATION": pubOccupation,
                            "HOUSE_NO": pubHouseNo,
                            "STREET_NO": pubStreetNo,
                            "VILLAGE": pubVillage,
                            "COMMUNE": pubCommune,
                            "DISTRICT": pubDistrict,
                            "PROVINCE": pubProvince,
                            "PHONE_NUMBER": pubPhoneNumber,
                            "EMAIL": pubEmail,
                            "CREATED_BY": pubCreatedBy,
                            "REMARKS": pubCustRemarks
                        };
                        var Application = {
                            "ApplicationDate": pubApplicationDate,
                            "ChannelId": pubChannelId,
                            "ChannelItemId": pubChannelItemId,
                            "ChannelLocationId": pubChannelLocationId,
                            "AgentCode": pubAgentCode,
                            "ReferrerId": pubReferrerId,
                            "ClientType": pubClientType,
                            "ClientTypeRemarks": pubClientTypeRemarks,
                            "ClientTypeRelation": pubClientTypeRelation,
                            "Remarks": "",
                            "NumberOfPurchasingYears": pubNumberofPurchasingYear,
                            "NumberOfApplications": pubNumberofApplication,
                            "LoanNumber": pubLoanNumber,
                            "PolicyholderName": pubPolicyholderName,
                            "PolicyholderGender": pubPolicyholderGender == '' ? -1 : pubPolicyholderGender,
                            "PolicyholderDOB": pubPolicyholderDob,
                            "PolicyholderIDType": pubPolicyholderIdType == '' ? -1 : pubPolicyholderIdType,
                            "PolicyholderIDNo": pubPolicyholderIdNo,
                            //"PolicyholderPhoneNumber": "012363466",
                            //"PolicyholderPhoneNumber2": "",
                            //"PolicyholderEmail": "",
                            "PolicyholderAddress": pubPolicyholderAddress
                        };


                        var ApplicationInsurance = {
                            "PRODUCT_ID": pubProductId,
                            "TERME_OF_COVER": pubCoverage,
                            "PAYMENT_PERIOD": pubPaymentPeriod,
                            "SUM_ASSURE": pubBasicSA,
                            "PAY_MODE": pubPaymentMode,
                            "PAYMENT_CODE": "",
                            "PREMIUM": pubBasicPremium,
                            "ANNUAL_PREMIUM": pubAnnualPremium,
                            "TOTAL_AMOUNT": pubBasicAfterDiscount,
                            "PACKAGE": pubPackage,
                            "DISCOUNT_AMOUNT": pubBasicDiscount,
                            "REMARKS": "",
                            "COVER_TYPE": pubCoverType
                            , "SumAssurePremium": pubSumAssurePremium
                        };

                        var ApplicationInsuranceRider = null;
                        if (pubProductDetail.IsRequiredRider == true) {
                            ApplicationInsuranceRider = {
                                "PRODUCT_ID": pubRiderProductId,
                                "SUM_ASSURE": pubRiderSA,
                                "PREMIUM": pubRiderPremium,
                                "ANNUAL_PREMIUM": pubRiderAnnualPremium,
                                "DISCOUNT_AMOUNT": pubRiderDiscount,
                                "TOTAL_AMOUNT": pubRiderAfterDiscount,
                                "REMARKS": ""
                            };
                        }
                        else {
                            if (pubRiderSA > 0) {
                                ApplicationInsuranceRider = {
                                    "PRODUCT_ID": pubRiderProductId,
                                    "SUM_ASSURE": pubRiderSA,
                                    "PREMIUM": pubRiderPremium,
                                    "ANNUAL_PREMIUM": pubRiderAnnualPremium,
                                    "DISCOUNT_AMOUNT": pubRiderDiscount,
                                    "TOTAL_AMOUNT": pubRiderAfterDiscount,
                                    "REMARKS": ""
                                };
                            }

                        }

                        var Beneficiaries = pubBeneficiaryList;

                        var PrimaryBeneficiary = null;
                        if (pubProductDetail.ProductType == 'MICRO_LOAN') {
                            PrimaryBeneficiary = {
                                "FullName": pubPrimaryBenName,
                                "LoanNumber": pubPrimaryBenLoanNumber,
                                "ADDRESS": pubPrimaryBenAddress
                            };
                        }

                        var Questionaire = {
                            "QUESTION_ID": "6D44FA76-6B00-42D6-A4D7-ACD85986DC7C",
                            "ANSWER": parseInt(objAnswer.val()),
                            "ANSWER_REMARKS": objAnswerRemarks.val(),
                            "REMARKS": ""
                        };
                        var result;
                        if (pubIsExisting == false) {//save new application

                            if (pubPageAccess.IsAdd == 1) {
                                var sendData = {
                                    Customer: Customer,
                                    Application: Application,
                                    ApplicationInsurance: ApplicationInsurance,
                                    ApplicationInsuranceRider: ApplicationInsuranceRider,
                                    Beneficiaries: Beneficiaries,
                                    PrimaryBeneficiary: PrimaryBeneficiary,
                                    Questionaire: Questionaire
                                };

                                $.ajax({
                                    url: webapiUrl + 'Application/SubmitApplication',
                                    method: 'POST',
                                    headers: { 'content-Type': 'application/json', 'Authorization': 'Bearer ' + objSession.Token.access_token },// sessionStorage.getItem('accessToken') },
                                    contentType: 'application/json; charset=utf-8',
                                    dataType: "json",
                                    data: JSON.stringify(sendData),
                                    success: function (data) {

                                        if (data.status == "200")//save success
                                        {

                                            // pubApplicationNumber = data.detail.ApplicationNumber;
                                            // ShowSuccess('Application Number : [ <strong>' + data.detail.ApplicationNumber + '</strong>] is created successfully. <br /> Please collect premium in the next step.');

                                            /*show all applications were saved recently*/
                                            var notifyAppNumber = '';
                                            $.each(data.detail, function (i, val) {
                                                if (val.IsMainApplication == true) {
                                                    pubApplicationNumber = val.ApplicationNumber;
                                                    notifyAppNumber += '<strong>' + val.ApplicationNumber + (val.ClientType != 'REPAYMENT' ? ' - NEW (Main)' : ' - REPAYMENT') + '</strong> <br />';
                                                }
                                                else {
                                                    notifyAppNumber += '<strong>' + val.ApplicationNumber + (val.ClientType != 'REPAYMENT' ? ' - NEW' : ' - REPAYMENT') + '</strong> <br />';
                                                }

                                            });
                                            ShowSuccess('Application created successfully. <br />' + notifyAppNumber + ' Please collect premium in the next step.');

                                            /*reload application*/
                                            LoadExistingApplication(pubApplicationNumber);
                                            //show issue policy section
                                            HideQuestion(true);
                                            HideIssuePolicy(false);

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
                                        ShowError(err);
                                    },/*progressing*/
                                    xhr: function () {
                                        var fileXhr = $.ajaxSettings.xhr();
                                        if (fileXhr.upload) {
                                            ShowProgressWithMessage('Saving information.');
                                        }
                                        return fileXhr;
                                    }
                                });
                            }
                            else {
                                /*user does not have right to save application*/
                                ShowError('You don\'t have permission to save application.');
                            }
                        }
                        else {//update application
                            if (pubPageAccess.IsUpdate == 1) {
                                var Customer = {
                                    "CustomerId": pubCustomerId,
                                    "ID_TYPE": parseInt(pubIdType),
                                    "ID_NUMBER": pubIdNumber,
                                    "FIRST_NAME_IN_ENGLISH": pubFirstNameEn,
                                    "LAST_NAME_IN_ENGLISH": pubLastNameEn,
                                    "FIRST_NAME_IN_KHMER": pubFirstNameKh,
                                    "LAST_NAME_IN_KHMER": pubLastNameKh,
                                    "GENDER": pubGender,
                                    "DATE_OF_BIRTH": pubDob,
                                    "NATIONALITY": pubNationality,
                                    "MARITAL_STATUS": pubMaritalStatus,
                                    "OCCUPATION": pubOccupation,
                                    "HOUSE_NO": pubHouseNo,
                                    "STREET_NO": pubStreetNo,
                                    "VILLAGE": pubVillage,
                                    "COMMUNE": pubCommune,
                                    "DISTRICT": pubDistrict,
                                    "PROVINCE": pubProvince,
                                    "PHONE_NUMBER": pubPhoneNumber,
                                    "EMAIL": pubEmail,
                                    "UPDATED_BY": pubCreatedBy,
                                    "REMARKS": pubCustRemarks
                                };

                                var Application = {
                                    "ApplicationId": pubApplicationId,
                                    "ApplicationDate": pubApplicationDate,
                                    "ChannelId": pubChannelId,
                                    "ChannelItemId": pubChannelItemId,
                                    "ChannelLocationId": pubChannelLocationId,
                                    "AgentCode": pubAgentCode,
                                    "ReferrerId": pubReferrerId,
                                    "ClientType": pubClientType,
                                    "ClientTypeRemarks": pubClientTypeRemarks,
                                    "ClientTypeRelation": pubClientTypeRelation,
                                    "Remarks": "",
                                    "UpdatedBy": pubCreatedBy,
                                    "NumberOfPurchasingYears": pubNumberofPurchasingYear,
                                    "NumberOfApplications": pubNumberofApplication,
                                    "LoanNumber": pubLoanNumber,
                                    "PolicyholderName": pubPolicyholderName,
                                    "PolicyholderGender": pubPolicyholderGender == '' ? -1 : pubPolicyholderGender,
                                    "PolicyholderDOB": pubPolicyholderDob,
                                    "PolicyholderIDType": pubPolicyholderIdType == '' ? -1 : pubPolicyholderIdType,
                                    "PolicyholderIDNo": pubPolicyholderIdNo,
                                    //"PolicyholderPhoneNumber": "012363466",
                                    //"PolicyholderPhoneNumber2": "",
                                    //"PolicyholderEmail": "",
                                    "PolicyholderAddress": pubPolicyholderAddress
                                };

                                var BeneficiariesToDelete = pubBenToDelete;

                                var PrimaryBeneficiary = null;
                                if (pubProductDetail.ProductType == 'MICRO_LOAN') {
                                    PrimaryBeneficiary = {
                                        "FullName": pubPrimaryBenName,
                                        "LoanNumber": pubPrimaryBenLoanNumber,
                                        "ADDRESS": pubPrimaryBenAddress
                                    };
                                }

                                var sendData = {
                                    Customer: Customer,
                                    Application: Application,
                                    ApplicationInsurance: ApplicationInsurance,
                                    ApplicationInsuranceRider: ApplicationInsuranceRider,
                                    Beneficiaries: Beneficiaries,
                                    BeneficiariesToDelete: pubBenToDelete,
                                    PrimaryBeneficiary: PrimaryBeneficiary,
                                    Questionaire: Questionaire
                                };

                                $.ajax({
                                    url: webapiUrl + 'Application/ReSubmitApplicationBatch',
                                    method: 'POST',
                                    headers: { 'content-Type': 'application/json', 'Authorization': 'Bearer ' + objSession.Token.access_token },// sessionStorage.getItem('accessToken') },
                                    contentType: 'application/json; charset=utf-8',
                                    dataType: "json",
                                    data: JSON.stringify(sendData),
                                    success: function (data) {

                                        if (data.status == "200")//save success
                                        {
                                            LoadExistingApplication(pubApplicationNumber);
                                            ShowSuccess(data.detail);

                                            //show issue policy section
                                            HideQuestion(true);
                                            HideIssuePolicy(false);
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
                                        ShowError(err);
                                    },/*progressing*/
                                    xhr: function () {
                                        var fileXhr = $.ajaxSettings.xhr();
                                        if (fileXhr.upload) {
                                            ShowProgressWithMessage('Updating information.');
                                        }
                                        return fileXhr;
                                    }
                                });
                            }
                            else {
                                /*user does not have right to update application*/
                                ShowError('You don\'t have permission to update application.');
                            }
                        }

                    }
                    else/*token expired*/ {
                        ShowErrorRedirect('TOKEN WAS EXPIRED', 'RE-LOAD', '../../default.aspx');
                    }
                }
                else /**/ {
                    ShowError(err);
                }
            });



            //button issue policy
            $('#btnIssue').click(function () {
                if (Date.parse(new Date()) < Date.parse(objSession.Token.expire_at)) {
                    if (pubPageAccess.IsAdd == 1) {
                        var txtIssueDate = $('#Main_txtIssueDate');
                        var txtCollectedPremium = $('#Main_txtCollectedPremium');
                        var txtPaymentReferenceNo = $('#Main_txtPaymentReferenceNo');
                        var txtTotalAmountPay = $('#Main_txtTotalAmountPay');

                        var err = '';
                        if (txtIssueDate.val() == '') {
                            err += '* Issue Date is required with a format [DD/MM/YYYY]. <br />';
                        }

                        var backDays = (CalBackDate());
                        if (backDays < -3) {
                            err += '* Back date is allowed only 3 days. <br />';
                        }
                        else if (backDays > 0) {
                            err += '* Issue date is greater than current system date is not allowed.. <br />';
                        }


                        if (txtCollectedPremium.val() == '' || txtCollectedPremium.val() == '0') {
                            err += '* Collected premium is required. <br />';
                        }
                        if (txtCollectedPremium.val() != txtTotalAmountPay.val()) {
                            err += '* Collected premium must be equal to Total Amount. <br />';
                        }
                        if (txtPaymentReferenceNo.val() == '' || txtPaymentReferenceNo.val() == '0') {
                            err += '* Transaction ID is required. <br />';
                        }
                        if (err == '') {

                            var objApplications = [];
                            objApplications = pubApplicationList;
                            //var sendData = {
                            //    "ApplicationNumber": pubApplicationNumber,
                            //    "IssueDate": txtIssueDate.val(),
                            //    "EffectiveDate": txtIssueDate.val(),
                            //    "CollectedPremium": parseFloat(txtCollectedPremium.val()),
                            //    "ReferenceNo": txtPaymentReferenceNo.val(),
                            //    "CreatedBy": objSession.UserName
                            //};

                            var sendData = {
                                "Applications": objApplications,
                                "IssueDate": txtIssueDate.val(),
                                "EffectiveDate": txtIssueDate.val(),
                                "CollectedPremium": parseFloat(txtCollectedPremium.val()),
                                "ReferenceNo": txtPaymentReferenceNo.val(),
                                "CreatedBy": objSession.UserName
                            };

                            //process issue policy
                            $.ajax({
                                url: webapiUrl + 'Policy/IssueMultiPolicy',
                                method: 'POST',
                                headers: { 'content-Type': 'application/json', 'Authorization': 'Bearer ' + objSession.Token.access_token },// sessionStorage.getItem('accessToken') },
                                contentType: 'application/json; charset=utf-8',
                                dataType: "json",
                                data: JSON.stringify(sendData),
                                success: function (data) {

                                    if (data.status == "200")//save success
                                    {
                                        pubIsFirstIssue = true;/*first click issue policy*/

                                        // ShowSuccess('Certificate Number : [ <strong>' + data.detail.PolicyNumber + '</strong>] is created successfully.');
                                        var displayPolicyIssued = '';
                                        $.each(data.detail, function (i, val) {
                                            displayPolicyIssued += val.ApplicationNumber + ' - ' + val.PolicyNumber + '<br />';
                                        });
                                        ShowSuccess('Policy created successfully.<br /> <strong>' + displayPolicyIssued + '</strong>');
                                        //show issue policy section
                                        HideQuestion(true);
                                        HideIssuePolicy(false);

                                        LoadExistingApplication(pubApplicationNumber);
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
                                    ShowError(err);
                                },/*progressing*/
                                xhr: function () {
                                    var fileXhr = $.ajaxSettings.xhr();
                                    if (fileXhr.upload) {
                                        ShowProgressWithMessage('Issuing policy.');
                                    }
                                    return fileXhr;
                                }
                            });
                        }
                        else {
                            ShowError(err);
                        }
                    }
                    else { /*user does not have access right to issue policy*/
                        ShowError('You don\'t have permission to process issue policy.');
                    }

                }
                else {
                    ShowErrorRedirect('TOKEN WAS EXPIRED', 'RE-LOAD', '../../default.aspx');
                }
            });

            $('#Main_ddlTotalSumAssure').change(function () {

                changedTotalSumAssure();

            });

            $('#Main_ddlBenGender').change(function () {

                FilterBeneficiaryRelation($('#Main_ddlBenGender').val());
            });

            $('#Main_txtTotalSumAssure').on('keypress', function (e) {
                // Allow only digits (ASCII codes 48-57)
                if (e.which < 48 || e.which > 57) {
                    e.preventDefault();
                }
            });


            /*End document.ready*/
        });

        function PopulateRaksmeyPremium() {

            var totalSA = $('#Main_txtTotalSumAssure').val();

            var premium = [];
            pubSumAssurePremium = new Array();
            if (totalSA >= pubProductDetail.SumAssuredMin) {
                if (totalSA <= 25000) {
                    var countApp = Math.ceil(totalSA / 5000);
                    $('#Main_ddlNumberOfApplications').val(countApp);
                    if (totalSA >= 5000) {
                        $('#Main_txtSumAssure').val(5000);
                        var remainSA = (5000 * countApp) - totalSA;
                        if (remainSA > 0) {
                            remainSA = 5000 - remainSA;
                        }
                        if (ValidateCalcPremium(5000)) {

                            for (i = 1; i <= countApp - (remainSA > 0 ? 1 : 0) ; i++) {

                                obj = {
                                    SumAssure: 5000,
                                    Premium: pubBasicPremium,
                                    DiscountAmount: pubBasicDiscount,
                                    TotalAmount: pubBasicAfterDiscount,
                                    AnnaulPremium: pubAnnualPremium
                                };
                                pubSumAssurePremium.push(obj);
                            }
                        }

                        if (remainSA > 0) {
                            if (ValidateCalcPremium(remainSA)) {
                                obj = {
                                    SumAssure: remainSA,
                                    Premium: pubBasicPremium,
                                    DiscountAmount: pubBasicDiscount,
                                    TotalAmount: pubBasicAfterDiscount,
                                    AnnaulPremium: pubAnnualPremium
                                };
                                pubSumAssurePremium.push(obj);
                            }
                        }
                    }
                    else {
                        $('#Main_txtSumAssure').val(totalSA);
                        if (ValidateCalcPremium(totalSA)) {
                            obj = {
                                SumAssure: totalSA,
                                Premium: pubBasicPremium,
                                DiscountAmount: pubBasicDiscount,
                                TotalAmount: pubBasicAfterDiscount,
                                AnnaulPremium: pubAnnualPremium
                            };
                            pubSumAssurePremium.push(obj);
                        }

                    }

                    /*Populate data*/
                    var objAnnPrem = $('#Main_txtAnnualPremium');
                    var objPrem = $('#Main_txtPremium');
                    var objPremAfterDis = $('#Main_txtPremiumAfterDiscount');
                    var objRiderPrem = $('#Main_txtRiderPremium');
                    var objRiderAfterDis = $('#Main_txtRiderPremiumAfterDiscount');
                    var objBasicDiscount = $('#Main_txtDiscountAmount');
                    var objRiderDiscount = $('#Main_txtRiderDiscountAmount');
                    var objTotalAmount = $('#Main_txtTotalAmount');
                    var objTotalDis = $('#Main_txtTotalDiscountAmount');
                    var objTotalAfterDis = $('#Main_txtTotalAmountAfterDiscount');

                    if (remainSA > 0) {
                        var obj = pubSumAssurePremium[0];
                        objPrem.val(obj.Premium);
                        objPremAfterDis.val(obj.TotalAmount);
                        objBasicDiscount.val(obj.DiscountAmount);
                        objTotalDis.val(obj.DiscountAmount + pubRiderDiscount);
                        objTotalAmount.val(obj.TotalAmount);
                        objTotalAfterDis.val(obj.Premium - pubBasicDiscount);

                        pubBasicPremium = obj.Premium;
                        pubBasicDiscount = obj.DiscountAmount;
                        pubBasicSA = obj.SumAssure;
                        pubBasicAfterDiscount = obj.Premium - pubBasicDiscount

                    }

                    /*calculate rider premium*/
                    if ($('#Main_ddlRiderSA').find('option:selected').val() != '') {
                        ValidateCalcRiderPremium();
                    }

                }
                else {

                    ShowError('Maximum Total Sum Assure must be equal to [2,5000]');
                    $('#Main_txtTotalSumAssure').val(0);
                }

            } else {
                ShowError('Minimum Total Sum Assure must be equal to [' + pubProductDetail.SumAssuredMin + ']');
                $('#Main_txtTotalSumAssure').val(0);
            }
        }

        function changedTotalSumAssure() {
            var objTotalSumAssure = $('#Main_ddlTotalSumAssure');

            $('#Main_ddlNumberOfApplications').val(objTotalSumAssure.val());
        }
        function changedPackage() {
            var proId = $('#Main_ddlPackage').val();
            var riderSA = $('#Main_ddlRiderSA');
            var objRiderPro = $('#Main_txtRiderProduct');

            var objReferralId = $('#Main_txtReferrerId');
            var objReferralIdLabel = $('#Main_lblReferrerId');
            var obj

            pubProductId = proId;
            if (proId != '') {
                if (Date.parse(new Date()) < Date.parse(objSession.Token.expire_at)) {
                    if (GetProductDetail(proId) == false) {
                        ShowError('Ooop! Get product detail error.');
                    }
                    else {
                        if (pubProductDetail.AllowRefer == true) {
                            objReferralIdLabel.show();
                            objReferralId.val('');
                            objReferralId.show();
                        }
                        else {
                            objReferralIdLabel.hide();
                            objReferralId.val('');
                            objReferralId.hide();
                        }


                        if (pubCustAge < pubProductDetail.AgeMin || pubCustAge > pubProductDetail.AgeMax) {
                            ShowError('* Age must be [' + pubProductDetail.AgeMin + ' To ' + pubProductDetail.AgeMax + '].');
                        }
                        else {
                            ValidateCalcPremium();
                            //store rider product id
                            pubRiderProductId = pubProductDetail.RiderProductID;
                            objRiderPro.val(pubRiderProductId);
                            if (pubRiderProductId == '') {
                                riderSA.prop('disabled', 'disabled');
                                riderSA.find('option').remove();
                                pubRiderAfterDiscount = 0;
                                pubRiderAnnualPremium = 0;
                                pubRiderDiscount = 0;
                                pubRiderPremium = 0;

                                /*hide all rider fields*/
                                $('.rider-field').css('display', 'none');
                                $('#rider-header').css('display', 'none');

                            }
                            else {
                                $('.rider-field').css('display', 'block');
                                $('#rider-header').css('display', 'block');

                                riderSA.removeProp('disabled');
                                var option = '';
                                option = '<option value="">---Select---</option>';
                                var sa = pubProductDetail.RiderSumAssuredRange;
                                for (i = 0; i < sa.length; i++) {
                                    option += '<option value="' + sa[i] + '">' + sa[i] + '</option>';
                                }
                                riderSA.find('option').remove();
                                riderSA.append(option);

                                /*auto select rider sa while loading exsting application information*/
                                riderSA.val(pubRiderSA);

                            }

                            if (pubProductDetail.ProductType == 'MICRO_LOAN') {

                                /*get policy holder from  channel information*/
                                var objChannel = objSession.Agent.ChannelItems[0];
                                $('#Main_txtPolicyholderName').val(objChannel.Channel_Name);
                                $('#Main_txtPolicyHolderAddress').val(objChannel.Channel_HQ_Address_KH);// val(objChannel.Channel_HQ_Address);

                                /*DISABLE POLICY HOLDER FIELDS*/
                                $('#Main_txtPolicyholderName').prop('disabled', 'disabled');
                                $('#Main_txtPolicyHolderAddress').prop('disabled', 'disabled');
                                $('#Main_ddlPolicyholderIDType').prop('disabled', 'disabled');
                                $('#Main_txtPolicyholderIDNo').prop('disabled', 'disabled');

                                $('#Main_ddlPolicyholderGender').prop('disabled', 'disabled');
                                $('#Main_txtPolicyholderDOB').prop('disabled', 'disabled');

                                /*Policyholder information*/
                                var holderName = $('#Main_txtPolicyholderName').val();
                                var holderGender = $('#Main_ddlPolicyholderGender').find('option:selected').val();
                                var holderDob = $('#Main_txtPolicyholderDOB').val();
                                var holderSelectedIdType = $('#Main_ddlPolicyholderIDType').find('option:selected').val();
                                var holderIdType = holderSelectedIdType == '' ? -1 : holderSelectedIdType;
                                var holderIDNo = $('#Main_txtPolicyholderIDNo').val().trim();
                                var holderAddress = $('#Main_txtPolicyHolderAddress').val();
                                /*show policy holder information*/
                                $('#dvPolicyHolder').css('display', 'block');

                                /*beneficiary, auto set 100% */
                                //$('#Main_txtBenPercentage').prop('disabled', 'disabled');
                                //$('#Main_txtBenPercentage').val('100');

                                $('#dvCoverPeriodTextBox').css('display', '');
                                $('#dvPayPeriodTextBox').css('display', '');
                                $('#Main_ddlTotalSumAssure').css('display', '');
                                $('#divSumAssureDropdown').css('display', '');

                                $('#divSumAssureTextBox').css('display', 'none');
                                $('#Main_txtTotalSumAssure').css('display', 'none');
                                $('#Main_ddlCoverPeriod').css('display', 'none');
                                $('#Main_ddlPaymentPeriod').css('display', 'none');

                                /*number of years*/
                                $('#Main_ddlNumberOfPurchasingYear').removeProp('disabled');
                            }
                            else {
                                $('#Main_ddlRiderSA option[value="5"]').remove();/*Product Raksmey, remove from dropdown as business requirement needed*/
                                /*clear policy holder*/
                                $('#Main_txtPolicyholderName').val('')
                                $('#Main_txtPolicyHolderAddress').val('');
                                $('#Main_ddlPolicyholderIDType').val('');
                                $('#Main_txtPolicyholderIDNo').val('');
                                $('#Main_ddlPolicyholderGender').val('');
                                $('#Main_txtPolicyholderDOB').val('');
                                /*hide policy holder information*/
                                $('#dvPolicyHolder').css('display', 'none');

                                /*beneficiary, allow user input */
                                $('#Main_txtBenPercentage').removeProp('disabled');
                                $('#Main_txtBenPercentage').val('');

                                $('#dvCoverPeriodTextBox').css('display', 'none');
                                $('#dvPayPeriodTextBox').css('display', 'none');
                                $('#Main_ddlTotalSumAssure').css('display', 'none');
                                $('#divSumAssureDropdown').css('display', 'none');

                                $('#divSumAssureTextBox').css('display', '');
                                $('#Main_txtTotalSumAssure').css('display', '');
                                $('#Main_ddlCoverPeriod').css('display', '');
                                $('#Main_ddlPaymentPeriod').css('display', '');

                                /*number of years*/
                                if (!pubIsExisting) { /*first load*/
                                    $('#Main_ddlNumberOfPurchasingYear').prop('disabled', 'disabled');
                                    $('#Main_ddlNumberOfPurchasingYear').val('1');
                                }
                            }
                        }
                    }
                }
                else {
                    ShowErrorRedirect('TOKEN WAS EXPIRED', 'RE-LOAD', '../../default.aspx');
                }
            }
        }

        function ShowClientTypeRemarks(t) {
            var objLclientRemarks = $('#Main_lblClientTypeRemarks');
            var objTclientRemarks = $('#Main_txtClientTypeRemarks');
            var objLclientRelation = $('#Main_lblClientTypeRelation');
            var objDclientRelation = $('#Main_ddlClientTypeRelation');
            if (t) {
                objLclientRemarks.show();
                objLclientRelation.show();
                objTclientRemarks.show();
                objDclientRelation.show();
            }
            else {
                objTclientRemarks.val('');
                objLclientRemarks.hide();
                objLclientRelation.hide();
                objTclientRemarks.hide();
                objDclientRelation.hide();
            }
        }

        function ValidateGetAge() {
            var dob = $('#Main_txtDob').val();
            var appDate = $('#Main_txtApplicationDate').val();
            var objAge = $('#Main_txtAge');
            var result = false;
            if (dob != '' && appDate != '') {

                var age = GetAge(dob, appDate);

                result = true;
            } else { result = false; }

            objAge.val(age);
            return result;
        }


        var apiTokenUrl = '';
        var webapiUrl = '';
        function LoadIdType() {
            var objIdType = $('#Main_ddlIdType');
            var objPolicyholderIdType = $('#Main_ddlPolicyholderIDType');
            var objBenIdType = $('#Main_ddlBenIdType');
            try {
                $.ajax({
                    url: webapiUrl + 'Master/GetMasterList?masterCode=ID_TYPE',
                    method: 'GET',
                    headers: { 'content-Type': 'application/json', 'Authorization': 'Bearer ' + objSession.Token.access_token },

                    contentType: 'application/json; charset=utf-8',
                    dataType: "json",
                    success: function (data) {
                        var option = '';
                        option = '<option value="-1">---Select---</option>';
                        $.each(data.detail, function (index, val) {
                            //bind to drop downlist
                            option += '<option value="' + val.Code + '">' + val.DescKh + '</option>';
                        });
                        objIdType.find('option').remove();
                        objIdType.append(option);
                        objPolicyholderIdType.find('option').remove();
                        objPolicyholderIdType.append(option);
                        objBenIdType.find('option').remove();
                        objBenIdType.append(option);
                    },
                    async: false,
                    error: function (err) {
                        return false;
                    }
                });
            }
            catch (e) {
                ShowError(e);
            }
        }
        function LoadGender() {
            var objGender = $('#Main_ddlGender');
            var objPolicyholderGender = $('#Main_ddlPolicyholderGender');
            var objBenGender = $('#Main_ddlBenGender');
            $.ajax({
                url: webapiUrl + 'Master/GetMasterList?masterCode=GENDER',
                method: 'GET',
                headers: { 'content-Type': 'application/json', 'Authorization': 'Bearer ' + objSession.Token.access_token },

                contentType: 'application/json; charset=utf-8',
                dataType: "json",
                success: function (data) {
                    var option = '';
                    option = '<option value="-1">---Select---</option>';
                    $.each(data.detail, function (index, val) {
                        //bind to drop downlist
                        option += '<option value="' + val.Code + '">' + val.DescKh + '</option>';
                    });
                    objGender.find('option').remove();
                    objGender.append(option);
                    objPolicyholderGender.find('option').remove();
                    objPolicyholderGender.append(option);
                    objBenGender.find('option').remove();
                    objBenGender.append(option);
                },
                async: false,
                error: function (err) {
                    return false;
                }
            });


        }
        function LoadMaritalStatus() {
            var objMarital = $('#Main_ddlMaritalStatus');
            $.ajax({
                url: webapiUrl + 'Master/GetMasterList?masterCode=MARITAL_STATUS',
                method: 'GET',
                headers: { 'content-Type': 'application/json', 'Authorization': 'Bearer ' + objSession.Token.access_token },

                contentType: 'application/json; charset=utf-8',
                dataType: "json",
                success: function (data) {
                    var option = '';
                    option = '<option value="">---Select---</option>';
                    $.each(data.detail, function (index, val) {
                        //bind to drop downlist
                        option += '<option value="' + val.Code + '">' + val.DescKh + '</option>';
                    });
                    objMarital.find('option').remove();
                    objMarital.append(option);
                },
                async: false,
                error: function (err) {
                    return false;
                }
            });
        }

        function LoadClientType() {
            var objClientType = $('#Main_ddlClientType');
            $.ajax({
                url: webapiUrl + 'Master/GetMasterList?masterCode=CLIENT_TYPE',
                method: 'GET',
                headers: { 'content-Type': 'application/json', 'Authorization': 'Bearer ' + objSession.Token.access_token },

                contentType: 'application/json; charset=utf-8',
                dataType: "json",
                success: function (data) {
                    var option = '';
                    //option = '<option value="">---Select---</option>';
                    $.each(data.detail, function (index, val) {
                        //bind to drop downlist
                        option += '<option value="' + val.Code + '">' + val.DescEn + '</option>';
                    });
                    objClientType.find('option').remove();
                    objClientType.append(option);
                },
                async: false,
                error: function (err) {
                    return false;
                }
            });
        }

        function LoadNationality() {
            var objNationality = $('#Main_ddlNationality');
            $.ajax({
                url: webapiUrl + 'Master/GetMasterList?masterCode=NATIONALITY',
                method: 'GET',
                headers: { 'content-Type': 'application/json', 'Authorization': 'Bearer ' + objSession.Token.access_token },

                contentType: 'application/json; charset=utf-8',
                dataType: "json",
                success: function (data) {
                    var option = '';
                    option = '<option value="">---Select---</option>';
                    $.each(data.detail, function (index, val) {
                        //bind to drop downlist
                        option += '<option value="' + val.DescKh + '">' + val.DescKh + '</option>';
                    });
                    objNationality.find('option').remove();
                    objNationality.append(option);
                },
                async: false,
                error: function (err) {
                    return false;
                }
            });
        }
        function LoadOccupation() {
            var objOccu = $('#Main_ddlOccupation');
            $.ajax({
                url: webapiUrl + 'Master/GetOccupationList',
                method: 'GET',
                headers: { 'content-Type': 'application/json', 'Authorization': 'Bearer ' + objSession.Token.access_token },

                contentType: 'application/json; charset=utf-8',
                dataType: "json",
                success: function (data) {
                    var option = '';
                    option = '<option value="">---Select---</option>';
                    $.each(data.detail, function (index, val) {
                        //bind to drop downlist
                        option += '<option value="' + val.OccupationKh + '">' + val.OccupationKh + '</option>';
                    });
                    objOccu.find('option').remove();
                    objOccu.append(option);
                },
                async: false,
                error: function (err) {
                    return false;
                }
            });
        }


        function LoadBeneficiaryRelation() {
            var objRelation = $('#Main_ddlRelation');

            $.ajax({
                url: webapiUrl + 'Master/GetBeneficiaryRelationList',
                method: 'GET',
                headers: { 'content-Type': 'application/json', 'Authorization': 'Bearer ' + objSession.Token.access_token },

                contentType: 'application/json; charset=utf-8',
                dataType: "json",
                success: function (data) {
                    objBeneficairyFilter = data.detail;

                    var option = '';
                    option = '<option value="">---Select---</option>';
                    $.each(data.detail, function (index, val) {
                        //bind to drop downlist
                        option += '<option value="' + val.RelationKh + '">' + val.RelationKh + '</option>';
                    });
                    objRelation.find('option').remove();
                    objRelation.append(option);
                },
                error: function (err) {
                    return false;
                }
            });
        }

        function FilterBeneficiaryRelation(gender) {

            var objRelation = $('#Main_ddlRelation');
            if (objBeneficairyFilter != null) {
                var option = '';
                option = '<option value="">---Select---</option>';
                $.each(objBeneficairyFilter, function (index, val) {
                    //bind to drop downlist
                    if (gender != '') {
                        if (val.GenderCode == gender || val.GenderCode == -1) {
                            option += '<option value="' + val.RelationKh + '">' + val.RelationKh + '</option>';
                        }
                    }
                    else {
                        option += '<option value="' + val.RelationKh + '">' + val.RelationKh + '</option>';
                    }

                });
                objRelation.find('option').remove();
                objRelation.append(option);
            }
        }

        function LoadNationality1() {
            var objNation = $('#Main_ddlNationality');
            $.ajax({
                url: webapiUrl + 'Master/GetCountryList',
                method: 'GET',
                headers: { 'content-Type': 'application/json', 'Authorization': 'Bearer ' + objSession.Token.access_token },

                contentType: 'application/json; charset=utf-8',
                dataType: "json",
                success: function (data) {
                    var option = '';
                    option = '<option value="">---Select---</option>';
                    $.each(data.detail, function (index, val) {
                        //bind to drop downlist
                        option += '<option value="' + val.Nationality + '">' + val.Nationality + '</option>';
                    });
                    objNation.find('option').remove();
                    objNation.append(option);
                },
                error: function (err) {
                    return false;
                }
            });
        }

        function LoadProvince() {
            var objProvince = $('#Main_ddlProvince');
            $.ajax({
                url: webapiUrl + 'Master/GetProvinceList',
                method: 'GET',
                headers: { 'content-Type': 'application/json', 'Authorization': 'Bearer ' + objSession.Token.access_token },

                contentType: 'application/json; charset=utf-8',
                dataType: "json",
                success: function (data) {
                    var option = '';
                    objProvince.find('option').remove();
                    option = '<option value="">---Select---</option>';
                    $.each(data.detail, function (index, val) {
                        //bind to drop downlist
                        option += '<option value="' + val.Code + '">' + val.Khmer + '</option>';
                    });

                    objProvince.append(option);
                },
                async: false,
                error: function (err) {
                    return false;
                }
            });
        }

        function LoadDistrict(provCode) {
            var objDist = $('#Main_ddlDistrict');
            $.ajax({
                url: webapiUrl + 'Master/GetDistrictList?provinceCode=' + provCode,
                method: 'GET',
                headers: { 'content-Type': 'application/json', 'Authorization': 'Bearer ' + objSession.Token.access_token },

                contentType: 'application/json; charset=utf-8',
                dataType: "json",
                success: function (data) {
                    var option = '';
                    objDist.find('option').remove();
                    option = '<option value="">---Select---</option>';
                    $.each(data.detail, function (index, val) {
                        //bind to drop downlist
                        option += '<option value="' + val.Code + '">' + val.Khmer + '</option>';
                    });

                    objDist.append(option);
                },
                async: false,
                error: function (err) {
                    return false;
                }
            });
        }

        function LoadCommune(distCode) {
            var objComm = $('#Main_ddlCommune');
            $.ajax({
                url: webapiUrl + 'Master/GetCommuneList?districtCode=' + distCode,
                method: 'GET',
                headers: { 'content-Type': 'application/json', 'Authorization': 'Bearer ' + objSession.Token.access_token },

                contentType: 'application/json; charset=utf-8',
                dataType: "json",
                success: function (data) {
                    var option = '';
                    objComm.find('option').remove();
                    option = '<option value="">---Select---</option>';
                    $.each(data.detail, function (index, val) {
                        //bind to drop downlist
                        option += '<option value="' + val.Code + '">' + val.Khmer + '</option>';
                    });

                    objComm.append(option);
                },
                async: false,
                error: function (err) {
                    return false;
                }
            });
        }

        function LoadVillage(commCode) {
            var objVillage = $('#Main_ddlVillage');
            $.ajax({
                url: webapiUrl + 'Master/GetVillageList?communeCode=' + commCode,
                method: 'GET',
                headers: { 'content-Type': 'application/json', 'Authorization': 'Bearer ' + objSession.Token.access_token },

                contentType: 'application/json; charset=utf-8',
                dataType: "json",
                success: function (data) {
                    var option = '';
                    objVillage.find('option').remove();
                    option = '<option value="">---Select---</option>';
                    $.each(data.detail, function (index, val) {
                        //bind to drop downlist
                        option += '<option value="' + val.Code + '">' + val.Khmer + '</option>';
                    });

                    objVillage.append(option);
                },
                async: false,
                error: function (err) {
                    return false;
                }
            });
        }

        //Get sale agent information

        function GetSaleAgentInfo(objSession) {
            if (objSession.Agent != null) {
                var objAgent = objSession.Agent;
                $('#Main_txtAgentCode').val(objAgent.AgentCode);
                $('#Main_txtAgentName').val(objAgent.AgentNameEn);

                var objddlSageAgent = $('#Main_ddlAgentCode');
                var objSageAgentName = $('#Main_txtAgentName');

                var objddlChannelLocation = $('#Main_ddlChannelLocation');
                //var objChannel

                var option = "";
                if (objSession.RoleAccess[0].RoleName == "ExternalSaleAgent") {

                    option = '<option value="">---Select---</option>';
                    option += '<option value="' + objAgent.AgentCode + '">' + objAgent.AgentCode + ' - ' + objAgent.AgentNameEn + '</option>';
                    //bind to drop downlist
                    objddlSageAgent.find('option').remove();
                    objddlSageAgent.append(option);
                    objddlSageAgent.val(objAgent.AgentCode);
                    objddlSageAgent.prop('disabled', 'disabled');


                }
                //else if (objSession.RoleAccess[0].RoleName == "ExternalLoanAdmin") {
                //    $.ajax({
                //        url: webapiUrl + 'SaleAgent/GetSaleAgentByChannelItemIdBranchCode?channelItemId=' + pubChannelItemId + '&&branchCode=',
                //        method: 'GET',
                //        headers: { 'content-Type': 'application/json', 'Authorization': 'Bearer ' + objSession.Token.access_token },

                //        contentType: 'application/json; charset=utf-8',
                //        dataType: "json",
                //        success: function (data) {
                //            var option = '';
                //            objVillage.find('option').remove();
                //            option = '<option value="">---Select---</option>';
                //            $.each(data.detail, function (index, val) {
                //                //bind to drop downlist
                //                option += '<option value="' + val.Code + '">' + val.Khmer + '</option>';
                //            });

                //            objVillage.append(option);
                //        },
                //        async: false,
                //        error: function (err) {
                //            return false;
                //        }
                //    });
                //}

            }
            else {
                ShowErrorRedirect('User is not found in agent mapping.', 'Close', '../../default.aspx');
            }
        }

        //Get channel information
        function GetChannelInfo() {

            //Get channel item information by user name
            var objChannel = $('#Main_ddlChannelItem');
            $.ajax({
                url: webapiUrl + 'SaleAgent/GetChannelItemByUser?userName=' + $('#<%=hdfUserName.ClientID%>').val(),
                method: 'GET',
                headers: { 'content-Type': 'application/json', 'Authorization': 'Bearer ' + sessionStorage.getItem('accessToken') },

                contentType: 'application/json; charset=utf-8',
                dataType: "json",
                success: function (data) {
                    //  var obj = data.detail[0];
                    option = '<option value="">---Select---</option>';
                    $.each(data.detail, function (index, val) {
                        option += '<option value="' + val.Channel_Item_ID + '">' + val.Channel_Name + '</option>';
                    });
                    //bind to drop downlist
                    objChannel.find('option').remove();
                    objChannel.append(option);

                },
                async: false,
                error: function (err) {
                    // console.log(err.responseText + 'My token:' + sessionStorage.getItem('accessToken'));
                    ShowError('Get channel item informaiton is error.');
                    return false;
                }

            });
        }

        ///get branch code by channel item id
        var pubChannelLocation = [];
        function BindChannelLocation(objSession) {
            if (objSession.Agent != null) {
                var objChannel = $('#Main_ddlChannelItem');
                var objBranchCode = $('#Main_ddlBranchCode');
                var objBranchName = $('#Main_txtBranchName');

                /*var objCh = objSession.Agent.Channels;*/

                var objCh = objSession.Agent.ChannelItems;
                var objChannelLocation = objSession.Agent.Channels;

                pubChannelLocation = new Array();
                try {
                    /*clear channel dropdown*/
                    objChannel.find('option').remove();
                    /*clear channel location dropdown*/
                    objBranchCode.find('option').remove();

                    optionch = '<option value="">---Select---</option>';
                    option = '<option value="">---Select---</option>';
                    $.each(objCh, function (index, val) {
                        /*    option += '<option value="' + val.ChannelLocationId + '">' + val.OfficeCode + '</option>';*/
                        optionch += '<option value="' + val.Channel_Item_ID + '">' + val.Channel_Name + '</option>';
                        /* pubChannelLocation.push({ Channel_Item_ID: val.ChannelItemId, Channel_Location_ID: val.ChannelLocationId, Office_Name: val.OfficeName });*/
                    });

                    $.each(objChannelLocation, function (index, val) {
                        option += '<option value="' + val.ChannelLocationId + '">' + val.OfficeCode + '</option>';
                        /* optionch += '<option value="' + val.Channel_Item_ID + '">' + val.Channel_Name + '</option>';*/
                        pubChannelLocation.push({ Channel_Item_ID: val.ChannelItemId, Channel_Location_ID: val.ChannelLocationId, Office_Name: val.OfficeName });
                    });


                    //bind to drop downlist
                    objBranchCode.append(option);
                    objChannel.append(optionch);

                    if (objCh.length == 1) {
                        var obj = objCh[0];
                        objChannel.val(obj.Channel_Item_ID);

                        //objBranchCode.val(obj.ChannelLocationId);
                        //objBranchName.val(obj.OfficeName);

                        $('#Main_hdfChannelItemId').val(obj.Channel_Item_ID)

                        objChannel.prop('disabled', 'disabled');
                        //objBranchCode.prop('disabled', 'disabled');
                        //objBranchName.prop('disabled', 'disabled');
                        // Trigger the change event manually
                        //  $('#Main_ddlBranchCode').trigger('change');

                    }

                    if (objChannelLocation.length == 1) {
                        var obj = objChannelLocation[0];
                        objBranchCode.val(obj.ChannelLocationId);
                        objBranchName.val(obj.OfficeName);
                        objChannel.prop('disabled', 'disabled');
                        objBranchCode.prop('disabled', 'disabled');
                        objBranchName.prop('disabled', 'disabled');

                        if (objSession.RoleAccess[0].RoleName == "ExternalSaleAgent") {
                            GetProductConfig($('#Main_ddlChannelItem').find('option:selected').val(), $('#Main_ddlAgentCode').find('option:selected').val());
                            if (pubProductConfig.length == 0) {
                                ShowWarning('Sale agent has no access to insurance product.');
                                $('#btnAppNext').prop('disabled', 'disabled');
                            }
                        }
                        else {
                            LoadAgent();
                        }
                    }
                    return true;
                }
                catch (error) {
                    return false;
                }
            }
            else {

                return false;
            }

        }

        function GetBranchCodeList(chId) {
            /*get channel location information by user and channel item id*/
            var objBranchCode = $('#Main_ddlBranchCode');

            $.ajax({
                url: webapiUrl + 'SaleAgent/GetChannelLocationByChannelItemIdAndUser?channelItemId=' + chId + '&userName=' + $('#Main_hdfUserName').val(),
                method: 'GET',
                headers: { 'content-Type': 'application/json', 'Authorization': 'Bearer ' + sessionStorage.getItem('accessToken') },

                contentType: 'application/json; charset=utf-8',
                dataType: "json",
                success: function (data) {
                    if (data.detail != null) {
                        pubChannelLocation = new Array();
                        objBranchCode.find('option').remove();
                        option = '<option value="">---Select---</option>';
                        $.each(data.detail, function (index, val) {
                            option += '<option value="' + val.Channel_Location_ID + '">' + val.Office_Code + '</option>';
                            pubChannelLocation.push({ Channel_Item_ID: val.Channel_Item_ID, Channel_Location_ID: val.Channel_Location_ID, Office_Name: val.Office_Name });
                        });
                        //bind to drop downlist
                        objBranchCode.append(option);
                        return true;

                    }
                    else {
                        ShowError('Channel location information is not found.');
                        return false;
                    }
                },
                async: false,
                error: function (err) {
                    return false;
                }
            });



        }

        /*Get data through webapi*/
        var pubProductConfig;
        function GetProductConfig(chId, agentId) {/*GetProductConfig(chId) {*/
            var chId = {
                ChannelItemId: chId,
                SaleAgentId: agentId
            };

            //Convert javascript object to JSON object
            var DTO = JSON.stringify(chId);
            result = false;
            $.ajax({
                /*url: webapiUrl + 'product/GetProductConfigListByChannelItemForPortal',*/
                url: webapiUrl + 'product/GetProductConfigListByChannelItemSaleAgent',
                method: 'POST',
                headers: { 'content-Type': 'application/json', 'Authorization': 'Bearer ' + objSession.Token.access_token },
                contentType: 'application/json; charset=utf-8',
                data: DTO,
                dataType: "json",
                success: function (data) {
                    pubProductConfig = data.detail;
                    var option = '';
                    var objPackage = $('#Main_ddlPackage');
                    objPackage.find('option').remove();
                    option = '<option value="">---Select---</option>';
                    $.each(data.detail, function (index, val) {
                        //bind to drop downlist
                        option += '<option value="' + val.ProductId + '">' + val.MarketingName + '</option>';
                    });
                    objPackage.append(option);

                    /*set auto selected package*/
                    var countPackage = $('#Main_ddlPackage option').length;
                    if (data.detail.length == 1) {
                        objPackage.prop('disabled', 'disabled');
                        objPackage.val(data.detail[0].ProductId);
                        pubProductId = objPackage.val();
                    }
                    else {
                        objPackage.removeProp('disabled');
                    }

                    result = true;

                },
                async: false,
                error: function (err) {
                    result = false;
                }
            });

            return result;

        }

        function GetAge(dob, compareDate) {
            var para = 'dob=' + dob + '&compareDate=' + compareDate;
            var age = 0;
            if (Date.parse(new Date()) < Date.parse(objSession.Token.expire_at)) {
                $.ajax({
                    url: webapiUrl + 'product/GetAge?' + para,
                    method: 'GET',
                    headers: { 'content-Type': 'application/json', 'Authorization': 'Bearer ' + objSession.Token.access_token },
                    contentType: 'application/json; charset=utf-8',

                    dataType: "json",
                    success: function (data) {

                        age = data.detail;
                    },
                    async: false,
                    error: function (err) {
                        age = 0;
                    }
                });
            }
            else {
                age = 0;
                ShowErrorRedirect('TOKEN WAS EXPIRED', 'RE-LOAD', '../../default.aspx');
            }
            return age;
        }

        function GetPremium(productId, gender, age, sumAssured, payMode) {

            var para = 'productId=' + productId + '&gender=' + gender + '&age=' + age + '&sumAssured=' + sumAssured + '&payMode=' + payMode;
            var premium = [];
            if (Date.parse(new Date()) < Date.parse(objSession.Token.expire_at)) {
                $.ajax({
                    url: webapiUrl + 'product/GetPremium?' + para,
                    method: 'GET',
                    headers: { 'content-Type': 'application/json', 'Authorization': 'Bearer ' + objSession.Token.access_token },
                    contentType: 'application/json; charset=utf-8',

                    dataType: "json",
                    success: function (data) {

                        premium[0] = data.detail.AnnualPremium;
                        premium[1] = data.detail.PremiumByPaymode;
                    },
                    async: false,
                    error: function (err) {
                        var premium = [];
                    }
                });
            }
            else {
                var premium = [];
                ShowErrorRedirect('TOKEN WAS EXPIRED', 'RE-LOAD', '../../default.aspx');
            }
            return premium;
        }

        function GetPremiumRider(productId, gender, age, sumAssured, payMode) {
            var para = 'productId=' + productId + '&gender=' + gender + '&age=' + age + '&sumAssured=' + sumAssured + '&payMode=' + payMode;
            var premium = [];
            if (Date.parse(new Date()) < Date.parse(objSession.Token.expire_at)) {
                $.ajax({
                    url: webapiUrl + 'product/GetPremiumRider?' + para,
                    method: 'GET',
                    headers: { 'content-Type': 'application/json', 'Authorization': 'Bearer ' + objSession.Token.access_token },
                    contentType: 'application/json; charset=utf-8',

                    dataType: "json",
                    success: function (data) {

                        premium[0] = data.detail.AnnualPremium;
                        premium[1] = data.detail.PremiumByPaymode;
                    },
                    async: false,
                    error: function (err) {
                        var premium = [];
                    }
                });
            }
            else {
                var premium = [];
                ShowErrorRedirect('TOKEN WAS EXPIRED', 'RE-LOAD', '../../default.aspx');
            }
            return premium;
        }

        function GetPremiumDiscount(productId, riderProductId, basicSA, riderSA, clientType, appDate) {
            var discount = [];
            if (Date.parse(new Date()) < Date.parse(objSession.Token.expire_at)) {
                $.ajax({
                    url: webapiUrl + 'product/GetPremiumDiscount',
                    method: 'POST',
                    headers: { 'content-Type': 'application/json', 'Authorization': 'Bearer ' + objSession.Token.access_token },
                    contentType: 'application/json; charset=utf-8',
                    data: JSON.stringify({
                        "ProductId": productId,
                        "ProductRiderId": riderProductId,
                        "SumAssured": basicSA,
                        "SumAssuredRider": riderSA,
                        "ApplicationDate": appDate,
                        "ClientType": clientType
                    }),
                    dataType: "json",
                    success: function (data) {

                        discount[0] = data.detail.BasicDiscountAmount;
                        discount[1] = data.detail.RiderDiscountAmount;
                    },
                    async: false,
                    error: function (err) {
                        var discount = []
                    }
                });
            }
            else {
                var discount = [];
                ShowErrorRedirect('TOKEN WAS EXPIRED', 'RE-LOAD', '../../default.aspx');
            }
            return discount;
        }

        function ValidateCalcPremium(optionalSA) {
            var objClientType = $('#Main_ddlClientType').find('option:selected').val();
            var objAppDate = $('#Main_txtApplicationDate').val();
            var objGender = $('#Main_ddlGender').find('option:selected').val();
            var objAge = $('#Main_txtAge').val();
            var objPackage = $('#Main_ddlPackage').find('option:selected').val();
            var objPayMode = $('#Main_ddlPaymentMode').find('option:selected').val();


            var objSumAssured = 0;

            if (pubProductDetail.ProductId == 'RSSP2025001') {

                if (optionalSA === undefined)
                    optionalSA = $('#Main_txtSumAssure').val();
                objSumAssured = optionalSA;//$('#Main_txtSumAssure').val();
            }
            else {
                objSumAssured = $('#Main_ddlSumAssure').find('option:selected').val();
            }
            var objAnnPrem = $('#Main_txtAnnualPremium');
            var objPrem = $('#Main_txtPremium');
            var objPremAfterDis = $('#Main_txtPremiumAfterDiscount');
            var objRiderPrem = $('#Main_txtRiderPremium');
            var objRiderAfterDis = $('#Main_txtRiderPremiumAfterDiscount');
            var objBasicDiscount = $('#Main_txtDiscountAmount');
            var objRiderDiscount = $('#Main_txtRiderDiscountAmount');
            var objTotalAmount = $('#Main_txtTotalAmount');
            var objTotalDis = $('#Main_txtTotalDiscountAmount');
            var objTotalAfterDis = $('#Main_txtTotalAmountAfterDiscount');

            var result = false;
            var prem = [];
            var premAnn = 0;
            var premByMode = 0;
            var premAfterDis = 0;
            var basicDiscount = 0;
            var riderDiscount = 0;
            var totalPrem = 0;
            var totalDis = 0;
            var totalAfterDis = 0;

            if (objAppDate != '' && objGender != '-1' && objPackage != '' && objPayMode != '' && objSumAssured != '0') {

                prem = GetPremium(objPackage, objGender, objAge, objSumAssured, objPayMode);
                if (prem.length > 0) {
                    premAnn = prem[0];
                    premByMode = prem[1];

                    pubAnnualPremium = prem[0];
                    pubBasicPremium = prem[1];
                    result = true;

                    if (pubProductDetail.ProductId == 'RSSP2025001') {
                        var cover = $('#Main_ddlCoverPeriod').find('option:selected').val().split(":");

                        if (cover[0] == 'M' & (["1", "2", "4", "5", "7", "8", "9", "10", "11"].includes(cover[1]))) {

                            pubAnnualPremium *= cover[1];
                            pubBasicPremium *= cover[1];
                            premAnn *= cover[1];
                            premByMode *= cover[1];
                        }

                    }

                    //get discount
                    var discount = [];
                    discount = GetPremiumDiscount(objPackage, '', objSumAssured, 0, objClientType);
                    if (discount.length > 0) {
                        basicDiscount = discount[0];
                        riderDiscount = discount[1];

                        pubBasicDiscount = basicDiscount;
                        pubRiderDiscount = riderDiscount;
                    }
                    premAfterDis = premByMode - basicDiscount;
                    totalPrem = premByMode;
                    totalDis = basicDiscount + riderDiscount;
                    totalAfterDis = totalPrem - totalDis;

                    pubTotalPremium = totalPrem;
                    pubBasicAfterDiscount = premAfterDis;
                    pubTotalDiscount = totalDis;
                    pubTotalPremiumAfterDiscount = totalAfterDis;
                    pubBasicSA = objSumAssured;
                }
                else {
                    result = false;
                }
            }
            else { result = false; }
            objAnnPrem.val(premAnn);
            objPrem.val(premByMode);
            objBasicDiscount.val(basicDiscount);
            objPremAfterDis.val(premAfterDis);
            objRiderDiscount.val(riderDiscount);
            objTotalAmount.val(totalPrem);
            objTotalDis.val(totalDis);
            objTotalAfterDis.val(totalAfterDis);

            /*show in issue policy screen*/
            $('#Main_txtTotalAmountPay').val(totalAfterDis);
            return result;
        }

        function ValidateCalcRiderPremium() {
            var objClientType = $('#Main_ddlClientType').find('option:selected').val();
            var objAppDate = $('#Main_txtApplicationDate').val();
            var objGender = $('#Main_ddlGender').find('option:selected').val();
            var objAge = $('#Main_txtAge').val();

            var objPayMode = $('#Main_ddlPaymentMode').find('option:selected').val();

            /*Basic*/
            var objSumAssured;// = $('#Main_ddlSumAssure').find('option:selected').val();
            if (pubProductDetail.ProductId == 'RSSP2025001') {
                objSumAssured = $('#Main_txtSumAssure').val();
            }
            else {
                objSumAssured = $('#Main_ddlSumAssure').find('option:selected').val();
            }

            var objPackage = $('#Main_ddlPackage').find('option:selected').val();
            var objAnnPrem = $('#Main_txtAnnualPremium');
            var objBasicPrem = $('#Main_txtPremium');
            var objBasicPremAfterDis = $('#Main_txtPremiumAfterDiscount');

            /*Rider*/
            var objRiderPrem = $('#Main_txtRiderPremium');
            var objRiderAfterDis = $('#Main_txtRiderPremiumAfterDiscount');
            var objBasicDiscount = $('#Main_txtDiscountAmount');
            var objRiderDiscount = $('#Main_txtRiderDiscountAmount');
            var objTotalAmount = $('#Main_txtTotalAmount');
            var objTotalDis = $('#Main_txtTotalDiscountAmount');
            var objTotalAfterDis = $('#Main_txtTotalAmountAfterDiscount');

            var objRiderProductId = $('#Main_txtRiderProduct').val();
            var objRiderSA = $('#Main_ddlRiderSA').find('option:selected').val();

            var result = false;
            var prem = [];
            var premAnn = 0;
            var premByMode = 0;
            var premAfterDis = 0;
            var basicDiscount = 0;
            var riderDiscount = 0;
            var totalPrem = 0;
            var totalDis = 0;
            var totalAfterDis = 0;

            pubRiderSA = objRiderSA;

            if (objAppDate != '' && objGender != '-1' && objPackage != '' && objPayMode != '' && objSumAssured != '0') {

                prem = GetPremiumRider(objRiderProductId, objGender, objAge, objRiderSA == '' ? 0 : objRiderSA, objPayMode);
                if (prem.length > 0) {
                    premAnn = prem[0];
                    premByMode = prem[1];

                    pubRiderAnnualPremium = premAnn;
                    pubRiderPremium = premByMode;
                    result = true;

                    //get discount
                    var discount = [];
                    discount = GetPremiumDiscount(objPackage, objRiderProductId, objSumAssured, objRiderSA == '' ? 0 : objRiderSA, objClientType);
                    if (discount.length > 0) {
                        basicDiscount = discount[0];
                        riderDiscount = discount[1];

                        pubBasicDiscount = basicDiscount;
                        pubRiderDiscount = riderDiscount;
                    }
                    premAfterDis = premByMode - pubRiderDiscount;
                    totalPrem = pubBasicPremium + premByMode;
                    totalDis = basicDiscount + riderDiscount;
                    totalAfterDis = totalPrem - totalDis;

                    pubRiderAfterDiscount = premAfterDis;
                    pubTotalPremium = totalPrem;
                    pubBasicAfterDiscount = pubBasicPremium - pubBasicDiscount;
                    pubTotalDiscount = totalDis;
                    pubTotalPremiumAfterDiscount = totalAfterDis;
                    pubBasicSA = objSumAssured;
                }
                else {
                    result = false;
                }
            }
            else { result = false; }

            objRiderPrem.val(premByMode);

            objBasicPremAfterDis.val(pubBasicAfterDiscount);

            objBasicDiscount.val(basicDiscount);
            // objPremAfterDis.val(premAfterDis);
            objRiderDiscount.val(riderDiscount);
            objRiderAfterDis.val(premAfterDis);
            objTotalAmount.val(totalPrem);
            objTotalDis.val(totalDis);
            objTotalAfterDis.val(totalAfterDis);

            /*show in issue policy screen*/
            $('#Main_txtTotalAmountPay').val(totalAfterDis);
            return result;
        }

        var pubProductDetail = null;//to store product detail object
        function GetProductDetail(proId) {
            var result = false;
            var objCoverPeriod = $('#<%=txtCoverPeriod.ClientID%>');
            var objPaymentPeriod = $('#<%=txtPaymentPeriod.ClientID%>');
            var objProductName = $('#<%=txtProductName.ClientID%>');
            var objSumAssure = $('#<%=ddlSumAssure.ClientID%>');
            var objRiderPro = $('#<%=txtRiderProduct.ClientID%>');
            var objRiderSA = $('#<%=ddlRiderSA.ClientID%>');
            var objRiderPremium = $('#Main_txtRiderPremium');
            var objRiderPremiumAfterDiscount = $('#Main_txtRiderPremiumAfterDiscount');


            var objPaymode = $('#Main_ddlPaymentMode');

            $.ajax({
                url: webapiUrl + 'product/GetProductDetail?productId=' + proId,
                method: 'GET',
                headers: { 'content-Type': 'application/json', 'Authorization': 'Bearer ' + objSession.Token.access_token },
                contentType: 'application/json; charset=utf-8',
                dataType: "json",
                success: function (data) {
                    var obj = data.detail;
                    objProductName.val(obj.EnTitle);
                    pubProductDetail = obj;
                    if (obj.RiderProductID != '' && obj.RiderProductID != null) {

                        objRiderPro.val(obj.RiderProductID);
                    }
                    else {
                        objRiderPro.prop('disabled', 'disabled');
                        objRiderSA.prop('disabled', 'disabled');
                        objRiderPremium.val('0');
                        objRiderPremiumAfterDiscount.val('0');
                    }

                    //bind sum assure into drop downlist
                    var option = '';
                    option = '<option value="0">---Select---</option>';
                    var basicSA = obj.BasicSumAssuredRange;
                    for (i = 0; i < basicSA.length; i++) {
                        option += '<option value="' + basicSA[i] + '">' + basicSA[i] + '</option>';
                    }

                    //bind payment mode into drop downlist
                    var optionMode = '';
                    optionMode = '<option value="">---Select---</option>';
                    var mode = obj.PayMode;
                    //for (i = 0; i < mode.length; i++) {
                    //    optionMode += '<option value="' + mode[i] + '">' + mode[i] + '</option>';
                    //}
                    $.each(mode, function (index, val) {
                        optionMode += '<option value="' + val.Id + '">' + val.ModeEn + '</option>';
                    });

                    objPaymentPeriod.val('1');
                    objCoverPeriod.val('1');
                    objSumAssure.find('option').remove();
                    objSumAssure.append(option);
                    objPaymode.find('option').remove();
                    objPaymode.append(optionMode);

                    /*auto select paymode*/
                    if (mode.length == 1) {
                        objPaymode.val(mode[0].Id);
                        objPaymode.prop('disabled', 'disabled');
                        pubPaymentMode = mode[0].Id;
                    }
                    else {
                        objPaymode.val('');
                        pubPaymentMode = pubIsExisting ? pubPaymentMode : '';
                        objPaymode.removeProp('disabled');
                        objPaymode.val(pubPaymentMode);
                    }

                    if (pubProductDetail.ProductId == 'RSSP2025001') {
                        if (!pubIsExisting) {
                            $('#Main_txtSumAssure').val(pubProductDetail.SumAssuredMin);
                            $('#Main_ddlPaymentMode').prop('selectedIndex', 3);
                            pubPaymentMode = 3;/*quarterly*/
                            $('#Main_ddlPaymentMode').prop('disabled', 'disabled');
                        }
                    }
                    else {
                        if (basicSA.length == 1) {
                            objSumAssure.val(basicSA[0]);
                            objSumAssure.prop('disabled', 'disabled');
                        }
                        else {
                            objSumAssure.removeProp('disabled');
                            objSumAssure.val(pubBasicSA);
                        }
                    }



                    result = true;
                    // console.log(option);
                },
                async: false,
                error: function (err) {
                    result = false;
                }
            });
            return result;
        }

        function GetClientTypeRelation() {
            var result = false;
            var objRelation = $('#Main_ddlClientTypeRelation');

            $.ajax({
                url: webapiUrl + 'Master/GetMasterRelation?masterCode=CLIENT_TYPE_RELATION',
                method: 'GET',
                headers: { 'content-Type': 'application/json', 'Authorization': 'Bearer ' + objSession.Token.access_token },
                contentType: 'application/json; charset=utf-8',
                dataType: "json",
                success: function (data) {

                    var obj = data.detail;
                    var option = '';
                    option = '<option value="">---Select---</option>';
                    $.each(obj, function (index, val) {
                        option += '<option value="' + val.RelationKh + '">' + val.RelationKh + '</option>';
                    });
                    objRelation.find('option').remove();
                    objRelation.append(option);
                    result = true;

                },
                async: false,
                error: function (err) {
                    result = false;
                }
                ,
                /* show progressing */
                xhr: function () {
                    var fileXhr = $.ajaxSettings.xhr();
                    if (fileXhr.upload) {
                        ShowProgress('Getting client relation.');
                    }
                    return fileXhr;
                }
            });

            return result;
        }

        function HideAppInfo(t) {
            if (t) {
                $('#dvApplicationInfo').hide();
            }
            else {
                $('#dvApplicationInfo').show();
            }
        }
        function HideInsurance(t) {
            if (t) {
                $('#dvInsurance').hide();
            }
            else {
                $('#dvInsurance').show();
            }
        }

        function HideCust(t) {
            if (t) {
                $('#dvCustomerInfo').hide();
            }
            else {
                $('#dvCustomerInfo').show();
            }
        }

        function HideBen(t) {
            if (t) {
                $('#dvBeneficiary').hide();
            }
            else {
                $('#dvBeneficiary').show();
            }
        }

        function HideQuestion(t) {
            if (t) {
                $('#dvQuestion').hide();
            }
            else {
                $('#dvQuestion').show();
            }
        }

        function HideIssuePolicy(t) {
            if (t) {
                $('#dvIssuePolicy').hide();
            }
            else {
                $('#dvIssuePolicy').show();
            }
        }
        function DisableApplicationInfo(t) {
            if (t) {
                $('#Main_ddlClientType').prop('disabled', 'disabled');
                $('#Main_txtReferrerId').prop('disabled', 'disabled');
                $('#Main_ddlChannelItem').prop('disabled', 'disabled');
                $('#Main_ddlBranchCode').prop('disabled', 'disabled');

                $('#btnAppNext').prop('disabled', 'disabled');
            }
            else {

                $('#btnAppNext').removeProp('disabled');
                $('#Main_ddlClientType').removeProp('disabled');
                $('#Main_txtReferrerId').removeProp('disabled');
                $('#Main_ddlChannelItem').removeProp('disabled');
                $('#Main_ddlBranchCode').removeProp('disabled');
            }
        }

        function AppNext() {
            HideCust(false);
            HideAppInfo(true);
        }
        function JumpToPolicy() {
            HideAppInfo(true);
            HideIssuePolicy(false);
        }

        function CustNext() {

            HideInsurance(false);
            HideCust(true);
        }

        function CustBack() {
            HideCust(true);
            HideAppInfo(false);
        }

        function InsuranceBack() {
            HideInsurance(true);
            HideCust(false);
        }
        function InsuranceNext() {
            HideInsurance(true);
            HideBen(false);
            //load benefication relation
            //LoadBeneficiaryRelation();

        }

        function BenBack() {
            HideBen(true);
            HideInsurance(false);
        }
        function BenNext() {
            HideBen(true);
            HideQuestion(false);
        }

        function QuestionBack() {
            HideQuestion(true);
            HideBen(false);
        }
        function QuestionNext() {
            LoadExistingApplication(pubApplicationNumber);
            HideQuestion(true);
            HideIssuePolicy(false);
        }

        function IssueBack() {
            HideIssuePolicy(true);
            HideQuestion(false);
        }

        function Initial() {
            /*Application information*/
            ShowClientTypeRemarks(false);
            $('#<%=txtApplicationNumber.ClientID%>').prop('disabled', 'disabled');
            $('#<%=txtCertificateNumber.ClientID%>').prop('disabled', 'disabled');
            $('#<%=txtPolicyStatus.ClientID%>').prop('disabled', 'disabled');
                <%--  $('#<%=txtAgentCode.ClientID%>').prop('disabled', 'disabled');--%>
            $('#<%=txtAgentName.ClientID%>').prop('disabled', 'disabled');

            $('#<%=txtBranchName.ClientID%>').prop('disabled', 'disabled');

            /*customer information*/
            $('#<%=txtAge.ClientID%>').prop('disabled', 'disabled');

            /*Insurance product and detail*/


            $('#<%=txtProductName.ClientID%>').prop('disabled', 'disabled');
            $('#<%=txtCoverPeriod.ClientID%>').prop('disabled', 'disabled');
            $('#<%=txtPaymentPeriod.ClientID%>').prop('disabled', 'disabled');
            $('#<%=txtAnnualPremium.ClientID%>').prop('disabled', 'disabled');
            $('#<%=txtPremium.ClientID%>').prop('disabled', 'disabled');
            $('#<%=txtDiscountAmount.ClientID%>').prop('disabled', 'disabled');
            $('#<%=txtPremiumAfterDiscount.ClientID%>').prop('disabled', 'disabled');
            $('#<%=txtRiderProduct.ClientID%>').prop('disabled', 'disabled');
            $('#<%=txtRiderPremium.ClientID%>').prop('disabled', 'disabled');
            $('#<%=txtRiderDiscountAmount.ClientID%>').prop('disabled', 'disabled');
            $('#<%=txtRiderPremiumAfterDiscount.ClientID%>').prop('disabled', 'disabled');
            $('#<%=txtTotalAmount.ClientID%>').prop('disabled', 'disabled');
            $('#<%=txtTotalDiscountAmount.ClientID%>').prop('disabled', 'disabled');
            $('#<%=txtTotalAmountAfterDiscount.ClientID%>').prop('disabled', 'disabled');

            $('#dvAnnualPremium').css('display', 'none');

            $('#Main_ddlCoverPeriod').css('display', 'none');
            $('#Main_ddlPaymentPeriod').css('display', 'none');

            $('#Main_ddlPaymentPeriod').prop('disabled', 'disabled');

            $('#Main_txtSumAssure').prop('disabled', 'disabled');

            $('#divSumAssureTextBox').css('display', 'none');
            $('#Main_txtTotalSumAssure').css('display', 'none');

            $('#lblGroupDiscountAmount').css('display', 'none');
            $('#lblGroupPremiumAfterDiscount').css('display', 'none');
            $('#lblGroupRiderDiscountAmount').css('display', 'none');
            $('#lblGroupRiderPremiumAfterDiscount').css('display', 'none');

            $('#lblGroupTotalDiscountAmount').css('display', 'none');
            $('#lblGroupTotalAmountAfterDiscount').css('display', 'none');



            $('#Main_ddlNumberOfApplications').prop('disabled', 'disabled');
            //$('#Main_ddlNumberOfPurchasingYear').val('1');
            //$('#Main_ddlNumberOfPurchasingYear').prop('disabled', 'disabled');

            $('#Main_txtReferrerId').hide();
            $('#Main_lblReferrerId').hide();

            /*Beneficiary*/
            //$('#Main_txtSharedPercentage').prop('disabled', 'disabled');
            //$('#Main_txtSharedPercentage').val('100');

            /*Issue policy*/

            // $('#Main_txtIssueDate').prop('disabled', 'disabled');

            $('#Main_txtCollectedPremium').prop('disabled', 'disabled');

            $('#btnJumpTopolicy').hide();
            $('#bQuestionNext').hide();

            /*hide policy holder information*/
            $('#dvPolicyHolder').css('display', 'none');
        }



        var pubTotalPercentage = 0;
        function AddBeneficiary() {
            var objBenName = $('#Main_txtBenName');
            var objBenAge = $('#Main_txtBenAge');
            var objBenRelation = $('#Main_ddlRelation');
            var objBenPercentage = $('#Main_txtBenPercentage');

            var objBenDOB = $('#Main_txtBenDOB');
            var objBenGender = $('#Main_ddlBenGender');
            var objBenIdType = $('#Main_ddlBenIdType');
            var objBenIdNo = $('#Main_txtBenIdNo');

            var err = '';
            var sumPercentage = pubTotalPercentage;

            /*row index*/
            var benList = $('#tblBenList tbody tr');
            var rowIndex = benList.length;


            sumPercentage += parseFloat(objBenPercentage.val());


            if (pubProductDetail.ProductType == 'MICRO_LOAN') {
                if (objBenName.val() == '') {
                    err += '* Full name is required. </br>';
                }
                else {
                    //if (objBenDOB.val() == '') {
                    //    err += '* DOB is required [DD/MM/YYYY]. </br>';
                    //}
                    if (objBenGender.val() == -1) {
                        err += '* Gender is required. </br>';
                    }
                    //if (objBenIdType.val() == '') {
                    //    err += '* ID Type is required. </br>';
                    //}
                    //if (objBenIdNo.val() == '') {
                    //    err += '* ID No. is required. </br>';
                    //}
                    if (objBenRelation.find('option:selected').val() == '') {
                        err += '* Relation is required.</br>';
                    }
                    if (objBenPercentage.val() == '') {
                        err += '* Percentage of sharing is required.</br>';
                    }
                    if (sumPercentage > 100) {
                        err += '* Total Percentage of sharing must be equal to 100%.</br>';
                    }
                }
            }
            else {
                if (objBenName.val() == '') {
                    err += '* Full name is required. </br>';
                }
                //if (objBenDOB.val() == '') {
                //    err += '* DOB is required [DD/MM/YYYY]. </br>';
                //}
                if (objBenGender.val() == -1) {
                    err += '* Gender is required. </br>';
                }
                //if (objBenIdType.val() == '') {
                //    err += '* ID Type is required. </br>';
                //}
                //if (objBenIdNo.val() == '') {
                //    err += '* ID No. is required. </br>';
                //}
                if (objBenRelation.find('option:selected').val() == '') {
                    err += '* Relation is required.</br>';
                }
                if (objBenPercentage.val() == '') {
                    err += '* Percentage of sharing is required.</br>';
                }
                if (sumPercentage > 100) {
                    err += '* Total Percentage of sharing must be equal to 100%.</br>';
                }
            }

            if (err == '') {

                var genderText = '';
                var genderCode = '';
                var idTypeCode = '';
                var idTypeText = '';

                var selectedGenderVal = objBenGender.find('option:selected').val();
                var selectedGenderText = objBenGender.find('option:selected').text();
                var selectedIdTypeVal = objBenIdType.find('option:selected').val();
                var selectedIdTypeText = objBenIdType.find('option:selected').text();

                if (selectedGenderVal == '' || selectedGenderVal == '-1') {
                    genderText = '';
                    genderCode = '-1';
                }
                else {
                    genderText = selectedGenderText;
                    genderCode = selectedGenderVal;

                }
                if (selectedIdTypeVal == '' || selectedIdTypeVal == '-1') {
                    idTypeCode = '-1';
                    idTypeText = '';
                }
                else {
                    idTypeCode = selectedIdTypeVal;
                    idTypeText = selectedIdTypeText;
                }

                if (pubBenRowEdited == -1) {
                    //add new row

                    var row = '<tr  id="benRow' + rowIndex + '">';
                    row += '<td class="hidden">' + rowIndex + '</td>';
                    row += '<td> <label id="benName' + rowIndex + '">' + objBenName.val() + '</label></td>';
                    //row += '<td> <label class="hidden" id="benGender' + rowIndex + '">' + objBenGender.find('option:selected').val() + '</label><label id="benGenderText' + rowIndex + '">' + objBenGender.find('option:selected').text() + '</label></td>';
                    row += '<td> <label class="hidden" id="benGender' + rowIndex + '">' + genderCode + '</label><label id="benGenderText' + rowIndex + '">' + genderText + '</label></td>';
                    row += '<td> <label id="benDOB' + rowIndex + '">' + objBenDOB.val() + '</label></td>';
                    row += '<td> <label  class="hidden" id="benIdType' + rowIndex + '">' + idTypeCode + '</label><label id="benIdTypeText' + rowIndex + '">' + idTypeText + '</label></td>';
                    row += '<td> <label id="benIdNo' + rowIndex + '">' + objBenIdNo.val() + '</label></td>';
                    row += '<td><label id="benAge' + rowIndex + '">' + objBenAge.val() + '</label></td>';
                    row += '<td><label id="benRelation' + rowIndex + '">' + objBenRelation.find('option:selected').val() + '</label></td>';
                    row += '<td class="row-center"><label id="benPercentage' + rowIndex + '">' + objBenPercentage.val() + '</label></td>';
                    row += '<td class="row-center"><button type="button" onclick="EditBenefitRow(' + rowIndex + ',\'' + objBenName.val() + '\', \'' + objBenGender.val() + '\', \'' + objBenDOB.val() + '\', \'' + objBenIdType.val() + '\', \'' + objBenIdNo.val() + '\', \'' + objBenAge.val() + '\', \'' + objBenRelation.val() + '\', \'' + objBenPercentage.val() + '\');"><span class ="glyphicon glyphicon-edit"></span></button>';
                    row += '<button type="button" onclick="DeleteBenefitRow(' + rowIndex + ');"><span class ="glyphicon glyphicon-remove camlife-color-red"></span></button></td>'
                    row += '</tr>';
                    $('#tblBenList').append(row);

                }
                else {
                    //update row
                    var curRow = $('#benRow' + pubBenRowEdited);
                    var objNewGenderText = 'benGenderText' + pubBenRowEdited;
                    var objNewGender = 'benGender' + pubBenRowEdited;
                    var objNewIdTypeText = 'benIdTypeText' + pubBenRowEdited;
                    var objNewIdType = 'benIdType' + pubBenRowEdited;
                    curRow.find('td:eq(1)').text(objBenName.val());/*Name*/
                    //curRow.find('td:eq(2)').text(objBenGender.val()); /*Gender*/
                    curRow.find('td:eq(2) label[id^="' + objNewGender + '"]').text(genderCode); /*Gender*/
                    curRow.find('td:eq(2) label[id^="' + objNewGenderText + '"]').text(genderText); /*Gender*/
                    curRow.find('td:eq(3)').text(objBenDOB.val()); /*DOB*/
                    //curRow.find('td:eq(4)').text(objBenIdType.val());  /*ID Type*/
                    curRow.find('td:eq(4) label[id^="' + objNewIdType + '"]').text(idTypeCode); /*Id Type code*/
                    curRow.find('td:eq(4) label[id^="' + objNewIdTypeText + '"]').text(idTypeText); /*Id type text*/
                    curRow.find('td:eq(5)').text(objBenIdNo.val()); /*ID No*/
                    curRow.find('td:eq(6)').text(objBenAge.val());/*Age*/
                    curRow.find('td:eq(7)').text(objBenRelation.val());/*relation*/
                    curRow.find('td:eq(8)').text(objBenPercentage.val());/*percentage*/
                    curRow.find('td:eq(9)').html('<button type="button" onclick="EditBenefitRow(' + pubBenRowEdited + ',\'' + objBenName.val() + '\', \'' + objBenGender.val() + '\', \'' + objBenDOB.val() + '\', \'' + objBenIdType.val() + '\', \'' + objBenIdNo.val() + '\', \'' + objBenAge.val() + '\', \'' + objBenRelation.val() + '\', \'' + objBenPercentage.val() + '\');"><span class ="glyphicon glyphicon-edit"></span></button><button type="button" onclick="DeleteBenefitRow(' + pubBenRowEdited + ');"><span class ="glyphicon glyphicon-remove camlife-color-red"></span></button>');
                    //reset edited row
                    pubBenRowEdited = -1;
                }
                pubTotalPercentage = sumPercentage;
                //clear
                objBenName.val('');
                objBenAge.val('');
                objBenRelation.val('');
                objBenPercentage.val('');
                objBenGender.val('');
                objBenDOB.val('');
                objBenIdType.val('');

            }
            return err;

        }

        //delete beneficairy
        pubBenToDelete = new Array();
        function DeleteBenefitRow(rowIndex) {
            var removePercentage = $('#benPercentage' + rowIndex).text();
            pubTotalPercentage -= removePercentage;

            var benId = $('#benRow' + rowIndex).find('td:eq(0)').text();
            /*save exist ben for delete*/
            if (benId.length > 2) {
                var benDelete = { Id: benId };
                pubBenToDelete.push(benDelete);
            }


            $('#benRow' + rowIndex).remove()
        }

        var pubBenRowEdited = -1;
        function EditBenefitRow(rowIndex, benName, benGender, benDOB, benIdType, benIdNo, benAge, benReation, benPercent) {
            pubTotalPercentage -= parseFloat(benPercent);
            var removePercentage = $('#benPercentage' + rowIndex).text();
            var objBenName = $('#Main_txtBenName');
            var objBenAge = $('#Main_txtBenAge');
            var objBenRelation = $('#Main_ddlRelation');
            var objBenPercent = $('#Main_txtBenPercentage');

            var objBenGender = $('#Main_ddlBenGender');
            var objBenDOB = $('#Main_txtBenDOB');
            var objBenIdType = $('#Main_ddlBenIdType');
            var objBenIdNo = $('#Main_txtBenIdNo');

            objBenName.val(benName);
            objBenAge.val(benAge);
            objBenRelation.val(benReation);
            objBenPercent.val(benPercent);
            objBenGender.val(benGender);
            objBenDOB.val(benDOB);
            objBenIdType.val(benIdType);
            objBenIdNo.val(benIdNo);

            pubBenRowEdited = rowIndex;

        }

        function ShowProgress() {
            $('#myModal').modal('show');
        }
        function HideProgress() {
            $('#myModal').modal('hide');
        }

        function LoadExistingApplication(appNo) {
            $.ajax({
                url: webapiUrl + 'Application/GetApplicationDetail?applicationNumber=' + appNo,
                method: 'GET',
                headers: { 'content-Type': 'application/json', 'Authorization': 'Bearer ' + objSession.Token.access_token },
                contentType: 'application/json; charset=utf-8',
                dataType: "json",
                success: function (data) {
                    if (data.detail != '') {
                        pubIsExisting = true;
                        var obj = data.detail;
                        var objCust = obj.Customer;
                        var objApp = obj.Application;
                        var objChannel = obj.Channel;
                        var objInsurance = obj.Insurance;
                        var objAddr = objCust.Address;
                        var objRider = obj.Rider;
                        var objBen = obj.Beneficiaries;
                        var objAgent = obj.Agent;
                        var riderSA = $('#Main_ddlRiderSA');
                        var objSubApplication = obj.SubApplications;

                        /*IF APPLICATION IS SUB APPLICATION , THEN SELECT MAIN POLICY INSTEAD*/
                        if (objApp.MainApplicationNumber != '') {
                            $.ajax({
                                url: webapiUrl + 'Application/GetApplicationDetail?applicationNumber=' + objApp.MainApplicationNumber,
                                method: 'GET',
                                headers: { 'content-Type': 'application/json', 'Authorization': 'Bearer ' + objSession.Token.access_token },
                                contentType: 'application/json; charset=utf-8',
                                dataType: "json",
                                success: function (data) {
                                    if (data.detail != '') {
                                        obj = data.detail;
                                        objCust = obj.Customer;
                                        objApp = obj.Application;
                                        objChannel = obj.Channel;
                                        objInsurance = obj.Insurance;
                                        objAddr = objCust.Address;
                                        objRider = obj.Rider;
                                        objBen = obj.Beneficiaries;
                                        objAgent = obj.Agent;
                                        objSubApplication = obj.SubApplications;
                                    }
                                },
                                async: false,
                                error: function (err) {
                                    pubIsExisting = false;
                                    result = false;
                                }
                            })

                        }/*END IF APPLICATION IS SUB APPLICATION , THEN SELECT MAIN POLICY INSTEAD*/

                        $('#Main_txtApplicationNumber').val(objApp.ApplicationNumber);
                        pubApplicationNumber = objApp.ApplicationNumber;

                        $('#Main_txtApplicationDate').val(moment(objApp.ApplicationDate).format("DD/MM/YYYY"));
                        $('#Main_txtCertificateNumber').val(obj.PolicyNumber);
                        $('#Main_txtPolicyStatus').val(obj.PolicyStatus);
                        $('#Main_ddlChannelItem').val(objChannel.ChannelItemId);

                        $('#Main_ddlClientType').val(objApp.ClientType);

                        if (objApp.ClientType == 'INDIVIDUAL') {
                            $('#dvLoanNumber').val('');
                            $('#dvLoanNumber').css('display', 'none');
                            ShowClientTypeRemarks(false);
                        }
                        else {
                            $('#dvLoanNumber').css('display', 'block');
                            if (objApp.ClientType != 'SELF' && objApp.ClientType != 'REPAYMENT') {
                                ShowClientTypeRemarks(true);
                                $('#Main_txtClientTypeRemarks').val(objApp.ClientTypeRemarks);
                                $('#Main_ddlClientTypeRelation').val(objApp.ClientTypeRelation);
                            }
                            else {
                                ShowClientTypeRemarks(false);

                            }
                        }

                        $('#Main_ddlTotalSumAssure').val(objApp.NumbersOfApplicationFirstYear);
                        $('#Main_ddlNumberOfApplications').val(objApp.NumbersOfApplicationFirstYear);
                        $('#Main_ddlNumberOfPurchasingYear').val(objApp.NumbersOfPurchasingYear);
                        $('#Main_txtLoanNumber').val(objApp.LoanNumber);

                        pubApplicationId = objApp.ApplicationId;
                        pubCustomerId = objCust.CustomerId;
                        pubLoanNumber = objApp.LoanNumber;

                        /*Policyholder information*/
                        $('#Main_txtPolicyholderName').val(objApp.PolicyholderName);
                        $('#Main_ddlPolicyholderGender').val(objApp.PolicyholderGender);
                        $('#Main_txtPolicyholderDOB').val(moment(objApp.PolicyholderDOB).year() == 1900 ? "" : moment(objApp.PolicyholderDOB).format("DD/MM/YYYY"));
                        $('#Main_ddlPolicyholderIDType').val(objApp.PolicyholderIDType);
                        $('#Main_txtPolicyholderIDNo').val(objApp.PolicyholderIDNo);
                        $('#Main_txtPolicyHolderAddress').val(objApp.PolicyholderAddress);

                        /*bind branch code*/
                        // GetBranchCodeList(objChannel.ChannelItemId);
                        $('#Main_ddlChannelItem').val(objChannel.ChannelItemId);
                        $('#Main_ddlBranchCode').val(objChannel.ChannelLocationId);
                        $('#Main_txtBranchName').val(objChannel.OfficeName);

                        $('#Main_hdfChannelItemId').val(objChannel.ChannelItemId);

                        /*load agent*/
                        LoadAgent();
                        /*selected agent*/
                        $('#Main_ddlAgentCode').val(objAgent.AgentCode);

                        if (GetProductConfig(objChannel.ChannelItemId, objAgent.AgentCode)) {
                            $('#Main_ddlPackage').val(objInsurance.ProductId);

                            GetProductDetail(objInsurance.ProductId);

                            $('#Main_ddlSumAssure').val(objInsurance.SumAssure);
                            $('#Main_txtSumAssure').val(objInsurance.SumAssure);

                            pubBasicSA = objInsurance.SumAssure;
                            $('#Main_ddlPaymentMode').val(objInsurance.PaymentMode);
                            pubPaymentMode = objInsurance.PaymentMode;
                            $('#Main_txtAnnualPremium').val(objInsurance.AnnualPremium);
                            pubAnnualPremium = objInsurance.AnnualPremium;
                            $('#Main_txtPremium').val(objInsurance.Premium);
                            pubBasicPremium = objInsurance.Premium;
                            $('#Main_txtDiscountAmount').val(objInsurance.DiscountAmount);
                            pubBasicDiscount = objInsurance.DiscountAmount;
                            $('#Main_txtPremiumAfterDiscount').val(objInsurance.TotalAmount);
                            pubBasicAfterDiscount = objInsurance.TotalAmount;
                            //  var riderPremium = 0;

                            if (pubProductDetail.RiderProductID == '') {
                                riderSA.prop('disabled', 'disabled');
                                riderSA.find('option').remove();

                                /*hide all rider fields*/
                                $('.rider-field').css('display', 'none');
                            }
                            else {
                                $('.rider-field').css('display', 'block');
                                pubRiderProductId = pubProductDetail.RiderProductID;
                                riderSA.removeProp('disabled');
                                var option = '';
                                option = '<option value="">---Select---</option>';
                                var sa = pubProductDetail.RiderSumAssuredRange;
                                for (i = 0; i < sa.length; i++) {
                                    option += '<option value="' + sa[i] + '">' + sa[i] + '</option>';
                                }
                                riderSA.find('option').remove();
                                riderSA.append(option);
                            }

                            if (objRider != null) {
                                $('#Main_ddlRiderSA').val(objRider.SumAssure);
                                $('#Main_txtRiderPremium').val(objRider.Premium);
                                $('#Main_txtRiderDiscountAmount').val(objRider.DiscountAmount);
                                $('#Main_txtRiderPremiumAfterDiscount').val(objRider.TotalAmount);
                                pubRiderSA = objRider.SumAssure;
                                pubRiderPremium = objRider.Premium;
                                pubRiderAnnualPremium = objRider.AnnualPremium;
                                pubRiderDiscount = objRider.DiscountAmount;
                                pubRiderAfterDiscount = objRider.TotalAmount;
                            }

                            $('#Main_txtTotalAmount').val(objInsurance.Premium + pubRiderPremium);
                            $('#Main_txtTotalDiscountAmount').val(objInsurance.DiscountAmount + pubRiderDiscount);
                            $('#Main_txtTotalAmountAfterDiscount').val(objInsurance.TotalAmount + pubRiderAfterDiscount);

                            pubTotalPremium = objInsurance.Premium + pubRiderPremium;
                            pubTotalPremiumAfterDiscount = objInsurance.TotalAmount;


                            if (pubProductDetail.ProductType == 'MICRO_LOAN') {

                                $('#dvPolicyHolder').css('display', 'block');
                                $('#dvPrimaryBeneficiary').css('display', 'block');
                                $('#dvContingentBeneficiary').html('Contingent beneficiary');

                                $('.star-ben').text('');


                            }
                            else {
                                $('#dvPolicyHolder').css('display', 'none');
                                $('#dvPrimaryBeneficiary').css('display', 'none');
                                $('#dvContingentBeneficiary').html('Beneficiary');
                                $('.star-ben').text('*');

                                $('#divSumAssureTextBox').css('display', '');
                                $('#Main_txtTotalSumAssure').css('display', '');
                                $('#Main_ddlCoverPeriod').css('display', '');
                                $('#Main_ddlPaymentPeriod').css('display', '');
                                $('#Main_ddlCoverPeriod').val(objInsurance.CoverType + ':' + objInsurance.CoverYear);
                                $('#Main_ddlPaymentPeriod').val(objInsurance.CoverType + ':' + objInsurance.CoverYear);

                                $('#divSumAssureDropdown').css('display', 'none');
                                $('#Main_ddlTotalSumAssure').css('display', 'none');
                                $('#dvCoverPeriodTextBox').css('display', 'none');
                                $('#dvPayPeriodTextBox').css('display', 'none');

                            }
                            /*DISABLE POLICY HOLDER FIELDS*/
                            $('#Main_txtPolicyholderName').prop('disabled', 'disabled');
                            $('#Main_txtPolicyHolderAddress').prop('disabled', 'disabled');
                            $('#Main_ddlPolicyholderIDType').prop('disabled', 'disabled');
                            $('#Main_txtPolicyholderIDNo').prop('disabled', 'disabled');
                            $('#Main_ddlPolicyholderGender').prop('disabled', 'disabled');
                            $('#Main_txtPolicyholderDOB').prop('disabled', 'disabled');

                            /*show in issue policy screen*/
                            var confirmApp = '';
                            var confirmSubApp = '';
                            var totalAmountSubApp = 0;
                            var totalSubSumAssure = 0;

                            pubApplicationList = new Array();

                            pubSumAssurePremium = new Array();

                            var objSumPrem = {
                                SumAssure: pubBasicSA,
                                Premium: pubBasicPremium,
                                DiscountAmount: pubBasicDiscount,
                                TotalAmount: pubBasicAfterDiscount,
                                AnnualPremium: pubAnnualPremium
                            };
                            pubSumAssurePremium.push(objSumPrem);

                            if (objSubApplication.length > 0) {
                                appObj = { ApplicationNumber: objApp.ApplicationNumber, IsMainApplication: true, ClientType: objApp.ClientType }
                                pubApplicationList.push(appObj);
                                confirmApp = '<strong>1. ' + objApp.ApplicationNumber + (objApp.ClientType != 'REPAYMENT' ? ' - NEW (Main)' : ' - REPAYMENT') + '</strong><br />';/*main application*/
                            }
                            else {

                                appObj = { ApplicationNumber: objApp.ApplicationNumber, IsMainApplication: false, ClientType: objApp.ClientType }
                                pubApplicationList.push(appObj);
                                confirmApp = '<strong>1. ' + objApp.ApplicationNumber + '</strong><br />';/*main application, there is no sub applications*/
                            }

                            $.each(objSubApplication, function (index, val) {
                                appObj = { ApplicationNumber: val.ApplicationNumber, IsMainApplication: false, ClientType: val.ClientType }
                                pubApplicationList.push(appObj);
                                confirmSubApp += '<strong>' + (index + 2) + '. ' + val.ApplicationNumber + (val.ClientType != 'REPAYMENT' ? ' - NEW' : ' - REPAYMENT') + '</strong><br />';
                                totalAmountSubApp += val.TotalAmount;// val.ClientType != 'REPAYMENT' ? val.TotalAmount:0;
                                totalSubSumAssure += val.ClientType != 'REPAYMENT' ? val.SumAssure : 0;

                                var objSumPrem = {
                                    SumAssure: val.SumAssure,
                                    Premium: val.BasicAmount,
                                    DiscountAmount: pubBasicDiscount,
                                    TotalAmount: val.TotalAmount
                                    //,AnnualPremium: pubAnnualPremium
                                };
                                pubSumAssurePremium.push(objSumPrem);

                            });
                            confirmApp += confirmSubApp;

                            $('#divApplicationToBeIssued').html(confirmApp);
                            $('#Main_txtTotalAmountPay').val(parseFloat(objInsurance.TotalAmount + pubRiderAfterDiscount + totalAmountSubApp).toFixed(3));
                            $('#Main_txtCollectedPremium').val(parseFloat(objInsurance.TotalAmount + pubRiderAfterDiscount + totalAmountSubApp).toFixed(3));

                            $('#Main_txtPaymentReferenceNo').val(obj.PaymentReferenceNo);
                            $('#Main_txtTotalSumAssure').val(objInsurance.SumAssure + totalSubSumAssure);
                        }
                        pubProductId = objInsurance.ProductId;

                        /*customer*/

                        $('#Main_ddlIdType').val(objCust.IdType);
                        $('#Main_txtIdNumber').val(objCust.IdNumber);
                        $('#Main_txtSurnameKh').val(objCust.LastNameKh);
                        $('#Main_txtFirstNameKh').val(objCust.FirstNameKh);
                        $('#Main_txtSurnameEn').val(objCust.LastNameEn);
                        $('#Main_txtFirstNameEn').val(objCust.FirstNameEn);
                        $('#Main_ddlNationality').val(objCust.Nationality);
                        $('#Main_ddlGender').val(objCust.Gender);
                        $('#Main_ddlMaritalStatus').val(objCust.MaritalStatus);
                        $('#Main_ddlOccupation').val(objCust.Occupation);
                        $('#Main_txtDob').val(moment(objCust.Dob).format("DD/MM/YYYY"));
                        $('#Main_txtAge').val(obj.Age);
                        $('#Main_txtPhoneNumber').val(objCust.PhoneNumber);
                        $('#Main_txtEmail').val(objCust.Email);
                        $('#Main_ddlProvince').val(objAddr.Province);
                        /*Load district*/
                        LoadDistrict(objAddr.Province);
                        $('#Main_ddlDistrict').val(objAddr.District);

                        /*Load commune*/
                        if (objAddr.District != '') {
                            LoadCommune(objAddr.District);
                            $('#Main_ddlCommune').val(objAddr.Commune);
                        }
                        /*Load Village*/
                        if (objAddr.Commune != '') {
                            LoadVillage(objAddr.Commune);
                            $('#Main_ddlVillage').val(objAddr.Village);
                        }

                        /*Insurance*/
                        $('#Main_txtProductName').val(objInsurance.ProductName);


                        /*Beneficiary*/
                        /*clear table rows*/
                        $('#tblBenList').find('tbody tr').remove();

                        var row = '';
                        $.each(objBen, function (index, val) {

                            pubTotalPercentage += parseFloat(val.PercentageOfShare);
                            var dob = '';
                            if (val.DOB != '' && moment(val.DOB).year() != 1900) {
                                dob = moment(val.DOB).format("DD/MM/YYYY");

                            }
                            else {
                                dob = '';
                            }
                            //add new row
                            row += '<tr  id="benRow' + index + '">';
                            row += '<td class="hidden">' + val.Id + '</td>';
                            row += '<td> <label id="benName' + index + '">' + val.FullName + '</label></td>';
                            row += '<td> <label class="hidden" id="benGender' + index + '">' + val.Gender + '</label><label id="benGenderText' + index + '">' + val.GenderString + '</label></td>';
                            row += '<td> <label id="benDOB' + index + '">' + dob + '</label></td>';
                            row += '<td> <label  class="hidden" id="benIdType' + index + '">' + val.IdType + '</label><label id="benIdTypeText' + index + '">' + val.IdTypeString + '</label></td>';
                            row += '<td> <label id="benIdNo' + index + '">' + val.IdNo + '</label></td>';
                            row += '<td><label id="benAge' + index + '">' + val.Age + '</label></td>';
                            row += '<td><label id="benRelation' + index + '">' + val.Relation + '</label></td>';
                            row += '<td class="row-center"><label id="benPercentage' + index + '">' + val.PercentageOfShare + '</label></td>';
                            row += '<td class="row-center"><button type="button" onclick="EditBenefitRow(' + index + ',\'' + val.FullName + '\', \'' + val.Gender + '\', \'' + dob + '\', \'' + val.IdType + '\', \'' + val.IdNo + '\', \'' + val.Age + '\', \'' + val.Relation + '\', \'' + val.PercentageOfShare + '\');"><span class ="glyphicon glyphicon-edit"></span></button>';
                            row += '<button type="button" onclick="DeleteBenefitRow(' + index + ');"><span class ="glyphicon glyphicon-remove camlife-color-red"></span></button></td>'
                            row += '</tr>';

                        });
                        $('#tblBenList').append(row);

                        if (obj.PolicyNumber != '') {
                            $('#btnSaveApplication').prop('disabled', 'disabled');
                            $('#btnIssue').prop('disabled', 'disabled');
                            /*button add beneficiary*/
                            $('#btnAdd').prop('disabled', 'disabled');
                            $('#tblBenList tbody tr button').prop("disabled", "disabled");

                            if (!pubIsFirstIssue) {
                                ShowWarning("This Application was already converted to policy! <br /> Modification is not allowed.");
                            }
                            $('#btnJumpTopolicy').hide();
                            $('#bQuestionNext').html('Collected Premium');
                            $('#bQuestionNext').show();
                        }
                        else {
                            $('#btnSaveApplication').removeProp('disabled');
                            $('#btnIssue').removeProp('disabled');

                            $('#btnJumpTopolicy').show();
                            $('#bQuestionNext').show();
                        }
                    }
                    else {
                        pubIsExisting = false;
                    }
                    HideProgress();

                },
                async: false,
                error: function (err) {
                    pubIsExisting = false;
                    result = false;
                },
                /* show progressing */
                xhr: function () {
                    var fileXhr = $.ajaxSettings.xhr();
                    if (fileXhr.upload) {
                        ShowProgress('Loading applition information.');
                    }
                    return fileXhr;
                }

            });
        }

        function LoadAgent() {
            var locationId = $('#Main_ddlBranchCode').find('option:selected').val();
            var branchName = '';
            $.each(pubChannelLocation, function (index, val) {
                if (val.Channel_Location_ID == locationId) {
                    branchName = val.Office_Name;
                    return false;
                }
            });
            $('#<%=txtBranchName.ClientID%>').val(branchName);

            var branchCode = $('#Main_ddlBranchCode').find('option:selected').text();

            /*load saleAgent*/
            var objddlAgentCode = $('#Main_ddlAgentCode');
            var objChannelItemId = $('#Main_hdfChannelItemId');

            if (objSession.RoleAccess[0].RoleName == "ExternalLoanAdmin" || objSession.RoleAccess[0].RoleName == "administrator") {
                $.ajax({
                    url: webapiUrl + 'SaleAgent/GetSaleAgentByChannelItemIdBranchCode?channelItemId=' + objChannelItemId.val() + '&branchCode=' + branchCode,
                    method: 'GET',
                    headers: { 'content-Type': 'application/json', 'Authorization': 'Bearer ' + objSession.Token.access_token },
                    contentType: 'application/json; charset=utf-8',
                    dataType: "json",
                    success: function (data) {
                        var option = '';
                        objddlAgentCode.find('option').remove();
                        option = '<option value="">---Select---</option>';
                        $.each(data.Detail, function (index, val) {
                            //bind to drop downlist
                            option += '<option value="' + val.SaleAgentId + '">' + val.SaleAgentId + ' - ' + val.FullNameEn + '</option>';
                        });

                        objddlAgentCode.append(option);
                    },
                    async: false,
                    error: function (err) {
                        return false;
                    }
                });
            }
        }



    </script>

    <div class="row">

        <div id="dvApplicationInfo">
            <div class="alert alert-success" role="alert">
                <h4 class="alert-heading">Please input application information here!</h4>
                <p>Please input all required fields.<span class="star">*</span></p>

            </div>



            <div class="col-md-12 div-title1 ">Application Information</div>

            <div class="col-md-3 ">
                <asp:Label runat="server" ID="lblClientType">Client Type</asp:Label>
                <asp:DropDownList ID="ddlClientType" runat="server" CssClass="form-control TextBoxShadowRequired">
                </asp:DropDownList>
            </div>
            <div class="col-md-3" id="colClientTypeRemarks">
                <asp:Label runat="server" ID="lblClientTypeRemarks">Client Type Remarks</asp:Label>
                <asp:TextBox ID="txtClientTypeRemarks" runat="server" CssClass="form-control khmer-font"></asp:TextBox>
            </div>
            <div class="col-md-3" id="colClientTypeRelation">
                <asp:Label runat="server" ID="lblClientTypeRelation">Client Type Relation</asp:Label>
                <asp:DropDownList ID="ddlClientTypeRelation" runat="server" CssClass="form-control khmer-font">
                </asp:DropDownList>
            </div>
            <div class="col-md-3"></div>

            <div class="col-md-3">

                <asp:Label runat="server" ID="lblAppDate">Application Date</asp:Label><span class="star">*</span>
                <div class="input-group TextBoxShadowRequired">
                    <span class="input-group-addon"><span class="glyphicon glyphicon-calendar" aria-hidden="true"></span></span>
                    <asp:TextBox ID="txtApplicationDate" ReadOnly="true" runat="server" CssClass="form-control "></asp:TextBox>

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
                <asp:Label ID="lblPartner" runat="server">Channel Name</asp:Label><span class="star">*</span>
                <asp:DropDownList ID="ddlChannelItem" runat="server" AppendDataBoundItems="true" CssClass="form-control">
                </asp:DropDownList>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblBranchCode" runat="server">Branch Code</asp:Label><span class="star">*</span>
                <asp:DropDownList ID="ddlBranchCode" runat="server" AppendDataBoundItems="true" CssClass="form-control TextBoxShadowRequired">
                </asp:DropDownList>
            </div>

            <div class="col-md-3">
                <asp:Label ID="lblBranchName" runat="server">Branch Name</asp:Label>
                <asp:TextBox ID="txtBranchName" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblAgentcode" runat="server">Agent Code</asp:Label>
                <%--   <asp:TextBox ID="txtAgentCode" runat="server" CssClass="form-control"></asp:TextBox>--%>
                <asp:DropDownList ID="ddlAgentCode" CssClass="form-control TextBoxShadowRequired" runat="server"></asp:DropDownList>
            </div>
            <div class="col-md-3 hidden">
                <asp:Label ID="lblAgentName" runat="server">Agent Name</asp:Label>
                <asp:TextBox ID="txtAgentName" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="col-md-3 " id="dvLoanNumber">
                <asp:Label ID="lblLoanNumber" runat="server">Loan Number</asp:Label><span class="star">*</span>
                <asp:TextBox ID="txtLoanNumber" runat="server" CssClass=" form-control TextBoxShadowRequired "></asp:TextBox>
            </div>



            <div class="col-md-12 margin-top-20 margin-bottom-20">
                <div class="btn-group right" role="group">
                    <button type="button" id="btnAppNext" class=" btn btn-primary button-space">Next&nbsp;&nbsp;<span class="glyphicon glyphicon-arrow-right"></span></button>
                    <button type="button" id="btnJumpTopolicy" class="btn btn-primary button-space" onclick="JumpToPolicy();">Issue Policy&nbsp;&nbsp;<span class="glyphicon glyphicon-forward"></span></button>
                </div>

            </div>
        </div>


        <div id="dvCustomerInfo">
            <div class="alert alert-success" role="alert">
                <h4 class="alert-heading">Please input customer information here!</h4>
                <p>Please input all required fields.<span class="star">*</span></p>
            </div>
            <div class="col-md-12 div-title1">Customer Information</div>
            <div class="col-md-3">
                <asp:Label ID="lblIdType" runat="server">ID Type</asp:Label><span class="star">*</span>
                <asp:DropDownList ID="ddlIdType" runat="server" CssClass="form-control khmer-font TextBoxShadowRequired">
                </asp:DropDownList>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblIdNo" runat="server">ID Number</asp:Label><span class="star">*</span>
                <asp:TextBox ID="txtIdNumber" runat="server" CssClass="form-control TextBoxShadowRequired"></asp:TextBox>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblSurNameKh" runat="server">Surname (KH)</asp:Label><span class="star">*</span>
                <asp:TextBox ID="txtSurnameKh" runat="server" CssClass="form-control khmer-font TextBoxShadowRequired"></asp:TextBox>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblFirstNameKh" runat="server">First Name (KH)</asp:Label><span class="star">*</span>
                <asp:TextBox ID="txtFirstNameKh" runat="server" CssClass="form-control khmer-font TextBoxShadowRequired"></asp:TextBox>
            </div>

            <div class="col-md-3">
                <asp:Label ID="lblSurNameEn" runat="server">Surname (EN)</asp:Label><span class="star">*</span>
                <asp:TextBox ID="txtSurnameEn" runat="server" CssClass="form-control TextBoxShadowRequired"></asp:TextBox>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblFirstNameEn" runat="server">First Name (EN)</asp:Label><span class="star">*</span>
                <asp:TextBox ID="txtFirstNameEn" runat="server" CssClass="form-control TextBoxShadowRequired"></asp:TextBox>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblNationality" runat="server">Nationality</asp:Label><span class="star">*</span>
                <asp:DropDownList ID="ddlNationality" runat="server" CssClass="form-control khmer-font TextBoxShadowRequired"></asp:DropDownList>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblGender" runat="server">Gender</asp:Label><span class="star">*</span>
                <asp:DropDownList ID="ddlGender" runat="server" CssClass="form-control khmer-font TextBoxShadowRequired">
                </asp:DropDownList>
            </div>

            <div class="col-md-3">
                <asp:Label ID="lblDob" runat="server">DOB</asp:Label><span class="star">*</span>
                <div class="input-group TextBoxShadowRequired">
                    <span class="input-group-addon"><span class="glyphicon glyphicon-calendar" aria-hidden="true"></span></span>
                    <asp:TextBox ID="txtDob" runat="server" CssClass="form-control " ReadOnly="true"></asp:TextBox>
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
                <asp:Label ID="lblMaritalStatus" runat="server">Marital Status</asp:Label><span class="star">*</span>
                <asp:DropDownList ID="ddlMaritalStatus" runat="server" CssClass="form-control khmer-font TextBoxShadowRequired">
                </asp:DropDownList>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblOccupation" runat="server">Occupation</asp:Label><span class="star">*</span>
                <asp:DropDownList ID="ddlOccupation" runat="server" CssClass="form-control khmer-font TextBoxShadowRequired"></asp:DropDownList>
            </div>

            <div class="col-md-6">
                <asp:Label ID="lblPhoneNumber" runat="server">Phone Number</asp:Label><span class="star">*</span>
                <asp:TextBox ID="txtPhoneNumber" runat="server" CssClass="form-control TextBoxShadowRequired"></asp:TextBox>
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
                <asp:Label ID="lblProvince" runat="server">Province</asp:Label><span class="star">*</span>
                <asp:DropDownList ID="ddlProvince" runat="server" CssClass="form-control khmer-font TextBoxShadowRequired"></asp:DropDownList>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblDistrict" runat="server">District</asp:Label>
                <asp:DropDownList ID="ddlDistrict" runat="server" CssClass="form-control khmer-font"></asp:DropDownList>
            </div>

            <div class="col-md-3">
                <asp:Label ID="lblCommune" runat="server">Commune</asp:Label>
                <asp:DropDownList ID="ddlCommune" runat="server" CssClass="form-control khmer-font"></asp:DropDownList>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblVillage" runat="server">Village</asp:Label>
                <asp:DropDownList ID="ddlVillage" runat="server" CssClass="form-control khmer-font"></asp:DropDownList>
            </div>
            <div class="col-md-3"></div>
            <div class="col-md-3"></div>

            <div class="col-md-9"></div>
            <div class="col-md-3">
                <div class="btn-group right" role="group">
                    <button type="button" class="btn btn-info button-space" onclick="CustBack();"><span class="glyphicon glyphicon-arrow-left"></span>&nbsp;&nbsp;Back</button>
                    <button type="button" class="btn btn-primary button-space" id="btnCustNext">Next&nbsp;&nbsp;<span class="glyphicon glyphicon-arrow-right"></span></button>
                </div>
            </div>
        </div>

        <div id="dvInsurance">
            <div class="alert alert-success" role="alert">
                <h4 class="alert-heading">Please input insurance product and detail here!</h4>
                <p>Please input all required fields.<span class="star">*</span></p>
            </div>
            <div class="col-md-12 div-title1">Insurance Product and Detail</div>

            <div class="col-md-3">
                <asp:Label ID="lblPackage" runat="server" CssClass="lable-bold">Package</asp:Label><span class="star">*</span>
                <asp:DropDownList ID="ddlPackage" runat="server" CssClass="form-control TextBoxShadowRequired"></asp:DropDownList>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblProductName" runat="server">Product Name</asp:Label>
                <asp:TextBox ID="txtProductName" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblCoverPeriod" runat="server">Tearm of Cover</asp:Label>
                <div class="input-group" id="dvCoverPeriodTextBox">
                    <span class="input-group-addon">YEAR</span>
                    <asp:TextBox ID="txtCoverPeriod" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
                <asp:DropDownList ID="ddlCoverPeriod" runat="server" CssClass="form-control TextBoxShadowRequired">
                   <%-- <asp:ListItem Value="M:1">1 Month</asp:ListItem>
                    <asp:ListItem Value="M:2">2 Months</asp:ListItem>--%>
                    <asp:ListItem Value="M:3">3 Months (Quarter)</asp:ListItem>
                   <%-- <asp:ListItem Value="M:4">4 Months</asp:ListItem>
                    <asp:ListItem Value="M:5">5 Months</asp:ListItem>--%>
                    <asp:ListItem Value="M:6">6 Months (Semi-Annual)</asp:ListItem>
                <%--    <asp:ListItem Value="M:7">7 Months</asp:ListItem>
                    <asp:ListItem Value="M:8">8 Months</asp:ListItem>
                    <asp:ListItem Value="M:9">9 Months</asp:ListItem>
                    <asp:ListItem Value="M:10">10 Months</asp:ListItem>
                    <asp:ListItem Value="M:11">11 Months</asp:ListItem>--%>
                    <asp:ListItem Value="Y:1">Annual</asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblPayPeriod" runat="server">Payment Period</asp:Label>
                <div class="input-group" id="dvPayPeriodTextBox">
                    <span class="input-group-addon">YEAR</span>
                    <asp:TextBox ID="txtPaymentPeriod" runat="server" CssClass="form-control">
                       
                    </asp:TextBox>
                </div>
                <asp:DropDownList ID="ddlPaymentPeriod" runat="server" CssClass="form-control">
                   <%-- <asp:ListItem Value="M:1">1 Month</asp:ListItem>
                    <asp:ListItem Value="M:2">2 Months</asp:ListItem>--%>
                    <asp:ListItem Value="M:3">3 Months (Quarter)</asp:ListItem>
                   <%-- <asp:ListItem Value="M:4">4 Months</asp:ListItem>
                    <asp:ListItem Value="M:5">5 Months</asp:ListItem>--%>
                    <asp:ListItem Value="M:6">6 Months (Semi-Annual)</asp:ListItem>
                   <%-- <asp:ListItem Value="M:7">7 Months</asp:ListItem>
                    <asp:ListItem Value="M:8">8 Months</asp:ListItem>
                    <asp:ListItem Value="M:9">9 Months</asp:ListItem>
                    <asp:ListItem Value="M:10">10 Months</asp:ListItem>
                    <asp:ListItem Value="M:11">11 Months</asp:ListItem>--%>
                    <asp:ListItem Value="Y:1">Annual</asp:ListItem>
                </asp:DropDownList>
            </div>

            <div class="col-md-3">
                <asp:Label ID="lblSA" runat="server">Sum Assure</asp:Label><span class="star">*</span>
                <div class="input-group" id="divSumAssureDropdown">
                    <span class="input-group-addon">USD</span>
                    <asp:DropDownList ID="ddlSumAssure" runat="server" CssClass="form-control"></asp:DropDownList>

                </div>
                <div class="input-group TextBoxShadowRequired" id="divSumAssureTextBox">
                    <span class="input-group-addon">USD</span>
                    <asp:TextBox ID="txtSumAssure" runat="server" CssClass="form-control "></asp:TextBox>
                </div>
            </div>

            <div class="col-md-3">
                <asp:Label ID="lblPaymentMode" runat="server">Payment Mode</asp:Label><span class="star">*</span>
                <asp:DropDownList ID="ddlPaymentMode" runat="server" CssClass="form-control TextBoxShadowRequired"></asp:DropDownList>
            </div>
            <div class="col-md-3" id="dvAnnualPremium">
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


            <div class="col-md-6" id="lblGroupDiscountAmount">
                <asp:Label ID="lblDiscountAmount" runat="server">Discount Amount</asp:Label>
                <div class="input-group">
                    <span class="input-group-addon">USD</span>
                    <asp:TextBox ID="txtDiscountAmount" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
            </div>
            <div class="col-md-6" id="lblGroupPremiumAfterDiscount">
                <asp:Label ID="lblPremiumAfterDiscount" runat="server">Premium After Discount</asp:Label>
                <div class="input-group">
                    <span class="input-group-addon">USD</span>
                    <asp:TextBox ID="txtPremiumAfterDiscount" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
            </div>


            <div class="col-md-3">

                <asp:Label ID="lblTotalSumAssure" runat="server">Total Sum Assure (USD)<span class="star">*</span></asp:Label>

                <asp:DropDownList ID="ddlTotalSumAssure" runat="server" CssClass="form-control TextBoxShadowRequired">

                    <asp:ListItem Text="5,000" Value="1"></asp:ListItem>
                    <asp:ListItem Text="10,000" Value="2"></asp:ListItem>
                    <asp:ListItem Text="15,000" Value="3"></asp:ListItem>
                    <asp:ListItem Text="20,000" Value="4"></asp:ListItem>
                    <asp:ListItem Text="25,000" Value="5"></asp:ListItem>
                </asp:DropDownList>
                <asp:TextBox runat="server" ID="txtTotalSumAssure" CssClass="form-control TextBoxShadowRequired" placeHolder="Enter Total Sum Assure"></asp:TextBox>

            </div>

            <div class="col-md-3">

                <asp:Label ID="lblNumberOfApplications" runat="server">Number of Application <span class="star">*</span></asp:Label>

                <asp:DropDownList ID="ddlNumberOfApplications" runat="server" CssClass="form-control TextBoxShadowRequired">
                    <asp:ListItem Text="-" Value="0"></asp:ListItem>
                    <asp:ListItem Text="1" Value="1"></asp:ListItem>
                    <asp:ListItem Text="2" Value="2"></asp:ListItem>
                    <asp:ListItem Text="3" Value="3"></asp:ListItem>
                    <asp:ListItem Text="4" Value="4"></asp:ListItem>
                    <asp:ListItem Text="5" Value="5"></asp:ListItem>
                </asp:DropDownList>
            </div>

            <div class="col-md-3">

                <asp:Label ID="lblNumberOfPurchasingYear" runat="server">Number of Year <span class="star">*</span></asp:Label>

                <asp:DropDownList ID="ddlNumberOfPurchasingYear" runat="server" CssClass="form-control TextBoxShadowRequired">
                    <asp:ListItem Text="-" Value="0"></asp:ListItem>
                    <asp:ListItem Text="1" Value="1"></asp:ListItem>
                    <asp:ListItem Text="2" Value="2"></asp:ListItem>
                    <asp:ListItem Text="3" Value="3"></asp:ListItem>
                    <asp:ListItem Text="4" Value="4"></asp:ListItem>
                    <asp:ListItem Text="5" Value="5"></asp:ListItem>
                </asp:DropDownList>
            </div>


            <div class="col-md-12 div-title1 margin-top-10" id="rider-header">Rider Product</div>

            <div class="col-md-3 rider-field">
                <asp:Label ID="lblRiderProduct" runat="server">Rider Product</asp:Label>
                <asp:TextBox ID="txtRiderProduct" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="col-md-3 rider-field">
                <asp:Label ID="lblRiderSA" runat="server">Rider Sum Assure (USD)</asp:Label>
                <div class="input-group">
                    <span class="input-group-addon">USD</span>
                    <asp:DropDownList ID="ddlRiderSA" runat="server" CssClass="form-control"></asp:DropDownList>
                </div>
            </div>
            <div class="col-md-3 rider-field">
                <asp:Label ID="lblRiderPremium" runat="server">Rider Premium</asp:Label>
                <div class="input-group">
                    <span class="input-group-addon">USD</span>
                    <asp:TextBox ID="txtRiderPremium" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
            </div>

            <div class="col-md-3" id="lblGroupRiderDiscountAmount">
                <asp:Label ID="lblRiderDiscountAmount" runat="server">Rider Discount Amount</asp:Label>
                <div class="input-group">
                    <span class="input-group-addon">USD</span>
                    <asp:TextBox ID="txtRiderDiscountAmount" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
            </div>


            <div class="col-md-12" id="lblGroupRiderPremiumAfterDiscount">
                <asp:Label ID="lblRiderPremiumAfterDiscount" runat="server">Rider Premium After Discount</asp:Label>
                <div class="input-group">
                    <span class="input-group-addon">USD</span>
                    <asp:TextBox ID="txtRiderPremiumAfterDiscount" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
            </div>



            <div class="col-md-3">
                <asp:Label ID="lblTotalAmount" runat="server">Total Amount</asp:Label>
                <div class="input-group">
                    <span class="input-group-addon">USD</span>
                    <asp:TextBox ID="txtTotalAmount" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
            </div>

            <div class="col-md-3" id="lblGroupTotalDiscountAmount">
                <asp:Label ID="lblTotalDiscountAmount" runat="server">Total Discount Amount</asp:Label>
                <div class="input-group">
                    <span class="input-group-addon">USD</span>

                    <asp:TextBox ID="txtTotalDiscountAmount" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
            </div>
            <div class="col-md-3" id="lblGroupTotalAmountAfterDiscount">
                <asp:Label ID="lblTotalAmountAfterDiscount" runat="server">Total Amount After Discount</asp:Label>
                <div class="input-group">
                    <span class="input-group-addon">USD</span>
                    <asp:TextBox ID="txtTotalAmountAfterDiscount" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
            </div>
            <div class="col-md-3">

                <asp:Label ID="lblReferrerId" runat="server">Referral Id <span class="star">*</span></asp:Label>
                <asp:TextBox ID="txtReferrerId" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="col-md-12 dvClear"></div>
            <div id="dvPolicyHolder">

                <div class="col-md-12 div-title1">Policy Holder</div>
                <div class="col-md-3" id="Div1">
                    <asp:Label runat="server" ID="lblPolicyholderName">Name</asp:Label><span class="star">*</span>
                    <asp:TextBox ID="txtPolicyholderName" runat="server" CssClass="form-control khmer-font"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <asp:Label runat="server" ID="lblPolicyholerDOB">DOB</asp:Label>
                    <div class="input-group TextBoxShadowRequired">
                        <span class="input-group-addon"><span class="glyphicon glyphicon-calendar" aria-hidden="true"></span></span>
                        <asp:TextBox ID="txtPolicyholderDOB" ReadOnly="true" runat="server" CssClass="form-control "></asp:TextBox>
                    </div>
                </div>
                <div class="col-md-3">
                    <asp:Label ID="lblPolicyholderGender" runat="server">Gender</asp:Label>
                    <asp:DropDownList ID="ddlPolicyholderGender" runat="server" CssClass="form-control khmer-font TextBoxShadowRequired">
                    </asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <asp:Label ID="lblPolicyholderIdType" runat="server">ID Type</asp:Label>
                    <asp:DropDownList ID="ddlPolicyholderIDType" runat="server" CssClass="form-control khmer-font TextBoxShadowRequired">
                    </asp:DropDownList>
                </div>
                <div class="col-md-3" id="Div3">
                    <asp:Label runat="server" ID="lblPolicyholderIdNo">ID No.</asp:Label>
                    <asp:TextBox ID="txtPolicyholderIDNo" runat="server" CssClass="form-control khmer-font"></asp:TextBox>
                </div>
                <div class="col-md-9" id="Div2">
                    <asp:Label runat="server" ID="Label1">Address</asp:Label>
                    <asp:TextBox ID="txtPolicyHolderAddress" TextMode="MultiLine" runat="server" CssClass="form-control khmer-font"></asp:TextBox>
                </div>
            </div>
            <div class="row">

                <div class="col-md-12">
                    <div class="btn-group right" role="group">
                        <button type="button" id="bInsureBack" class="btn btn-info button-space" onclick="InsuranceBack();"><span class="glyphicon glyphicon-arrow-left"></span>&nbsp;&nbsp;Back</button>
                        <button type="button" id="bInsuranceNext" class="btn btn-primary button-space">Next&nbsp;&nbsp;<span class="glyphicon glyphicon-arrow-right"></span></button>
                    </div>
                </div>
            </div>
        </div>

        <div id="dvBeneficiary">
            <div class="alert alert-success" role="alert">
                <h4 class="alert-heading">Please input benefiary here!</h4>
                <p>Please input all required fields.<span class="star">*</span></p>
            </div>
            <div id="dvPrimaryBeneficiary">
                <div class="col-md-12 div-title1">Primary beneficiary</div>
                <div class="col-md-12 ">
                    <div class="col-md-5">
                        <asp:Label ID="lblPrimaryBenName" runat="server">Name</asp:Label><span class="star">*</span>
                        <asp:TextBox ID="txtPrimaryBenName" runat="server" CssClass="form-control khmer-font TextBoxShadowRequired" ReadOnly="true"></asp:TextBox>
                    </div>
                    <div class="col-md-2">
                        <asp:Label ID="lblPrimaryBenLoanNumber" runat="server">Loan Number</asp:Label><span class="star">*</span>
                        <asp:TextBox ID="txtPrimaryBenLoanNumber" runat="server" CssClass="form-control khmer-font TextBoxShadowRequired" ReadOnly="true"></asp:TextBox>
                    </div>
                    <div class="col-md-5">
                        <asp:Label ID="lblPrimaryBenAddress" runat="server">Address</asp:Label><span class="star">*</span>
                        <asp:TextBox ID="txtPrimaryBenAddress" runat="server" CssClass="form-control khmer-font TextBoxShadowRequired" ReadOnly="true"></asp:TextBox>
                    </div>
                </div>
            </div>

            <div class="col-md-12 dvClear">
            </div>
            <div class="col-md-12 div-title1" id="dvContingentBeneficiary">Contingent beneficiary</div>
            <div class="col-md-12 ">
                <div class="col-md-3">
                    <asp:Label ID="lblBenName" runat="server">Full Name</asp:Label><span class="star-ben">*</span>
                    <asp:TextBox ID="txtBenName" runat="server" CssClass="form-control khmer-font TextBoxShadowRequired"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <asp:Label ID="lblBenDOB" runat="server">DOB</asp:Label><span class="star-ben">*</span>
                    <%-- <asp:TextBox ID="txtBenDOB" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>--%>
                    <div class="input-group TextBoxShadowRequired">
                        <span class="input-group-addon"><span class="glyphicon glyphicon-calendar" aria-hidden="true"></span></span>
                        <asp:TextBox ID="txtBenDOB" ReadOnly="true" runat="server" CssClass="form-control "></asp:TextBox>
                    </div>
                </div>
                <div class="col-md-3">
                    <asp:Label ID="lblBenGender" runat="server">Gender</asp:Label><span class="star-ben">*</span>
                    <asp:DropDownList ID="ddlBenGender" runat="server" CssClass="form-control khmer-font ">
                    </asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <asp:Label ID="lblBenIdType" runat="server">ID Type</asp:Label><span class="star-ben">*</span>
                    <asp:DropDownList ID="ddlBenIdType" runat="server" CssClass="form-control khmer-font">
                    </asp:DropDownList>
                </div>

                <div class="col-md-3">
                    <asp:Label ID="lblBenIdNo" runat="server">ID No.</asp:Label><span class="star-ben">*</span>
                    <asp:TextBox ID="txtBenIdNo" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <asp:Label ID="lblBenAge" runat="server">Age</asp:Label>
                    <div class="input-group">
                        <span class="input-group-addon">YEAR</span>
                        <asp:TextBox ID="txtBenAge" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>
                </div>
                <div class="col-md-3">
                    <asp:Label ID="lblRelation" runat="server">Relation</asp:Label><span class="star-ben">*</span>
                    <asp:DropDownList ID="ddlRelation" runat="server" CssClass="form-control khmer-font TextBoxShadowRequired"></asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <asp:Label ID="lblPercentage" runat="server">Percentage of Share</asp:Label><span class="star-ben">*</span>
                    <div class="input-group TextBoxShadowRequired">
                        <asp:TextBox ID="txtBenPercentage" runat="server" CssClass="form-control"></asp:TextBox>
                        <span class="input-group-addon">%</span>

                    </div>
                </div>
                <div class="col-md-1">
                    <br />
                    <button type="button" id="btnAdd" class="btn btn-primary btn-sm "><span class="glyphicon glyphicon-plus "></span>&nbsp;&nbsp;Add</button>
                </div>
            </div>
            <div class="col-md-12"></div>
            <div class="row">
                <div class="col-md-12 margin-right-20 ">

                    <table id="tblBenList" class="table khmer-font div-beneficiary margin-top-20 margin-left-20">
                        <thead>
                            <tr>
                                <th class="col-sm-2 hidden">No.</th>
                                <th class="col-sm-2">Full Name</th>
                                <th class="col-sm-2">Gender</th>
                                <th class="col-sm-2">DOB</th>
                                <th class="col-sm-2">ID TYPE</th>
                                <th class="col-sm-2">ID NO.</th>
                                <th class="col-sm-2">Age</th>
                                <th class="col-sm-2">Relation</th>
                                <th class="col-sm-2">Percentage</th>
                                <th class="col-sm-2"></th>
                            </tr>
                        </thead>
                    </table>

                </div>
            </div>
            <div class="row">
                <%--  <div class="col-md-9" style="padding-top: 40px;"></div>--%>
                <div class="col-md-12">
                    <div class="btn-group right" role="group">
                        <button type="button" id="bBenBack" class="btn btn-info button-space" onclick="BenBack();"><span class="glyphicon glyphicon-arrow-left"></span>&nbsp;&nbsp;Back</button>
                        <button type="button" id="btnBenNext" class="btn btn-primary button-space">Next&nbsp;&nbsp;<span class="glyphicon glyphicon-arrow-right"></span></button>
                    </div>
                </div>
            </div>
        </div>
        <div id="dvQuestion">
            <div class="alert alert-success" role="alert">
                <h4 class="alert-heading">Please answere health question here!</h4>
                <p>Please input all required fields.<span class="star">*</span></p>
            </div>
            <div class="col-md-12 div-title1">Health Question of the Assured</div>
            <div class="col-md-8">
                <p class="khmer-font" style="padding-top: 10px;">១. តើអ្នកត្រូវបានធានារ៉ាប់រងកំពុងស្ថិតក្នុងលក្ខខណ្ឌណាមួយដែលមានស្រាប់មុនពេលបណ្ណសន្យារ៉ាប់រងមានសុពលភាពហើយត្រូវបានកំណត់ដូចជា៖ជំងឺមហារីក ជំងឺទឹកនោមផ្អែម ជំងឺបេះដូង ជំងឺថ្លើម ជំងឺដាច់សរសៃឈាមក្នុងខួរក្បាល ជំងឺសួត ជំងឺតំរងនោម ជំងឺរ៉ាំរ៉ៃ ជំងឺផ្សេងៗដែលកំពុងកើតមានឡើងឬកំពុងព្យាបាលមិនទាន់ជាសះស្បើយ ឬរបួសស្នាមរ៉ាំរ៉ៃដែរឬទេ? ប្រសិនបើប្រែប្រួលសូមបញ្ជាក់មូលហេតុ។</p>
                <p>1. Has the Life Assured is in the conditions which existed before effective date of insurance policy and defined as: Cancer, diabetes, heart disease, liver disease, stroke, lung disease, kidney disease or chronic injuries? If yes, please state the reason.:</p>
            </div>
            <div class="col-md-4">
                <asp:Label ID="lblAnswer" runat="server">Answer</asp:Label><span class="star">*</span>
                <p>
                    <asp:DropDownList ID="ddlAnswer" runat="server" CssClass="form-control TextBoxShadowRequired">
                        <asp:ListItem Text="NO" Value="0"></asp:ListItem>
                        <asp:ListItem Text="YES" Value="1"></asp:ListItem>
                    </asp:DropDownList>
                </p>
                <p class="khmer-font">
                    <asp:TextBox ID="txtAnswerRemarks" placeHolder="Answer detail" TextMode="MultiLine" runat="server" CssClass="form-control"></asp:TextBox>
                </p>
            </div>

            <div class="col-md-12">
                <div class="btn-group right" role="group">
                    <button type="button" id="bQuestionBack" class="btn btn-info button-space" onclick="QuestionBack();"><span class="glyphicon glyphicon-arrow-left"></span>&nbsp;&nbsp;Back</button>
                    <button type="button" id="btnSaveApplication" class="btn btn-primary button-space"><span class="glyphicon glyphicon-save"></span>&nbsp;&nbsp;Save Application</button>
                    <button type="button" id="bQuestionNext" class="btn btn-primary button-space" onclick="QuestionNext();">Skip&nbsp;&nbsp;<span class="glyphicon glyphicon-forward"></span></button>
                </div>
            </div>
        </div>

        <div id="dvIssuePolicy">
            <div class="alert alert-success" role="alert">
                <h4 class="alert-heading">Please input premium collection here!</h4>
                <p>Please input all required fields.<span class="star">*</span></p>
            </div>
            <div class="col-md-12 div-title1">Issue Policy</div>
            <div class="col-md-12">
                <asp:Label ID="lblApplicationToBeIssued" runat="server">Application to be issued </asp:Label>
                <div class=" alert alert-success">
                    <div style="border: solid 1px #21275B; padding: 5px 5px 5px 5px; border-radius: 5px;" id="divApplicationToBeIssued"></div>
                </div>
            </div>

            <div class="col-md-3">
                <asp:Label ID="lblTotalAmountPay" runat="server">Total Amount </asp:Label>
                <div class="input-group">
                    <span class="input-group-addon">USD</span>
                    <asp:TextBox ID="txtTotalAmountPay" ReadOnly="true" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblIssueDate" runat="server">Payment Date</asp:Label><span class="star">*</span>
                <div class="input-group TextBoxShadowRequired">
                    <span class="input-group-addon"><span class="glyphicon glyphicon-calendar" aria-hidden="true"></span></span>
                    <asp:TextBox ID="txtIssueDate" ReadOnly="true" runat="server" CssClass="form-control "></asp:TextBox>
                </div>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblCollectedPremium" runat="server">Collected Premium</asp:Label><span class="star">*</span>
                <div class="input-group">
                    <span class="input-group-addon">USD</span>
                    <asp:TextBox ID="txtCollectedPremium" runat="server" CssClass="form-control"></asp:TextBox>
                </div>

            </div>
            <div class="col-md-3">
                <asp:Label ID="lblPaymentReferenceNo" runat="server">Transaction ID</asp:Label><span class="star">*</span>
                <asp:TextBox ID="txtPaymentReferenceNo" runat="server" CssClass="form-control TextBoxShadowRequired"></asp:TextBox>
            </div>



            <div class="col-md-12">
                <div class="btn-group right" role="group">

                    <button type="button" id="bIssueBack" class="btn btn-info button-space" onclick="IssueBack();"><span class="glyphicon glyphicon-arrow-left"></span>&nbsp;&nbsp;Back</button>
                    <button type="button" id="btnIssue" class="btn btn-primary button-space">Issue Policy</button>
                </div>
            </div>

        </div>
    </div>
    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" data-backdrop="static">
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
    <div class="modal fade " id="modalAlert" data-backdrop="static" data-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel">
        <div class="modal-dialog ">
            <div class="modal-content">
                <div class="modal-header">
                    <h1 class="modal-title" id="modalTitle"></h1>

                </div>
                <div class="modal-body">
                    <div class="alert alert-danger modal-body-scroll" role="alert" id="dvMessage">
                        <p id="pErrorMessage"></p>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" id="btnUnderstood" class="btn btn-primary" data-dismiss="modal">Understood</button>
                </div>
            </div>
        </div>
    </div>

    <asp:HiddenField ID="hdfUserName" runat="server" />
    <asp:HiddenField ID="hdfChannelId" runat="server" />
    <asp:HiddenField ID="hdfChannelItemId" runat="server" />
    <asp:HiddenField ID="hdfChannelLocationId" runat="server" />
    <asp:HiddenField ID="hdfTokenUrl" runat="server" />
    <asp:HiddenField ID="hdfAPIUrl" runat="server" />

</asp:Content>

