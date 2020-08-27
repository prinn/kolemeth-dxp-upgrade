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

package com.liferay.webform.action;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletConfig;
import javax.portlet.PortletPreferences;
import javax.portlet.ReadOnlyException;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.portlet.DefaultConfigurationAction;
import com.liferay.portal.kernel.servlet.SessionErrors;
import com.liferay.portal.kernel.util.Constants;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.LocaleUtil;
import com.liferay.portal.kernel.util.LocalizationUtil;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.StringUtil;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portlet.PortletPreferencesFactoryUtil;
import com.liferay.portlet.expando.DuplicateColumnNameException;
import com.liferay.webform.util.WebFormUtil;

/**
 * @author Jorge Ferrer
 * @author Alberto Montero
 * @author Julio Camarero
 * @author Brian Wing Shun Chan
 */
public class ConfigurationActionImpl extends DefaultConfigurationAction {
	
	private static final String FIELD_LABEL = "fieldLabel";
	private static final int SEVENTY_FIVE = 75;
	
	@Override
	public void processAction(
			PortletConfig portletConfig, ActionRequest actionRequest,
			ActionResponse actionResponse)
		{
		
		String tabs2 = ParamUtil.getString(actionRequest, "tabs2");

		

		try {
			
			if (tabs2.equals("display-settings")) {
				
					validateFields(actionRequest);		
					
					createfields(actionRequest);
				
				
			}
			else if (tabs2.equals("web-content-added-email")) {
				validateEmailAdded(actionRequest);
			}
			else if (tabs2.equals("web-content-approval-denied-email")) {
				validateAdminEmailAdded(actionRequest);
			}
				
		
				super.processAction(portletConfig, actionRequest, actionResponse);
		} catch (Exception e) {
			e.getMessage();
		}
	}

	protected void validateAdminEmailAdded(ActionRequest actionRequest) {
		
		String adminEmailSubject = getParameter(
				actionRequest, "adminEmailSubject");
			String adminEmailBody = getParameter(
				actionRequest, "adminEmailBody");

			if (Validator.isNull(adminEmailSubject)) {
				SessionErrors.add(actionRequest, "adminEmailSubject");
			}
			else if (Validator.isNull(adminEmailBody)) {
				SessionErrors.add(actionRequest, "adminEmailBody");
			}
		
	}

	protected void validateEmailAdded(ActionRequest actionRequest) {
		
		String emailSubject = getParameter(
				actionRequest, "emailSubject");
			String emailBody = getParameter(
				actionRequest, "emailBody");

			if (Validator.isNull(emailSubject)) {
				SessionErrors.add(actionRequest, "emailSubject");
			}
			else if (Validator.isNull(emailBody)) {
				SessionErrors.add(actionRequest, "emailBody");
			}
	}

	private void createfields(ActionRequest actionRequest)
			 {
		
		try{
				if (!SessionErrors.isEmpty(actionRequest)) {
					return;
				}
		
				Locale defaultLocale = LocaleUtil.getDefault();
				String defaultLanguageId = LocaleUtil.toLanguageId(defaultLocale);
		
				boolean updateFields = ParamUtil.getBoolean(actionRequest, "updateFields");
				String portletResource = ParamUtil.getString(actionRequest, "portletResource");
		
				PortletPreferences preferences = PortletPreferencesFactoryUtil.getPortletSetup(actionRequest, portletResource);
				
		
				LocalizationUtil.setLocalizedPreferencesValues(actionRequest, preferences, "title");
				LocalizationUtil.setLocalizedPreferencesValues(actionRequest, preferences, "description");
		
				updateFields(actionRequest, defaultLocale, defaultLanguageId,
						updateFields, portletResource, preferences);
		
				if (SessionErrors.isEmpty(actionRequest)) {
					preferences.store();
				}
		} catch (PortalException e) {
			e.getMessage();
		} catch (SystemException e) {
			e.getMessage();
		} catch (ReadOnlyException e) {
			e.getMessage();
		} catch (Exception e) {
			e.getMessage();
		} 
	}

