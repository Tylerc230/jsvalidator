<?php
require_once("jsvalidator.php");
$validator = new JSValidator("js.xml");
$jsIds = array("add", "multi", "div");
foreach($jsIds as $jsId)
{
	echo "Script: $jsId ".$validator->executeScript($jsId, 3, 4)."\n";
}
$arr = array(3,1);
echo "Script: sumArr ".$validator->executeScript("sumArr",$arr); 

