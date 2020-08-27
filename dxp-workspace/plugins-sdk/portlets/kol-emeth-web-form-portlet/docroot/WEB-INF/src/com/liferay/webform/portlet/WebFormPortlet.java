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

package com.liferay.webform.portlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.mail.internet.InternetAddress;
import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletPreferences;
import javax.portlet.PortletResponse;
import javax.portlet.ReadOnlyException;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;
import javax.portlet.ValidatorException;
import javax.servlet.http.Cookie;

import com.liferay.counter.service.CounterLocalServiceUtil;
import com.liferay.mail.service.MailServiceUtil;
import com.liferay.portal.NoSuchRoleException;
import com.liferay.portal.kernel.captcha.CaptchaTextException;
import com.liferay.portal.kernel.captcha.CaptchaUtil;
import com.liferay.portal.kernel.dao.orm.QueryUtil;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.mail.MailMessage;
import com.liferay.portal.kernel.portlet.PortletResponseUtil;
import com.liferay.portal.kernel.servlet.SessionErrors;
import com.liferay.portal.kernel.servlet.SessionMessages;
import com.liferay.portal.kernel.util.Constants;
import com.liferay.portal.kernel.util.ContentTypes;
import com.liferay.portal.kernel.util.FileUtil;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.LocalizationUtil;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.StringUtil;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.model.Role;
import com.liferay.portal.model.User;
import com.liferay.portal.service.RoleLocalServiceUtil;
import com.liferay.portal.service.UserLocalServiceUtil;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portlet.PortletPreferencesFactoryUtil;
import com.liferay.portlet.expando.model.ExpandoRow;
import com.liferay.portlet.expando.service.ExpandoRowLocalServiceUtil;
import com.liferay.portlet.expando.service.ExpandoTableLocalServiceUtil;
import com.liferay.portlet.expando.service.ExpandoValueLocalServiceUtil;
import com.liferay.util.bridges.mvc.MVCPortlet;
import com.liferay.webform.util.PortletPropsValues;
import com.liferay.webform.util.WebFormUtil;

/**
 * @author Daniel Weisser
 * @author Jorge Ferrer
 * @author Alberto Montero
 * @author Julio Camarero
 * @author Brian Wing Shun Chan
 */
public class WebFormPortlet extends MVCPortlet {
	
	
	private static final String DATA_BASE_TABLE_NAME = "databaseTableName";
	private static final String FIELD_LABEL = "fieldLabel";
	private static final String PARAGRAPH = "paragraph";
	private static final String FIELD_TYPE = "fieldType";
	private static final String FIELD = "field";

	public void deleteData(
			ActionRequest actionRequest, ActionResponse actionResponse)
		 {
		try {
		ThemeDisplay themeDisplay = (ThemeDisplay)actionRequest.getAttribute(
			WebKeys.THEME_DISPLAY);

		PortletPreferences preferences;
		
			preferences = PortletPreferencesFactoryUtil.getPortletSetup(actionRequest);
		

		String databaseTableName = preferences.getValue(
			DATA_BASE_TABLE_NAME, StringPool.BLANK);

		if (Validator.isNotNull(databaseTableName)) {
			ExpandoTableLocalServiceUtil.deleteTable(
				themeDisplay.getCompanyId(), WebFormUtil.class.getName(),
				databaseTableName);
		}
		} catch (PortalException e) {
			e.getMessage();
		} catch (SystemException e) {
			e.getMessage();
		}
	}

