<%@page import="com.liferay.portal.kernel.util.ParamUtil"%>
<%@page import="com.liferay.portal.kernel.util.Constants"%>
<%@ include file="/html/smstwilio/init.jsp"%>
<%
	String redirect = ParamUtil.getString(request, "redirect");
%>

<liferay-ui:success key="success" message="dsg.sms.properties.success"></liferay-ui:success>

<liferay-portlet:actionURL portletConfiguration="true" var="configurationURL" />

<aui:form action="<%=configurationURL%>" method="post" name="fm">
	<aui:input name="<%=Constants.CMD%>" type="hidden" value="<%=Constants.UPDATE%>" />
	<aui:input name="redirect" type="hidden" value="<%=redirect%>" />

	<liferay-ui:message key="dsg.configure.sms.properties" />
	<table class="aui-w100">
		<tr>
			<td><aui:input label="From" name="preferences--smsFrom--" type="text" value="<%=smsFrom%>" showRequiredLabel="false">
					<aui:validator name="required"></aui:validator>
					<aui:validator name="number"></aui:validator>
					<aui:validator name="maxLength" errorMessage="Please enter no more than 10 digits.">10</aui:validator>
					<aui:validator name="minLength" errorMessage="Please enter at least 10 digits.">10</aui:validator>
				</aui:input></td>
		</tr>
		<tr>
			<td><aui:input label="Authentication Sid" name="preferences--authSid--" type="text" value="<%=authSid%>" showRequiredLabel="false">
					<aui:validator name="required"></aui:validator>
				</aui:input></td>
		</tr>
		<tr>
			<td><aui:input label="Authentication Token" name="preferences--authTokenId--" type="text" value="<%=authTokenId%>" showRequiredLabel="false">
					<aui:validator name="required"></aui:validator>
				</aui:input></td>
		</tr>
		<tr>
			<td><aui:input label="Body" name="preferences--smsBody--" type="textarea" value="<%=smsBody%>">
					<aui:validator name="maxLength" errorMessage="Please enter no more than 160 characters.">160</aui:validator>
				</aui:input></td>
		</tr>
	</table>
	<aui:button type="submit" />
</aui:form>




