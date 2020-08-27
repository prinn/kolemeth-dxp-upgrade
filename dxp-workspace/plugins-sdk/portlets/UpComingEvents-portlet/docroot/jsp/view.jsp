<%@ include file="/jsp/init.jsp"%>

<%
	if (upcomingType.isEmpty() && setDuration==0) {
%>
<liferay-util:include page="/html/portal/portlet_not_setup.jsp"></liferay-util:include>
<%
	} else {
%>
<jsp:include page="/jsp/view_upcomingEvents.jsp"></jsp:include>
<%
	}
%>