<%@page import="com.liferay.portal.kernel.util.FastDateFormatFactoryUtil"%>
<%@page import="java.text.Format"%>
<%@page import="com.liferay.portal.service.GroupLocalServiceUtil"%>
<%@page import="com.liferay.portal.model.Layout"%>
<%@page import="com.liferay.portal.model.PortletConstants"%>
<%@page import="javax.portlet.PortletRequest"%>
<%@page import="com.liferay.util.Encryptor"%>
<%@page import="javax.portlet.PortletConfig"%>
<%@page import="com.liferay.portal.kernel.util.StringPool"%>
<%@page import="com.liferay.portal.kernel.util.GetterUtil"%>
<%@page import="javax.portlet.PortletPreferences"%>
<%@page import="com.liferay.portlet.PortletPreferencesFactoryUtil"%>
<%@page import="com.liferay.portlet.PortletURLFactoryUtil"%>
<%@page import="com.liferay.portal.util.PortalUtil"%>
<%@page import="com.liferay.portal.service.LayoutLocalServiceUtil"%>
<%@page import="javax.portlet.PortletURL"%>
<%@page import="com.liferay.portal.kernel.dao.orm.QueryUtil"%>
<%@page import="com.liferay.portal.kernel.dao.orm.DynamicQuery"%>
<%@page import="com.liferay.portal.kernel.util.PortalClassLoaderUtil"%>
<%@page import="com.liferay.portal.kernel.dao.orm.DynamicQueryFactoryUtil"%>
<%@page import="com.liferay.portlet.asset.service.AssetVocabularyLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.dao.orm.PropertyFactoryUtil"%>
<%@page import="com.liferay.portlet.asset.model.AssetVocabulary"%>
<%@page import="com.liferay.portlet.asset.model.AssetCategoryConstants"%>
<%@page import="com.liferay.portlet.asset.service.AssetCategoryLocalServiceUtil"%>
<%@page import="java.util.Collections"%>
<%@page import="com.liferay.portlet.asset.model.AssetCategory"%>
<%@page import="java.util.List"%>


<%@page import="com.liferay.portal.kernel.util.CalendarUtil"%>
<%@page import="com.liferay.portal.kernel.util.StringBundler"%>
<%@page import="com.liferay.portal.kernel.util.WebKeys"%>
<%@page import="com.liferay.portal.theme.ThemeDisplay"%>
<%@page import="javax.portlet.RenderRequest"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="com.liferay.portal.kernel.util.Time"%>
<%@page import="com.liferay.portal.kernel.util.HtmlUtil"%>
<%@page import="com.liferay.portal.kernel.util.ListUtil"%>
<%@page import="com.liferay.portal.kernel.dao.search.SearchContainer"%>

<%@page import="java.util.ArrayList"%>
<%@page import="com.liferay.portal.kernel.util.CalendarFactoryUtil"%>
<%@page import="com.liferay.portal.kernel.util.Validator"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="com.liferay.portal.kernel.util.ParamUtil"%>
<%@page import="com.liferay.portal.kernel.util.StringUtil"%>

<%@page import="com.liferay.portlet.calendar.service.CalEventServiceUtil"%>
<%@page import="com.liferay.portlet.calendar.model.CalEvent"%>
<%@page import="java.util.Calendar"%>


<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet"%>
<%@ taglib uri="http://alloy.liferay.com/tld/aui" prefix="aui"%>
<%@ taglib uri="http://liferay.com/tld/portlet" prefix="liferay-portlet"%>
<%@ taglib uri="http://liferay.com/tld/theme" prefix="liferay-theme"%>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui"%>
<%@ taglib uri="http://liferay.com/tld/util" prefix="liferay-util"%>

<portlet:defineObjects />
<liferay-theme:defineObjects />


<%
	PortletPreferences preferences = renderRequest.getPreferences();

	String portletResource = ParamUtil.getString(request,
			"portletResource");

	if (Validator.isNotNull(portletResource)) {
		preferences = PortletPreferencesFactoryUtil.getPortletSetup(
				request, portletResource);
	}
	
	String upcomingType =  GetterUtil.getString(preferences.getValue("upcomingType", StringPool.BLANK));
	int setDuration = GetterUtil.getInteger(preferences.getValue("setDuration", StringPool.BLANK));
	int setTotalEvents = GetterUtil.getInteger(preferences.getValue("setTotalEvents", StringPool.BLANK), 5);
	
	PortletURL viewAllCalendarURL = PortletURLFactoryUtil.create(request, "8", PortalUtil.getPlidFromPortletId(themeDisplay.getScopeGroupId(), "8"), PortletRequest.RENDER_PHASE);
	//PortletURL viewAllCalendarURL = PortletURLFactoryUtil.create(request, "8", LayoutLocalServiceUtil.getFriendlyURLLayout(themeDisplay.getScopeGroupId(), false, "/calendar").getPlid() , PortletRequest.RENDER_PHASE);
	
	viewAllCalendarURL.setParameter("struts_action", "/calendar/view");
	viewAllCalendarURL.setParameter("tabs1", "events");
	
	PortletURL viewCalendarEventURL = PortletURLFactoryUtil.create(request, "8", PortalUtil.getPlidFromPortletId(themeDisplay.getScopeGroupId(), "8"), PortletRequest.RENDER_PHASE);
	//PortletURL viewCalendarEventURL = PortletURLFactoryUtil.create(request, "8", LayoutLocalServiceUtil.getFriendlyURLLayout(themeDisplay.getScopeGroupId(), false, "/calendar").getPlid() , PortletRequest.RENDER_PHASE);
	viewCalendarEventURL.setParameter("struts_action", "/calendar/view_event");
	AssetVocabulary assetVocabularyCalendar = null;
	List<AssetVocabulary> assetVocabularieslist = Collections.emptyList();
	List<AssetCategory> assetCategorieslist = Collections.emptyList();
	
	DynamicQuery dynamicQueryForVocabulary = DynamicQueryFactoryUtil.forClass(AssetVocabulary.class,PortalClassLoaderUtil.getClassLoader())
		.add(PropertyFactoryUtil.forName("name").eq("Calendar"));
	assetVocabularieslist = (List<AssetVocabulary>) AssetVocabularyLocalServiceUtil.dynamicQuery(dynamicQueryForVocabulary);
	
	if (assetVocabularieslist != null && assetVocabularieslist.size() > 0) {
		assetVocabularyCalendar = assetVocabularieslist.get(0);
		}
 
	
	Format noDisplayDayFormat = FastDateFormatFactoryUtil.getSimpleDateFormat("dd", locale);
	Format noDisplayMonthFormat = FastDateFormatFactoryUtil.getSimpleDateFormat("mm", locale);
	Format noDisplayYearFormat = FastDateFormatFactoryUtil.getSimpleDateFormat("yyyy", locale);
	
%>