	public void saveData(
			ActionRequest actionRequest, ActionResponse actionResponse)
	 {
		try {
				ThemeDisplay themeDisplay = (ThemeDisplay)actionRequest.getAttribute(WebKeys.THEME_DISPLAY);		
				String portletId = (String)actionRequest.getAttribute(WebKeys.PORTLET_ID);
		
				PortletPreferences 	preferences = PortletPreferencesFactoryUtil.getPortletSetup(actionRequest, portletId);				
		
				boolean requireCaptcha = GetterUtil.getBoolean(preferences.getValue("requireCaptcha", StringPool.BLANK));
				String successURL = GetterUtil.getString(preferences.getValue("successURL", StringPool.BLANK));
				String contentId = GetterUtil.getString(preferences.getValue("contentId", StringPool.BLANK));
				String poUpRedirectURL = GetterUtil.getString(preferences.getValue("poUpRedirectURL", StringPool.BLANK));		
				boolean sendAsEmail = GetterUtil.getBoolean(preferences.getValue("sendAsEmail", StringPool.BLANK));
				boolean saveToDatabase = GetterUtil.getBoolean(preferences.getValue("saveToDatabase", StringPool.BLANK));
				String databaseTableName = GetterUtil.getString(preferences.getValue(DATA_BASE_TABLE_NAME, StringPool.BLANK));
				boolean saveToFile = GetterUtil.getBoolean(preferences.getValue("saveToFile", StringPool.BLANK));
				String fileName = GetterUtil.getString(preferences.getValue("fileName", StringPool.BLANK));
		
				if (requireCaptcha) {
					try {
						CaptchaUtil.check(actionRequest);
					}
					catch (CaptchaTextException cte) {
						SessionErrors.add(actionRequest, CaptchaTextException.class.getName());
								return;
					}
				}
		
				Map<String, String> fieldsMap = new LinkedHashMap<String, String>();
				String contactUsRole = StringPool.BLANK;
				String clientEmailId = StringPool.BLANK;
				String clientName = StringPool.BLANK;
				for (int i = 1; true; i++) {
					String fieldLabel = preferences.getValue(
						FIELD_LABEL + i, StringPool.BLANK);
					
					if("Who would you like to send your message to?".equalsIgnoreCase(fieldLabel.trim()) 
							|| "Send To".equalsIgnoreCase(fieldLabel.trim())		){
					 contactUsRole =	actionRequest.getParameter(FIELD + i);
					}
		
					
					if(fieldLabel.trim().equalsIgnoreCase("Your email")  ||  (fieldLabel.trim()).equalsIgnoreCase("email")){
						clientEmailId = actionRequest.getParameter(FIELD + i);
					}
					
					if(fieldLabel.trim().equalsIgnoreCase("Your Name")  ||  (fieldLabel.trim()).equalsIgnoreCase("name")){
						clientName = actionRequest.getParameter(FIELD + i);
					}
					
					String fieldType = preferences.getValue(
						FIELD_TYPE + i, StringPool.BLANK);
		
					if (Validator.isNull(fieldLabel)) {
						break;
					}
		
					if (fieldType.equalsIgnoreCase(PARAGRAPH)) {
						continue;
					}
		
					fieldsMap.put(fieldLabel, actionRequest.getParameter(FIELD + i));
				}
				
				Set<String> validationErrors = null;
		
				try {
					validationErrors = validate(fieldsMap, preferences);
				}
				catch (Exception e) {
					SessionErrors.add(actionRequest, "validation-script-error",	e.getMessage().trim());		
					return;
				}
		
				sendMailAndSaveData(actionRequest, actionResponse, themeDisplay, portletId, preferences, successURL,
						contentId, poUpRedirectURL, sendAsEmail, saveToDatabase, databaseTableName, saveToFile,
						fileName, fieldsMap, contactUsRole, clientEmailId, clientName, validationErrors);
		} catch (PortalException e1) {
			e1.getMessage();
		} catch (SystemException e1) {
			e1.getMessage();
		} catch (Exception e) {
			e.getMessage();
		}
		
	}

	private void sendMailAndSaveData(ActionRequest actionRequest,
			ActionResponse actionResponse, ThemeDisplay themeDisplay,
			String portletId, PortletPreferences preferences,
			String successURL, String contentId, String poUpRedirectURL,
			boolean sendAsEmail, boolean saveToDatabase,
			String databaseTableName, boolean saveToFile, String fileName,
			Map<String, String> fieldsMap, String contactUsRole,
			String clientEmailId, String clientName,
			Set<String> validationErrors) {

		try {
				if (validationErrors.isEmpty()) {
					boolean databaseSuccess = true;
					boolean fileSuccess = true;
		
					if (sendAsEmail) {
					sendAdminEmail(
							themeDisplay.getCompanyId(), fieldsMap, preferences, contactUsRole, clientName, clientEmailId, themeDisplay);
						sendClientEmail(
								themeDisplay.getCompanyId(), fieldsMap, preferences, clientName, clientEmailId, themeDisplay);
					}
					String predatabaseTableName = databaseTableName;
					if (saveToDatabase) {
						if (Validator.isNull(predatabaseTableName)) {
							predatabaseTableName = WebFormUtil.getNewDatabaseTableName(
								portletId);
		
						
								preferences.setValue(
									DATA_BASE_TABLE_NAME, predatabaseTableName);
							
							preferences.store();
						}
		
						databaseSuccess = saveDatabase(
							themeDisplay.getCompanyId(), fieldsMap, preferences,
							predatabaseTableName);
					}
		
					if (saveToFile) {
						fileSuccess = saveFile(fieldsMap, fileName);
					}
		
					if (databaseSuccess && fileSuccess) {
						SessionMessages.add(actionRequest, "success");
					}
					else {
						SessionErrors.add(actionRequest, "error");
					}
				}
				else {
					for (String badField : validationErrors) {
						SessionErrors.add(actionRequest, "error" + badField);
					}
				}
		
				if (SessionErrors.isEmpty(actionRequest) &&
					Validator.isNotNull(successURL)) {
		
					actionResponse.sendRedirect(successURL);
				}
				
				setCookies(actionResponse, 2);	
				actionRequest.setAttribute("isPopUpMessage", false);
				
				if(SessionErrors.isEmpty(actionRequest) &&
						Validator.isNotNull(poUpRedirectURL) && 
						Validator.isNotNull(contentId)){	
					setCookies(actionResponse, 1);	
					actionRequest.setAttribute("isPopUpMessage", true);			
				}
		} catch (ReadOnlyException e) {
			e.getMessage();
		} catch (IOException e) {
			e.getMessage();
		} catch (ValidatorException e) {
			e.getMessage();
		}

	}


