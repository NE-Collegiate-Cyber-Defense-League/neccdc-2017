<div id="header">
	<img id="logo" src="images/Logo.png" />
	<div id="menu">
		<ul class="navlinks">
			<li class="navlink"><div id="spacer"></div></li>
			<li class="navlink"><a href="index.php">Home</a></li>
			<li class="navlink"><a href="index.php?page=about.php">About</a></li>
			<li class="navlink"><a href="index.php?page=rankings.php">Rankings</a></li>
			<li class="navlink"><a href="index.php?page=standings.php">Standings</a></li>
			
			<?php if(isset($session['logged_in']) and $session['logged_in'] == True){
			echo '
                        <li class="navlink"><a href="index.php?page=my_fantasy.php">My Fantasy</a></li>
                        <li class="navlink"><a href="index.php?page=settings.php">Settings</a></li>
			<li class="navlink"><a href="index.php?page=my_team.php">My Team</a></li>
			';
			}?>
		</ul>
	</div>
	<div id="signin">
		<?php 
		if(isset($session['logged_in']) and $session['logged_in'] == True){
			echo 'Welcome ' . ucfirst($session['username']) ." - <a href='signout.php'>Sign Out</a>";
		}else{
			echo '<a href="index.php?page=signin.html"><button id="signin-button">Sign In</button></a>';
		}
		?>
	</div>
</div>
