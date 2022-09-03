let ActiveButton = "#1";
let secretKey = ""
window.addEventListener('message', function(event) {
   let data = event.data;
   switch (data.event) {
       case 'login':
         $("body").fadeIn();
         $("#container").fadeIn();
         break;

       case 'hide':
         $("body, #container").hide();
         break;

       case 'notify':
         $("#notify-message").html(data.msg);
         $("#notify").fadeIn();
         setTimeout(() => {
            $("#notify").fadeOut();
         }, 3000);
   }
});

function Reset(){
   $("#login-site, #register-site, #forgot-password-site").hide();
   $("#login-username, #login-pass, #register-username, #register-pass, #sKey").val('')
}

function OpenForm(form) {
   Reset();
   if(form=="login"){
      $("#login-site").fadeIn();
   }else {
      $("#register-site").fadeIn();
   }
}

function GenerateSecretKey(length) {
   var result           = '';
   var characters       = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
   var charactersLength = characters.length;
   for ( var i = 0; i < length; i++ ) {
     result += characters.charAt(Math.floor(Math.random() * 
   charactersLength));
  }
  return result;
}

$("#1").click(function(){
   $(ActiveButton).removeClass("active");
   ActiveButton = "#1";
   $(ActiveButton).addClass("active");
   OpenForm("login");
})

$("#2").click(function(){
   $(ActiveButton).removeClass("active");
   ActiveButton = "#2";
   $(ActiveButton).addClass("active");
   secretKey = GenerateSecretKey(4)
   $("#secretkey").html(secretKey)
   OpenForm("register");
})

$("#register-button").click(function(){
   let username = $("#register-username").val();
   let password = $("#register-pass").val();
   $.post("https://esegovic_login/NUI.Register", JSON.stringify({
      username: username,
      password: password,
      secretKey: secretKey
   }))
   $("#register-username, #register-pass").val('')
})

$("#login-button").click(function(){
   let username = $("#login-username").val();
   let password = $("#login-pass").val();
   $.post("https://esegovic_login/NUI.Login", JSON.stringify({
      username: username,
      password: password
   }))
})

$("#password-forgot").click(function(){
   Reset();
   $("#forgot-password-site").fadeIn();
})

$("#delete-account").click(function(){
   $.post("https://esegovic_login/NUI.DeleteAccount", JSON.stringify({}))
   Reset();
   OpenForm("login");
})

$("#reset-pass").click(function(){
   let sKey = $("#sKey").val();
   $.post("https://esegovic_login/NUI.ResetPassword", JSON.stringify({
      key: sKey
   }))
   Reset();
   OpenForm("login");
})