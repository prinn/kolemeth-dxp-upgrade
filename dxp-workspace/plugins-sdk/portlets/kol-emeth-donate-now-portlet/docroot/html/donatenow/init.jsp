<!-- 
/**
 * @author Rajeeva Lochana B R
 * @version 0.1
 * 
 */
 -->

<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>
<%@ taglib uri="http://liferay.com/tld/portlet" prefix="liferay-portlet" %>
<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>
<%@ taglib uri="http://liferay.com/tld/theme" prefix="theme" %>
<%@ taglib uri="http://liferay.com/tld/util" prefix="liferay-util" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@page import="com.liferay.portal.kernel.util.Constants"%>
<%@page import="com.liferay.portal.kernel.util.ParamUtil"%>
<%@page import="com.liferay.portal.kernel.util.PropsUtil"%>
<%@page import="com.liferay.portal.kernel.util.StringUtil"%>
<%@page import="com.liferay.portal.kernel.util.PropsKeys"%>
<%@page import="com.liferay.portal.kernel.util.ArrayUtil"%>
<%@page import="com.liferay.portal.kernel.util.KeyValuePair"%>
<%@page import="com.liferay.portal.kernel.util.Validator"%>
<%@page import="com.liferay.portal.kernel.util.StringPool"%>
<%@page import="com.liferay.portal.kernel.util.GetterUtil"%>
<%@page import="com.liferay.portal.kernel.captcha.CaptchaTextException"%>
<%@page import="com.liferay.portal.kernel.captcha.CaptchaMaxChallengesException"%>
<%@page import="com.liferay.portal.kernel.language.LanguageUtil"%>
<%@page import="com.liferay.portal.kernel.portlet.LiferayWindowState"%>
<%@page import="com.liferay.portal.kernel.util.HtmlUtil"%>
<%@page import="com.liferay.portal.kernel.util.UnicodeFormatter"%>
<%@page import="com.liferay.portlet.PortalPreferences" %>
<%@page import="com.liferay.portlet.journal.model.JournalArticleDisplay"%>
<%@page import="com.liferay.portlet.journal.service.JournalArticleLocalServiceUtil"%>
<%@page import="com.liferay.portlet.journal.model.JournalArticle"%>
<%@page import="com.liferay.portal.util.PortalUtil"%>
<%@page import="com.liferay.portal.kernel.util.PrefsPropsUtil"%>
<%@page import="com.liferay.portlet.PortletPreferencesFactoryUtil"%>

<%@page import="javax.portlet.PortletPreferences"%>
<%@page import="javax.portlet.WindowState"%>
<%@page import="javax.portlet.ValidatorException"%>

<%@page import="java.util.Arrays"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Currency"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Enumeration"%>

<%@page import="java.text.NumberFormat"%>
<%@page import="java.text.DecimalFormat"%>

<%@page import="com.kol.emeth.donatenow.model.DonateNowForm"%>
<%@page import="com.kol.emeth.donatenow.util.DonateNowPreferences"%>



<portlet:defineObjects />
<theme:defineObjects/>


<%

String currentURL = PortalUtil.getCurrentURL(request);

PortletPreferences preferences = null;

if (renderRequest != null) {
	preferences = renderRequest.getPreferences();
}

String portletResource = ParamUtil.getString(request, "portletResource");

if (Validator.isNotNull(portletResource)) {
	preferences = PortletPreferencesFactoryUtil.getPortletSetup(request, portletResource);
}

	DonateNowPreferences donateNowPrefs = DonateNowPreferences.getInstance(preferences);
	
	String currencyId = donateNowPrefs.getCurrencyId(preferences) ;
	
	Currency currency = Currency.getInstance(currencyId);	
	
	String apiKeyString = donateNowPrefs.getAPIKey(preferences);
	
	String genaralFundsNames = donateNowPrefs.getGenaralFundsNames(preferences);
	
	String fundDescriptions = donateNowPrefs.getFundDescriptions(preferences);
	
	Integer totalMinimumAmount =  ParamUtil.getInteger(request, "totalMinimumAmount", donateNowPrefs.getDonationMinimumAmount(preferences));
	
%>

<script type="text/javascript">
	var currentPage = window.location.pathname;

	function redirectToSupportNowPage(url){	
		
		if(!url){
			url = currentPage;
		}
		window.top.parent.location = url;
	}
	
	
	 function showPopup(url) {
		  var $dialog = $('<div id="dialog" class="event-dialog" title="" style="display:none;"></div>')
           .html('<iframe frameBorder="0" src="' + url + '" width="99%"></iframe>')
          .dialog({
              autoOpen: false,
              modal: true,
              title: ""
          });
			$dialog.dialog('open');
		   
	   }
</script>