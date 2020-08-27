
<%@ include file="/jsp/init.jsp"%>

<%@page import="com.liferay.portal.kernel.util.Constants"%>
<%@page import="com.liferay.portal.kernel.util.ParamUtil"%>

<%
	String redirect = ParamUtil.getString(request, "redirect");
%>

<h4>Please configure below properties to see upcoming calendar events.</h4>
<liferay-portlet:actionURL portletConfiguration="true"
	var="configurationURL" />

<aui:form action="<%=configurationURL%>" method="post" name="fm">
	<aui:input name="<%=Constants.CMD%>" type="hidden"
		value="<%=Constants.UPDATE%>" />
	<aui:input name="redirect" type="hidden" value="<%=redirect%>" />
	<aui:fieldset>
		<div class="social-boomarks-options" id="<portlet:namespace />kolEmethView">
			<aui:select name="preferences--upcomingType--" label="Upcoming Types">
			<aui:option value="" ></aui:option>
			
			<%
			if (assetVocabularyCalendar != null) {
					assetCategorieslist = AssetCategoryLocalServiceUtil.getVocabularyCategories(
						AssetCategoryConstants.DEFAULT_PARENT_CATEGORY_ID, 	assetVocabularyCalendar.getVocabularyId(), QueryUtil.ALL_POS,	QueryUtil.ALL_POS, null);
		
			
				for (AssetCategory assetCategory : assetCategorieslist) {
					
					assetCategory = assetCategory.toEscapedModel();
					
					%>
					<aui:option value="<%=assetCategory.getTitle(themeDisplay.getLocale()).toLowerCase() %>" label="<%=assetCategory.getTitle(themeDisplay.getLocale()) %>" selected="<%= assetCategory.getTitle(themeDisplay.getLocale()).equalsIgnoreCase(upcomingType) %>"></aui:option>
					<%			
				}
			}%>
			
			</aui:select>
		<aui:input name="preferences--setDuration--" type="text"  label="Enter Duration in Month" value="<%=setDuration%>" />
		<aui:input name="preferences--setTotalEvents--" type="text"  label="Total number of Events to View" value="<%=setTotalEvents%>" />
		</div>
	</aui:fieldset>
	<aui:button type="submit" />
</aui:form>