	private void updateFields(ActionRequest actionRequest,
			Locale defaultLocale, String defaultLanguageId,
			boolean updateFields, String portletResource,
			PortletPreferences preferences) {
		try {
				if (updateFields) {
					int i = 1;
		
					String databaseTableName = WebFormUtil.getNewDatabaseTableName(portletResource);
		
					
						preferences.setValue("databaseTableName", databaseTableName);
					
		
					int[] formFieldsIndexes = StringUtil.split(ParamUtil.getString(actionRequest, "formFieldsIndexes"), 0);
		
					for (int formFieldsIndex : formFieldsIndexes) {
						Map<Locale, String> fieldLabelMap =
							LocalizationUtil.getLocalizationMap(actionRequest, FIELD_LABEL + formFieldsIndex);
		
						if (Validator.isNull(fieldLabelMap.get(defaultLocale))) {
							continue;
						}
		
						String fieldType = ParamUtil.getString(actionRequest, "fieldType" + formFieldsIndex);
						boolean fieldOptional = ParamUtil.getBoolean(actionRequest, "fieldOptional" + formFieldsIndex);
						Map<Locale, String> fieldOptionsMap = LocalizationUtil.getLocalizationMap(actionRequest, "fieldOptions" + formFieldsIndex);
						String fieldValidationScript = ParamUtil.getString(actionRequest, "fieldValidationScript" + formFieldsIndex);
						String fieldValidationErrorMessage = ParamUtil.getString(actionRequest,	"fieldValidationErrorMessage" + formFieldsIndex);
		
						if ((Validator.isNotNull(fieldValidationScript) ^ (Validator.isNotNull(fieldValidationErrorMessage)))) {
									SessionErrors.add(actionRequest, "invalidValidationDefinition" + i);
						}
		
						updateModifiedLocales( FIELD_LABEL + i, fieldLabelMap, preferences);
						updateModifiedLocales( "fieldOptions" + i, fieldOptionsMap, preferences);
		
						preferences.setValue("fieldType" + i, fieldType);
						preferences.setValue("fieldOptional" + i, String.valueOf(fieldOptional));
						preferences.setValue("fieldValidationScript" + i, fieldValidationScript);
						preferences.setValue("fieldValidationErrorMessage" + i,	fieldValidationErrorMessage);
		
						i++;
					}
		
					if (!SessionErrors.isEmpty(actionRequest)) { return; }
		
					// Clear previous preferences that are now blank
		
					String fieldLabel = LocalizationUtil.getPreferencesValue( preferences, FIELD_LABEL + i, defaultLanguageId);
		
					while (Validator.isNotNull(fieldLabel)) {
						Map<Locale, String> fieldLabelMap = LocalizationUtil.getLocalizationMap(actionRequest, FIELD_LABEL + i);
		
						for (Locale locale : fieldLabelMap.keySet()) {
							String languageId = LocaleUtil.toLanguageId(locale);
		
							LocalizationUtil.setPreferencesValue(preferences, FIELD_LABEL + i, languageId, StringPool.BLANK);
		
							LocalizationUtil.setPreferencesValue(preferences, "fieldOptions" + i, languageId, StringPool.BLANK);
						}
		
						preferences.setValue("fieldType" + i, StringPool.BLANK);
						preferences.setValue("fieldOptional" + i, StringPool.BLANK);
						preferences.setValue("fieldValidationScript" + i, StringPool.BLANK);
						preferences.setValue("fieldValidationErrorMessage" + i, StringPool.BLANK);
						i++;
						fieldLabel = LocalizationUtil.getPreferencesValue(preferences, FIELD_LABEL + i, defaultLanguageId);
					}
				}
		} catch (ReadOnlyException e) {
			e.getMessage();
		} catch (Exception e) {
			e.getMessage();
		}
	}

	@Override
	public String render(
			PortletConfig portletConfig, RenderRequest renderRequest,
			RenderResponse renderResponse)
		{

		String cmd = ParamUtil.getString(renderRequest, Constants.CMD);

		if (cmd.equals(Constants.ADD)) {
			return "/edit_field.jsp";
		}
		else {
			return "/configuration.jsp";
		}
	}

	protected void updateModifiedLocales(
			String parameter, Map<Locale, String> newLocalizationMap,
			PortletPreferences preferences)
		{
		try {
				Map<Locale, String> oldLocalizationMap =
					LocalizationUtil.getLocalizationMap(preferences, parameter);
		
				List<Locale> modifiedLocales = LocalizationUtil.getModifiedLocales(
					oldLocalizationMap, newLocalizationMap);
		
				for (Locale locale : modifiedLocales) {
					String languageId = LocaleUtil.toLanguageId(locale);
					String value = newLocalizationMap.get(locale);
		
				
						LocalizationUtil.setPreferencesValue(
							preferences, parameter, languageId, value);
					
				}
		
		} catch (Exception e) {
			e.getMessage();
		}
	}