	@Override
	public void serveResource(
		ResourceRequest resourceRequest, ResourceResponse resourceResponse) {

		String cmd = ParamUtil.getString(resourceRequest, Constants.CMD);

		try {
			if (cmd.equals("captcha")) {
				serveCaptcha(resourceRequest, resourceResponse);
			}
			else if (cmd.equals("export")) {
				exportData(resourceRequest, resourceResponse);
			}
		}
		catch (Exception e) {
			log.error(e, e);
		}
	}

	protected void exportData(
			ResourceRequest resourceRequest, ResourceResponse resourceResponse)
		{

		ThemeDisplay themeDisplay = (ThemeDisplay)resourceRequest.getAttribute(
			WebKeys.THEME_DISPLAY);

		PortletPreferences preferences;
		try {
					preferences = PortletPreferencesFactoryUtil.getPortletSetup(resourceRequest);
				
		
				String databaseTableName = preferences.getValue(
					DATA_BASE_TABLE_NAME, StringPool.BLANK);
				String title = preferences.getValue("title", "no-title");
		
				StringBuilder sb = new StringBuilder();
		
				List<String> fieldLabels = new ArrayList<String>();
		
				for (int i = 1; true; i++) {
					String fieldLabel = preferences.getValue(
						FIELD_LABEL + i, StringPool.BLANK);
		
					String localizedfieldLabel = LocalizationUtil.getPreferencesValue(
						preferences, FIELD_LABEL + i, themeDisplay.getLanguageId());
		
					if (Validator.isNull(fieldLabel)) {
						break;
					}
		
					fieldLabels.add(fieldLabel);
		
					sb.append("\"");
					sb.append(localizedfieldLabel.replaceAll("\"", "\\\""));
					sb.append("\";");
				}
		
				sb.deleteCharAt(sb.length() - 1);
				sb.append("\n");
		
				if (Validator.isNotNull(databaseTableName)) {
					List<ExpandoRow> rows = ExpandoRowLocalServiceUtil.getRows(
						themeDisplay.getCompanyId(), WebFormUtil.class.getName(),
						databaseTableName, QueryUtil.ALL_POS, QueryUtil.ALL_POS);
		
					for (ExpandoRow row : rows) {
						for (String fieldName : fieldLabels) {
							String data = ExpandoValueLocalServiceUtil.getData(
								themeDisplay.getCompanyId(),
								WebFormUtil.class.getName(), databaseTableName,
								fieldName, row.getClassPK(), StringPool.BLANK);
		
							data = data.replaceAll("\"", "\\\"");
		
							sb.append("\"");
							sb.append(data);
							sb.append("\";");
						}
		
						sb.deleteCharAt(sb.length() - 1);
						sb.append("\n");
					}
				}
		
				String fileName = title + ".csv";
				byte[] bytes = sb.toString().getBytes();
				String contentType = ContentTypes.APPLICATION_TEXT;
		
				PortletResponseUtil.sendFile(
					resourceRequest, resourceResponse, fileName, bytes, contentType);
		
		} catch (PortalException e) {
			e.getMessage();
		} catch (SystemException e) {
			e.getMessage();
		} catch (IOException e) {
			e.getMessage();
		}
	}

