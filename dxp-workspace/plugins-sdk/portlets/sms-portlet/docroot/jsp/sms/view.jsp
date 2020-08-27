<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet"%>
<%@ taglib uri="http://alloy.liferay.com/tld/aui" prefix="aui"%>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui"%>
<portlet:defineObjects />

<portlet:actionURL name="processSMSAction" var="sendSMSUrl">
</portlet:actionURL>

<liferay-ui:success key="success" message="dsg.sms.send.success"></liferay-ui:success>
<liferay-ui:error key="error" message="dsg.sms.send.error"></liferay-ui:error>

<aui:form action="<%=sendSMSUrl%>" method="post">
	<aui:input label="dsg.sms.label" name="txtSms" type="text" />
	<aui:button type="submit" value="dsg.sms.send.button.value" />
</aui:form>


