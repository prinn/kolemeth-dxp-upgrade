package com.kolemeth.delete.calendar.event.portlet;

import java.io.IOException;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletException;

import com.liferay.portal.NoSuchGroupException;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.servlet.SessionErrors;
import com.liferay.portal.kernel.servlet.SessionMessages;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.model.Group;
import com.liferay.portal.service.GroupLocalServiceUtil;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portlet.calendar.service.CalEventLocalServiceUtil;
import com.liferay.util.bridges.mvc.MVCPortlet;

/**
 * @author rajeeva.lochana
 * @version 0.1
 * Portlet implementation class DeleteCalEventPortlet
 */
public class DeleteCalEventPortlet extends MVCPortlet {
	
   /**
    * 
    * @param actionRequest
    * @param actionResponse
    * @throws IOException
    * @throws PortletException
    * @throws PortalException
    * @throws SystemException
    */
    public void deleteLayoutEvent(
            ActionRequest actionRequest, ActionResponse actionResponse) 
            		throws PortalException, SystemException {  
    	
    	try{
	        Group group =  GroupLocalServiceUtil.
		    		getLayoutGroup(getThemeObject(actionRequest).getCompanyId(), 
		    				getThemeObject(actionRequest).getLayout().getPlid());
	    	 
	    	long groupId =  group.getGroupId();
	    	
	    	deleteAllCalEvents(actionRequest, groupId);
    	}catch (NoSuchGroupException e) { 
			SessionErrors.add(actionRequest, "no-event-exist-on-this-layout");
		}

    }
    
    /**
     * 
     * @param actionRequest
     * @param actionResponse
     * @throws IOException
     * @throws PortletException
     */
    public void deleteSiteEvent(
            ActionRequest actionRequest, ActionResponse actionResponse){    	

    	long groupId =  getThemeObject(actionRequest).getScopeGroupId();
    	
    	deleteAllCalEvents(actionRequest, groupId);

    }
    
    
    
    /**
     * 
     * @param actionRequest
     * @param actionResponse
     * @throws IOException
     * @throws PortletException
     */
    public void deleteGlobalEvent(
            ActionRequest actionRequest, ActionResponse actionResponse){    	
    	
    	long groupId =  getThemeObject(actionRequest).getCompanyGroupId();
    	
    	deleteAllCalEvents(actionRequest, groupId);

    }

    
    
	/**
	 * 
	 * @param actionRequest
	 * @param groupId
	 */
	private void deleteAllCalEvents(ActionRequest actionRequest, long groupId) {
		try {
    		  			
		    CalEventLocalServiceUtil.deleteEvents(groupId);
		    
		    SessionMessages.add(actionRequest, "deleted-sucessfully");
			log.info("All event deleted successfully");
			
		}catch (PortalException e) {
			log.error("PortalException - Events not deleted");
			
		} catch (SystemException e) {
			log.error("SystemException - Events not deleted");
		}
	}

	
	/**
	 * 
	 * @param actionRequest
	 * @return
	 */
	private ThemeDisplay getThemeObject(ActionRequest actionRequest) {
		ThemeDisplay themeDisplay = (ThemeDisplay) 
				actionRequest.getAttribute(WebKeys.THEME_DISPLAY);
		return themeDisplay;
	}
  
    private static Log log = LogFactoryUtil.getLog(DeleteCalEventPortlet.class);

}
