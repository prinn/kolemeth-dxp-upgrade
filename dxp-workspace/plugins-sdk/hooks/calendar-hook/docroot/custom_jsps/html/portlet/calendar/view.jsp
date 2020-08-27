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


<%@page import="nl.bitwalker.useragentutils.DeviceType"%>
<%@page import="nl.bitwalker.useragentutils.UserAgent"%>
<%@ include file="/html/portlet/calendar/init.jsp" %>


<% 
boolean checkDevice = UserAgent.parseUserAgentString(request.getHeader("user-agent")).getOperatingSystem().isMobileDevice();
		 
String tabs1 = ParamUtil.getString(request, "tabs1", tabs1Default);
String eventType = ParamUtil.getString(request, "eventType");
		 
String[] eventTypes = StringUtil.split(ParamUtil.getString(request, "eventType"));

String selCategory = ParamUtil.getString(request, "selCategory", "All Events");

PortletURL portletURL = renderResponse.createRenderURL();

portletURL.setParameter("struts_action", "/calendar/view");

	if(checkDevice){
		tabs1 = "events";
%>
		<style>
			.portlet-calendar ul.aui-tabview-list{
				display : none;
			}
		</style>

<%  } 
portletURL.setParameter("tabs1", tabs1);
String[] urlArray = PortalUtil.stripURLAnchor(portletURL.toString(), "&#");

String urlWithoutAnchor = urlArray[0];
String urlAnchor = urlArray[1];

AssetVocabulary assetVocabularyCalendar = null;
List<AssetVocabulary> assetVocabularies = Collections.emptyList();
List<AssetCategory> assetCategories = Collections.emptyList();
DynamicQuery dynamicQueryForVocabulary = DynamicQueryFactoryUtil.forClass(AssetVocabulary.class, 
			PortalClassLoaderUtil.getClassLoader()).add(PropertyFactoryUtil.forName("name").eq("Calendar"));
assetVocabularies = (List<AssetVocabulary>) AssetVocabularyLocalServiceUtil.dynamicQuery(dynamicQueryForVocabulary);
	if (assetVocabularies != null && assetVocabularies.size() > 0) {
			assetVocabularyCalendar = assetVocabularies.get(0);
	}
	if (assetVocabularyCalendar != null) {
		assetCategories = AssetCategoryLocalServiceUtil.getVocabularyCategories(AssetCategoryConstants.DEFAULT_PARENT_CATEGORY_ID,
							assetVocabularyCalendar.getVocabularyId(), QueryUtil.ALL_POS, QueryUtil.ALL_POS, null);
	}
	
	
	
		String vocabularyNavigation = _buildVocabularyNavigation(
				 assetVocabularyCalendar.getVocabularyId(), themeDisplay);

		if (Validator.isNotNull(vocabularyNavigation)) {
%>

			<%=vocabularyNavigation%>

<%
	}
		
%>

<aui:form method="post" name="fm">
	<liferay-util:include page="/html/portlet/calendar/tabs1.jsp" />

	<c:choose>
		<c:when test='<%= tabs1.equals("summary")  %>'>
			<%@ include file="/html/portlet/calendar/summary.jspf" %>
		</c:when>
		<c:when test='<%= tabs1.equals("day") %>'>
			<%@ include file="/html/portlet/calendar/day.jspf" %>
		</c:when>
		<c:when test='<%= tabs1.equals("week") %>'>
			<%@ include file="/html/portlet/calendar/week.jspf" %>
		</c:when>
		<c:when test='<%= tabs1.equals("month") %>'>
			<%@ include file="/html/portlet/calendar/month.jspf" %>
		</c:when>
		<c:when test='<%= tabs1.equals("year") %>'>
			<%@ include file="/html/portlet/calendar/year.jspf" %>
		</c:when>
		<c:when test='<%= tabs1.equals("events") %>'>
			<%@ include file="/html/portlet/calendar/events.jspf" %>
		</c:when>
		<c:when test='<%= tabs1.equals("all-events") %>'>
			<%@ include file="/html/portlet/calendar/all-events.jspf" %>
		</c:when>
		<c:when test='<%= tabs1.equals("export-import") %>'>
			<%@ include file="/html/portlet/calendar/export_import.jspf" %>
		</c:when>
	</c:choose>
</aui:form>

<%
if (!tabs1.equals("summary")) {
	PortalUtil.addPortletBreadcrumbEntry(request, LanguageUtil.get(pageContext, tabs1), currentURL);
}
%>


