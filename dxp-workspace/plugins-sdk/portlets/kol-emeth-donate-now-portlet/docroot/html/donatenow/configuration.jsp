<!-- 
/**
 * @author Rajeeva Lochana B R
 * @version 0.1
 * 
 */
 -->

<%@page import="com.liferay.portal.model.Role"%>
<%@page import="com.liferay.portal.service.RoleLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.util.HtmlUtil"%>
<%@ include file="/html/donatenow/init.jsp" %>



<%
	String tabs2 = ParamUtil.getString(request, "tabs2", "display-settings");

	String redirect = ParamUtil.getString(request, "redirect");

	String emailFromName = ParamUtil.getString(request, "emailFromName", donateNowPrefs.getEmailFromName(preferences));
	String emailFromAddress = ParamUtil.getString(request, "emailFromAddress", donateNowPrefs.getEmailFromAddress(preferences));

	String emailAddress =  ParamUtil.getString(request, "emailAddress", donateNowPrefs.getEmailToAddress(preferences));
	
	String emailSubject = ParamUtil.getString(request, "emailSubject", donateNowPrefs.getEmailSubject(preferences));
	String emailBody = ParamUtil.getString(request, "emailBody", donateNowPrefs.getEmailBody(preferences));
	
	String adminEmailSubject = ParamUtil.getString(request, "adminEmailSubject", donateNowPrefs.getAdminEmailSubject(preferences));
	String adminEmailBody = ParamUtil.getString(request, "adminEmailBody", donateNowPrefs.getAdminEmailBody(preferences));
	
	
	String editorParam = StringPool.BLANK;
	String editorContent = StringPool.BLANK;
	
	if (tabs2.equals("add-client-email")) {
		editorParam = "emailBody";
		editorContent = emailBody;
	}
	else if (tabs2.equals("add-admin-email")) {
		editorParam = "adminEmailBody";
		editorContent = adminEmailBody;		
	}

%>
<style>
.aui-field-label {
    font-weight: bold !important;
}
</style>

<liferay-portlet:renderURL var="portletURL" portletConfiguration="true">
	<portlet:param name="tabs2" value="<%= tabs2 %>" />
	<portlet:param name="redirect" value="<%= redirect %>" />
</liferay-portlet:renderURL>

<liferay-portlet:actionURL portletConfiguration="true" var="configurationURL" />