	protected String getMailBody(Map<String, String> fieldsMap) {
		StringBuilder sb = new StringBuilder();

		for (String fieldLabel : fieldsMap.keySet()) {
			String fieldValue = fieldsMap.get(fieldLabel);

			sb.append(fieldLabel);
			sb.append(" : ");
			sb.append(fieldValue);
			sb.append("<br/>");
		}

		return sb.toString();
	}

	protected boolean saveDatabase(
			long companyId, Map<String, String> fieldsMap,
			PortletPreferences preferences, String databaseTableName)
	{

		WebFormUtil.checkTable(companyId, databaseTableName, preferences);	

		try {
			
			long classPK = CounterLocalServiceUtil.increment(
					WebFormUtil.class.getName());
			
			for (String fieldLabel : fieldsMap.keySet()) {
				String fieldValue = fieldsMap.get(fieldLabel);

				ExpandoValueLocalServiceUtil.addValue(
					companyId, WebFormUtil.class.getName(), databaseTableName,
					fieldLabel, classPK, fieldValue);
			}

			return true;
		}
		catch (Exception e) {
			log.error(
				"The web form data could not be saved to the database", e);

			return false;
		}
	}

	protected boolean saveFile(Map<String, String> fieldsMap, String fileName) {

		// Save the file as a standard Excel CSV format. Use ; as a delimiter,
		// quote each entry with double quotes, and escape double quotes in
		// values a two double quotes.

		StringBuilder sb = new StringBuilder();

		for (String fieldLabel : fieldsMap.keySet()) {
			String fieldValue = fieldsMap.get(fieldLabel);

			sb.append("\"");
			sb.append(StringUtil.replace(fieldValue, "\"", "\"\""));
			sb.append("\";");
		}

		String s = sb.substring(0, sb.length() - 1) + "\n";

		try {
			FileUtil.write(fileName, s, false, true);

			return true;
		}
		catch (Exception e) {
			log.error("The web form data could not be saved to a file", e);

			return false;
		}
	}
	
	protected void sendClientEmail(long companyId, Map<String, String> fieldsMap,
			PortletPreferences preferences,	String clientName, 
			String clientEmailId, ThemeDisplay themeDisplay) {
		
		try {
			String emailAddresses = clientEmailId;
			InternetAddress fromAddress = new InternetAddress(
				WebFormUtil.getEmailFromAddress(preferences, companyId),
				WebFormUtil.getEmailFromName(preferences, companyId));
			String subject = WebFormUtil.getEmailSubject(preferences);
			String body = WebFormUtil.getEmailBody(preferences); 
					
			
			body = StringUtil.replace(body, 
							new String[]{
								"[$TO_NAME$]",
								"[$PORTAL_URL$]",
								"[$FROM_ADDRESS$]"								
							}, 
							new String[]{
								clientName,
								themeDisplay.getPortalURL(),
								WebFormUtil.getEmailFromAddress(preferences, companyId)							
							}
					);
					
			MailMessage mailMessage = new MailMessage(
				fromAddress, subject, body, true);

			InternetAddress[] toAddresses = InternetAddress.parse(
				emailAddresses);

			mailMessage.setTo(toAddresses);

			MailServiceUtil.sendEmail(mailMessage);

		}
		catch (Exception e) {
			log.error("The web form email could not be sent", e);
		}
		
	}

	protected boolean sendAdminEmail(
		long companyId, Map<String, String> fieldsMap,
		PortletPreferences preferences, String contactUsRole, String clientName, String clientEmailId, ThemeDisplay themeDisplay) {

		try {
			String emailAddresses = preferences.getValue(
				"emailAddress", StringPool.BLANK);
			
			emailAddresses =  emailAddresses +	getEmailAddress(preferences, contactUsRole, themeDisplay);
			
			if (Validator.isNull(emailAddresses)) {
				log.error(
					"The web form email cannot be sent because no email " +
						"address is configured");

				return false;
			}

			InternetAddress fromAddress = new InternetAddress(clientEmailId, clientName);
			String subject = WebFormUtil.getAdminEmailSubject(preferences);
			String body = WebFormUtil.getAdminEmailBody(preferences);
			
			subject = StringUtil.replace(subject, 
						new String[]{
							"[$PAGE_NAME$]"
						},
						new String[]{
							themeDisplay.getLayout().getHTMLTitle(themeDisplay.getLocale())					
						}
					);
			
			body = StringUtil.replace(body, 
					new String[]{
						"[$FORM_DETAILS$]",
						"[$FROM_NAME$]",
						"[$FROM_ADDRESS$]",
						"[$PAGE_NAME$]"
					}, 
					new String[]{
						getMailBody(fieldsMap),
						clientName,
						clientEmailId,
						themeDisplay.getLayout().getHTMLTitle(themeDisplay.getLocale())
					}
			);
			
			

			MailMessage mailMessage = new MailMessage(
				fromAddress, subject, body, true);

			InternetAddress[] toAddresses = InternetAddress.parse(
				emailAddresses);

			mailMessage.setTo(toAddresses);

			MailServiceUtil.sendEmail(mailMessage);

			return true;
		}
		catch (Exception e) {
			log.error("The web form email could not be sent", e);

			return false;
		}
	}
	
