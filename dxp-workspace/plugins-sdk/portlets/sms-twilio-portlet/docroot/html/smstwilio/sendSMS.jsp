<%@ include file="/html/smstwilio/init.jsp"%>

<portlet:actionURL name="processSMSAction" var="sendSMSUrl">
</portlet:actionURL>

<liferay-ui:success key="success" message="dsg.sms.send.success"></liferay-ui:success>
<liferay-ui:error key="error" message="dsg.sms.send.error"></liferay-ui:error>
<liferay-ui:error key="propertiesNotSet" message="dsg.sms.properties.notset"></liferay-ui:error>

<aui:form action="<%=sendSMSUrl%>" method="post">
	<aui:input label="dsg.sms.label" name="txtSms" type="text" showRequiredLabel="false">
		<aui:validator name="required"></aui:validator>
		<aui:validator name="number"></aui:validator>
		<aui:validator name="maxLength" errorMessage="Please enter no more than 10 digits.">10</aui:validator>
		<aui:validator name="minLength" errorMessage="Please enter at least 10 digits.">10</aui:validator>
	</aui:input>
	<aui:button type="submit" value="dsg.sms.send.button.value" />
</aui:form>


