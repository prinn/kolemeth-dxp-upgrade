
<%@ include file="/jsp/init.jsp"%>


<%


//PortletURL portletURL = renderResponse.createRenderURL();
//SearchContainer searchContainer = new SearchContainer(renderRequest, null, null, SearchContainer.DEFAULT_CUR_PARAM, SearchContainer.DEFAULT_DELTA, portletURL, null, null);
Calendar cal = CalendarFactoryUtil.getCalendar(timeZone, locale);
//System.out.println("-------TimeZone:" + timeZone);
Calendar tempCal = (Calendar) cal.clone();
int month = cal.get(Calendar.MONTH);
int year = cal.get(Calendar.YEAR);
int date = cal.get(Calendar.DATE);

int currentDay = 0;
int maxDayOfMonth = 0;

Format dateFormatDate = FastDateFormatFactoryUtil.getDate(locale);
Format dateFormatDateTime = FastDateFormatFactoryUtil.getDateTime(locale);
Format dateFormatTime = FastDateFormatFactoryUtil.getTime(locale);
int count = 0;

StringBundler sbcategoryType = new StringBundler();
if (assetVocabularyCalendar != null) {
	
	assetCategorieslist = AssetCategoryLocalServiceUtil.getVocabularyCategories(
				AssetCategoryConstants.DEFAULT_PARENT_CATEGORY_ID, 	assetVocabularyCalendar.getVocabularyId(), QueryUtil.ALL_POS,	QueryUtil.ALL_POS, null);

	sbcategoryType.append(upcomingType.toLowerCase());
	sbcategoryType.append(",");
	for (AssetCategory assetCategory : assetCategorieslist) {
		
		assetCategory = assetCategory.toEscapedModel();
		
		if(upcomingType.equalsIgnoreCase(assetCategory.getTitle(themeDisplay.getLocale()))){
			
				List<AssetCategory> categoriesChildren = AssetCategoryLocalServiceUtil
						.getChildCategories(assetCategory.getCategoryId(),	QueryUtil.ALL_POS, QueryUtil.ALL_POS, null);
				
				String title = assetCategory.getTitle(themeDisplay.getLocale());
				
				if (!categoriesChildren.isEmpty() || upcomingType.equalsIgnoreCase(title)) {
					
					for (AssetCategory category : categoriesChildren) {
						
						sbcategoryType.append(category.getTitle(themeDisplay.getLocale()).toLowerCase());
						sbcategoryType.append(",");
						
					}
					
				}
		}
		
	}
}	

String[] eventTypes = StringUtil.split(sbcategoryType.toString());

