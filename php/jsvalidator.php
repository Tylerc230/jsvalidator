<?php

class JSValidator
{
	function __construct($protoScripts)
	{
		$this->scripts = $this->parseScripts($protoScripts);
	}

	function parseScripts($xmlFile)
	{
		$xml = simplexml_load_file($xmlFile);
		if(isset($xml->row))
		{
			$scripts = array();
			foreach($xml->row as $scriptRow)
			{
				$script = array();
				$jsId = (string)$scriptRow->id;
				$script["id"] = $jsId;
				$script["script"] = (string)$scriptRow->script;
				$script["params"] = $this->parseParams($scriptRow->params);
				$scripts[$jsId] = $script;

			}
			return $scripts;
		}
	}

	function parseParams($paramsXML)
	{
		if(isset($paramsXML->param))
		{
			$params = array();
			foreach($paramsXML->param as $paramRow)
			{
				$params[] = (string)$paramRow;
			}
			return $params;
		}

	}

	function executeScript()
	{
		$numArgs = func_num_args();
		$argList = func_get_args();
		$jsId = $argList[0];
		$script = $this->scripts[$jsId]["script"];
		$params = $this->scripts[$jsId]["params"];
		if(count($params) != $numArgs - 1)
			throw new Exception("Wrong number of params supplied to executeScript");

		$js = new JSContext();
		for($i = 1; $i < $numArgs; $i++)
		{
			$js->assign($params[$i - 1], $argList[$i]);
		}
		return $js->evaluateScript($script);

	}

	var $scripts;
}

