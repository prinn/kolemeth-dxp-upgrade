package com.kol.emeth.donatenow.util;

import com.liferay.util.portlet.PortletProps;

/**
 * @author Rajeeva Lochana B R
 * @version 0.1
 * 
 */

public final class PortletPropsValues {
	
	private PortletPropsValues(){
		
	}
	
	 static final String[] CREDIT_CARD_TYPES =  PortletProps.getArray(PortletPropsKeys.CREDIT_CARD_TYPES);
	 
	 static final String EMAIL_FROM_ADDRESS =  PortletProps.get(PortletPropsKeys.EMAIL_FROM_ADDRESS);
	 
	 static final String EMAIL_TO_ADDRESS =  PortletProps.get(PortletPropsKeys.EMAIL_TO_ADDRESS);
	
	 static final String EMAIL_FROM_NAME =  PortletProps.get(PortletPropsKeys.EMAIL_FROM_NAME);
	 

}