	/**
	 * 
	 * @param portletResponse
	 * @param chargeStatusReturnValue
	 */
	private void setCookies(PortletResponse portletResponse, int chargeStatusReturnValue){
		
            Cookie cookie = new Cookie("WEB_FORM", chargeStatusReturnValue+StringPool.BLANK);
            cookie.setPath(StringPool.SLASH);
            portletResponse.addProperty(cookie);
            
	}

	/**
	 * fetch user email Id based on regular roles.
	 * @param preferences
	 * @return
	 */
	private String getEmailAddress(PortletPreferences preferences, String contactUsRole, ThemeDisplay themeDisplay) {
		
		 String[] rolesList = new String[0];			
		 StringBuffer stringBuffer = new StringBuffer();
		 
		try {
			
			if(Validator.isNotNull(contactUsRole)){
				rolesList = new String[]{contactUsRole};
			}else{
				rolesList = StringUtil.split(preferences.getValue("roles", StringPool.BLANK));
			}
				if(rolesList.length > 0){
					for(int i =0 ; i < rolesList.length ; i++){							
						Role role=RoleLocalServiceUtil.getRole(themeDisplay.getCompanyId(), rolesList[i]);	
						if(Validator.isNotNull(role)){
							List<User> regularRoleUserlList = UserLocalServiceUtil.getRoleUsers(role.getRoleId());					
							
								if (regularRoleUserlList.size() != 0) {
									for (User user : regularRoleUserlList) {
										stringBuffer.append(",");
										stringBuffer.append(user.getEmailAddress());
										
									}
								}
						}							
					}
				}
		}catch(NoSuchRoleException e){ 
			e.getMessage();
		}catch (PortalException e) {
			e.getMessage();
		} catch (SystemException e) {
			e.getMessage();
		}
		
		return stringBuffer.toString();
	}

	protected void serveCaptcha(
			ResourceRequest resourceRequest, ResourceResponse resourceResponse)
	 {

		try {
			CaptchaUtil.serveImage(resourceRequest, resourceResponse);
		} catch (IOException e) {
			e.getMessage();
		}
	}

	protected Set<String> validate(
			Map<String, String> fieldsMap, PortletPreferences preferences)
	{

		Set<String> validationErrors = new HashSet<String>();
		try {
				for (int i = 0; i < fieldsMap.size(); i++) {
					String fieldType = preferences.getValue(
						FIELD_TYPE + (i + 1), StringPool.BLANK);
					String fieldLabel = preferences.getValue(
						FIELD_LABEL + (i + 1), StringPool.BLANK);
					String fieldValue = fieldsMap.get(fieldLabel);
		
					boolean fieldOptional = GetterUtil.getBoolean(
						preferences.getValue(
							"fieldOptional" + (i + 1), StringPool.BLANK));
		
					if (Validator.equals(fieldType, PARAGRAPH)) {
						continue;
					}
		
					if (!fieldOptional && Validator.isNotNull(fieldLabel) &&
						Validator.isNull(fieldValue)) {
		
						validationErrors.add(fieldLabel);
		
						continue;
					}
		
					if (!PortletPropsValues.VALIDATION_SCRIPT_ENABLED) {
						continue;
					}
		
					String validationScript = GetterUtil.getString(
						preferences.getValue(
							"fieldValidationScript" + (i + 1), StringPool.BLANK));
		
					
						if (Validator.isNotNull(validationScript) &&
							!WebFormUtil.validate(
								fieldValue, fieldsMap, validationScript)) {
		
							validationErrors.add(fieldLabel);
		
							continue;
						}
					
				}
		} catch (Exception e) {
			e.getMessage();
		}

		return validationErrors;
	}

	private static Log log = LogFactoryUtil.getLog(WebFormPortlet.class);

}