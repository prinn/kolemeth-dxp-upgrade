package com.kol.emeth.donatenow.util;

import java.util.Currency;
import java.util.Locale;
import java.util.Set;
import java.util.TreeSet;

import javax.portlet.PortletPreferences;

import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.StringUtil;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.util.ContentUtil;
import com.liferay.util.portlet.PortletProps;
/**
 * @author Rajeeva Lochana B R
 * @version 0.1
 * 
 */


public class DonateNowPreferences {

	public static String[] getCurrencyIds() {
		
		String[] currencyIds = null;

				Set<String> set = new TreeSet<String>();

				Locale[] locales = Locale.getAvailableLocales();

				for (int i = 0; i < locales.length; i++) {
					Locale locale = locales[i];

					if (locale.getCountry().length() == 2) {
						Currency currency = Currency.getInstance(locale);

						String currencyId = currency.getCurrencyCode();

						set.add(currencyId);
					}
				}

				currencyIds = set.toArray(new String[set.size()]);
				
			if(Validator.isNull(currencyIds)){
				currencyIds =	new String[] {"USD", "CAD", "EUR", "GBP", "JPY"};
			}
		
		return currencyIds;
		
	}
	
	
	public static String[] getCCTypes() {		
	
		return PortletPropsValues.CREDIT_CARD_TYPES;
		
	}
	

	public String[] getCcTypes(PortletPreferences portletPreferences) {
		String ccTypes = portletPreferences.getValue(
			"ccTypes", StringUtil.merge(getCCTypes()));

		if (ccTypes.equals(Constants.CC_NONE)) {
			return new String[0];
		}
		else {
			return StringUtil.split(ccTypes);
		}
	}
	
	public String getCurrencyId(PortletPreferences portletPreferences) {
		return portletPreferences.getValue("currencyId", "USD");
	}
	
	public String getAPIKey(PortletPreferences portletPreferences) {
		return portletPreferences.getValue("apiKey", StringPool.BLANK);
	}
	
	public String getGenaralFundsNames(PortletPreferences portletPreferences) {
		
		return portletPreferences.getValue("genaralFundsNames", "General Fund");
		
	}
	
	public String getFundDescriptions(PortletPreferences portletPreferences) {
		
		return portletPreferences.getValue("fundDescriptions", "Description");
		
	}	
	
	public String getEmailFromAddress(
			PortletPreferences preferences)
		{

		return preferences.getValue(
				"emailFromAddress", PortletPropsValues.EMAIL_FROM_ADDRESS);
	}
	
	
	public String getEmailToAddress(
			PortletPreferences preferences) {
		
		String emailAddress = preferences.getValue(
				"emailAddress", StringPool.BLANK );
		
		if(Validator.isNull(emailAddress)){
			emailAddress = PortletPropsValues.EMAIL_TO_ADDRESS;
		}
		
			return emailAddress ;
			
	}
	
	public String  getAdminEmailToAddress(
			PortletPreferences preferences)
		 {

		return preferences.getValue(
				"emailAddress", StringPool.BLANK);
	}

	public String getEmailFromName(
			PortletPreferences preferences)
		{

		return preferences.getValue(
				"emailFromName", PortletPropsValues.EMAIL_FROM_NAME);
	}
	
	public String getEmailSubject(
			PortletPreferences preferences) {

			String emailSubject = preferences.getValue(
				"emailSubject", StringPool.BLANK);

			if (Validator.isNotNull(emailSubject)) {
				return emailSubject;
			}
			else {
				return ContentUtil.get(PortletProps.get(PortletPropsKeys.EMAIL_SUBJECT));
			}
	}
	
	
	public String getEmailBody(
			PortletPreferences preferences) {

			String emailBody = preferences.getValue(
				"emailBody", StringPool.BLANK);

			if (Validator.isNotNull(emailBody)) {
				return emailBody;
			}
			else {
				return ContentUtil.get(PortletProps.get(PortletPropsKeys.EMAIL_BODY));
			}
	}
	
	
	
	public String getAdminEmailSubject(
			PortletPreferences preferences) {

			String adminEmailSubject = preferences.getValue(
				"adminEmailSubject", StringPool.BLANK);

			if (Validator.isNotNull(adminEmailSubject)) {
				return adminEmailSubject;
			}
			else {
				return ContentUtil.get(PortletProps.get(PortletPropsKeys.ADMIN_EMAIL_SUBJECT));
			}
	}
	
	
	public String getAdminEmailBody(
			PortletPreferences preferences) {

			String adminEmailBody = preferences.getValue(
				"adminEmailBody", StringPool.BLANK);

			if (Validator.isNotNull(adminEmailBody)) {
				return adminEmailBody;
			}
			else {
				return ContentUtil.get(PortletProps.get(PortletPropsKeys.ADMIN_EMAIL_BODY));
			}
	}
	
	
	public Integer getDonationMinimumAmount(
			PortletPreferences portletPreferences) {
		
		return GetterUtil.getInteger(portletPreferences.getValue("totalMinimumAmount", "0"));
		
	}

		
	public static DonateNowPreferences getInstance(
			PortletPreferences portletPreferences){

			return new DonateNowPreferences();
			
		}
	

}
