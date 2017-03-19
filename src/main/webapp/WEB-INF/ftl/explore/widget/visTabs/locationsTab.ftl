<#-- LOCATIONS TAB -->
function tabVisLocations(uniqueVisWidget, url, widgetElem, tabContent, reload)
{
	if(reload)
		L.Util.requestAnimFrame(mymap.invalidateSize,mymap,!1,mymap._container);
	else
	{
		$.getJSON( url , function( data ) 
		{
			<#-- remove  pop up progress log -->
			$.PALM.popUpMessage.remove( uniqueVisWidget );

			if(data.oldVis=="false")
			{				
				if( data.map.realLocationsFound == 0 )
				{
					$.PALM.callout.generate( tabContent , "warning", "No data found!!", "Information about geographical locations is not available for the specified criteria!" );
					return false;
				}
				
				var locDiv = $('<div/>').attr("id","mapid").css("height","60vh").css("z-index","1");
				tabContent.append(locDiv);
					
				mymap = L.map('mapid');
				
				L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}', 
				{
				    attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
				    maxZoom: 18,
				    id: 'mguliani.0ph7d97m',
				    accessToken: 'pk.eyJ1IjoibWd1bGlhbmkiLCJhIjoiY2lyNTJ5N3JrMDA1amh5bWNkamhtemN6ciJ9.uBTppyCUU7bF58hUUVxZaw'
				})
				.addTo(mymap);
				
				var maxlat=0;
				var maxlon=0;
				var minlat=0;
				var minlon=0;
				
				var myLayer;
				var mydata = [];	
				var city = [];
				var country = [];
				var confdata = data;
				var i;
				
				var zoom = 2;
				if(data.map.events.length < 10)
				zoom = 3;
				
				if(data.type=="researcher" || data.type=="publication" || data.type=="topic" || data.type=="circle")
				{
					for(i=0; i< data.map.events.length; i++)
					{
					 	(function(i) 
					 	{
							$.getJSON("https://api.mapbox.com/geocoding/v5/mapbox.places/" + data.map.events[i].location + ".json?autocomplete=false&access_token=pk.eyJ1IjoibWd1bGlhbmkiLCJhIjoiY2lyNTJ5N3JrMDA1amh5bWNkamhtemN6ciJ9.uBTppyCUU7bF58hUUVxZaw", function(mapdata)
							{
								year = data.map.events[i].year
								eventGroupId = data.map.events[i].eventGroupId
								groupname = data.map.events[i].groupName
				
								mapdata.features[0].properties.conference = groupname
								mapdata.features[0].properties.year = year
								mapdata.features[0].properties.eventGroupId = eventGroupId
								mapdata.features[0].properties.dataType = "researcher"
								mydata.push(myLayer.addData(mapdata.features[0]));
							});
						})(i);
					}			
					myLayer = L.geoJson(mydata, 
					{
					       pointToLayer: function (feature, latlng) 
					       {
						       if(latlng.lat > maxlat)
						       		maxlat = latlng.lat
						       if(latlng.lat < minlat)
						       		minlat = latlng.lat
						       if(latlng.lon > maxlon)
						       		maxlon = latlng.lon
						       if(latlng.lon < minlon)
						       		minlat = latlng.lon
						       
							   mymap.setView([(maxlat+minlat)/2,(maxlon+minlon)/2], zoom);
							   return L.marker(latlng).bindPopup("<b>Hello world!</b><br>I am a popup.").openPopup();
						  },
						  onEachFeature: onEachFeature
					}).addTo(mymap); 
				}
				if(data.type=="conference")
				{
					var eventGroupList=[];	
					var iconColorList=['green','blue','red','yellow','orange','violet','black','grey'];			
					for(i=0; i< data.map.events.length; i++)
					{
						(function(i) 
						{
							$.getJSON("https://api.mapbox.com/geocoding/v5/mapbox.places/" + data.map.events[i].location + ".json?autocomplete=false&access_token=pk.eyJ1IjoibWd1bGlhbmkiLCJhIjoiY2lyNTJ5N3JrMDA1amh5bWNkamhtemN6ciJ9.uBTppyCUU7bF58hUUVxZaw", function(mapdata)
							{
								year = data.map.events[i].year
								groupname = data.map.events[i].groupName
								eventGroupId = data.map.events[i].eventGroupId
								if(eventGroupList.indexOf(groupname)== -1)
								eventGroupList.push(groupname);
								mapdata.features[0].properties.conference = groupname
								mapdata.features[0].properties.year = year
								mapdata.features[0].properties.eventGroupId = eventGroupId
								mapdata.features[0].properties.dataType = "conference"
								mydata.push(myLayer.addData(mapdata.features[0]));
							});
						})(i);
					}			
					myLayer = L.geoJson(mydata, 
					{
				       pointToLayer: function (feature, latlng) {
				      	
				       if(latlng.lat > maxlat)
				       		maxlat = latlng.lat
				       if(latlng.lat < minlat)
				       		minlat = latlng.lat
				       if(latlng.lon > maxlon)
				       		maxlon = latlng.lon
				       if(latlng.lon < minlon)
				       		minlat = latlng.lon
				       
				       mymap.setView([(maxlat+minlat)/2,(maxlon+minlon)/2], zoom);
				       return L.marker(latlng,{icon: new L.Icon({
					   		iconUrl: 'https://cdn.rawgit.com/pointhi/leaflet-color-markers/master/img/marker-icon-'+iconColorList[eventGroupList.indexOf(feature.properties.conference)]+'.png'
						})})
							.bindPopup("<b>Hello world!</b><br>I am a popup.").openPopup();
				    },
				       onEachFeature: onEachFeature
				     }).addTo(mymap); 
				}
				
				mymap.on('click',function(e)
				{
					hidemenudiv('menu')
					hidehoverdiv('divtoshow')
  					hidehoverdiv('divhold');
				})
			}
		})
		.fail(function() 
		{
   	 		$.PALM.popUpMessage.remove( uniquePid );
		});
	}		
}

function onEachFeature(feature, layer) 
{
	var popupContent = feature.properties.conference + ",<br> " + feature.place_name + ",<br> " + feature.properties.year;
	layer.bindPopup(popupContent);
	
	layer.on('mouseover', function (e) 
	{
        this.openPopup();
    });
    
    layer.on('mouseout', function (e) 
    {
        this.closePopup();
    });
  	
  	layer.on('click', function(e)
  	{
  		obj = {
				type:"clickLocation",
				clientX:e.layerPoint.x,
				clientY:e.layerPoint.y,
				itemName: feature.properties.conference,
				eventGroupId:feature.properties.eventGroupId
			  };
  		
  		if(feature.properties.dataType == "researcher")
			showmenudiv(obj,'menu');
		if(feature.properties.dataType == "conference")
			showhoverdiv(obj,'divtoshow', "This conference is already added");
  	});
}
	