var headerCaption = new Object();
					
<#-- Researcher Type -->
headerCaption["researcher-researchers-Network"] = "Co-authors network: \nNetwork of selected researchers and their co-authors \n\nNodes are colored as per node degree[yellow(low) to red(high)] and their size indicates how many shortest paths are they on. \nEdges are weighted by number of co-authorships. \nIf multiple researchers are selected, common co-authors are shown. \nRight click for highlighting co-authors in the network"
headerCaption["researcher-researchers-Group"] = "Clustered authors: \nCo-authors clustered based on their interests \n\nConvex hulls enclose individual clusters. \nIf multiple researchers are selected, common co-authors are shown."
headerCaption["researcher-researchers-Similar"] = "Similar researchers: \nResearchers similar to selected researchers, based on interests \n\nMay or may not be co-authors. \nFilters not applicable!"
headerCaption["researcher-researchers-List"] = "List of co-authors: \nCo-authors with number of co-authorships \n\nIf multiple researchers are selected, common co-authors are added to the list."
headerCaption["researcher-researchers-Comparison"] = "Comparison: \nEuler diagram to compare selected researchers based on co-authors"

headerCaption["researcher-conferences-Locations"] = "Geographical locations: \nConference event locations on world map. \n\nLocations of the events attended by the selected researchers, if conferences are added and geographical information is available. \nIf multiple researchers are selected, conference locations where they have publications together are shown."
headerCaption["researcher-conferences-Group"] = "Clustered conferences: \nConferences clustered based on interests \n\nConvex hulls enclose individual clusters. \nIf multiple researchers are selected, conferences where they have publications together are clustered."
headerCaption["researcher-conferences-List"] = "List of conferences and their respective events: \nConference events attended by selected authors, with year and location information. \n\nIf multiple researchers are selected, conference locations where they have publications together are added to the list."
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
headerCaption["conference-researchers-List"] = "List of researchers: \nResearchers with number of publications in the conferences \n\nIf multiple conferences are selected, common researchers are added to the list."
headerCaption["conference-researchers-Comparison"] = "Comparison: \nEuler diagram to compare selected conferences based on researchers"

headerCaption["conference-conferences-Locations"] = "Geographical locations: \nConference event locations on world map. \n\nLocations of all the events of the selected conferences, if <#-- conferences are added --> and geographical information is available."
headerCaption["conference-conferences-Similar"] = "Similar conferences: \nConferences similar to selected conferences, based on interests \n\nFilters not applicable!"
headerCaption["conference-conferences-List"] = "List of conferences and their respective events: \nLocations of all the events of the selected conferences, with year and location information."

headerCaption["conference-publications-Timeline"] = "Publications timeline: \nAll Publications in chronological order"
headerCaption["conference-publications-Group"] = "Clustered publications: \nPublications clustered based on topics \n\nConvex hulls enclose individual clusters."
headerCaption["conference-publications-List"] = "List of all publications."

headerCaption["conference-topics-Bubbles"] = "Bubble chart: \nInterests of the conferences in the form of discs \n\nA disc representing an interest, has a portion each of the selected conferences. \nDiscs are sorted by weights of the interests."
headerCaption["conference-topics-Evolution"] = "Evolution of interests: \nChart to depict interests of selected conferences over the years. \n\nInterests corresponding to each year are marked by points."
headerCaption["conference-topics-List"] = "List of common interests of the conferences"
headerCaption["conference-topics-Comparison"] = "Comparison: \nEuler diagram to compare selected conferences based on interests"

<#-- Publication Type -->
headerCaption["publication-researchers-Network"] = "Researchers network: \nNetwork of researchers who have authored all the selected publications \n\nNodes are colored as per node degree[yellow(low) to red(high)] and their size indicates how many shortest paths are they on. "
headerCaption["publication-researchers-Group"] = "Clustered researchers: \nAuthors of the publications, clustered based on their interests \n\nConvex hulls enclose individual clusters. \nIf multiple publications are selected, common researchers are shown."
headerCaption["publication-researchers-List"] = "List of researchers: \nList of authors of the publications \n\nIf multiple publications are selected, common researchers are added to the list."
headerCaption["publication-researchers-Comparison"] = "Comparison: \nEuler diagram to compare selected publications based on researchers"

headerCaption["publication-conferences-Locations"] = "Geographical locations: \nConference event locations on world map. \n\nLocations of the conference events of selected publications, if geographical information of the conference, is available."
headerCaption["publication-conferences-List"] = "List of conference events of the publications with year and location information."

headerCaption["publication-publications-Timeline"] = "Publications timeline: \nSelected Publications in chronological order"
headerCaption["publication-publications-Similar"] = "Similar conferences: \nPublications similar to selected publications, based on topics \n\nFilters not applicable!"

headerCaption["publication-topics-Bubbles"] = "Bubble chart: \nTopics of the publications in the form of discs \n\nA disc representing a topic, has a portion each of the selected publications. \nDiscs are sorted by weights of the topics."
headerCaption["publication-topics-List"] = "List of common topics of the publications"
headerCaption["publication-topics-Comparison"] = "Comparison: \nEuler diagram to compare selected publications based on topics"

