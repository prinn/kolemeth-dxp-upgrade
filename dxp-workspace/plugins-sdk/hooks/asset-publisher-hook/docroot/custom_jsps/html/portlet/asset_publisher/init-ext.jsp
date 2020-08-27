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
<%@page import="javax.portlet.PortletRequest"%>
<%@page import="com.liferay.portal.service.LayoutLocalServiceUtil"%>
<%@page import="com.liferay.portlet.PortletURLFactoryUtil"%>
<%@page import="javax.portlet.PortletURL"%>
<%@ taglib uri="http://liferay.com/tld/theme"  prefix="theme"%>
<%@page import="com.liferay.portal.kernel.util.CalendarFactoryUtil"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.liferay.portal.kernel.util.StringPool"%>
<%@page import="com.liferay.portal.kernel.util.Validator"%>
<%@page import="com.liferay.portal.kernel.dao.orm.DynamicQuery"%>
<%@page import="com.liferay.portal.kernel.dao.orm.DynamicQueryFactoryUtil"%>
<%@page import="com.liferay.portal.kernel.dao.orm.PropertyFactoryUtil"%>
<%@page import="com.liferay.portal.kernel.util.PortalClassLoaderUtil"%>
<%@page import="com.liferay.portlet.asset.model.AssetCategoryConstants"%>
<theme:defineObjects/>
<%

		 String upcomingType = preferences.getValue("upcomingType", StringPool.BLANK);
		 
		 boolean enableKolEmethView = GetterUtil.getBoolean(preferences.getValue("enableKolEmethView", "false"));
		 
		 
			String categoryType = upcomingType;
			
			AssetVocabulary assetVocabularyCalendar = null;
			List<AssetVocabulary> assetVocabularieslist = Collections.emptyList();
			List<AssetCategory> assetCategorieslist = Collections.emptyList();
			
			DynamicQuery dynamicQueryForVocabulary = DynamicQueryFactoryUtil.forClass(AssetVocabulary.class,PortalClassLoaderUtil.getClassLoader())
				.add(PropertyFactoryUtil.forName("name").eq("Calendar"));
			assetVocabularieslist = (List<AssetVocabulary>) AssetVocabularyLocalServiceUtil.dynamicQuery(dynamicQueryForVocabulary);
			
			if (assetVocabularieslist != null && assetVocabularieslist.size() > 0) {
				assetVocabularyCalendar = assetVocabularieslist.get(0);
				}
		 
			
			Calendar curCal = CalendarFactoryUtil.getCalendar(themeDisplay.getTimeZone(), themeDisplay.getLocale());

			int curMonth = curCal.get(Calendar.MONTH);
			int curDay = curCal.get(Calendar.DATE);
			int curYear = curCal.get(Calendar.YEAR);
			
			PortletURL calendarURL = PortletURLFactoryUtil.create(request, "8", LayoutLocalServiceUtil.getFriendlyURLLayout(themeDisplay.getScopeGroupId(), false, "/calendar").getPlid() , PortletRequest.RENDER_PHASE);

			calendarURL.setParameter("struts_action", "/calendar/view");
			calendarURL.setParameter("tabs1", "events");
			
			String st = calendarURL.toString() + "&_8_" + "month=" + curMonth;
		 
%>