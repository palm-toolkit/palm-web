
  	<@security.authorize access="isAuthenticated()">
	<li>
		<a href="user" id="user_button" title="User profile"><i class="fa fa-user"></i><strong>Profile</strong></a>
	</li>
	<li>
		<a href="logout" id="signout_button" title="Logout"><i class="fa fa-sign-out"></i></a>
	</li>
  	</@security.authorize>

	<@security.authorize access="isAnonymous()">
	<li>	
		<a href="#" id="signin_button" onclick="$.PALM.popUpAjaxModal.load( 'login?form=true' )"><i class="fa fa-sign-in"></i><strong> Sign in</strong></a>
	</li>
	</@security.authorize>
  
  
  <#-- if already login -->
  <#--
  <li class="dropdown user user-menu">
    <a href="#" class="dropdown-toggle" data-toggle="dropdown">
      <img src="dist/img/user2-160x160.jpg" class="user-image" alt="User Image"/>
      <span class="hidden-xs">Alexander Pierce</span>
    </a>
    <ul class="dropdown-menu">
      <li class="user-header">
        <img src="dist/img/user2-160x160.jpg" class="img-circle" alt="User Image" />
        <p>
          Alexander Pierce - Web Developer
          <small>Member since Nov. 2012</small>
        </p>
      </li>
      <!-- Menu Body -->
      <#--
      <li class="user-body">
        <div class="col-xs-4 text-center">
          <a href="#">Followers</a>
        </div>
        <div class="col-xs-4 text-center">
          <a href="#">Sales</a>
        </div>
        <div class="col-xs-4 text-center">
          <a href="#">Friends</a>
        </div>
      </li>
      -->
      <!-- Menu Footer-->
      <#--
      <li class="user-footer">
        <div class="pull-left">
          <a href="#" class="btn btn-default btn-flat">Profile</a>
        </div>
        <div class="pull-right">
          <a href="#" class="btn btn-default btn-flat">Sign out</a>
        </div>
      </li>
    </ul>
  </li>
  -->