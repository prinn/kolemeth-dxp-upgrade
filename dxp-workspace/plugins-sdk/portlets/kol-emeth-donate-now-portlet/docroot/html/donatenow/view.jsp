<!-- 
/**
 * @author Rajeeva Lochana B R
 * @version 0.1
 * 
 */
 -->

<%@ include file="/html/donatenow/init.jsp" %>

<%

	genaralFundsNames = genaralFundsNames +","+ "Other"; 

	String[] ccTypes = donateNowPrefs.getCcTypes(preferences);
	String[] generalFundsNameArray = StringUtil.split(genaralFundsNames.trim());
	String[] generalFundsName = new String[generalFundsNameArray.length] ;
	int count = 0;
	
	for(int gf = 0; gf < generalFundsNameArray.length ; gf++){//to remove continues comma/ null value from fundnames
		if(Validator.isNotNull(generalFundsNameArray[gf])){
			generalFundsName[count] = generalFundsNameArray[gf];
			count = count +1;
		}		
	}
	
	String[] fundDescriptionsArray = StringUtil.split(fundDescriptions, ";");	
	Boolean success = GetterUtil.getBoolean(renderRequest.getAttribute("success"));
	Boolean error = GetterUtil.getBoolean(renderRequest.getAttribute("error"));
	Calendar calendar = Calendar.getInstance();
	int year = calendar.get(Calendar.YEAR);
	
 %>
	<div style="display:none;">
		<liferay-ui:success key="donate-now" message="donate-now"></liferay-ui:success>
	</div>

