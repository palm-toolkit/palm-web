<div id="boxbody${wUniqueName}" class="box-body">

</div>

<script>
	$( function(){
		<#-- add slimscroll to widget body -->
		$("#boxbody${wUniqueName} #tab_publication_detail").slimscroll({
			height: "100%",
	        size: "3px",
			allowPageScroll: true,
   			touchScrollStep: 50
	    });

		$.getJSON( "<@spring.url '/publication/bibtex' />?id=${targetId}", function( data ){
			var widgetContentContainer = $( "#boxbody${wUniqueName}");
			
			
			var citeContent = $( "<dl/>" ).addClass( "dl-horizontal" );
			
			if( typeof data.BibTeX !== "undefined" ){
				citeContent.append(
								$( "<dt/>" ).html( "BibTeX" )
							)
							.append(
								$( "<dd/>" )
								.addClass( "separator" )
								.html( data.BibTeX.replace(/(?:\r\n|\r|\n)/g, '<br />') )
							);
			} 
			if( typeof data.MLA !== "undefined" ){
				citeContent.append(
								$( "<dt/>" ).html( "MLA" )
							)
							.append(
								$( "<dd/>" )
								.addClass( "separator" )
								.html( data.MLA.replace(/(?:\r\n|\r|\n)/g, '<br />') )
							);
			} 
			if( typeof data.APA !== "undefined" ){
				citeContent.append(
								$( "<dt/>" ).html( "APA" )
							)
							.append(
								$( "<dd/>" )
								.addClass( "separator" )
								.html( data.APA.replace(/(?:\r\n|\r|\n)/g, '<br />') )
							);
			} 
			if( typeof data.Chicago !== "undefined" ){
				citeContent.append(
								$( "<dt/>" ).html( "Chicago" )
							)
							.append(
								$( "<dd/>" )
								.addClass( "separator" )
								.html( data.Chicago.replace(/(?:\r\n|\r|\n)/g, '<br />') )
							);
			} 
			
			widgetContentContainer.html( citeContent );
		});
	});<#-- end document ready -->
</script>