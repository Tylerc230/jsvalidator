<?php
require_once("jsvalidator.php");
$validator = new JSValidator("js.xml");


echo "script 0 = ".$validator->executeScript(1, 8, 9);
echo "script 0 = ".$validator->executeScript(1, 3, 4);


