var headerCaption = new Object();
					
					<#-- Researcher Type -->
					headerCaption["researcher-researchers-Network"] = "Co-authors network: \nNetwork of selected researchers and their co-authors \n\nNodes are colored as per node degree[yellow(low) to red(high)] and their size indicates how many shortest paths are they on. \nEdges are weighted by number of co-authorships. \nIf multiple researchers are selected, common co-authors are shown. \nRight click for highlighting co-authors in the network"
					headerCaption["researcher-researchers-Group"] = "Clustered authors: \nCo-authors clustered based on their interests \n\nConvex hulls enclose individual clusters. \nIf multiple researchers are selected, common co-authors are shown."
					headerCaption["researcher-researchers-Similar"] = "Similar researchers: \nResearchers similar to selected researchers, based on interests \n\nMay or may not be co-authors. \nFilters not applicable!"
					headerCaption["researcher-researchers-List"] = "List of co-authors: \nCo-authors with number of co-authorships \n\nIf multiple researchers are selected, common co-authors are shown."
					headerCaption["researcher-researchers-Comparison"] = "Comparison: \nEuler diagram to compare selected researchers based on co-authors"
					
					headerCaption["researcher-conferences-Locations"] = "Geographical locations: \nConference event locations on world map. \n\nLocations of the events attended by the selected researchers, if conferences are added and geographical information is available. \nIf multiple researchers are selected, conference locations where they have publications together are shown."
					headerCaption["researcher-conferences-Group"] = "Clustered conferences: \nConferences clustered based on interests \n\nConvex hulls enclose individual clusters. \nIf multiple researchers are selected, conference where they have publications together are clustered."
					headerCaption["researcher-conferences-List"] = "List of conferences and their respective events: \nConference events attended by selected authors , with year and location information. \n\nIf multiple researchers are selected, conference locations where they have publications together are shown."
					headerCaption["researcher-conferences-Comparison"] = "Comparison: \nEuler diagram to compare selected researchers based on conferences \n\nResult might be different from other conference visualizations, in case researchers have attended same conferences, but not co-authored."
										
					headerCaption["researcher-publications-Timeline"] = "Publications timeline: \nPublications in chronological order"
					headerCaption["researcher-publications-Group"] = "Clustered publications: \nPublications clustered based on topics \n\nConvex hulls enclose individual clusters. \nIf multiple researchers are selected, common publications are clustered."
					headerCaption["researcher-publications-List"] = "List of publications"
					headerCaption["researcher-publications-Comparison"] = "Comparison: \nEuler diagram to compare selected researchers based on publications"
					
					headerCaption["researcher-topics-Bubbles"] = "Bubble chart: \nInterests of the researchers in the form of discs \n\nA disc representing an interest, has a portion each of the selected researchers. \nDiscs are sorted by weights of the interests."
					headerCaption["researcher-topics-Evolution"] = "Evolution of interests: \nChart to depict interests of selected authors over the years. \n\nInterests corresponding to each year are marked by points."
					headerCaption["researcher-topics-List"] = "List of common interests of the researchers"
					headerCaption["researcher-topics-Comparison"] = "Comparison: \nEuler diagram to compare selected researchers based on interests"
					
					<#-- Conference Type -->
					headerCaption["conference-researchers-Network"] = "Researchers network: \nNetwork of researchers who have published in the selected conferences \n\nNodes are colored as per node degree[yellow(low) to red(high)] and their size indicates how many shortest paths are they on. \nEdges are weighted by number of co-authorships. \nIf multiple conferences are selected, researchers who have publications in all selected conferences, are shown. \nRight click for highlighting co-authors in the network"
					headerCaption["conference-researchers-Group"] = "Clustered researchers: \nResearchers clustered based on their interests \n\nConvex hulls enclose individual clusters. \nIf multiple conferences are selected, common researchers are shown."
					headerCaption["conference-researchers-List"] = "List of researchers: \nResearchers with number of publications in the conferences \n\nIf multiple conferences are selected, common researchers are shown."
					headerCaption["conference-researchers-Comparison"] = "Comparison: \nEuler diagram to compare selected conferences based on researchers"
					
					headerCaption["conference-conferences-Locations"] = "Geographical locations: \nConference event locations on world map. \n\nLocations of all the events of the selected conferences, if <#-- conferences are added --> and geographical information is available."
					headerCaption["conference-conferences-Similar"] = "Similar conferences: \nConferences similar to selected conferences, based on interests \n\nFilters not applicable!"
					headerCaption["conference-conferences-List"] = "List of conferences and their respective events: \nLocations of all the events of the selected conferences , with year and location information."
					
					headerCaption["conference-publications-Timeline"] = "Publications timeline: \nAll Publications in chronological order"
					headerCaption["conference-publications-Group"] = "Clustered publications: \nPublications clustered based on topics \n\nConvex hulls enclose individual clusters."
					headerCaption["conference-publications-List"] = "List of all publications."
					
					headerCaption["conference-topics-Bubbles"] = "Bubble chart: \nInterests of the conferences in the form of discs \n\nA disc representing an interest, has a portion each of the selected conferences. \nDiscs are sorted by weights of the interests."
					headerCaption["conference-topics-Evolution"] = "Evolution of interests: \nChart to depict interests of selected conferences over the years. \n\nInterests corresponding to each year are marked by points."
					headerCaption["conference-topics-List"] = "List of common interests of the conferences"
					headerCaption["conference-topics-Comparison"] = "Comparison: \nEuler diagram to compare selected conferences based on interests"
					
					<#-- Publication Type -->
					headerCaption["publication-researchers-Network"] = "Researchers network: \nNetwork of researchers who have authored all the selected publications \n\nNodes are colored as per node degree[yellow(low) to red(high)] and their size indicates how many shortest paths are they on. "
					headerCaption["publication-researchers-Group"] = "Clustered researchers: \nAuthors of the publications, clustered based on their interests \n\nConvex hulls enclose individual clusters. \nIf multiple conferences are selected, common researchers are shown."
					headerCaption["publication-researchers-List"] = "List of researchers: \nList of authors of the publications \n\nIf multiple publications are selected, common researchers are shown."
					headerCaption["publication-researchers-Comparison"] = "Comparison: \nEuler diagram to compare selected publications based on researchers"
					
					headerCaption["publication-conferences-Locations"] = "Geographical locations: \nConference event locations on world map. \n\nLocations of the conference events of selected publications, if geographical information of the conference, is available."
					headerCaption["publication-conferences-List"] = "List of conference events of the publications with year and location information."
					
					headerCaption["publication-publications-Timeline"] = "Publications timeline: \nSelected Publications in chronological order"
					headerCaption["publication-publications-Similar"] = "Similar conferences: \nPublications similar to selected publications, based on topics \n\nFilters not applicable!"
					
					headerCaption["publication-topics-Bubbles"] = "Bubble chart: \nTopics of the publications in the form of discs \n\nA disc representing a topic, has a portion each of the selected publications. \nDiscs are sorted by weights of the topics."
					headerCaption["publication-topics-List"] = "List of common topics of the publications"
					headerCaption["publication-topics-Comparison"] = "Comparison: \nEuler diagram to compare selected publications based on topics"
					