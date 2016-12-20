<div id="boxbody-${wUniqueName}" class="box-body no-padding">
	<div class="similar_researchers"></div>
</div>
<script>
	$( function(){
		<#-- add slim scroll -->
       $("#boxbody-${wUniqueName}>.similar_researchers").slimscroll({
			height: "300px",
	        size: "6px",
			allowPageScroll: true,
   			touchScrollStep: 50//,
   			//railVisible: true,
    		//alwaysVisible: true
	    });
	    
	    <#-- generate unique id for progress log -->
		var uniquePidSimilarResearchers = $.PALM.utility.generateUniqueId();	
		

		  
		  data = {
  "author": {
    "id": "88267d19-2ec7-4076-9aa0-bbffbf1235f9",
    "name": "Christopher D Manning",
    "photo": "http://nlp.stanford.edu/manning/images/Christopher_Manning_027_132x132.jpg",
    "affiliation": {
      "country": "United States",
      "institution": "Stanford University"
    },
    "isAdded": true,
    "institutionAffiliation": "same",
    "index": 0,
    "x": 341.8640023949088,
    "y": 149.47557503892742,
    "vy": -0.0001861195870579904,
    "vx": 0.0002148423333087106,
    "radius": 10,
    "fixed": true
  },
  "countTotal": 285,
  "count": 30,
  "coAuthors": [
    {
      "id": "d6d11ff3-791a-461e-b4b4-69d3f9714a19",
      "name": "daniel zeman",
      "photo": "http://nlp.stanford.edu/manning/images/Christopher_Manning_027_132x132.jpg",
      "isAdded": false,
      "coauthorTimes": 1,
      "commonInterests": [],
      "index": 1,
      "x": 325.6447892100572,
      "y": 182.29184998713515,
      "vy": -0.00019276471175642794,
      "vx": 0.00009166232001788042,
      "radius": 11,
      "angle": 0.20943951023931953,
      "fixed": true,
      "similarity" : 0.8
    },
    {
      "id": "e32fd5e4-3144-4d0a-9800-f68ad27ce386",
      "name": "miriam connor",
      "isAdded": false,
      "coauthorTimes": 3,
      "commonInterests": [],
      "index": 2,
      "x": 357.89365302028085,
      "y": 107.47211348005865,
      "vy": -0.00020974353214949385,
      "vx": 0.0002724186734248695,
      "radius": 13,
      "angle": 0.41887902047863906,
      "fixed": true,
      "similarity" : 0.9
    },
    {
      "id": "94ac45de-902b-405b-8ec0-3a5e5d637ff9",
      "name": "chlo  kiddon",
      "isAdded": false,
      "coauthorTimes": 2,
      "commonInterests": [],
      "index": 3,
      "x": 367.5397414649646,
      "y": 114.90542423694953,
      "vy": -0.00018460835072642827,
      "vx": 0.0003143989147224432,
      "radius": 12,
      "angle": 0.6283185307179586,
      "fixed": true,
      "similarity" : 0.74
    },
    {
      "id": "5937a354-0d52-410a-a24e-4fc93da6fbe4",
      "name": "margaret m collins",
      "isAdded": false,
      "coauthorTimes": 2,
      "commonInterests": [],
      "index": 4,
      "x": 386.46442918441534,
      "y": 145.94128562124888,
      "vy": -0.00015695189532930962,
      "vx": 0.0002318562344508886,
      "radius": 12,
      "angle": 0.8377580409572781,
      "fixed": true,
      "similarity" : 1
    },
    {
      "id": "72adb04c-22c6-44c4-9c59-b3807da2c5b9",
      "name": "jason bolton",
      "isAdded": false,
      "coauthorTimes": 2,
      "commonInterests": [],
      "index": 5,
      "x": 381.795875322981,
      "y": 128.250011342952,
      "vy": -0.00020307547111192737,
      "vx": 0.00018848380462383867,
      "radius": 12,
      "angle": 1.0471975511965976,
      "fixed": true,
      "similarity" : 0.7
    },
    {
      "id": "121eb4be-095b-4d77-b0cc-4108172997fc",
      "name": "roger levy",
      "isAdded": false,
      "coauthorTimes": 8,
      "commonInterests": [],
      "index": 6,
      "x": 371.1629455336942,
      "y": 124.62970427987771,
      "vy": -0.000081058030433121,
      "vx": 0.00011524415950512923,
      "radius": 18,
      "angle": 1.2566370614359172,
      "fixed": true,
      "similarity" : 0.66
    },
    {
      "id": "38847f84-2d6e-4d83-80d8-bc2a27df3009",
      "name": "stuart m shieber",
      "isAdded": false,
      "coauthorTimes": 4,
      "commonInterests": [],
      "index": 7,
      "x": 376.98484765342397,
      "y": 139.02608237689654,
      "vy": -0.00014530688864575168,
      "vx": 0.00022336810558913476,
      "radius": 14,
      "angle": 1.4660765716752369,
      "fixed": true,
      "similarity" : 0.67
    },
    {
      "id": "778ab298-0d20-49c0-a286-46917378cf0f",
      "name": "joshua walker",
      "isAdded": false,
      "coauthorTimes": 2,
      "commonInterests": [],
      "index": 8,
      "x": 378.2069212118084,
      "y": 155.086472011494,
      "vy": -0.00016948802113833306,
      "vx": 0.0001875865711743825,
      "radius": 12,
      "angle": 1.6755160819145563,
      "fixed": true,
      "similarity" : 0.89
    },
    {
      "id": "677747aa-85e8-4cc3-87e9-b0306388a647",
      "name": "michael collins",
      "isAdded": false,
      "coauthorTimes": 2,
      "commonInterests": [],
      "index": 9,
      "x": 384.60082136453826,
      "y": 163.77505319035484,
      "vy": -0.0001404335873564199,
      "vx": 0.00011959388714793024,
      "radius": 12,
      "angle": 1.8849555921538759,
      "fixed": true,
      "similarity" : 0.95
    },
    {
      "id": "36794325-bb02-4bca-b30f-dad23ec23d09",
      "name": "kenneth heafield",
      "isAdded": false,
      "coauthorTimes": 4,
      "commonInterests": [],
      "index": 10,
      "x": 378.35589119056567,
      "y": 177.12272742119538,
      "vy": -0.00029483202477373094,
      "vx": 0.00020942854070112155,
      "radius": 14,
      "angle": 2.0943951023931953,
      "fixed": true,
      "similarity" : 1
    },
    {
      "id": "9c8b6b21-ae22-4d24-ad08-826ee7223d21",
      "name": "brendan m buckley",
      "isAdded": false,
      "coauthorTimes": 2,
      "commonInterests": [],
      "index": 11,
      "x": 369.3981425764372,
      "y": 171.50487836034503,
      "vy": 0.00000945983968599004,
      "vx": -0.00005895772398507753,
      "radius": 12,
      "angle": 2.3038346126325147,
      "fixed": true,
      "similarity" : 0.5
    },
    {
      "id": "070e3dbd-77f2-46b8-b42e-fdbbc128e67f",
      "name": "yoshua bengio",
      "isAdded": false,
      "coauthorTimes": 2,
      "commonInterests": [],
      "index": 12,
      "x": 367.09871913074596,
      "y": 186.4124722598742,
      "vy": -0.00016170950713051096,
      "vx": 0.00016427222236005726,
      "radius": 12,
      "angle": 2.5132741228718345,
      "fixed": true,
      "similarity" : 0.55
    },
    {
      "id": "d5a0900b-d3dc-41fb-8a9d-7e3359e666c3",
      "name": "jeffrey pennington",
      "isAdded": false,
      "coauthorTimes": 6,
      "commonInterests": [],
      "index": 13,
      "x": 355.713298015654,
      "y": 184.07689359286388,
      "vy": -0.00014726847270647904,
      "vx": 0.00011428781328698296,
      "radius": 16,
      "angle": 2.7227136331111543,
      "fixed": true,
      "similarity" : 0.52
    },
    {
      "id": "1d0b57e3-fa06-47e5-9fb1-5567f2393de1",
      "name": "conal sathi",
      "isAdded": false,
      "coauthorTimes": 2,
      "commonInterests": [],
      "index": 14,
      "x": 350.2488846492767,
      "y": 194.64006573297524,
      "vy": -0.00020373906574129347,
      "vx": 0.00007243976201074453,
      "radius": 12,
      "angle": 2.9321531433504737,
      "fixed": true,
      "similarity" : 0.58
    },
    {
      "id": "f86bb73c-95b9-4dcc-9ed6-0589b0c53256",
      "name": "keith siilats",
      "isAdded": false,
      "coauthorTimes": 2,
      "commonInterests": [],
      "index": 15,
      "x": 340.8152953256721,
      "y": 187.52833707654202,
      "vy": -0.00022460313710284568,
      "vx": 0.00005563711856423907,
      "radius": 12,
      "angle": 3.1415926535897927,
      "fixed": true,
      "similarity" : 0.86
    },
    {
      "id": "948c1450-32d3-446d-80dc-6dac719ef113",
      "name": "angel x chang",
      "isAdded": false,
      "coauthorTimes": 28,
      "commonInterests": [],
      "index": 16,
      "x": 331.0678771541387,
      "y": 192.91802943121914,
      "vy": -0.0001326464372130242,
      "vx": 0.00006613896632404565,
      "radius": 38,
      "angle": 3.3510321638291125,
      "fixed": true,
      "similarity" : 0.83
    },
    {
      "id": "e19f92dc-0e28-475e-9109-6bc898a8f748",
      "name": "ezra callahan",
      "isAdded": false,
      "coauthorTimes": 2,
      "commonInterests": [],
      "index": 17,
      "x": 315.57358892675836,
      "y": 186.74945640504686,
      "vy": -0.0003096716623450247,
      "vx": 0.000014130433973880791,
      "radius": 12,
      "angle": 3.5604716740684323,
      "fixed": true,
      "similarity" : 0.77
    },
    {
      "id": "6b6f9258-e7bd-49d0-822c-e492a3e568e4",
      "name": "jason chuang",
      "isAdded": false,
      "coauthorTimes": 20,
      "commonInterests": [],
      "index": 18,
      "x": 313.31032421654584,
      "y": 171.2392085762656,
      "vy": -0.00018509106762566526,
      "vx": 0.0001651632853220169,
      "radius": 30,
      "angle": 3.7699111843077517,
      "fixed": true
    },
    {
      "id": "e446d305-fd2c-4a52-a4ff-7f2858b8e96c",
      "name": "brittany harding",
      "isAdded": false,
      "coauthorTimes": 4,
      "commonInterests": [],
      "index": 19,
      "x": 304.57659092156507,
      "y": 176.16928408500104,
      "vy": -0.00044117844315399795,
      "vx": 0.000015037045533341629,
      "radius": 14,
      "angle": 3.979350694547071,
      "fixed": true,
      "similarity" : 0.2
    },
    {
      "id": "bfd926c6-ac26-4616-b10a-c9ee08b23cad",
      "name": "anthony p fitzgerald",
      "isAdded": false,
      "coauthorTimes": 6,
      "commonInterests": [],
      "index": 20,
      "x": 303.70283182400203,
      "y": 163.29571805885772,
      "vy": -0.0003940993644823394,
      "vx": 0.0002158841396807492,
      "radius": 16,
      "angle": 4.1887902047863905,
      "fixed": true,
      "similarity" : 0.69
    },
    {
      "id": "7d61ec23-895c-437c-b217-4ad31ca387c4",
      "name": "marta recasens",
      "isAdded": false,
      "coauthorTimes": 1,
      "commonInterests": [],
      "index": 21,
      "x": 297.4020089673525,
      "y": 153.8263241192745,
      "vy": -0.0003517006247458743,
      "vx": 0.00014430802872525354,
      "radius": 11,
      "angle": 4.39822971502571,
      "fixed": true,
      "similarity" : 0.92
    },
    {
      "id": "4cdb3450-a280-4de8-b53e-0c731299916d",
      "name": "aitor soroa",
      "isAdded": false,
      "coauthorTimes": 2,
      "commonInterests": [],
      "index": 22,
      "x": 306.4103638223835,
      "y": 145.54879670115005,
      "vy": -0.0003300734696258867,
      "vx": 0.00017632417825897182,
      "radius": 12,
      "angle": 4.607669225265029,
      "fixed": true,
      "similarity" : 0.61
    },
    {
      "id": "62961cba-cbbf-40a0-95f5-faa293587081",
      "name": "michel galley",
      "isAdded": false,
      "coauthorTimes": 24,
      "commonInterests": [],
      "index": 23,
      "x": 297.8792691484519,
      "y": 138.65992891194753,
      "vy": -0.0003877801911230962,
      "vx": 0.0002025778219165628,
      "radius": 34,
      "angle": 4.817108735504349,
      "fixed": true,
      "similarity" : 0.88
    },
    {
      "id": "cf0046b1-b10e-4886-89c5-dd335e196b8d",
      "name": "vijay krishnan",
      "isAdded": false,
      "coauthorTimes": 2,
      "commonInterests": [],
      "index": 24,
      "x": 305.0964698118839,
      "y": 128.6639808720353,
      "vy": -0.0002576250192305197,
      "vx": 0.0003460890865565938,
      "radius": 12,
      "angle": 5.026548245743669,
      "fixed": true,
      "similarity" : 0.95
    },
    {
      "id": "1efeff74-f638-4fd5-b194-ff5ff652f3fc",
      "name": "nick chater",
      "isAdded": false,
      "coauthorTimes": 4,
      "commonInterests": [],
      "index": 25,
      "x": 318.96770157447713,
      "y": 123.27045628290706,
      "vy": -0.0005146454499946188,
      "vx": 0.00047514977011308253,
      "radius": 14,
      "angle": 5.235987755982989,
      "fixed": true,
      "similarity" : 1
    },
    {
      "id": "e89a59d9-63da-4f43-841c-abdaa5869b86",
      "name": "iddo lev",
      "isAdded": false,
      "coauthorTimes": 2,
      "commonInterests": [],
      "index": 26,
      "x": 310.6689769717156,
      "y": 116.64242200592197,
      "vy": -0.00014972357263597172,
      "vx": 0.00013998758395511213,
      "radius": 12,
      "angle": 5.445427266222309,
      "fixed": true,
      "similarity" : 0.72
    },
    {
      "id": "208a56ee-ad01-4e68-8597-b501a11d54b4",
      "name": "jon gauthier",
      "isAdded": false,
      "coauthorTimes": 2,
      "commonInterests": [],
      "index": 27,
      "x": 322.6086304503372,
      "y": 109.66739168872623,
      "vy": -0.00040094443172917924,
      "vx": 0.0002621745129757222,
      "radius": 12,
      "angle": 5.654866776461628,
      "fixed": true,
      "similarity" : 0.89
    },
    {
      "id": "8a56670c-ef1d-4541-aca0-9ba537f7c516",
      "name": "abigail see",
      "isAdded": false,
      "coauthorTimes": 2,
      "commonInterests": [],
      "index": 28,
      "x": 333.425200785418,
      "y": 112.00150681634345,
      "vy": -0.0001149760525737755,
      "vx": 0.000290593629237147,
      "radius": 12,
      "angle": 5.8643062867009474,
      "fixed": true,
      "similarity" : 0.62
    },
    {
      "id": "0715c202-8d32-4be3-9e49-6f456a127103",
      "name": "david mcclosky",
      "isAdded": false,
      "coauthorTimes": 17,
      "commonInterests": [],
      "index": 29,
      "x": 342.1487819973825,
      "y": 104.69245100735017,
      "vy": -0.0002211279395220075,
      "vx": 0.00021009949013877193,
      "radius": 27,
      "angle": 6.073745796940267,
      "fixed": true,
      "similarity" : 0.49
    },
    {
      "id": "62099615-49a8-4d36-a49e-726a6f3f6db2",
      "name": "miriam corris",
      "isAdded": false,
      "coauthorTimes": 4,
      "commonInterests": [],
      "index": 30,
      "x": 349.87867207795085,
      "y": 114.50899307139058,
      "vy": -0.0002224307029507572,
      "vx": 0.0003056790763428868,
      "radius": 14,
      "angle": 6.283185307179585,
      "fixed": true,
      "similarity" : 0.7
    }
  ]
};
		
		createSimilarResearchers("#boxbody-${wUniqueName} .similar_researchers", data);
		$.PALM.popUpMessage.remove( uniquePidSimilarResearchers );
		
		<#-- source : "<@spring.url '/researcher/similarAuthorList' />", -->
	    <#-- unique options in each widget -->
<#--		var options ={
			source : "<@spring.url '/researcher/coAuthorList' />",
			query: "",
			queryString : "",
			page:0,
			maxresult:50,
			onRefreshStart: function(  widgetElem  ){
				<#-- show pop up progress log -->
<#--				$.PALM.popUpMessage.create( "loading similar researchers list", {uniqueId: uniquePidSimilarResearchers, popUpHeight:40, directlyRemove:false , polling:false});
			},
			onRefreshDone: function(  widgetElem , data ){
				var targetContainer = $( widgetElem ).find( ".similar_researchers" );
				<#-- remove previous list -->
<#--				targetContainer.html( "" );	
				data = [ {"author" : {"id" : 11121, "name" : "ligia", "photo":"http://nlp.stanford.edu/manning/images/Christopher_Manning_027_132x132.jpg" }},{"name": "Ana"} ];	
		 		
				if( data.count == 0 ){
					$.PALM.callout.generate( targetContainer , "warning", "Empty Similar Researchers!", "Researcher does not have any similar researchers on PALM (insufficient data)" );
					return false;
				}							
				if( data.count > 0 ){ 
					<#-- remove any remaing tooltip -->
<#--					$( "body .tooltip" ).remove(); 
					 createSimilarResearchers("#boxbody-${wUniqueName} .similar_researchers", data);
				} 

				$.PALM.popUpMessage.remove( uniquePidSimilarResearchers );
			}					
		};
		
		<#--// register the widget-->
		$.PALM.options.registeredWidget.push({
			"type":"${wType}",
			"group": "${wGroup}",
			"source": "${wSource}",
			"selector": "#widget-${wUniqueName}",
			"element": $( "#widget-${wUniqueName}" ),
	     	"options": {}
		});
	} );
</script>