<html>
	<?php include_once("session.php"); ?>
	<?php include("includes.html"); ?>
	<body>
		<?php 
		if(!isset($_GET['page'])){
			$site = "home.php";
		}else{
			$site = $_GET['page'];
		}
		?>
		<?php include("header.php"); ?>
		<?php include($site); ?>
		<?php include("footer.html"); ?>
	</body>
</html>