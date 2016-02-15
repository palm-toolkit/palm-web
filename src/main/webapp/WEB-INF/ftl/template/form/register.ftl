<div class="register-box shadow-dialog">
  <div class="register-logo">
  	<div class="dialog-close-container"><i class="dialog-close-button fa fa-times" onclick="$.PALM.popUpAjaxModal.remove()"></i></div>
    <a href="#"><strong>PALM</strong> Registration</a>
  </div>

  <div class="register-box-body">
    <#--<p class="login-box-msg">Register a new membership</p>-->
    <form id="register-form" action="<@spring.url '/register' />" method="post">
      <div class="form-group has-feedback">
        <input type="text" name="name" id="name" class="form-control" placeholder="Full name"/>
        <span class="glyphicon glyphicon-user form-control-feedback"></span>
      </div>
      <div class="form-group has-feedback">
        <input type="text" name="username" id="username" class="form-control" placeholder="Email"/>
        <span class="glyphicon glyphicon-envelope form-control-feedback"></span>
      </div>
      <div class="form-group has-feedback">
        <input type="password" name="password" id="password" class="form-control" placeholder="Password"/>
        <span class="glyphicon glyphicon-lock form-control-feedback"></span>
      </div>
      <div class="form-group has-feedback">
        <input type="password" name="repassword" id="repassword"  class="form-control" placeholder="Retype password"/>
        <span class="glyphicon glyphicon-log-in form-control-feedback"></span>
      </div>
      <div class="row">
       <#--
        <div class="col-xs-8">    
          <div class="checkbox icheck">
            <label>
              <input type="checkbox"> I agree to the <a href="#">terms</a>
            </label>
          </div>                        
        </div><!-- /.col -->
        <div class="col-xs-4">
          <button id="submit" type="submit" class="btn btn-primary btn-block btn-flat">Register</button>
        </div><!-- /.col -->
      </div>
    </form>        
	
	<#--
    <div class="social-auth-links text-center">
      <p>- OR -</p>
      <a href="#" class="btn btn-block btn-social btn-facebook btn-flat"><i class="fa fa-facebook"></i> Sign up using Facebook</a>
      <a href="#" class="btn btn-block btn-social btn-google-plus btn-flat"><i class="fa fa-google-plus"></i> Sign up using Google+</a>
    </div>
	-->
	
    <a href="#" onclick="$.PALM.popUpAjaxModal.load( 'login?form=true' )" class="text-center">I've already registered</a>
  </div><!-- /.form-box -->
</div><!-- /.register-box -->

<script>
  $(function () {
  		<#-- activate input mask-->
		// validate signup form on keyup and submit
		$("#register-form").validate({
			rules: {
				name: "required",
				username: {
					required: true,
					email: true,
					remote:{
						url:"<@spring.url '/userapi/isUsernameNotExist' />",
						type:"get",
						data: {
				          	username: function() {
				            	return $( "#username" ).val();
				          	}
				        }
					}
				},
				password: {
					required: true,
					minlength: 3
				},
				repassword: {
					required: true,
					minlength: 3,
					equalTo: "#password"
				}
			},
			messages: {
				name: "Please enter your name",
				username: {
					required: "Please provide an email",
					email: "Please enter a valid email address",
					remote: "Email is already registered"
				},
				password: {
					required: "Please provide a password",
					minlength: "Your password must be at least 3 characters long"
				},
				repassword: {
					required: "Please provide a password",
					minlength: "Your password must be at least 3 characters long",
					equalTo: "Please enter the same password as above"
				}
			}, submitHandler: function(form) {
				<#-- send via ajax -->
				$.post( $("#register-form").attr( "action" ), $("#register-form").serialize(), function( data ){
					<#-- todo if error -->
	
					<#-- if status ok (regitered successfully )-->
					if( data.status == "ok" ){
						<#-- reload main page with target author -->
						$.PALM.popUpAjaxModal.load( 'login?form=true&info=success-register' )
					}
				});
			}
		});

  		<#-- jquery post on button click -->
		//$( "#submit" ).click( function( e ){
			//e.preventDefault();
			<#-- todo check input valid -->

			
		//});
				
		//function validateEmail(email) {
		//    var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
		//    return re.test(email);
		//}
		
  	<#--
    $('input').iCheck({
      checkboxClass: 'icheckbox_square-blue',
      radioClass: 'iradio_square-blue',
      increaseArea: '20%' // optional
    });
    -->
  });
</script>