	protected void validateFields(ActionRequest actionRequest)
		{

		Locale defaultLocale = LocaleUtil.getDefault();
		String defaultLanguageId = LocaleUtil.toLanguageId(defaultLocale);

		String title = ParamUtil.getString(
			actionRequest, "title" + StringPool.UNDERLINE + defaultLanguageId);

		boolean sendAsEmail = GetterUtil.getBoolean(
			getParameter(actionRequest, "sendAsEmail"));
//		String subject = getParameter(actionRequest, "subject");

		boolean saveToDatabase = GetterUtil.getBoolean(
			getParameter(actionRequest, "saveToDatabase"));

		boolean saveToFile = GetterUtil.getBoolean(
			getParameter(actionRequest, "saveToFile"));

		if (Validator.isNull(title)) {
			SessionErrors.add(actionRequest, "titleRequired");
		}

		if (!sendAsEmail && !saveToDatabase && !saveToFile) {
			SessionErrors.add(actionRequest, "handlingRequired");
		}

		if (sendAsEmail) {
//			if (Validator.isNull(subject)) {
//				SessionErrors.add(actionRequest, "subjectRequired");
//			}

			String[] emailAdresses = WebFormUtil.split(
				getParameter(actionRequest, "emailAddress"));

//			if (emailAdresses.length == 0) {
//				SessionErrors.add(actionRequest, "emailAddressRequired");
//			}

			for (String emailAdress : emailAdresses) {
				emailAdress = emailAdress.trim();

				if (!Validator.isEmailAddress(emailAdress)) {
					SessionErrors.add(actionRequest, "emailAddressInvalid");
				}
			}
		}

		saveToFileValidation(actionRequest, saveToFile);

		saveToDataBaseValidation(actionRequest, saveToDatabase);

		if (!validateUniqueFieldNames(actionRequest)) {
			SessionErrors.add(
				actionRequest, DuplicateColumnNameException.class.getName());
		}
	}

	private void saveToDataBaseValidation(ActionRequest actionRequest,
			boolean saveToDatabase) {
		if (saveToDatabase) {
			int i = 1;

			String languageId = LocaleUtil.toLanguageId(
				actionRequest.getLocale());

			String fieldLabel = ParamUtil.getString(
				actionRequest, FIELD_LABEL + i + "_" + languageId);

			while ((i == 1) || (Validator.isNotNull(fieldLabel))) {
				if (fieldLabel.length() > SEVENTY_FIVE ) {
					SessionErrors.add(actionRequest, "fieldSizeInvalid" + i);
				}

				i++;

				fieldLabel = ParamUtil.getString(
					actionRequest, FIELD_LABEL + i + "_" + languageId);
			}
		}
	}

	private void saveToFileValidation(ActionRequest actionRequest,
			boolean saveToFile) {
		if (saveToFile) {
			String fileName = getParameter(actionRequest, "fileName");

			// Check if server can create a file as specified

			try {
				FileOutputStream fileOutputStream = new FileOutputStream(
					fileName, true);

				fileOutputStream.close();
			}
			catch (SecurityException es) {
				SessionErrors.add(actionRequest, "fileNameInvalid");
			}
			catch (FileNotFoundException fnfe) {
				SessionErrors.add(actionRequest, "fileNameInvalid");
			} catch (IOException e) {
				e.getMessage();
			}
		}
	}

	protected boolean validateUniqueFieldNames(ActionRequest actionRequest) {
		Locale defaultLocale = LocaleUtil.getDefault();

		Set<String> localizedUniqueFieldNames = new HashSet<String>();

		int[] formFieldsIndexes = StringUtil.split(
			ParamUtil.getString(actionRequest, "formFieldsIndexes"), 0);

		for (int formFieldsIndex : formFieldsIndexes) {
			Map<Locale, String> fieldLabelMap =
				LocalizationUtil.getLocalizationMap(
					actionRequest, FIELD_LABEL + formFieldsIndex);

			if (Validator.isNull(fieldLabelMap.get(defaultLocale))) {
				continue;
			}

			for (Locale locale : fieldLabelMap.keySet()) {
				String fieldLabelValue = fieldLabelMap.get(locale);

				if (Validator.isNull(fieldLabelValue)) {
					continue;
				}

				String languageId = LocaleUtil.toLanguageId(locale);

				if (!localizedUniqueFieldNames.add(
						languageId + "_" + fieldLabelValue)) {

					return false;
				}
			}
		}

		return true;
	}

}