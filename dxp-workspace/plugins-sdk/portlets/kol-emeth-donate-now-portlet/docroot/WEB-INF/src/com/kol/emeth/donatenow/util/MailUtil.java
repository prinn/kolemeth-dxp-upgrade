package com.kol.emeth.donatenow.util;

import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.util.mail.MailEngine;
import com.liferay.util.mail.MailEngineException;

public final class MailUtil {

	
	private static Log logger = LogFactoryUtil.getLog(MailUtil.class);

	private MailUtil() {
	}
	
	
	/**
	 * 
	 * @param fromEmailId
	 * @param toEmailIds
	 * @param ccEmailIds
	 * @param subject
	 * @param body
	 */
	public static void sendEmail(String fromEmailId, String toEmailIds, String subject, String body){
		try {
			InternetAddress iFrom = new InternetAddress(fromEmailId);
			String[] array = toEmailIds.split(StringPool.SEMICOLON);
			InternetAddress[] iTo = new InternetAddress[array.length];
			for(int index = 0; index < iTo.length; index++){
				iTo[index] = new InternetAddress(array[index]);
			}			
				
				MailEngine.send(iFrom, iTo, subject, body, true);
				
			if (logger.isDebugEnabled()) {
				logger .info("Email sent successfully.");
			}
			
		} catch (AddressException e) {
			if (logger.isDebugEnabled()) {
				logger .info("Could not be send Email.", e);
			}
		} catch (MailEngineException e) {
			if (logger.isDebugEnabled()) {
				logger .info("Could not be send Email.", e);
			}
		}
	}
}