<%!private String _buildVocabularyNavigation(
			long categoryId, ThemeDisplay themeDisplay)
			throws Exception {
	List<AssetCategory> categories = AssetCategoryLocalServiceUtil.getVocabularyCategories(AssetCategoryConstants.DEFAULT_PARENT_CATEGORY_ID,
			categoryId, QueryUtil.ALL_POS, QueryUtil.ALL_POS, null);
// 		List<AssetCategory> categories = AssetCategoryLoServiceUtil
// 				.getVocabularyRootCategories(AssetCategoryConstants.DEFAULT_PARENT_CATEGORY_ID,vocabulary.getVocabularyId(),
// 						-1, -1, null);

		if (categories.isEmpty()) {
			return null;
		}

		StringBundler sb = new StringBundler();

		_buildCategoriesNavigation(categories, categoryId, themeDisplay, sb );

		return sb.toString();
	}
private void _buildCategoriesNavigation(List<AssetCategory> categories,
		long categoryId, ThemeDisplay themeDisplay,	StringBundler sb ) throws Exception {
	for (AssetCategory category : categories) {
		category = category.toEscapedModel();
		List<AssetCategory> categoriesChildren = AssetCategoryServiceUtil
				.getChildCategories(category.getCategoryId(),
						QueryUtil.ALL_POS, QueryUtil.ALL_POS, null);
		String title = category.getTitle(themeDisplay.getLocale());
		if (!categoriesChildren.isEmpty()) {
			sb.append("<input id=\"" + title.toLowerCase() + "\" name=\"" + title.toLowerCase()
					+ "\" type=\"hidden\" value=\"");
			_buildsCategoriesNavigation(categoriesChildren, categoryId, themeDisplay, sb);
			sb.append("\" >");
		}
	}
}

private void _buildsCategoriesNavigation(
		List<AssetCategory> categoriesChildren, long categoryId,
		ThemeDisplay themeDisplay, StringBundler sb) {
	for (AssetCategory category : categoriesChildren) {
		String title = category.getTitle(themeDisplay.getLocale());
		sb.append(title.toLowerCase());
		sb.append(",");
	}

}


/**
*to fech select
*/

private String _buildVocabularyNavigation(long vocabularyId, ThemeDisplay themeDisplay, String selCategory, String eventType)
		throws Exception {
	
	List<AssetCategory> categories = AssetCategoryLocalServiceUtil.getVocabularyCategories(AssetCategoryConstants.DEFAULT_PARENT_CATEGORY_ID,
			vocabularyId, QueryUtil.ALL_POS, QueryUtil.ALL_POS, null);

	if (categories.isEmpty()) {
		return null;
	}

	StringBundler sb = new StringBundler();

	_buildCategoriesNavigation(categories, vocabularyId, 
			themeDisplay, sb, selCategory, eventType);
	return sb.toString();
}

	private void _buildCategoriesNavigation(List<AssetCategory> categories,
			long categoryId, ThemeDisplay themeDisplay,
			StringBundler sb, String selCategory, String eventType ) throws Exception {
		for (AssetCategory category : categories) {
			category = category.toEscapedModel();
			List<AssetCategory> categoriesChildren = AssetCategoryServiceUtil
					.getChildCategories(category.getCategoryId(),
							QueryUtil.ALL_POS, QueryUtil.ALL_POS, null);
			String title = category.getTitle(themeDisplay.getLocale());
			if (!categoriesChildren.isEmpty() && selCategory.equalsIgnoreCase(title)) {
				sb.append("<select id=\"_" + title + "\" name=\"_" + title +"\" onChange=\"javascript:getSelSubEvents(this);\" > ");
				sb.append("<option value=\"");
				sb.append(title.toLowerCase());
				sb.append("\" >");
				sb.append("All "+title);
				sb.append("</option>");
				_buildsCategoriesNavigation(categoriesChildren, categoryId,
						 themeDisplay, sb, selCategory, eventType);
				sb.append("</select >");
			}
		}
	}

	private void _buildsCategoriesNavigation(
			List<AssetCategory> categoriesChildren, long categoryId,
			 ThemeDisplay themeDisplay, StringBundler sb, String selCategory, String eventType) {
		for (AssetCategory category : categoriesChildren) {
			String title = category.getTitle(themeDisplay.getLocale());
				sb.append("<option value=\"");
				sb.append(title.toLowerCase());
				sb.append("\" ");
				if(eventType.equalsIgnoreCase(title)){
					
					sb.append(" selected >");
				}else{
					sb.append(">");
				}
				
				sb.append(title);
				sb.append("</option>");
		}

	}%>
	
