<div class="login-box shadow-dialog">
  <div class="login-logo">
  	<div class="dialog-close-container"><i class="dialog-close-button fa fa-times" onclick="$.PALM.popUpAjaxModal.remove()"></i></div>
    <a href="../../index2.html"><strong>PALM</strong> sign in</a>
  </div><#-- /.login-logo -->
  <div class="login-box-body">
    <#--<p class="login-box-msg">Sign in to start your session</p>-->
    <form name="f" action="<@spring.url '/login' />" method="POST">
		
	<#if auth?? && auth=="fail">
			<div class="alert alert-danger alert-dismissable">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h4><i class="icon fa fa-ban"></i> Error!</h4>
				Invalid Username or Password
			</div>
    </#if>
	<#if info?? && info="success-register">
			<div class="alert alert-success alert-dismissable">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				<h4><i class="icon fa fa-check"></i>You've successfully registered</h4>
				Now please login to complete your profile.
			</div>
	</#if>

      <div class="form-group has-feedback">
        <input type="text" name="j_username" class="form-control" placeholder="Email"/>
        <span class="glyphicon glyphicon-envelope form-control-feedback"></span>
      </div>
      <div class="form-group has-feedback">
        <input type="password" name="j_password" class="form-control" placeholder="Password"/>
        <span class="glyphicon glyphicon-lock form-control-feedback"></span>
      </div>
      <div class="row">
      	<#--
        <div class="col-xs-8">    
          <div class="checkbox icheck">
            <label>
              <input type="checkbox"> Remember Me
            </label>
          </div>                        
        </div><#-- /.col -->
        <div class="col-xs-4">
          <#--<button type="submit" class="btn btn-primary btn-block btn-flat">Sign In</button>-->
          <input name="submit" class="btn btn-primary btn-block btn-flat" type="submit" value="Sign in"/>
        </div><#-- /.col -->
      </div>
    </form>
	
	<#--
    <div class="social-auth-links text-center">
      <p>- OR -</p>
      <a href="#" class="btn btn-block btn-social btn-facebook btn-flat"><i class="fa fa-facebook"></i> Sign in using Facebook</a>
      <a href="#" class="btn btn-block btn-social btn-google-plus btn-flat"><i class="fa fa-google-plus"></i> Sign in using Google+</a>
    </div>
	-->
	
    <a href="#">I forgot my password</a><br>
    <a id="register_link" href="#"  onclick="$.PALM.popUpAjaxModal.load( 'register' )" class="text-center">Register a new membership</a>

  </div><#-- /.login-box-body -->
</div><#-- /.login-box -->
	    
<script>
  $(function () {
    $('input').iCheck({
      checkboxClass: 'icheckbox_square-blue',
      radioClass: 'iradio_square-blue',
      increaseArea: '20%' // optional
    });
  });
</script>