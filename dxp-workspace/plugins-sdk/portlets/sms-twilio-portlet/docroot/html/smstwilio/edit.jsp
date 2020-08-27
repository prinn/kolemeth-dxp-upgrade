<%@ include file="/html/smstwilio/init.jsp"%>


<liferay-ui:success key="success" message="dsg.sms.properties.success"></liferay-ui:success>

<liferay-portlet:actionURL portletConfiguration="true" var="configurationURL" />

<aui:form action="<%= configurationURL %>" method="post" name="fm">

	<liferay-ui:message key="dsg.configure.sms.properties" />
	<table class="aui-w100">
		<tr>
			<td><aui:input label="From" name="preferences--smsFrom--" type="text" value="<%=smsFrom%>">
					<aui:validator name="required"></aui:validator>
				</aui:input></td>
		</tr>
		<tr>
			<td><aui:input label="Authentication Sid" name="preferences--authSid--" type="text" value="<%=authSid%>">
					<aui:validator name="required"></aui:validator>
				</aui:input></td>
		</tr>
		<tr>
			<td><aui:input label="Authentication Token" name="preferences--authTokenId--" type="text" value="<%=authTokenId%>">
					<aui:validator name="required"></aui:validator>
				</aui:input></td>
		</tr>
		<tr>
			<td><aui:input label="Body" name="preferences--smsBody--" type="textarea" value="<%=smsBody%>" /></td>
		</tr>
	</table>
	<aui:button type="submit" />
</aui:form>




