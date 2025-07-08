

function ShowError(sms) {
    if (sms != '') {
        document.getElementById('pErrorMessage').innerHTML = sms;
        //$('#dvError').show();
        $('#modalTitle').html('<span class="glyphicon glyphicon-remove color-error"></span> ERROR MESSAGE');
        $('#dvMessage').removeClass('alert alert-success');
        $('#dvMessage').addClass('alert alert-danger');
        $('#modalAlert').modal('show');
    }
}

function ShowErrorRedirect(sms, buttonText, url) {
    if (sms != '') {
     
        document.getElementById('btnUnderstood').innerHTML = buttonText;
        document.getElementById('pErrorMessage').innerHTML = sms;
        $('#modalTitle').html(' <span class="glyphicon glyphicon-remove color-error"></span> ERROR MESSAGE');
        $('#dvMessage').removeClass('alert alert-success alert-warning');
        $('#dvMessage').addClass('alert alert-danger');
        $('#modalAlert').modal('show');
     
        $('#btnUnderstood').click(function () {
            window.open(url, "_self");
        });
    }
    
}

function ShowSuccessRedirect(sms, buttonText, url) {
    if (sms != '') {

        document.getElementById('btnUnderstood').innerHTML = buttonText;
        document.getElementById('pErrorMessage').innerHTML = sms;
        $('#modalTitle').html('<span class="glyphicon glyphicon-ok color-success"></span> SUCCESS');
        $('#dvMessage').removeClass('alert alert-danger alert-warning');
        $('#dvMessage').addClass('alert alert-success');
        $('#modalAlert').modal('show');

        $('#btnUnderstood').click(function () {
            window.open(url, "_self");
        });
    }

}

function ShowSuccess(sms) {
    if (sms != '') {
        document.getElementById('pErrorMessage').innerHTML = sms;
        //$('#dvError').show();
        $('#modalTitle').html('<span class="glyphicon glyphicon-ok color-success"></span> SUCCESS');
        $('#dvMessage').removeClass('alert alert-danger alert-warning');
        $('#dvMessage').addClass('alert alert-success');
        $('#modalAlert').modal('show');
    }
}

function ShowWarning(sms) {
    if (sms != '') {
        document.getElementById('pErrorMessage').innerHTML = sms;
        //$('#dvError').show();
        $('#modalTitle').html('<span class="glyphicon glyphicon-warning-sign color-warning"></span> WARNING');
        $('#dvMessage').removeClass('alert alert-success alert-danger');
        $('#dvMessage').addClass('alert alert-warning');
        $('#modalAlert').modal('show');
    }
}

function ShowInfor(sms) {
    if (sms != '') {
        document.getElementById('pErrorMessage').innerHTML = sms;
        //$('#dvError').show();
        $('#modalTitle').html('<span class="glyphicon glyphicon-warning-sign color-warning"></span> INFORMATION');
        $('#dvMessage').removeClass('alert alert-success alert-danger');
        $('#dvMessage').addClass('alert alert-warning');
        $('#modalAlert').modal('show');
    }
}

function ShowProgress(t)
{
    if (t == null) {
        $('#myModal').modal('show');
    }
    else {
        document.getElementById('pMessage').innerHTML = message;
        $('#myModal').modal('show');
    }
}
function ShowProgressWithMessage(message) {
   
    document.getElementById('pMessage').innerHTML = message;
    $('#myModal').modal('show');
}
function HideProgress() {
    $('#myModal').modal('hide');
}

function setCookie(cName, cValue, Exdays) {
    d = new Date();
    d.setTime(d.getTime() + (Exdays * 24 * 60 * 60 * 1000));
    var expires = "expires=" + d.toUTCString();
    document.cookie = cName + "=" + cValue + ";" + expires + ";path=/";
}

function setCookie1(cName, cValue, Exdays) {
    d = new Date();
    d.setTime(d.getTime() + (Exdays * 24 * 60 * 60 * 1000));
    var expires = "expires=" + d.toUTCString();
    document.cookie = cName + "=" + cValue + ";" + expires + ";path=/";
}

function getCookie(cname) {
  //  var name = cname + "=";
  ////  var decodedCookie = decodeURIComponent(document.cookie);
  //  var ca = decodedCookie.split(';');
  //  for (var i = 0; i < ca.length; i++) {
  //      var c = ca[i];
  //      while (c.charAt(0) == ' ') {
  //          c = c.substring(1);
  //      }
  //      if (c.indexOf(name) == 0) {
  //          return c.substring(name.length, c.length);
  //      }
  //  }
  //  //return "";


    var agent = response.Detail.Agent;
    var name = cname+"=";
    var ca = document.cookie.split(';');

    for (var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') c = c.substring(1);
        if (c.indexOf(name) == 0) return c.substring(name.length, c.length);
    }
}



function GetCookieValue(check_name) {
    var a_all_cookies = document.cookie.split(';');
    var a_temp_cookie = '';
    var cookie_name = '';
    var cookie_value = '';
    var b_cookie_found = false; // set boolean t/f default f
    var val = '';
    for (i = 0; i < a_all_cookies.length; i++) {
        // now we'll split apart each name=value pair
        a_temp_cookie = a_all_cookies[i].split('=');
        // and trim left/right whitespace while we're at it
        cookie_name = a_temp_cookie[0].replace(/^\s+|\s+$/g, '');
        // if the extracted name matches passed check_name
        if (cookie_name == check_name) {
            b_cookie_found = true;
            // we need to handle case where cookie has no value but exists (no = sign, that is):
            if (a_temp_cookie.length > 1) {
                cookie_value = unescape(a_temp_cookie[1].replace(/^\s+|\s+$/g, ''));
            }
            // note that in cases where cookie is initialized but no value, null is returned
            //alert(cookie_value);
            val = cookie_value;
            break;
        }
        a_temp_cookie = null;
        cookie_name = '';
    }
    if (!b_cookie_found) {
        // alert('No data Found');
        val = '';
    }

    return val
}


function GetCookieValue1(check_name) {
    var a_all_cookies = document.cookie.split(';');
    var a_temp_cookie = '';
    var cookie_name = '';
    var cookie_value = '';
    var b_cookie_found = false; // set boolean t/f default f
    var val = '';
    for (i = 0; i < a_all_cookies.length; i++) {
        // now we'll split apart each name=value pair
        a_temp_cookie = a_all_cookies[i].split('=');
        // and trim left/right whitespace while we're at it
        cookie_name = a_temp_cookie[0].replace(/^\s+|\s+$/g, '');
        // if the extracted name matches passed check_name
        if (cookie_name == check_name) {
            b_cookie_found = true;
            // we need to handle case where cookie has no value but exists (no = sign, that is):
            if (a_temp_cookie.length > 1) {
                cookie_value = unescape(a_temp_cookie[1].replace(/^\s+|\s+$/g, ''));
            }
            // note that in cases where cookie is initialized but no value, null is returned
            //alert(cookie_value);
            val = cookie_value;
            break;
        }
        a_temp_cookie = null;
        cookie_name = '';
    }
    if (!b_cookie_found) {
        // alert('No data Found');
        val = '';
    }

    return JSON.parse(val);
}

function GetPageAccess(pageName)
{
    var obj = JSON.parse(sessionStorage.getItem('SESSION_LOGIN'));
    var result;
    $.each(obj.RoleAccess, function (i, val) {
      
       
        if (pageName == val.ObjectCode)
        {
            pubPageAccess = { ObjectCode: val.ObjectCode, IsView: val.IsView };

            result = obj.RoleAccess[i];
            return false /*exit loop*/
           
        }
    });
  
    return result;
   
}
