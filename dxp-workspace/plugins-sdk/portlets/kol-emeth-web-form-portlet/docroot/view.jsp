<%--
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
--%>

<%@ include file="/init.jsp" %>

<portlet:renderURL var="popUpURL" windowState="<%=LiferayWindowState.POP_UP.toString()%>">
		<portlet:param name="jspPage" value="/success.jsp"/>
</portlet:renderURL>

<%
String title = LocalizationUtil.getPreferencesValue(preferences, "title", themeDisplay.getLanguageId());
String description = LocalizationUtil.getPreferencesValue(preferences, "description", themeDisplay.getLanguageId());
boolean requireCaptcha = GetterUtil.getBoolean(preferences.getValue("requireCaptcha", StringPool.BLANK));
String successURL = preferences.getValue("successURL", StringPool.BLANK);
String contentId = preferences.getValue("contentId", StringPool.BLANK);
Boolean isPopUpMessage = GetterUtil.getBoolean(renderRequest.getAttribute("isPopUpMessage"));

	if(Validator.isNotNull(contentId) && isPopUpMessage){
%>
			<script type="text/javascript">
				var pop_up_URL = '<%= popUpURL.toString() %>';
				showPopUpMessage(pop_up_URL);
			</script>
<%
	}
%>



<portlet:actionURL var="saveDataURL">
	<portlet:param name="<%= ActionRequest.ACTION_NAME %>" value="saveData" />
</portlet:actionURL>