<aui:form action="<%= configurationURL %>" method="post" name="fm" onSubmit='<%= "event.preventDefault(); " + renderResponse.getNamespace() + "saveConfiguration();" %>'>
	<aui:input name="<%= Constants.CMD %>" type="hidden" value="<%= Constants.UPDATE %>" />
	<aui:input name="tabs2" type="hidden" value="<%= tabs2 %>" />
	<aui:input name="redirect" type="hidden" value="<%= redirect %>" />
	
	
	<liferay-ui:tabs
		names="display-settings,add-client-email,add-admin-email"
		param="tabs2"
		url="<%= portletURL %>"
	/>
	<c:choose>
			<c:when test='<%= tabs2.equals("display-settings") %>'>
						<aui:input name="preferences--ccTypes--" type="hidden" />
						<aui:input name="preferences--roles--" type="hidden" id="roles" />
					<liferay-ui:panel collapsible="<%= false %>" extended="<%= Boolean.TRUE %>" id="DonateNowEmailConfiguration" persistState="<%= true %>" title="email">
							<aui:fieldset>		
								<div style="display:none;">
										<!-- SP Issue 86: Donate Now - From Address in settings unnecessary
										   To reuse this future we are just hiding function from end user.
										  -->
									<aui:input cssClass="lfr-input-text-container" label="name" name="preferences--emailFromName--" type="text" value="<%= emailFromName %>" showRequiredLabel="false">
										<aui:validator name="required"></aui:validator>
									</aui:input>
					
									<aui:input cssClass="lfr-input-text-container" label="from-address" name="preferences--emailFromAddress--" type="text" value="<%= emailFromAddress %>" showRequiredLabel="false">
										<aui:validator name="email"></aui:validator>
									</aui:input>
								</div>
							
								<aui:input cssClass="lfr-input-text-container" helpMessage="add-email-addresses-separated-by-commas" label="addresses-to" name="preferences--emailAddress--" value="<%= emailAddress %>" />
						
								<aui:field-wrapper label="addresses-to-based-on-roles" helpMessage="addresses-to-based-on-roles-description">
								
								<%
								List<String> lines = new ArrayList<String>();
								String[] linesArr = lines.toArray(new String[lines.size()]);  
								
								List<Role> allRoles = RoleLocalServiceUtil.getRoles(1,"");
								
								
								String[] roles1 = lines.toArray(new String[allRoles.size()]);  
								String[] roles2 = StringUtil.split(preferences.getValue("roles", StringPool.BLANK));
								int count = 0;
								 for(int i=0 ; i < roles1.length; i++){
									 if(!allRoles.get(i).getName().equalsIgnoreCase("Owner") && !allRoles.get(i).getName().equalsIgnoreCase("User")
											 && !allRoles.get(i).getName().equalsIgnoreCase("Guest") && !allRoles.get(i).getName().equalsIgnoreCase("Power User")){
										 roles1[count]	= allRoles.get(i).getName();
										 count = count + 1;
									 }
								 }
				   
								     
				      
				      
				      			List leftList = new ArrayList();
				
									for (int i = 0; i < roles2.length; i++) {
										String roles = (String)roles2[i];
												leftList.add(new KeyValuePair(roles, LanguageUtil.get(pageContext, roles)));
									}
				
									// Right list
				
									List rightList = new ArrayList();
				
									for (int i = 0; i < roles1.length; i++) {
										String roles = (String)roles1[i];
											if (Validator.isNotNull(roles) && !ArrayUtil.contains(roles2, roles) ){
												rightList.add(new KeyValuePair(roles, LanguageUtil.get(pageContext,  roles)));
											}
									}
									%>
				
									<liferay-ui:input-move-boxes
										leftTitle="current"
										rightTitle="available"
										leftBoxName="current_roles"
										rightBoxName="available_roles"
										leftReorder="true"
										leftList="<%= leftList %>"
										rightList="<%= rightList %>"
									/>
								</aui:field-wrapper>
						</aui:fieldset>
					</liferay-ui:panel>
					<liferay-ui:panel collapsible="<%= false %>" extended="<%= Boolean.TRUE %>" id="donateNowFormInformationConfiguration" persistState="<%= true %>" title="Form Information">
						<aui:fieldset>
							<div class="portlet-msg-info">
								<aui:a href="https://stripe.com/signup" target="_blank" label="you-can-get-a-api-key-from-stripe" />
							</div>
						
							<aui:input label="stripe.api.key" size="50" name="preferences--apiKey--" type="text" value="<%= apiKeyString %>" wrap="soft" showRequiredLabel="false">
								<aui:validator name="required" errorMessage="stripe.api.key.required"></aui:validator>
							</aui:input>
							
							
							<aui:input style="width:500px;" name="preferences--genaralFundsNames--" label="Fund Names" helpMessage="Please enter fund names separated by commas" type="textarea" showRequiredLabel="false" value="<%= genaralFundsNames %>">
								<aui:validator name="required"></aui:validator>
							</aui:input>

							<aui:input style="width:500px;" name="preferences--fundDescriptions--" label="Fund Descriptions" helpMessage="Please enter fund descriptions separated by semicolons" type="textarea" showRequiredLabel="false" value="<%= fundDescriptions %>">
								<aui:validator name="required"></aui:validator>
							</aui:input>

							
							<aui:field-wrapper label="credit-cards" >
					
										<%
										
										String[] ccTypes1 = DonateNowPreferences.getCCTypes();					
										String[] ccTypes2 = donateNowPrefs.getCcTypes(preferences);
					
										// Left list
					
										List leftList = new ArrayList();
					
										for (int i = 0; i < ccTypes2.length; i++) {
											String ccType = (String)ccTypes2[i];
					
											leftList.add(new KeyValuePair(ccType, LanguageUtil.get(pageContext, "cc_" + ccType)));
										}
					
										// Right list
					
										List rightList = new ArrayList();
					
										for (int i = 0; i < ccTypes1.length; i++) {
											String ccType = (String)ccTypes1[i];
					
											if (!ArrayUtil.contains(ccTypes2, ccType)) {
												rightList.add(new KeyValuePair(ccType, LanguageUtil.get(pageContext, "cc_" + ccType)));
											}
										}
										%>
					
										<liferay-ui:input-move-boxes
											leftTitle="current"
											rightTitle="available"
											leftBoxName="current_cc_types"
											rightBoxName="available_cc_types"
											leftReorder="true"
											leftList="<%= leftList %>"
											rightList="<%= rightList %>"
										/>
									</aui:field-wrapper>
					
							
							<aui:select label="currency" name="preferences--currencyId--" inlineLabel="left">
					
										<%
										for (int i = 0; i < DonateNowPreferences.getCurrencyIds().length; i++) {
										%>
					
											<aui:option label="<%= DonateNowPreferences.getCurrencyIds()[i] %>" selected="<%= currencyId.equals(DonateNowPreferences.getCurrencyIds()[i]) %>" />
					
										<%
										}
										%>
					
							</aui:select>
							
							<aui:input label="total.minimum.amount" name="preferences--totalMinimumAmount--" value="<%= totalMinimumAmount %>" showRequiredLabel="flase" inlineLabel="left">
								<aui:validator name="required"></aui:validator>
								<aui:validator name="digits"></aui:validator>
							</aui:input>
						
						</aui:fieldset>
					</liferay-ui:panel>
			
			</c:when>
			<c:when test='<%= tabs2.startsWith("add-client-email") || tabs2.startsWith("add-admin-email") %>'>
				<aui:fieldset>
				
					<c:choose>
						<c:when test='<%= tabs2.equals("add-client-email") %>'>						
								<aui:input cssClass="lfr-input-text-container" label="subject" name="preferences--emailSubject--" type="text" value="<%= emailSubject %>" />
						</c:when>					
						<c:when test='<%= tabs2.equals("add-admin-email") %>'>		
								<aui:input cssClass="lfr-input-text-container" label="subject" name="preferences--adminEmailSubject--" type="text" value="<%= adminEmailSubject %>" />
						</c:when>				
					</c:choose>
					
					<aui:field-wrapper label="body">
				
						<liferay-ui:input-editor editorImpl="<%= EDITOR_WYSIWYG_IMPL_KEY %>" />
	
						<aui:input name='<%= "preferences--" + editorParam + "--" %>' type="hidden" />
					</aui:field-wrapper>
	
						<div class="definition-of-terms">
							<h4><liferay-ui:message key="definition-of-terms" /></h4>
			
							<dl>
								<dt>
									[$FROM_ADDRESS$]
								</dt>
								<dd>
									<%= HtmlUtil.escape(emailFromAddress) %>
								</dd>
								<dt>
									[$FROM_NAME$]
								</dt>
								<dd>
									<%= HtmlUtil.escape(emailFromName) %>
								</dd>
								<dt>
									[$TO_ADDRESS$]
								</dt>
								<dd>
									<liferay-ui:message key="the-address-of-the-email-recipient" />
								</dd>
								<dt>
									[$TO_NAME$]
								</dt>
								<dd>
									<liferay-ui:message key="the-name-of-the-email-recipient" />
								</dd>
								<c:if test='<%= tabs2.equals("add-admin-email") %>'>
									<dt>
										[$ADDRESS$]
									</dt>
									<dd>
										<liferay-ui:message key="the-address-of-the-email-recipient" />
									</dd>
									<dt>
										[$PHONE_NUMBER$]
									</dt>
									<dd>
										<liferay-ui:message key="the-phone-number-of-the-email-recipient" />
									</dd>
								</c:if>
								<dt>
									[$SYMBOL$]
								</dt>
								<dd>
									<liferay-ui:message key="currency-symbol" />
								</dd>
								<dt>
									[$AMOUNT$]
								</dt>
								<dd>
									<liferay-ui:message key="donation-total-amount" />
								</dd>
								<dt>
									[$SYS_DATE$]
								</dt>
								<dd>
									<liferay-ui:message key="sys-date" />
								</dd>
							</dl>
						</div>
				</aui:fieldset>
			</c:when>
	</c:choose>

	<aui:button-row>
		<aui:button type="submit" />
	</aui:button-row>

