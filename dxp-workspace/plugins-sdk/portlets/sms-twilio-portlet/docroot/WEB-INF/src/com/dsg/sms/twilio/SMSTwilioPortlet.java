package com.dsg.sms.twilio;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletException;
import javax.portlet.PortletPreferences;
import javax.portlet.PortletRequest;
import javax.portlet.PortletURL;

import com.liferay.portal.kernel.servlet.SessionErrors;
import com.liferay.portal.kernel.servlet.SessionMessages;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portal.util.PortalUtil;
import com.liferay.portlet.PortletURLFactoryUtil;
import com.liferay.util.bridges.mvc.MVCPortlet;
import com.twilio.sdk.TwilioRestClient;
import com.twilio.sdk.TwilioRestException;
import com.twilio.sdk.resource.factory.SmsFactory;
import com.twilio.sdk.resource.instance.Sms;

/**
 * Portlet implementation class SMSTwilioPortlet
 */
public class SMSTwilioPortlet extends MVCPortlet {
	public void processSMSAction(ActionRequest actionRequest,
			ActionResponse actionResponse) throws IOException, PortletException {
		ThemeDisplay themeDisplay = (ThemeDisplay) actionRequest
				.getAttribute(WebKeys.THEME_DISPLAY);
		String portletName = (String) actionRequest
				.getAttribute(WebKeys.PORTLET_ID);
		PortletURL redirectURL = PortletURLFactoryUtil
				.create(PortalUtil.getHttpServletRequest(actionRequest),
						portletName, themeDisplay.getLayout().getPlid(),
						PortletRequest.RENDER_PHASE);

		String phoneNumber = actionRequest.getParameter("txtSms");
		try {
			if (phoneNumber != null && phoneNumber.length() > 0) {
				sendSMS(phoneNumber, actionRequest);
				SessionMessages.add(actionRequest, "success");
			}
		} catch (TwilioRestException e) {
			SessionErrors.add(actionRequest, "error");
			e.printStackTrace();
		} finally {
			actionResponse.sendRedirect(redirectURL.toString());
		}
	}

	private void sendSMS(String phoneNumber, ActionRequest actionRequest)
			throws TwilioRestException {
		PortletPreferences portletPreferences = actionRequest.getPreferences();
		String authTokenId = portletPreferences.getValue("authTokenId", "");
		String authSid = portletPreferences.getValue("authSid", "");
		String smsFrom = portletPreferences.getValue("smsFrom", "");
		String smsBody = portletPreferences.getValue("smsBody", "");
		if (authTokenId == "" && authSid == "" && smsFrom == "") {
			SessionErrors.add(actionRequest, "propertiesNotSet");
		} else {
			TwilioRestClient client = new TwilioRestClient(authSid, authTokenId);
			Map<String, String> params = new HashMap<String, String>();
			params.put("Body", smsBody);
			params.put("To", phoneNumber);
			params.put("From", smsFrom);

			SmsFactory messageFactory = client.getAccount().getSmsFactory();
			Sms message = messageFactory.create(params);
			System.out.println(message.getSid());
		}

	}
}