<aui:form action="<%= saveDataURL %>" method="post" name="fm">
	<c:if test="<%= Validator.isNull(successURL) %>">
		<aui:input name="redirect" type="hidden" value="<%= currentURL %>" />
	</c:if>

	<aui:fieldset label="<%= HtmlUtil.escape(title) %>">
		<em class="description"><%= HtmlUtil.escape(description) %></em>

		<liferay-ui:success key="success" message="the-form-information-was-sent-successfully" />

		<liferay-ui:error exception="<%= CaptchaMaxChallengesException.class %>" message="maximum-number-of-captcha-attempts-exceeded" />
		<liferay-ui:error exception="<%= CaptchaTextException.class %>" message="text-verification-failed" />
		<liferay-ui:error key="error" message="an-error-occurred-while-sending-the-form-information" />

		<c:if test='<%= PortletPropsValues.VALIDATION_SCRIPT_ENABLED && SessionErrors.contains(renderRequest, "validation-script-error") %>'>
			<liferay-util:include page="/script_error.jsp" />
		</c:if>

		<%
		int i = 1;

		String fieldName = "field" + i;
		String fieldLabel = LocalizationUtil.getPreferencesValue(preferences, "fieldLabel" + i, themeDisplay.getLanguageId());
		boolean fieldOptional = PrefsParamUtil.getBoolean(preferences, request, "fieldOptional" + i, false);
		String fieldValue = ParamUtil.getString(request, fieldName);

		while ((i == 1) || Validator.isNotNull(fieldLabel)) {
			String fieldType = preferences.getValue("fieldType" + i, "text");
			String fieldOptions = LocalizationUtil.getPreferencesValue(preferences, "fieldOptions" + i, themeDisplay.getLanguageId());
			String fieldValidationScript = preferences.getValue("fieldValidationScript" + i, StringPool.BLANK);
			String fieldValidationErrorMessage = preferences.getValue("fieldValidationErrorMessage" + i, StringPool.BLANK);
		%>

			<c:if test="<%= PortletPropsValues.VALIDATION_SCRIPT_ENABLED %>">
				<liferay-ui:error key='<%= "error" + fieldLabel %>' message="<%= fieldValidationErrorMessage %>" />

				<c:if test='<%= Validator.isNotNull(fieldValidationScript) %>'>
					<div class="aui-helper-hidden" id="<portlet:namespace/>validationError<%= fieldName %>">
						<span class="portlet-msg-error"><%= fieldValidationErrorMessage %></span>
					</div>
				</c:if>
			</c:if>

			<c:if test="<%= !fieldOptional %>">
				<div class="aui-helper-hidden" id="<portlet:namespace/>fieldOptionalError<%= fieldName %>">
					<span class="portlet-msg-error"><liferay-ui:message key='<%= (HtmlUtil.escape(fieldLabel)) +" field is mandatory." %>' /></span>
				</div>
			</c:if>

			<c:choose>
				<c:when test='<%= fieldType.equals("paragraph") %>'>
					<p class="lfr-webform" id="<portlet:namespace /><%= fieldName %>"><%= HtmlUtil.escape(fieldOptions) %></p>
				</c:when>
				<c:when test='<%= fieldType.equals("text") %>'>
				    <%if((HtmlUtil.escape(fieldLabel)).equalsIgnoreCase("Your email")  ||  (HtmlUtil.escape(fieldLabel)).equalsIgnoreCase("email") ||  (HtmlUtil.escape(fieldLabel)).equalsIgnoreCase("city")){ %>
				    <!--  <table class="aui-w75" > -->
				    	
				    		<div class="form-input-container-float form-input-container-clear">
								<aui:input size='38' cssClass='<%= fieldOptional ? "optional" : StringPool.BLANK %>' label="<%= HtmlUtil.escape(fieldLabel) %>" name="<%= fieldName %>" value="<%= HtmlUtil.escape(fieldValue) %>" >
										
										<%if(!(HtmlUtil.escape(fieldLabel)).equalsIgnoreCase("city")) {%>
											<aui:validator name="email" errorMessage="Please enter a valid email Id"></aui:validator>										
										<%} else{%>
										 <aui:validator name="custom"  errorMessage="Please enter alpha and numbers only">
								          function (val, fieldNode, rulevalue) {
								                var returnvalue = true;
								                var iChars = "~`!@#$%^&*()_+=-[]\\\';,/{}|\":<>?";
								                for (var i = 0; i < val.length; i++) {
								                    if (iChars.indexOf(val.charAt(i)) != -1) {                 
								                     returnvalue = false;
								                    }
								                }
								                return returnvalue;
								        }
								    </aui:validator>
										<%} %>
										
								</aui:input>
							</div><!-- form-input-container-float -->
							
					<% }else if((HtmlUtil.escape(fieldLabel)).equalsIgnoreCase("state")) {%>
				    
			  		  <div class="form-input-container-float">
						<aui:input size="10" cssClass='<%= fieldOptional ? "optional" : StringPool.BLANK %>' label="<%= HtmlUtil.escape(fieldLabel) %>" name="<%= fieldName %>" value="<%= HtmlUtil.escape(fieldValue) %>" />
						</div><!-- form-input-container-float -->
			
					<%}else if((HtmlUtil.escape(fieldLabel)).equalsIgnoreCase("Your phone number")  ||  (HtmlUtil.escape(fieldLabel)).equalsIgnoreCase("Phone number") ||  (HtmlUtil.escape(fieldLabel)).equalsIgnoreCase("zip")) {%>
					    
					  		  <!-- <td class='<%= (HtmlUtil.escape(fieldLabel)).equalsIgnoreCase("zip") ? "aui-w65" : "aui-w75"%>' <%  if(!(HtmlUtil.escape(fieldLabel)).equalsIgnoreCase("zip")){%>colspan="2" <% }%> style="padding: 0px 5px 0px 0px;" > -->
					  		  <div class="form-input-container-float">
								<aui:input showRequiredLabel="false" id='<%= !(HtmlUtil.escape(fieldLabel)).equalsIgnoreCase("zip") ? "phoneNumber" : fieldName %>' size='<%=!(HtmlUtil.escape(fieldLabel)).equalsIgnoreCase("zip") ? 37 : 20 %>' cssClass='<%= fieldOptional ? "optional" : StringPool.BLANK %>' label="<%= HtmlUtil.escape(fieldLabel) %>" name="<%= fieldName %>" value="<%= HtmlUtil.escape(fieldValue) %>" >
									
									<%if(!(HtmlUtil.escape(fieldLabel)).equalsIgnoreCase("zip")) {%>
										<aui:validator name="required" errorMessage="Please enter a valid phone number"></aui:validator>																					
									<%} else{%>
										<aui:validator name="digits"></aui:validator>
									<%} %>
								</aui:input>
					  		  </div><!-- form-input-container-float -->
								
					<!-- </table> -->
					
					<%} else{%>
					<div class="form-input-container-clear">
					<aui:input  size='<%= HtmlUtil.escape(fieldLabel).equalsIgnoreCase("address") ? 47 :30 %>' cssClass='<%= fieldOptional ? "optional" : StringPool.BLANK %>' label="<%= HtmlUtil.escape(fieldLabel) %>" name="<%= fieldName %>" value="<%= HtmlUtil.escape(fieldValue) %>" >
								
								<%if((HtmlUtil.escape(fieldLabel)).equalsIgnoreCase("address")) {%>
									<aui:validator name="custom"  errorMessage="Please enter alpha and numbers only">
								          function (val, fieldNode, rulevalue) {
								                var returnvalue = true;
								                var iChars = "~`!@#$%^&*()_+=-[]\\\';,/{}|\":<>?";
								                for (var i = 0; i < val.length; i++) {
								                    if (iChars.indexOf(val.charAt(i)) != -1) {                 
								                     returnvalue = false;
								                    }
								                }
								                return returnvalue;
								        }
								    </aui:validator>
										<%} %>
				
					</aui:input>
					</div><!-- form-input-container-clear -->
					<%} %>
				</c:when>
				<c:when test='<%= fieldType.equals("textarea") %>'>
					<aui:input cssClass='<%= "lfr-textarea-container" + (fieldOptional ? "optional" : StringPool.BLANK) %>' label="<%= HtmlUtil.escape(fieldLabel) %>" name="<%= fieldName %>" type="textarea" value="<%= HtmlUtil.escape(fieldValue) %>" wrap="soft" />
				</c:when>
				<c:when test='<%= fieldType.equals("checkbox") %>'>
					<aui:input cssClass='<%= fieldOptional ? "optional" : StringPool.BLANK %>' inlineLabel="left" label="<%= HtmlUtil.escape(fieldLabel) %>" name="<%= fieldName %>" type="checkbox" value="<%= GetterUtil.getBoolean(fieldValue) %>" />
				</c:when>
				<c:when test='<%= fieldType.equals("radio") %>'>
					<aui:field-wrapper cssClass='<%= fieldOptional ? "optional" : StringPool.BLANK %>' label="<%= HtmlUtil.escape(fieldLabel) %>" name="<%= fieldName %>">

						<%
						for (String fieldOptionValue : WebFormUtil.split(fieldOptions)) {
						%>

							<aui:input checked="<%= fieldValue.equals(fieldOptionValue) %>" inlineLabel="left" label="<%= HtmlUtil.escape(fieldOptionValue) %>" name="<%= fieldName %>" type="radio" value="<%= HtmlUtil.escape(fieldOptionValue) %>" />

						<%
						}
						%>

					</aui:field-wrapper>
				</c:when>
				<c:when test='<%= fieldType.equals("options") %>'>

					<%
					String[] options = WebFormUtil.split(fieldOptions);
					%>

					<aui:select cssClass='<%= fieldOptional ? "optional" : StringPool.BLANK %>' label="<%= HtmlUtil.escape(fieldLabel) %>" name="<%= fieldName %>" style="width:179px ; height:25px; padding-top:3px">
							<aui:option size="50" value="">Choose One...</aui:option>
						<%
						for (String fieldOptionValue : WebFormUtil.split(fieldOptions)) {
						%>

							<aui:option size="50" selected="<%= fieldValue.equals(fieldOptionValue) %>" value="<%= HtmlUtil.escape(fieldOptionValue) %>"><%= HtmlUtil.escape(fieldOptionValue) %></aui:option>

						<%
						}
						%>

					</aui:select>
				</c:when>
			</c:choose>

		<%
			i++;

			fieldName = "field" + i;
			fieldLabel = LocalizationUtil.getPreferencesValue(preferences, "fieldLabel" + i, themeDisplay.getLanguageId());
			fieldOptional = PrefsParamUtil.getBoolean(preferences, request, "fieldOptional" + i, false);
			fieldValue = ParamUtil.getString(request, fieldName);
		}
		%>

		<c:if test="<%= requireCaptcha %>">
			<portlet:resourceURL var="captchaURL">
				<portlet:param name="<%= Constants.CMD %>" value="captcha" />
			</portlet:resourceURL>

			<liferay-ui:captcha url="<%= captchaURL %>" />
		</c:if>

		<aui:button type="submit" onClick="" value="send" />
	</aui:fieldset>