</aui:form>
	<aui:script>
		<c:if test='<%= tabs2.startsWith("display-settings") %>'>
	
				Liferay.provide(
					window,
					'<portlet:namespace />saveConfiguration',
					function() {
					setCookie("DONATE_CONFIG","1");
					document.getElementById("<portlet:namespace />roles").value = Liferay.Util.listSelect(document.<portlet:namespace />fm.<portlet:namespace />current_roles);
					var cctypesValue  = Liferay.Util.listSelect(document.<portlet:namespace />fm.<portlet:namespace />current_cc_types); 
					
					if(cctypesValue == ''){
							cctypesValue = 'cc_none';
					}
							document.getElementById("<portlet:namespace />ccTypes").value = cctypesValue;
							submitForm(document.<portlet:namespace />fm);
					},
					['liferay-util-list-fields']
				);
		
		</c:if>
	
	function <portlet:namespace />initEditor() {
		return "<%= UnicodeFormatter.toString(editorContent) %>";
	}
	
	<c:if test='<%= tabs2.startsWith("add-client-email")  || tabs2.startsWith("add-admin-email") %>'>
		function <portlet:namespace />saveConfiguration() {
			document.<portlet:namespace />fm.<portlet:namespace /><%= editorParam %>.value = window.<portlet:namespace />editor.getHTML();
			submitForm(document.<portlet:namespace />fm);
			}
			
			
		</c:if>
	
</aui:script>

<%!
public static final String EDITOR_WYSIWYG_IMPL_KEY = "editor.wysiwyg.portal-web.docroot.html.portlet.journal.configuration.jsp";
%>