for(int m = 0; m <= setDuration; m++){
	tempCal.set(Calendar.MONTH, cal.get(Calendar.MONTH));
	tempCal.set(Calendar.YEAR, cal.get(Calendar.YEAR));
	tempCal.add(Calendar.MONTH, m);
	
	currentDay = tempCal.get(Calendar.DATE);
	maxDayOfMonth = tempCal.getActualMaximum(Calendar.DATE);

	for (int i = currentDay; i <= maxDayOfMonth; i++) {
		
		
		tempCal.set(Calendar.DATE, i);
		List<CalEvent> events = CalEventServiceUtil.getEvents(scopeGroupId, tempCal, eventTypes);
		
		
		 for(int j=0; j < events.size();j++){
			 CalEvent currentEvent = events.get(j);
			 boolean noDisplayEvent = false;
				try{
				String[] noEventDates =  (currentEvent.getExpandoBridge().getAttribute("no-event-date-value")).toString().split(",");
				
				for(int ii = 0 ; ii < noEventDates.length ; ii++){	
					if(Validator.isNotNull(noEventDates[ii])){
						DateFormat formatter = new SimpleDateFormat("mm/dd/yyyy"); 
						Date date1 = (Date)formatter.parse(noEventDates[ii]);
						String noEventDay = noDisplayDayFormat.format(date1).toString();
						String noEventMonth = noDisplayMonthFormat.format(date1).toString();
						String noEventYear = noDisplayYearFormat.format(date1).toString();
						int monthIncByOne = month + 1;
							if(noEventDay.equals(String.valueOf(i).format("%02d", i))
									&& noEventMonth.equals(String.valueOf(monthIncByOne).format("%02d", monthIncByOne))
									&& noEventYear.equals(String.valueOf(year))){
								noDisplayEvent = true;
							}
					}
				}}catch(Exception exception){
					exception.printStackTrace();
				}
			
		
		if(!noDisplayEvent){
			
			Date startDate = null;
			if(count >=setTotalEvents){
				break;
			}
			
			if(currentEvent.isRepeating()){
				count++;
				startDate = tempCal.getTime();
			}else{
				count++;
				startDate = currentEvent.getStartDate();
			}
			
			viewCalendarEventURL.setParameter("eventId", String.valueOf(currentEvent.getEventId()));
			viewCalendarEventURL.setParameter("startDate", String.valueOf(dateFormatDate.format(Time.getDate(startDate, timeZone))));
			String viewURL = viewCalendarEventURL.toString();
			
	%>

<div class="asset-abstract default-asset-publisher">
		
		<h6 class="upcoming-title">
			
					<a href="<%= viewURL %>"><%= HtmlUtil.escape(currentEvent.getTitle()) %></a>					
		</h6>

		<div class="upcoming-content">
			<div class="asset-summary">
			<%if(!currentEvent.isAllDay()){ %>
				<c:choose>
					<c:when test="<%= currentEvent.isTimeZoneSensitive() %>">
						<%= dateFormatTime.format(Time.getDate(currentEvent.getStartDate(), timeZone)) %> <%= dateFormatDate.format(Time.getDate(startDate, timeZone)) %>
					</c:when>
					<c:otherwise>
						<%= dateFormatTime.format(Time.getDate(currentEvent.getStartDate(), timeZone)) %> <%= dateFormatDate.format(tempCal.getTime()) %>
					</c:otherwise>
				</c:choose>
			<%}
			else{			
			 %>
			 <c:choose>
					<c:when test="<%= currentEvent.isTimeZoneSensitive() %>">
						All Day <%= dateFormatDate.format(Time.getDate(startDate, timeZone)) %>
					</c:when>
					<c:otherwise>
						All Day <%= dateFormatDate.format(tempCal.getTime()) %>
					</c:otherwise>
				</c:choose>
			<%} %>			
				<br>
				
				<c:if test="<%= Validator.isNotNull(currentEvent.getLocation()) %>">
					<span class="location"><%= HtmlUtil.escape(currentEvent.getLocation()) %></span>
				</c:if>
				
			</div>
		</div>
</div>


<%	
		}

 		}// third For Loop Ends here
		if(count >=setTotalEvents){
			break;
				}		
	}// second For Loop Ends here
	
	tempCal.set(Calendar.DATE, 1);

	if(count >=setTotalEvents){
		break;
			}
}// first For Loop Ends here

if(count==0){
%>
<h6>No Upcoming <%=upcomingType%>!</h6>
<br/>
<%} %>
<c:if test="<%=Validator.isNotNull(upcomingType)%>">
	<%
	StringBundler sb = new StringBundler();
	if (assetVocabularyCalendar != null) {
		
		assetCategorieslist = AssetCategoryLocalServiceUtil.getVocabularyCategories(
					AssetCategoryConstants.DEFAULT_PARENT_CATEGORY_ID, 	assetVocabularyCalendar.getVocabularyId(), QueryUtil.ALL_POS,	QueryUtil.ALL_POS, null);
	
	
		for (AssetCategory assetCategory : assetCategorieslist) {
			
			assetCategory = assetCategory.toEscapedModel();
			
			if(upcomingType.equalsIgnoreCase(assetCategory.getTitle(themeDisplay.getLocale()))){
				
					List<AssetCategory> categoriesChildren = AssetCategoryLocalServiceUtil
							.getChildCategories(assetCategory.getCategoryId(),	QueryUtil.ALL_POS, QueryUtil.ALL_POS, null);
					
					String title = assetCategory.getTitle(themeDisplay.getLocale());
					
					if (!categoriesChildren.isEmpty() || upcomingType.equalsIgnoreCase(title)) {
						
						for (AssetCategory category : categoriesChildren) {
							
							sb.append(category.getTitle(themeDisplay.getLocale()).toLowerCase());
							sb.append(",");
							
						}
						
					}
			}
			
		}
	}	
		String calendarEventsURL = viewAllCalendarURL.toString() + "&_8_" + "month=" + month + "&_8_" + "day=" + date + "&_8_" + "year=" + year +  "&_8_"+ "selCategory=" + upcomingType + "&_8_" + "eventType="+upcomingType+","+ sb.toString();
	%>
	<a href="<%=calendarEventsURL.toString() %>" >View all</a>
	<!-- <a href="/calendar">View calendar</a> -->
</c:if>
