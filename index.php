<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Room Monitoring</title>
<link href="css/styles.css" rel="stylesheet" type="text/css" />
</head>

<body>
<div id="wrapper">
<h2>Room Monitoring System</h2>
<div id="room">
<h1>Room 1</h1>
<?php
	$filename='falldetect/1.gif';
	if (file_exists($filename)==0) {
		echo '<img src="images/clear.png" alt="Room is clear" />';
	    echo '<p>Room 1 is clear</p>';
	} else {
		$file_basename = substr($filename, 0, strripos($filename, '.')); // strip extention
		$file_basename = substr($file_basename, strripos($filename, '/'));
		$file_ext = substr($filename, strripos($filename, '.')); // strip name
		$today = date("Ymd");// Find Date
		$newfilename=$file_basename .'_' . $today . $file_ext;
		copy ($filename,'archive/'.$newfilename);
	    echo '<img src="falldetect/1.gif"/><br>';
		echo '<p class="error">A fall has occured in Room 1!</p>';
		
	}

?>
</div>
<div id="room">
<h1>Room 2</h1>
<?php
	$filename2='falldetect/2.gif';
	if (file_exists($filename2)==0) {
		echo '<img src="images/clear.png" alt="Room is clear" />';
	    echo '<p>Room 2 is clear</p>';
	} else {
		$file_basename = substr($filename2, 0, strripos($filename2, '.')); // strip extention
		$file_basename = substr($file_basename, strripos($filename2, '/'));
		$file_ext = substr($filename2, strripos($filename2, '.')); // strip name
		$today = date("Ymd");// Find Date
		$newfilename=$file_basename .'_' . $today . $file_ext;
		copy ($filename2,'archive/'.$newfilename);
	    echo '<img src="falldetect/2.gif"/><br>';
		echo '<p class="error">A fall has occured in Room 2!</p>';
		
	}

?>
</div>
<div id="clear"></div>
<div id="room">
<h1>Room 3</h1>
<?php
	$filename1='falldetect/3.gif';
	if (file_exists($filename1)==0) {
		echo '<img src="images/clear.png" alt="Room is clear" />';
	    echo '<p>Room 3 is clear</p>';
	} else {
		$file_basename = substr($filename3, 0, strripos($filename3, '.')); // strip extention
		$file_basename = substr($file_basename, strripos($filename3, '/'));
		$file_ext = substr($filename3, strripos($filename3, '.')); // strip name
		$today = date("Ymd");// Find Date
		$newfilename=$file_basename .'_' . $today . $file_ext;
		copy ($filename3,'archive/'.$newfilename);
	    echo '<img src="falldetect/3.gif"/><br>';
		echo '<p class="error">A fall has occured in Room 3!</p>';
		
	}

?>
</div>

<div id="room">
<h1>Room 4</h1>
<?php
	$filename4='falldetect/4.gif';
	if (file_exists($filename4)==0) {
		echo '<img src="images/clear.png" alt="Room is clear" />';
	    echo '<p>Room 4 is clear</p>';
	} else {
		$file_basename = substr($filename4, 0, strripos($filename4, '.')); // strip extention
		$file_basename = substr($file_basename, strripos($filename4, '/'));
		$file_ext = substr($filename4, strripos($filename4, '.')); // strip name
		$today = date("Ymd");// Find Date
		$newfilename=$file_basename .'_' . $today . $file_ext;
		copy ($filename4,'archive/'.$newfilename);
	    echo '<img src="falldetect/4.gif"/><br>';
		echo '<p class="error">A fall has occured in Room 4!</p><br>';
		
	}

?>
</div>
<h2>Detected Fall Log</h2>
<?php
$path = "falldetect";

if(isset($_POST['file']) && is_array($_POST['file']))
{
	foreach($_POST['file'] as $file)
	{	
		unlink($path . "/" . $file) or die("Failed to delete file");
	}
}
?>
<form name="form1" method="post">
<?php
$path = "falldetect";
$dir_handle = @opendir($path) or die("Unable to open folder");

while (false !== ($file = readdir($dir_handle))) {

if($file == "index.php")
continue;
if($file == ".")
continue;
if($file == "..")
continue;
echo "<div id='falls'>";
echo "<img src='falldetect/$file' alt='$file'><br />";
echo "<input type='CHECKBOX' name='file[]' value='$file' class='radio'>";
echo "(Select to Archive Screenshot)";
echo "<p>Room $file</p>";
echo "</div>";
}
closedir($dir_handle);
?>
<div id="buttons">
<input type="submit" name="Delete" value="Archive Falls" class="btn">
<input type="button" value="Reload Page" onClick="window.location='http://www.akshayp.com/stuff/index.php';" class="btn">
</div>
</form>
</div>
</div>
</body>
</html>
