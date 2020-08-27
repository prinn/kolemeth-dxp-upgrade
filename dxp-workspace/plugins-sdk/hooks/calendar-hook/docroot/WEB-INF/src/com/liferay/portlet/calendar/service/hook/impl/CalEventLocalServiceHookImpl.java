package com.liferay.portlet.calendar.service.hook.impl;

import com.liferay.portal.kernel.cal.TZSRecurrence;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.service.ServiceContext;
import com.liferay.portlet.asset.model.AssetCategory;
import com.liferay.portlet.asset.service.AssetCategoryLocalServiceUtil;
import com.liferay.portlet.calendar.model.CalEvent;
import com.liferay.portlet.calendar.service.CalEventLocalService;
import com.liferay.portlet.calendar.service.CalEventLocalServiceWrapper;

public class CalEventLocalServiceHookImpl extends CalEventLocalServiceWrapper {

	public CalEventLocalServiceHookImpl(
			CalEventLocalService calEventLocalService) {
		super(calEventLocalService);
	}
	
	
	@Override
	public CalEvent addEvent(long userId, String title, String description,
			String location, int startDateMonth, int startDateDay,
			int startDateYear, int startDateHour, int startDateMinute,
			int endDateMonth, int endDateDay, int endDateYear,
			int durationHour, int durationMinute, boolean allDay,
			boolean timeZoneSensitive, String type, boolean repeating,
			TZSRecurrence recurrence, int remindBy, int firstReminder,
			int secondReminder, ServiceContext serviceContext)
			throws PortalException, SystemException {

		String updatedType = getCategoryEventsOrEventType(type, serviceContext);
		
		return super.addEvent(userId, title, description, location, startDateMonth,
				startDateDay, startDateYear, startDateHour, startDateMinute,
				endDateMonth, endDateDay, endDateYear, durationHour, durationMinute,
				allDay, timeZoneSensitive, updatedType, repeating, recurrence, remindBy,
				firstReminder, secondReminder, serviceContext);
	}


	@Override
	public CalEvent updateEvent(long userId, long eventId, String title,
			String description, String location, int startDateMonth,
			int startDateDay, int startDateYear, int startDateHour,
			int startDateMinute, int endDateMonth, int endDateDay,
			int endDateYear, int durationHour, int durationMinute,
			boolean allDay, boolean timeZoneSensitive, String type,
			boolean repeating, TZSRecurrence recurrence, int remindBy,
			int firstReminder, int secondReminder, ServiceContext serviceContext)
			throws PortalException, SystemException {
		
		
		String updatedType = getCategoryEventsOrEventType(type, serviceContext);
		
		return super.updateEvent(userId, eventId, title, description, location,
				startDateMonth, startDateDay, startDateYear, startDateHour,
				startDateMinute, endDateMonth, endDateDay, endDateYear, durationHour,
				durationMinute, allDay, timeZoneSensitive, updatedType, repeating, recurrence,
				remindBy, firstReminder, secondReminder, serviceContext);
	}
	
	
	/**
	 * 
	 * @param type
	 * @param serviceContext
	 * @return
	 * @throws PortalException
	 * @throws SystemException
	 */
	private String getCategoryEventsOrEventType(String type,
			ServiceContext serviceContext) throws PortalException,
			SystemException {
		StringBuffer buffer = new StringBuffer();
		
			if(Validator.isNotNull(serviceContext.getAssetCategoryIds()) && serviceContext.getAssetCategoryIds().length > 0){
				long[] nStrings = serviceContext.getAssetCategoryIds();
				
				for(int i=0; i< nStrings.length ; i++){			
					AssetCategory assetCategory = AssetCategoryLocalServiceUtil.getAssetCategory(nStrings[i]);			
					buffer.append(assetCategory.getName().toLowerCase());
					if(nStrings.length-1 != i){
						buffer.append(",");
					}
				
				}
			}
			
			String modifiedType = type;
			if(Validator.isNull(type)){
				modifiedType = buffer.toString();
			}
		return modifiedType;
	}
	
}
