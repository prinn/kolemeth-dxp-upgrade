package com.dsg.sms.controller;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.rmi.RemoteException;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletException;
import javax.portlet.PortletRequest;
import javax.portlet.PortletURL;
import javax.xml.rpc.ServiceException;

import com.clickatell.api.soap.webservice.PushServerWSLocator;
import com.clickatell.api.soap.webservice.PushServerWSPortType;
import com.liferay.portal.kernel.servlet.SessionMessages;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portal.util.PortalUtil;
import com.liferay.portlet.PortletURLFactoryUtil;
import com.liferay.util.bridges.mvc.MVCPortlet;
import com.liferay.util.portlet.PortletProps;

/**
 * Portlet implementation class SMSPortlet
 */
public class SMSPortlet extends MVCPortlet {

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
		int apiId = Integer.parseInt(PortletProps.get("clickatell.api.id"));
		System.out.println("apiID:" + apiId);
		try {
			if (phoneNumber != null && phoneNumber.length() > 0) {
				sendSMS(phoneNumber);
				SessionMessages.add(actionRequest, "success");
			}
		} catch (RemoteException e) {
			SessionMessages.add(actionRequest, "error");
			e.printStackTrace();
		} finally {
			actionResponse.sendRedirect(redirectURL.toString());
		}
	}

	private void sendSMS(String phoneNumber) throws RemoteException {
		System.out.println("in send SMS");
		int apiId = Integer.parseInt(PortletProps.get("clickatell.api.id"));
		System.out.println("apiID:" + apiId);
		String userName = PortletProps.get("clickatell.username");
		String password = PortletProps.get("clickatell.password");
		String[] to = new String[] { phoneNumber };
		PushServerWSLocator locator = new PushServerWSLocator();
		PushServerWSPortType portType = null;
		try {
			portType = locator.getPushServerWSPort(new URL(
					"http://api.clickatell.com/soap/webservice.php"));
			System.out.println("porttype:" + portType);
		} catch (MalformedURLException e) {
			System.out.println("message exception:MalformedURLException");
			e.printStackTrace();
		} catch (ServiceException e) {
			System.out.println("message exception:ServiceException");
			e.printStackTrace();
		}

		// send the message
		portType.sendmsg(
				"",
				apiId,
				userName,
				password,
				to,
				"",
				"This msg won't be displayed.Will get Clickatell's message since it is a trial version",
				0, 0, 0, 0, 0.0f, 0, 0, 0, 0, "", 0, "", "", "", 0);

	}
}
