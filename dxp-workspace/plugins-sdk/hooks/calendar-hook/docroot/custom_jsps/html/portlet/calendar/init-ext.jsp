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

<%@page import="com.liferay.portal.kernel.util.FastDateFormatFactoryUtil"%>
<%@page import="java.text.Format"%>
<%@page import="com.liferay.portlet.asset.service.AssetVocabularyServiceUtil"%>
<%@page import="com.liferay.portlet.asset.service.AssetCategoryLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.util.PortalClassLoaderUtil"%>
<%@page import="com.liferay.portal.theme.ThemeDisplay"%>
<%@page import="com.liferay.portal.kernel.util.StringBundler"%>
<%@page import="com.liferay.portlet.asset.model.AssetCategory"%>
<%@page import="com.liferay.portal.kernel.dao.orm.QueryUtil"%>
<%@page import="com.liferay.portal.kernel.dao.orm.DynamicQuery"%>
<%@page import="com.liferay.portlet.asset.model.AssetCategoryConstants"%>
<%@page import="com.liferay.portlet.asset.service.AssetVocabularyLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.dao.orm.PropertyFactoryUtil"%>
<%@page import="com.liferay.portal.kernel.dao.orm.DynamicQueryFactoryUtil"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.List"%>
<%@page import="com.liferay.portlet.asset.model.AssetVocabulary"%>
<%@page import="com.liferay.portlet.asset.service.AssetCategoryServiceUtil"%>

<%
boolean enableKolEmethCalendar = GetterUtil.getBoolean(preferences.getValue("kolEmethCalendar", "false"));
int setDuration = GetterUtil.getInteger(preferences.getValue("duration", StringPool.BLANK),5);	 
		 if(enableKolEmethCalendar){
			 
			 tabs1Names = "day,week,month,year,events";
		 }
		 
		 if (CalendarPermission.contains(permissionChecker, scopeGroupId, ActionKeys.EXPORT_ALL_EVENTS)) {
				tabs1Names += ",all-events,export-import";
			}
		 
		// String[] noEventDates = preferences.getValues("noEventDates", new String[0]);
		
Format noDisplayDayFormat = FastDateFormatFactoryUtil.getSimpleDateFormat("dd", locale);
Format noDisplayMonthFormat = FastDateFormatFactoryUtil.getSimpleDateFormat("mm", locale);
Format noDisplayYearFormat = FastDateFormatFactoryUtil.getSimpleDateFormat("yyyy", locale);
%>