<%@page import="com.liferay.portal.kernel.language.LanguageUtil"%>
<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>
<%@ taglib uri="http://liferay.com/tld/theme"  prefix="theme"%>

<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui" %>

<portlet:defineObjects />
<theme:defineObjects />


<liferay-ui:success key="deleted-sucessfully" message="all.calendar.event.deleted.successfully"/>
<liferay-ui:error key="no-event-exist-on-this-layout" message="no.event.exist.on.this.layout"/>

<portlet:actionURL var="deleteLayoutEventURL" name="deleteLayoutEvent"/>
<portlet:actionURL var="deleteGlobalEventURL" name="deleteGlobalEvent"/>
<portlet:actionURL var="deleteSiteEventURL" name="deleteSiteEvent"/>

<aui:form action="<%= deleteLayoutEventURL.toString() %>" onSubmit="javascript:deleteAllEvent();" name="fm1">
Delete all events related to this specific site.<br>
	<aui:button type="submit" name="deleteAllEvent" value='<%= LanguageUtil.format(pageContext, "delete.layout.event", themeDisplay.getLayout().getHTMLTitle(themeDisplay.getLocale())) %>'></aui:button>
</aui:form>
<br>

<aui:form action="<%= deleteGlobalEventURL.toString() %>" onSubmit="javascript:deleteAllEvent();" name="fm2">
Delete all events related to Global.<br>
	<aui:button type="submit" name="deleteAllEvent" value="delete.global.event"></aui:button>
</aui:form>
<br>

<aui:form action="<%= deleteSiteEventURL.toString() %>" onSubmit="javascript:deleteAllEvent();" name="fm3">
Delete all events related to site.<br>
	<aui:button type="submit" name="deleteAllEvent" value="delete.site.event"></aui:button>
</aui:form>
<br><br>

<aui:script>
		function deleteAllEvent(){
		AUI().use('aui-dialog','aui-overlay-mask', 'aui-overlay-manager', 'dd-constrain','aui-io-request', 'aui-io', 'event-custom', 'io-form', function(A){		
			var overlayMask = new A.OverlayMask().render();
			var message = A.Node.create('<h3 class="loader-message"><div class="aui-loadingmask-message-content">Deleting events please wait...</div></h3>');
				
				setTarget(document);
		
				function showMessage () {
					message.appendTo(document.body);
				};
		
		
				function setTarget (elem) {
					overlayMask.set('target', elem).show();	
					if(elem == document){
						showMessage();	
					}
				};
				
				
				function closeOverlay() {
					overlayMask.hide();
					message.remove();
				}	
		});		
	}
	
</aui:script>