<%--
/**
 * Copyright (c) 2000-2012 Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
--%>

<%@ include file="/html/portlet/calendar/init.jsp" %>
<%@ taglib uri="http://liferay.com/tld/theme" prefix="theme" %>
<theme:defineObjects/>
<%
ResultRow row = (ResultRow)request.getAttribute(WebKeys.SEARCH_CONTAINER_RESULT_ROW);

CalEvent event = null;

boolean view = true;
String cssClass = StringPool.BLANK;

if (row != null) {
	event = (CalEvent)row.getObject();
}
else {
	cssClass = "nav nav-list unstyled well";
	event = (CalEvent)request.getAttribute("view_event.jsp-event");

}

if (themeDisplay.isSignedIn()){
%>

	<div id="dhec_menu" class="lfr-component lfr-menu-list lfr-menu-expanded align-right nav nav-list unstyled well">
			<ul>
				<c:if test="<%= CalEventPermission.contains(permissionChecker, event, ActionKeys.UPDATE) %>">
				<li>
					<portlet:renderURL var="editURL">
						<portlet:param name="struts_action" value="/calendar/edit_event" />
						<portlet:param name="redirect" value="<%= currentURL %>" />
						<portlet:param name="backURL" value="<%= currentURL %>" />
						<portlet:param name="eventId" value="<%= String.valueOf(event.getEventId()) %>" />
					</portlet:renderURL>
			
					<liferay-ui:icon
						image="edit"
						url="<%= editURL %>"
						label="true" />
					</li>
				</c:if>
			
				<c:if test="<%= CalEventPermission.contains(permissionChecker, event, ActionKeys.VIEW) && (themeDisplay.isSignedIn()) %>">
				<li>
					<portlet:actionURL windowState="<%= LiferayWindowState.EXCLUSIVE.toString() %>" var="exportURL">
						<portlet:param name="struts_action" value="/calendar/export_events" />
						<portlet:param name="redirect" value="<%= currentURL %>" />
						<portlet:param name="eventId" value="<%= String.valueOf(event.getEventId()) %>" />
					</portlet:actionURL>
			
					<liferay-ui:icon
						image="export"
						url='<%= exportURL %>'
						label="true"
					/>
					</li>
				</c:if>
			
				<c:if test="<%= CalEventPermission.contains(permissionChecker, event, ActionKeys.PERMISSIONS) %>">
				<li>
					<liferay-security:permissionsURL
						modelResource="<%= CalEvent.class.getName() %>"
						modelResourceDescription="<%= event.getTitle() %>"
						resourcePrimKey="<%= String.valueOf(event.getEventId()) %>"
						var="permissionsURL"
					/>
			
					<liferay-ui:icon
						image="permissions"
						url="<%= permissionsURL %>"
						label="true" 
					/>
					</li>
				</c:if>
			
				<c:if test="<%= CalEventPermission.contains(permissionChecker, event, ActionKeys.DELETE) %>">
				<li>
					<portlet:renderURL var="redirectURL">
						<portlet:param name="struts_action" value="/calendar/view" />
					</portlet:renderURL>
			
					<portlet:actionURL var="deleteURL">
						<portlet:param name="struts_action" value="/calendar/edit_event" />
						<portlet:param name="<%= Constants.CMD %>" value="<%= Constants.DELETE %>" />
						<portlet:param name="redirect" value="<%= view ? redirectURL : currentURL %>" />
						<portlet:param name="eventId" value="<%= String.valueOf(event.getEventId()) %>" />
					</portlet:actionURL>
			
					<liferay-ui:icon-delete url="<%= deleteURL %>" label="true" />
					</li>
				</c:if>
			</ul>
	 </div>
 <% } %>