</aui:form>

<aui:script use="aui-base,selector-css3">
	var form = A.one('#<portlet:namespace />fm');

	if (form) {
		form.on(
			'submit',
			function(event) {
				var keys = [];

				var fieldLabels = {};
				var fieldOptional = {};
				var fieldValidationErrorMessages = {};
				var fieldValidationFunctions = {};
				var fieldsMap = {};

				<%
				int i = 1;

				String fieldName = "field" + i;
				String fieldLabel = preferences.getValue("fieldLabel" + i, StringPool.BLANK);

				while ((i == 1) || Validator.isNotNull(fieldLabel)) {
					boolean fieldOptional = PrefsParamUtil.getBoolean(preferences, request, "fieldOptional" + i, false);
					String fieldType = preferences.getValue("fieldType" + i, "text");
					String fieldValidationScript = preferences.getValue("fieldValidationScript" + i, StringPool.BLANK);
					String fieldValidationErrorMessage = preferences.getValue("fieldValidationErrorMessage" + i, StringPool.BLANK);
				%>

					var key = "<%= fieldName %>";

					keys[<%= i %>] = key;

					fieldLabels[key] = "<%= HtmlUtil.escape(fieldLabel) %>";
					fieldValidationErrorMessages[key] = "<%= fieldValidationErrorMessage %>";

					function fieldValidationFunction<%= i %>(currentFieldValue, fieldsMap) {
						<c:choose>
							<c:when test="<%= PortletPropsValues.VALIDATION_SCRIPT_ENABLED && Validator.isNotNull(fieldValidationScript) %>">
								<%= fieldValidationScript %>
							</c:when>
							<c:otherwise>
								return true;
							</c:otherwise>
						</c:choose>
					};

					fieldOptional[key] = <%= fieldOptional %>;
					fieldValidationFunctions[key] = fieldValidationFunction<%= i %>;

					<c:choose>
						<c:when test='<%= fieldType.equals("radio") %>'>
							var radioButton = A.one('input[name=<portlet:namespace />field<%= i %>]:checked');

							fieldsMap[key] = '';

							if (radioButton) {
								fieldsMap[key] = radioButton.val();
							}
						</c:when>
						<c:otherwise>
							var inputField = A.one('#<portlet:namespace />field<%= i %>');

							fieldsMap[key] = (inputField && inputField.val()) || '';
						</c:otherwise>
					</c:choose>

				<%
					i++;

					fieldName = "field" + i;
					fieldLabel = preferences.getValue("fieldLabel" + i, "");
				}
				%>

				var validationErrors = false;

				for (var i = 1; i < keys.length; i++) {
					var key = keys [i];

					var currentFieldValue = fieldsMap[key];

					var optionalFieldError = A.one('#<portlet:namespace />fieldOptionalError' + key);
					var validationError = A.one('#<portlet:namespace />validationError' + key);

					if (!fieldOptional[key] && currentFieldValue.match(/^\s*$/)) {
						validationErrors = true;

						A.all('.portlet-msg-success').hide();

						if (optionalFieldError) {
							optionalFieldError.show();
						}
					}
					else if (!fieldValidationFunctions[key](currentFieldValue, fieldsMap)) {
						validationErrors = true;

						A.all('.portlet-msg-success').hide();

						if (optionalFieldError) {
							optionalFieldError.hide();
						}

						if (validationError) {
							validationError.show();
						}
					}
					else {
						if (optionalFieldError) {
							optionalFieldError.hide();
						}

						if (validationError) {
							validationError.hide();
						}
						
					}
				}

				if (validationErrors) {
					event.halt();
					event.stopImmediatePropagation();
				}else{
				
					var errorCount  = jQuery('.aui-form-validator-error').length;
							if(errorCount == "0"){
								showLoaderMessage("0");	
							}		
							
				}
			}
		);
	}
</aui:script>


<script>

	$(document).ready(function() {
		
			jQuery("#<portlet:namespace />phoneNumber").mask("999-999-9999");
		
	});
	
	
	 function showLoaderMessage(value){
			AUI().use('aui-base','aui-io-request', 'aui-io', 'aui-overlay-mask', 'aui-overlay-manager', function(A){
				var overlayMask = new A.OverlayMask().render();
				var message = A.Node.create('<h3 class="loader-message"><div class="aui-loadingmask-message-content">Loading...</div></h3>');
				setTarget(document);
		
				function showMessage () {
					message.appendTo(document.body);
				};
		
				function setTarget (elem) {
					overlayMask.set('target', elem).show();	
					if(elem == document){
						showMessage();	
					}
				};
				
				if(value == "1"){
					setInterval(function(){closeOverlay();},10);
				}
				
				function closeOverlay() {
					overlayMask.hide();
					message.remove();
				}			
			});
		}
	    
	    showLoaderMessage("1");	
	
</script>