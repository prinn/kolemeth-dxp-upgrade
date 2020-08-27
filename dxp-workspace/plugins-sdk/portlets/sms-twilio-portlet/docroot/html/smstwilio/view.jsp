<%@ include file="/html/smstwilio/init.jsp"%>

<%
	boolean smsPropertyNotSetFlag = false;
	if (authTokenId == "" && authSid == "" && smsFrom == "") {
		smsPropertyNotSetFlag = true;
	}
%>

<%
	if (smsPropertyNotSetFlag) {
%>
<liferay-util:include page="/html/portal/portlet_not_setup.jsp"></liferay-util:include>

<%
	} else {
%>
<jsp:include page="/html/smstwilio/sendSMS.jsp"></jsp:include>
<%
	}
%>
