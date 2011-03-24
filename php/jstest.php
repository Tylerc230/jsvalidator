<?php
require_once("jsvalidator.php");
$validator = new JSValidator("js.xml");
$jsIds = array(1, 2, 3);

foreach($jsIds as $jsId)
	echo "Script #: $jsId ".$validator->executeScript($jsId, 3, 4)."\n";