<#-- Topic Type -->
headerCaption["topic-researchers-Network"] = "Researchers network: \nNetwork of researchers who have interest in the selected topics \n\nNodes are colored as per node degree[yellow(low) to red(high)] and their size indicates how many shortest paths are they on. \nRight click for highlighting co-authors in the network"
headerCaption["topic-researchers-Group"] = "Clustered researchers: \nResearchers interested in the topics, clustered based on their interests \n\nConvex hulls enclose individual clusters. \nIf multiple interests are selected, researchers with interest in all selected interests are shown."
headerCaption["topic-researchers-List"] = "List of researchers: \nList of researchers interested in the topics \n\nIf multiple interests are selected, researchers with interests in all are added to the list."
headerCaption["topic-researchers-Comparison"] = "Comparison: \nEuler diagram to compare selected interests based on researchers"

headerCaption["topic-conferences-Locations"] = "Geographical locations: \nConference event locations on world map. \n\nLocations of the events interested in the selected topics, if conferences are added and geographical information is available. \nIf multiple interests are selected, conference events which have all the selected interests are shown."
headerCaption["topic-conferences-Group"] = "Clustered conferences: \nConferences clustered based on interests \n\nConvex hulls enclose individual clusters. \nIf multiple interests are selected, conference which have interest in all selected interests, are clustered."
headerCaption["topic-conferences-List"] = "List of conferences and their respective events: \nConference events with selected interests, with year and location information."
headerCaption["topic-conferences-Comparison"] = "Comparison: \nEuler diagram to compare selected interests based on conferences"

headerCaption["topic-publications-Timeline"] = "Publications timeline: \nPublications with selected topics in chronological order"
headerCaption["topic-publications-Group"] = "Clustered publications: \nPublications clustered based on topics \n\nConvex hulls enclose individual clusters. \nIf multiple interests are selected, publications with common topics are clustered."
headerCaption["topic-publications-List"] = "List of publications"
headerCaption["topic-publications-Comparison"] = "Comparison: \nEuler diagram to compare selected interests based on publications"

headerCaption["topic-topics-Similar"] = "Similar Interests: \nTopics similar to selected topics, based on co-occurence \n\nFilters not applicable!"
headerCaption["topic-topics-Evolution"] = "Evolution of interests: \nChart to depict interests in selected topics over the years through number of publications."

<#-- Circle Type -->
headerCaption["circle-researchers-Network"] = "Researchers network: \nNetwork of researchers added to the selected circle \n\nNodes are colored as per node degree[yellow(low) to red(high)] and their size indicates how many shortest paths are they on. \nEdges are weighted by number of co-authorships. \nIf multiple researchers are selected, researchers common to the selected circles are shown. \nRight click for highlighting co-authors in the network"
headerCaption["circle-researchers-Group"] = "Clustered researchers: \nResearchers in the circles, clustered based on their interests \n\nConvex hulls enclose individual clusters. \nIf multiple circles are selected, common researchers are shown."
headerCaption["circle-researchers-List"] = "List of researchers: \nResearchers added to the circle \n\nIf multiple circles are selected, common researchers are added to the list."
headerCaption["circle-researchers-Comparison"] = "Comparison: \nEuler diagram to compare selected circles based on researchers"

headerCaption["circle-conferences-Locations"] = "Geographical locations: \nConference event locations on world map. \n\nLocations of the events of publications present in the circle, if conferences are added and geographical information is available. \nIf multiple circles are selected, common conference locations are shown."
headerCaption["circle-conferences-Group"] = "Clustered conferences: \nConferences clustered based on interests \n\nConvex hulls enclose individual clusters. \nIf multiple circles are selected, common conferences are clustered."
headerCaption["circle-conferences-List"] = "List of conferences and their respective events: \nConference events of publications added to the selected circle, with year and location information. \n\nIf multiple circles are selected, common conference locations are shown."
headerCaption["circle-conferences-Comparison"] = "Comparison: \nEuler diagram to compare selected circles based on conferences"
					
headerCaption["circle-publications-Timeline"] = "Publications timeline: \nPublications added to the circle in chronological order"
headerCaption["circle-publications-Group"] = "Clustered publications: \nPublications clustered based on topics \n\nConvex hulls enclose individual clusters. \nIf multiple circles are selected, common publications are clustered."
headerCaption["circle-publications-List"] = "List of publications present in the circles"
headerCaption["circle-publications-Comparison"] = "Comparison: \nEuler diagram to compare selected circles based on publications"

headerCaption["circle-topics-Bubbles"] = "Bubble chart: \nInterests of the circles in the form of discs \n\nA disc representing an interest, has a portion each of the selected circles. \nDiscs are sorted by weights of the interests."
headerCaption["circle-topics-Evolution"] = "Evolution of interests: \nChart to depict interests of selected circles over the years. \n\nInterests corresponding to each year are marked by points."
headerCaption["circle-topics-List"] = "List of common interests of the circles"
headerCaption["circle-topics-Comparison"] = "Comparison: \nEuler diagram to compare selected circles based on interests"
