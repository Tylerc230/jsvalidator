##JSValidator Tech Spec
ATTENTION: This technology has been submitted to the US Patent office by Zynga inc.
###Abstract

JSValidator allows logic to be shared, at run time, between a mobile client and a php server. The same logic can be executed concurrently on the client and the server without duplicating code in each’s respective languages. This allows the client to update the UI immediately, based on user interactions, while allowing the server to validate those user interactions server side.
###Purpose

In client/server architecture, and especially in mobile, the latency of round trip communications can be in the order of seconds. If the UI update is dependant on the server response, any feed back to the user can take many seconds to complete. This leads to a poor user experience because the user has no indication that their action had any consequence and gets no immediate feed back about the the state of the game.

There are a few solutions to this problem. All calculations could be performed on the server. The client would have to wait for a response from the server to be informed about the outcome of his actions. Another solution would be to allow the client to perform the calculations, inform the user of the outcome and then tell the server what the outcome is. The problem here is that a malicious user could spoof communications with the server to award himself with points or levelups that he had not earned. 

The most common solution has been to do all calculations (awarding points, level ups and unlocking features) on the client, in the clients native language, to provide instant feed back to the user. The same exact calculations are run again on the server to update the users world data in the database. The problem with this approach is that the logic must be kept in sync between client and server which is a serious maintenance issue and potential source of bugs.

JSValidator attempts to mitigate these problems by allowing a developer to define logic they want to share between client and server, as Javascript in an XML file. This file is hosted on the server and shared with the client at startup. Both client and server can reference the scripts found in the xml and execute them independently, passing in and returning values in their native languages (see figure 1).

###Interface

On the PHP side, a developer would instantiate a JSValidator instance, supplying the path to the XML containing the scripts (see XML Format below). He would then execute the scripts by passing in a unique key identifying the script and any parameters the script may need to execute.
/**
 * This is the JSValidator constructor
 * @param $scriptXML an xml file containing snippets of java script, identified by a string, along
 *  with any parameters needed to be passed in
 */
function __construct($scriptXML)

	/**
	 * This method executes a snippet of Javascipt, returning the outcome.
	 * @param 1: a unique string identifying the script.
	 * @params: 2 - (N - 1) scalar variables passed to the script as parameters.
	 * @return the result of the script as a string.
	 */
function executeScript()

	The iOS interface is almost identical. The only difference is that JSValidator is passed a URL to the xml file.
	/**
	 * This method downloads and parses the XML containing the Javascripts, storing them in a 
	 * format that is easily consumed.
	 * @param url the url to the XML located on the server.
	 */
	- (void)setXMLURL:(NSString *)url;

	/**
	 * This method executes a snippet of Javascript and returns the outcome as a string.
	 * @param jsId String identifying the Javascript snippet in the XML.
	 * @param … variable length args passed on to the Javascript as parameters.
	 * @return a string representing the result of the calculation.
	 */
	- (id)executeScript:(NSString*)jsId, …
	XML Format

	The format is:
	<scripts>
		<row>
			<id>key</id>
			<params>
				<param>param1</param>
				<param>param2</param>
			</params>
			<script>
				javascript snippet
			</script>
		</row>
	</scripts>

		key is a string unique to the file used to identify the script in code
		param the names of parameters passed to the javascript, the javascript will reference these names to do its calculations.
		javascript snippet Your actual javascript. The last line should start with “retVal =” . “retVal” is what is returned back to the calling native code.
		eg.
	<scripts>
		<row>
			<id>add</id>
			<params>
				<param>A</param>
				<param>B</param>
			</params>
			<script>retVal = A + B;</script>
		</row>
		<row>
			<id>multi</id>
			<params>
				<param>A</param>
				<param>B</param>
			</params>
			<script>retVal = A * B;</script>
		</row>
	</scripts>

	##An Example

	Lets suppose I am working on a farming game. The desired functionality is that the amount of XP (Experience Points) awarded to the user for harvesting crops is based on the number of crops just harvested as well as his current level. For level 0 - 10 the user is awarded (number of crops harvested * 1), for levels 11 - 20 he is awarded (number of crops harvested * 5) and if the user is level 21 and up he receives (number of crops harvested * 10) XP. This would be modeled in XML as follows (we’ll call it ‘js.xml’):
		<row>
		 <id>xpAwardedForCropsAtLevel</id>
		 <params>
		 <param>numCropsJustHarvested</param>
		 <param>currentLevel</param>
		 </params>
		 <script>
			 if(currentLevel  &lt;= 10)
				 retVal = numCropsJustHarvested;
			 else if(currentLevel &lt;= 20)
				 retVal = numCropsJustHarvested * 5;
			 else 
				 retVal = numCropsJustHarvested * 10;
		 </script>
	 </row>
		 NB: One limitation of using XML is that certain characters (ie. less than, greater than signs) must be escaped.

		 Your iOS code would look like:

		 JSValidator * jsv = [[JSValidator alloc] init];
		 [jsv setXMLURL:@”http://myremoteserver/js.xml”];
		 int xpAwarded = [[jsv executeScript:@”xpAwardedForCropsAtLevel”, numHarvestedCrops, currentLevel, nil] intValue];
		 ...Update the UI and send the number of crops harvested to the server...

		 Once the number of crops harvested was received by the server, your PHP would look like this:

		 $jsv = new JSValidator(“js.xml”);
		 $xpAwarded = $jsv->executeScript(“xpAwardedForCropsAtLevel”, $user->currentLevel, $harvestedCrops);
		 ...Update the user blob with the new value for xpAwarded...

		 The beauty of this solution is that if the formula for XP changes, all we have to do is update the XML. The client simply downloads the latest scripts and can use them immediately. We don’t have to wait for a client push, which in Apple’s case, can take up to a month to reach the app store not including user upgrade time.
		 Technologies Leveraged

		 On the server side, I am using the PHP Spidermonkey extension. This gives PHP access to the same Javascript engine found in the Firefox browser amongst many other projects. On the client side, I am utilizing the built in iOS Javascript engine used by Safari.
		 Future Plans

		 Support for more complex types (arrays, JSON objects) as parameters.
		 More type validation on parameters passed in to scripts.
		 Return value of type specified in XML not just strings.
		 Port to other languages/platforms.

		 (Figure 1)</script></param></param></params></id></row></script></param></param></params></id></row></script></param></param></params></id></row></scripts></script></param></param></params></id></row></scripts>