<c:choose>
	<c:when test="<%=Validator.isNotNull(apiKeyString) && ccTypes.length > 0%>">
	
	<script type="text/javascript">
		if(((document.cookie.indexOf("DONATE_NOW=2") != -1 || document.cookie.indexOf("DONATE_NOW") == -1))
				&& (document.cookie.indexOf("DONATE_CONFIG=2") != -1 || document.cookie.indexOf("DONATE_CONFIG") == -1)){
			loadPageLoadMask();
		}
	</script>
	
			<portlet:actionURL  var="donateActionURL" name="addAction"></portlet:actionURL>
		
			<portlet:renderURL var="successURL" windowState="<%=LiferayWindowState.POP_UP.toString()%>">
				<portlet:param name="jspPage" value="/html/donatenow/success.jsp"/>
			</portlet:renderURL>	
			
			<portlet:renderURL var="errorURL" windowState="<%=LiferayWindowState.POP_UP.toString()%>">
				<portlet:param name="jspPage" value="/html/donatenow/error.jsp"/>
			</portlet:renderURL>	
			
			
			<%if(success){ %>
			<script type="text/javascript">
			var errorURL = '<%= successURL.toString() %>';
					showPopup(errorURL);
			</script>
			
			<% } 
			if(error){
			%>
			<script type="text/javascript">
			var successURL = '<%= errorURL.toString() %>';
					showPopup(successURL);
			</script>
			<%
			}	
			
					DonateNowForm  donateNow  = null; 
					
						 if(Validator.isNotNull(renderRequest.getAttribute("donateNow"))){	 
							 donateNow = (DonateNowForm) renderRequest.getAttribute("donateNow");
						 }else{
							 donateNow	= DonateNowForm.getInstance();
						 }	
						 
				   Integer[] generalFundNameArray = donateNow.getGeneralFund();
						 
						if(generalFundNameArray.length == 0){
							generalFundNameArray = new Integer[generalFundsName.length];
							Arrays.fill(generalFundNameArray, 0);
						}
						
			%>
			<aui:form action="<%=donateActionURL %>" method="post" onSubmit="event.preventDefault();setTotalAmount()" name="fm2" autocomplete="off">
					<input id="generalFundsNameLength" name="generalFundsNameLength" value="<%= count %>" type="hidden">
					<liferay-ui:error key="missing" message="missing"></liferay-ui:error>
					<liferay-ui:error key="processing_error" message="processing-error"></liferay-ui:error>
					<liferay-ui:message key="donate.now.description"/>			
				<div class="donate-wrapper aui-w100">
		
						<% for(int j = 0; j < generalFundsName.length ; j++){
											
					        String generalFund = "generalFund"+j;
					        String generalFundAmount = generalFund+"-amount";
											
					        String fundDescription = "";
					           if (j < fundDescriptionsArray.length) {
					                fundDescription = fundDescriptionsArray[j];
					            }
											
					    %>
						    <c:set var="generalFundId" value="<%= generalFund %>" />
						    
						 <c:if test="<%= Validator.isNotNull(generalFundsName[j]) %>">
						    <div class="donate-fund">						 
						        <div class="aui-w50">
									
						          				  <aui:input  name="<%=generalFund %>" id='<%=generalFund %>' type="checkbox" onClick="repGenChk('${generalFundId}');" label="<%= generalFundsName[j] %>" inlineLabel="right" showRequiredLabel="false" checked="<%= j == 0 || generalFundNameArray[j] != 0 %>" ></aui:input>
						          			
											
												 <%if (Validator.isNotNull(fundDescription) || generalFundsName[j].equalsIgnoreCase("Other")){
													 
													 if (request.getHeader("User-Agent").indexOf("Windows NT") == -1 ){%>
												 
														<abbr rel="tooltip" title='<%=  generalFundsName[j].equalsIgnoreCase("Other") ? "Any other donations go here." : fundDescription   %>'>
															<span class="taglib-icon-help" style="float:left; margin-top:4px; margin-left:5px;"><img  src="<%= themeDisplay.getPathThemeImages() %>/portlet/help.png"  ></span>
														</abbr>
													<%}else{ %>
														<liferay-ui:icon-help message='<%=  generalFundsName[j].equalsIgnoreCase("Other") ? "Any other donations go here." : fundDescription   %>'/> 
												<%		}
												 }else{ %>	
													<span style=" margin-top:4px; margin-left:5px;"> &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;</span>
												<%} %>
										<c:if test='<%=generalFundsName[j].equalsIgnoreCase("Other") %>'>
											<div id="otherDivId" style="display:none;">
												<aui:input name="otherName" id="otherId" label="" type="hidden" value="<%= generalFund %>"></aui:input>
												<aui:input name="otherGeneralFundName"  id="otherGeneralFundName" size="16" type="text" label="" showRequiredLabel="false"  disabled="<%= j != 0 && Validator.isNull(donateNow.getOtherFundName()) %>" value='<%= Validator.isNotNull(donateNow.getOtherFundName())  ? donateNow.getOtherFundName() : StringPool.BLANK %>'>
													 <aui:validator name="custom"  errorMessage="Please enter fund name">
												        function (val, fieldNode, rulevalue) {
												         var returnvalue = true;
												         var otherCheckBoxId = document.getElementById("<portlet:namespace/>otherId").value;
												         var isChecked=document.getElementById("<portlet:namespace/>"+otherCheckBoxId).value;
				    	 									 if((isChecked=="true" || isChecked=='true')){
				    	 										 if(val != ""){									               
														                var iChars = "~`!@#$%^&*()_+=-[]\\\';,.{}|\":<>?";
														                for (var i = 0; i < val.length; i++) {
														                    if (iChars.indexOf(val.charAt(i)) != -1) {                 
														                     returnvalue = false;
														                    }
														                }	
													                }else{
													                	 returnvalue = false;
													                }								                
												                }
												              return returnvalue;
												        }
										   			 </aui:validator>
												</aui:input> 
											</div> 
										</c:if>
						        </div><!-- aui-w50 -->
						      
						        <div class="aui-w50">
						           
						            <aui:input name="<%= generalFundAmount %>" size="29" id="<%= generalFundAmount %>" type="text" label="amount" inlineLabel="left" showRequiredLabel="false"  disabled="<%= j != 0 && generalFundNameArray[j] == 0 %>" value='<%= (j != 0) ? generalFundNameArray[j] : (generalFundNameArray[j] != 0)  ? generalFundNameArray[j] : StringPool.BLANK %>'>
										<aui:validator name="required" ></aui:validator>
										<aui:validator name="number"></aui:validator>
										<aui:validator name="maxLength">10</aui:validator>
									</aui:input>
						        
						        </div><!-- aui-w50 -->
							</div><!--  donate-fund -->
					        </c:if>   
						<%} %>
					    	
					    <div class="donate-total-fund donate-total">
					        <div class="aui-w50">
					            <aui:input name="total" size="29" type="text"  label='<%= LanguageUtil.format(pageContext, "total-x", currency.getSymbol(themeDisplay.getLocale())) %>' inlineLabel="left" disabled="true" showRequiredLabel="false" value='<%=  Validator.isNotNull(donateNow.getTotal()) ? GetterUtil.getInteger(donateNow.getTotal())/100  : 0 %>'>
									<aui:validator name="required"/>
								    <aui:validator name="custom"  errorMessage='<%= LanguageUtil.format(pageContext, "please-enter-funds-not-less-than-x", new String[] {currency.getSymbol(themeDisplay.getLocale()),String.valueOf(totalMinimumAmount)} )%>'>
								        function (val, fieldNode, rulevalue) {
								        		var minAmount = <%= totalMinimumAmount %>;
								                var returnvalue = true;
								                    if (val < minAmount) {                 
								                     returnvalue = false;
								                    }
								                return returnvalue;
								        }
								    </aui:validator>
								</aui:input> 
								<aui:input name="totalAmount" type="hidden" value="0"></aui:input>
					                
					            <label class="donate-minimum" for="<portlet:namespace/>total">Minimum <%= currency.getSymbol(themeDisplay.getLocale()) + totalMinimumAmount %> </label>
					            
					        </div><!-- aui-w50 -->
					     </div><!-- donate-total -->
					            
					<!-- /------------------------------------------------ Contact info ------------------------------------------------/ -->
					            
					    <!-- name -->
					            
					        <div class="donate-contact">
					       		 <aui:input name="name" size="30" type="text" value='<%=  Validator.isNotNull(donateNow.getName()) ? donateNow.getName() : StringPool.BLANK %>' label="name" showRequiredLabel="false" >
										<aui:validator name="required" ></aui:validator>
										<aui:validator name="custom"  errorMessage="Please enter alpha">
									        function (val, fieldNode, rulevalue) {
									                var returnvalue = true;
									                var iChars = "~`!@#$%^&*()_+=-[]\\\';,./{}|\":<>?0123456789";
									                for (var i = 0; i < val.length; i++) {
									                    if (iChars.indexOf(val.charAt(i)) != -1) {                 
									                     returnvalue = false;
									                    }
									                }
									                return returnvalue;
									        }
								       </aui:validator>
								 </aui:input>
					        </div>
					            
					    <!-- address -->
					            
					        <div class="donate-contact">
					            <aui:input name="address" type="text" size="47" label="address" showRequiredLabel="false"  value='<%=  Validator.isNotNull(donateNow.getAddress()) ? donateNow.getAddress()  : StringPool.BLANK %>'>
									<aui:validator name="required"/>
								    <aui:validator name="custom"  errorMessage="Please enter alpha and numbers only">
								        function (val, fieldNode, rulevalue) {
								                var returnvalue = true;
								                var iChars = "~`!@#$%^&*()_+=-[]\\\';,./{}|\":<>?";
								                for (var i = 0; i < val.length; i++) {
								                    if (iChars.indexOf(val.charAt(i)) != -1) {                 
								                     returnvalue = false;
								                    }
								                }
								                return returnvalue;
								        }
								    </aui:validator>
								</aui:input>
					        </div>
					            
					    <!-- city -->
					            
					            <div class="donate-contact float-left">
					                <aui:input name="city" size="30" type="text" label="city" showRequiredLabel="false"  value='<%=  Validator.isNotNull(donateNow.getCity()) ? donateNow.getCity() : StringPool.BLANK %>'>
										<aui:validator name="required" ></aui:validator>
										 <aui:validator name="custom"  errorMessage="Please enter only alpha.">
								          function (val, fieldNode, rulevalue) {
								                var returnvalue = true;
								                var iChars = "~`!@#$%^&*()_+=-[]\\\';,/{}|\":<>?0123456789";
								                for (var i = 0; i < val.length; i++) {
								                    if (iChars.indexOf(val.charAt(i)) != -1) {                 
								                     returnvalue = false;
								                    }
								                }
								                return returnvalue;
								        }
								    </aui:validator>
									</aui:input>
					            </div>
					            
					    <!-- state -->
					            
					            <div class="donate-contact float-left">
					                <aui:input name="state" size="11" type="text" label="state" showRequiredLabel="false" value='<%=  Validator.isNotNull(donateNow.getState()) ? donateNow.getState() : StringPool.BLANK %>'>
										<aui:validator name="required" ></aui:validator>
										 <aui:validator name="custom"  errorMessage="Please enter only alpha.">
								          function (val, fieldNode, rulevalue) {
								                var returnvalue = true;
								                var iChars = "~`!@#$%^&*()_+=-[]\\\';.,/{}|\":<>?0123456789";
								                for (var i = 0; i < val.length; i++) {
								                    if (iChars.indexOf(val.charAt(i)) != -1) {                 
								                     returnvalue = false;
								                    }
								                }
								                return returnvalue;
								        }
								    </aui:validator>
									</aui:input>
					            </div>
					            
					    <!-- zip -->
					            
					            <div class="donate-contact">
					                <aui:input name="zip" size="11" type="text" label="zip" showRequiredLabel="false" value='<%=  Validator.isNotNull(donateNow.getZip()) ? donateNow.getZip() : StringPool.BLANK %>'>
										<aui:validator name="required" ></aui:validator>
										<aui:validator name="digits" ></aui:validator>
									</aui:input>
					            </div>
					            
					    <!-- email -->
					            
					            <div class="donate-contact float-left">
					                <aui:input name="email" size="30" type="text" label="email" showRequiredLabel="false" value='<%=  Validator.isNotNull(donateNow.getEmail()) ? donateNow.getEmail()  : StringPool.BLANK %>'>
										<aui:validator name="required" ></aui:validator>
										<aui:validator name="email" ></aui:validator>
									</aui:input>
					            </div>
					            
					    <!-- phone -->
					            
					            <div class="donate-contact">
					            <liferay-ui:error key="incorrect-zip" message="incorrect-zip" />
					                <aui:input name="phoneNumber" size="37" type="text" label="phone.number" showRequiredLabel="false" value='<%=  Validator.isNotNull(donateNow.getPhoneNumber()) ? donateNow.getPhoneNumber() : StringPool.BLANK %>'>
										<aui:validator name="required" errorMessage="Please enter a valid phone number" ></aui:validator>
									</aui:input>
					            </div>
					            
					    <!-- credit card type -->
					            
					            <div class="donate-contact">
					                <aui:select label="credit.card.type" name="creditCardType" showRequiredLabel="false"  style="width:179px ; height:25px; padding-top:3px">
											<aui:option size="50" value="0"><liferay-ui:message key="choose.one"></liferay-ui:message> </aui:option>
										<%
											for (int i = 0; i < ccTypes.length; i++) {
										 %>			
												<aui:option size="50" label='<%=  "cc_" + ccTypes[i]  %>' value="<%=  ccTypes[i]  %>" selected="<%= donateNow.getCreditCardType().equalsIgnoreCase(ccTypes[i])  %>" />
										<%
											}
										 %>			
									</aui:select>
									<aui:input name="selectedCardType" label="" type="hidden" value='<%= Validator.isNotNull(donateNow.getCreditCardType())  ? donateNow.getCreditCardType() : "visa"   %>'></aui:input>
					            </div>
					                
					    <!-- credit card number -->
					                
					            <div class="donate-contact float-left">
					            
					                <liferay-ui:error key="incorrect_number" message="incorrect-number" />
									<liferay-ui:error key="invalid_number" message="invalid-number" />
									<liferay-ui:error key="expired_card" message="expired-card" />
									<liferay-ui:error key="card_declined" message="card-declined" />
									
									<aui:input name="creditCardNumber" size="30" type="text" label="credit.card.number" showRequiredLabel="false" value='<%=  Validator.isNotNull(donateNow.getCreditCardNumber()) ? donateNow.getCreditCardNumber()  : StringPool.BLANK %>'>
										<aui:validator name="required" ></aui:validator>
										<aui:validator name="digits" ></aui:validator>
										<aui:validator name="custom"  errorMessage="Please enter a valid credit card number.">
												        function (val, fieldNode, rulevalue) {
												         var returnvalue = false;
												         var selectedCardvalue = document.getElementById("<portlet:namespace/>selectedCardType").value;
												         
												          if(selectedCardvalue == "visa" ||  selectedCardvalue == "discover"
												          		||  selectedCardvalue == "mastercard" || selectedCardvalue == "jcb"){
				    	 									 if(val.length == 16){									               
														              returnvalue = true;			                
												             }
												          }       
												                
				    	 								  if((selectedCardvalue == "amex")){
				    	 									 if(val.length == 15){									               
														              returnvalue = true;			                
												             }
												          }
												             
												          if((selectedCardvalue == "diners")){
				    	 									  if(val.length == 14){									               
														              returnvalue = true;			                
												               }
												          }
												              return returnvalue;
												        }
										</aui:validator>											
									</aui:input>
					                
					            </div>
					                
					    <!-- credit card expiration date -->
					                
					            <div class="donate-contact float-left">
					            
					                <liferay-ui:error key="invalid_expiry_month"  message="invalid-expiry-month" />
									<liferay-ui:error key="invalid_expiry_year"  message="invalid-expiry-year" />
					              
					               <div><liferay-ui:message key="expiration.date"/></div>
						             <aui:column style="margin-left:-5px;">
										<aui:select label="" name="month" style="height:28px; padding-top:3px">
											<aui:option value="none"><liferay-ui:message key="month"></liferay-ui:message> </aui:option>
											<% for(int i=01; i <=12 ;i++){ 
												DecimalFormat twodigits = new DecimalFormat("00");
											%>
												<aui:option value="<%= twodigits.format(i) %>" selected='<%= donateNow.getCreditCardType().equalsIgnoreCase(twodigits.format(i)+StringPool.BLANK) %>'><%=twodigits.format(i)%></aui:option>
											<%} %>
										</aui:select>
						           	</aui:column>			            
									
									 <aui:column style="margin-left:-5px;">
										<aui:select label="" name="year" style="height:28px; padding-top:3px">
											<aui:option value="none"><liferay-ui:message key="year"></liferay-ui:message> </aui:option>
											<% for(int i = 0; i <=14 ;i++){ %>
												<aui:option value="<%=year+i%>" selected='<%= donateNow.getCreditCardType().equalsIgnoreCase(year+StringPool.BLANK)  %>'><%=year+i%></aui:option>
											<%} %>
										</aui:select>
									</aui:column>
					            </div>
					                
					    <!-- credit card cvc -->
					                
					            <div class="donate-contact">
					                <liferay-ui:error key="invalid_cvc" message="invalid-cvc" />
									<liferay-ui:error key="incorrect_cvc" message="incorrect-cvc" />
									
									<aui:input name="cvvCode" type="password" size="11" label="cvv.code" showRequiredLabel="false" value='<%=  Validator.isNotNull(donateNow.getCvvCode()) ? donateNow.getCvvCode()  : StringPool.BLANK %>'>
										<aui:validator name="required" ></aui:validator>
										<aui:validator name="digits" ></aui:validator>
										<aui:validator name="custom"  errorMessage='Please enter a valid CVV Code.'>
												        function (val, fieldNode, rulevalue) {
												         var returnvalue = false;
												         var selectedCardvalue = document.getElementById("<portlet:namespace/>selectedCardType").value;
												         												         									                
				    	 								  if((selectedCardvalue == "amex")){
				    	 									 if(val.length == 4){									               
														              returnvalue = true;			                
												             }
												          }else{
												          		
												          		if(val.length == 3){									               
														              returnvalue = true;			                
												               }
												          }
												             
												         
												              return returnvalue;
												        }
										</aui:validator>
									</aui:input>
					            </div>
					                
					    <!-- captcha -->
					                
					            <div class="donate-contact" style="clear:both;">
					                <liferay-ui:error exception="<%= CaptchaMaxChallengesException.class %>" message="maximum-number-of-captcha-attempts-exceeded" />
									<liferay-ui:error exception="<%= CaptchaTextException.class %>" message="text-verification-failed" />		
													
									<portlet:resourceURL var="captchaURL">
										<portlet:param name="<%= Constants.CMD %>" value="captcha" />
									</portlet:resourceURL>
									
									<liferay-ui:captcha url="<%= captchaURL %>" /> 
					            </div>
					
				</div><!-- donate-wrapper -->
				<br><br>
				<aui:button value="donate"  type="submit" style="clear:both;"/>	
					
			</aui:form>
			
			<script type="text/javascript">
			 	setCookie("DONATE_CONFIG","2");
				var pathname = window.location.pathname;
				var nameSpace = '<portlet:namespace/>';	
				var generalFundsNameLength = $("#generalFundsNameLength").val();
							
				$(document).ready(function(){

					  var otherCheckBoxId = document.getElementById("<portlet:namespace/>otherId").value;
					  var isChecked=document.getElementById("<portlet:namespace/>"+otherCheckBoxId).value;
					  var forName = "<portlet:namespace/>"+otherCheckBoxId.toString()+"-amount";
						 if((isChecked=="true" || isChecked=='true')){

								$("label[for='"+forName+"']").removeClass('disabled');	
								$('#otherDivId').css('display','block');
								$("#<portlet:namespace/>otherGeneralFundName").removeAttr("disabled");
					    }
						 
						jQuery("#<portlet:namespace />phoneNumber").mask("999-999-9999");
					
					 $('#'+nameSpace+'creditCardType').change(function(){
							var selectedValue = $(this).val();
							
							if(selectedValue == 0){
								selectedValue = "visa";
							}
							
							 document.getElementById(nameSpace+"selectedCardType").value = selectedValue;

					});
					 
						 for(var i = 0; i < generalFundsNameLength ; i++){  
							 
							 var textboxId="generalFund"+i+"-amount";
							 var forName = "<portlet:namespace/>"+textboxId;
							 
						    	  if((i != 0)){
						    		  $("label[for='"+forName+"']").addClass('disabled');
						    	  }
						  				  
						   	 $("#<portlet:namespace/>"+textboxId).keydown(function(event) {
						    	
						        // Allow: backspace, delete, tab, escape, and enter
						        if ( event.keyCode == 46 || event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 27 || event.keyCode == 13 || 
						             // Allow: Ctrl+A
						            (event.keyCode == 65 && event.ctrlKey === true) || 
						             // Allow: home, end, left, right
						            (event.keyCode >= 35 && event.keyCode <= 39)) {
						                 // let it happen, don't do anything
						                 return;
						        }
						        else {
						            // Ensure that it is a number and stop the keypress
						            if (event.shiftKey || ((event.keyCode < 48) || (event.keyCode > 57)) && ((event.keyCode < 96) || (event.keyCode > 105))) {
						                event.preventDefault(); 
						            }   
						        }
						    });
					   }
				});
				
			
				$(document).ready(function(){
					
					 var sum = 0;						
					     $("input").keyup (function (e) {	
					    	 var currentId=$(this).attr("id").replace(nameSpace.toString(),"");
				
						    	 if(currentId.indexOf("-amount") >= 0 && !(e.keyCode == 9)){
						    	 
							    	 if($(this).val()!='' || $(this).val()!=""){
							    		 sum = $(this).val();
							    	 }else{
							    		  sum = 0;
							    	 }
						    	 
						    	 var total=getTotal(currentId);
						    	 var total1=parseFloat(total)+parseFloat(sum);
							   	      document.getElementById(nameSpace+"total").value = parseFloat(total1);
							   	      
						        }
						});	
					     
				});
				
				
					      function repGenChk(checkboxId){
					    	  
					    	 var isChecked=document.getElementById("<portlet:namespace/>"+checkboxId.toString()).value;
					    	 var otherCheckBoxId = document.getElementById("<portlet:namespace/>otherId").value;				    	 
					    	 var forName = "<portlet:namespace/>"+checkboxId.toString()+"-amount";
					    	 
					    	  if((isChecked=="true" || isChecked=='true')){
					    		  
					    		   $("label[for='"+forName+"']").removeClass('disabled');	    		  
					    		   $("#<portlet:namespace/>"+checkboxId.toString()+"-amount").val("");
					    		   $("#<portlet:namespace/>"+checkboxId.toString()+"-amount").removeAttr("disabled");
					    		   	
						    		   	if(otherCheckBoxId == checkboxId){	   
						    		   		 $('#otherDivId').css('display','block');
						    		   		 $("#<portlet:namespace/>otherGeneralFundName").removeAttr("disabled");
						    		   	}
					    		   
					    	   }else{
					    		   
					    		   $("label[for='"+forName+"']").addClass('disabled');	    		
					    		   $("#<portlet:namespace/>"+checkboxId.toString()+"-amount").val("0");	
					    		   $("#<portlet:namespace/>"+checkboxId.toString()+"-amount").attr("disabled",true);
					    		    
						    			if(otherCheckBoxId == checkboxId){	 
						    				 $('#otherDivId').css('display','none');
						    		   		 $("#<portlet:namespace/>otherGeneralFundName").attr("disabled",true);
						    		   		 document.getElementById(nameSpace+"otherGeneralFundName").value = "";
						    		   	}
					    			
					    		    var total1=getTotal(checkboxId.toString()+"-amount");
					    	    	  document.getElementById(nameSpace+"total").value = parseFloat(total1);
					    	   }				    	  
							  	 		
					        }
				         
				         
				         function getTotal(currentId){
				        	 var total=0;
					        	 for(var i = 0; i < generalFundsNameLength ; i++){
					        		 
						   			  var textboxId="generalFund"+i+"-amount";
						   											
						   		 if(textboxId != currentId) {

						   			 var currentVal=$("#<portlet:namespace/>"+textboxId).val();

						   			 	if(currentVal=="" || currentVal=='' || currentVal == "undefined"){
								   				currentVal= "0";
								   		}
							   					 total=parseFloat(total)+parseFloat(currentVal);	
							   					 
							   			 }				   			
					   			 }
				        	 
				        	 return total;
				       	  
				         }
				         
				         
			 	    function setTotalAmount(){
			 	    
			 	  		 document.getElementById(nameSpace+"totalAmount").value = document.getElementById(nameSpace+"total").value * 100;
			 	  		 
			 	  		var errorCount  = jQuery('.aui-form-validator-error').length;
							if(errorCount == "0"){
								showLoaderMessage("0");	
								submitForm(document.<portlet:namespace />fm2);
							}		
			 	    }

			 	    </script>
			 	   
			 	     <aui:script>
				
				    //loader mask with overlay function
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
								setInterval(function(){closeOverlay();},5);
							}
							
							function closeOverlay() {
								overlayMask.hide();
								message.remove();
							}			
						});
					}
				    
				    showLoaderMessage("1");	//cache image first time to fix loader image issue in chrome
				    
				     $(window).load(function() {
				    	 removePageLoadMask();
		             });
		             
		             
		             //select box validation
		             AUI().use('aui-form-validator', function(A) {
							// Extending Alloy Default values for FormValidator STRINGS and RULES
							A.mix(YUI.AUI.defaults.FormValidator.STRINGS, {
									customRule: 'Please select card type.',
									monthCustomRule:'Please Select month.',
									yearCustomRule:'Please Select year.',
									yearExpireRule:"Your card has already expired."
									},
								true
							);
							
							A.mix(YUI.AUI.defaults.FormValidator.RULES, {
								customRule: function(val, fieldNode, ruleValue) {
									return (val != "0");
								},
								monthCustomRule: function(val, fieldNode, ruleValue) {
									return (val != "none");
								},
								yearCustomRule: function(val, fieldNode, ruleValue) {
									return (val != "none");
								},
								yearExpireRule: function(val, fieldNode, ruleValue) {
									var date = new Date();
									var month=new Array();
									var selectedMonthVal = A.one('#<portlet:namespace />month').val();
										month[0]="01"; month[1]="02";  month[2]="03";
										month[3]="04"; month[4]="05";  month[5]="06";
										month[6]="07"; month[7]="08";  month[8]="09";
										month[9]="10"; month[10]="11"; month[11]="12";
										var n = month[date.getMonth()]; 
										var returnValue = true;
										if(val == date.getFullYear()){
											if(selectedMonthVal < n){
												returnValue = false;
											}
										}
										
									return returnValue;
								}
							},
								true
							);
							
							var validator1 = new A.FormValidator({
								boundingBox: '#<portlet:namespace />fm2',
								validateOnBlur: true,
								selectText: true,
								rules: {
								<portlet:namespace />creditCardType: {
									required: true,
									customRule:true
									},
									<portlet:namespace />month: {
									required: true,
									monthCustomRule:true
									},
									<portlet:namespace />year: {
									required: true,
									yearCustomRule:true,
									yearExpireRule:true
									}
								},
								on: {
								           submitError: function(event) {
								               var formEvent = event.validator.formEvent;
								               var errors = event.validator.errors;
								           },
								
								           submit: function(event) {
								               var formEvent = event.validator.formEvent;
								           }
								       }
								});
						});
				
			</aui:script>			
		
	</c:when>
	<c:otherwise>
		<liferay-util:include page="/html/portal/portlet_not_setup.jsp" >
			<liferay-util:param name="portletId" value="<%= themeDisplay.getPortletDisplay().getId() %>"></liferay-util:param>
		</liferay-util:include>
	</c:otherwise>
</c:choose>