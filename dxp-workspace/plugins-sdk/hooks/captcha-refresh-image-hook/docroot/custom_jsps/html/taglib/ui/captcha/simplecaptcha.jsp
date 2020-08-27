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

<%@ include file="/html/taglib/ui/captcha/init.jsp" %>
<%@ taglib uri="http://liferay.com/tld/theme" prefix="theme" %>
<theme:defineObjects/>
<%
String url = (String)request.getAttribute("liferay-ui:captcha:url");

boolean captchaEnabled = false;

try {
	if (portletRequest != null) {
		captchaEnabled = CaptchaUtil.isEnabled(portletRequest);
	}
	else {
		captchaEnabled = CaptchaUtil.isEnabled(request);
	}
}
catch (CaptchaMaxChallengesException cmce) {
	captchaEnabled = true;
}

%>

<c:if test="<%= captchaEnabled %>">

	<div class="taglib-captcha">
				<aui:layout> 
					<aui:column>
						<img alt="<liferay-ui:message key="text-to-identify" />" class="captcha" src="<%= url %>" />
					</aui:column>
					<aui:column>
						<a href="#" class="captcha-reload">
							<img src="<%= themeDisplay.getPathThemeImages()%>/custom/refresh-icon2.png" alt="Reload-Capcha" style="margin: 0px 0px -16px" />
						</a>
					</aui:column>
				</aui:layout>
				
		<aui:input label="text-verification" name="captchaText" size="10" type="text" value="">
			<aui:validator name="required" />
		</aui:input>
	</div>
		
	<script>
		jQuery(".captcha-reload").click(function() {
			jQuery(".captcha").attr("src", jQuery(".captcha").attr("src")+"&force=" + new Date().getMilliseconds());
			return false;
			});	
	</script>

</c:if>


