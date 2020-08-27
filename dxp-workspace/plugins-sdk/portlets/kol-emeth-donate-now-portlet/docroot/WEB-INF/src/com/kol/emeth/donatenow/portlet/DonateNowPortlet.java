package com.kol.emeth.donatenow.portlet;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Currency;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletPreferences;
import javax.portlet.PortletRequest;
import javax.portlet.PortletResponse;
import javax.portlet.PortletSession;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;

import com.kol.emeth.donatenow.model.DonateNowForm;
import com.kol.emeth.donatenow.util.DonateNowPreferences;
import com.kol.emeth.donatenow.util.MailUtil;
import com.liferay.portal.NoSuchRoleException;
import com.liferay.portal.kernel.captcha.CaptchaTextException;
import com.liferay.portal.kernel.captcha.CaptchaUtil;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.servlet.SessionErrors;
import com.liferay.portal.kernel.servlet.SessionMessages;
import com.liferay.portal.kernel.util.Constants;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.StringUtil;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.model.Role;
import com.liferay.portal.model.User;
import com.liferay.portal.service.RoleLocalServiceUtil;
import com.liferay.portal.service.UserLocalServiceUtil;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portal.util.PortalUtil;
import com.liferay.util.bridges.mvc.MVCPortlet;
import com.stripe.Stripe;
import com.stripe.exception.APIConnectionException;
import com.stripe.exception.AuthenticationException;
import com.stripe.exception.CardException;
import com.stripe.exception.InvalidRequestException;
import com.stripe.exception.StripeException;
import com.stripe.model.Charge;



/**
 * Portlet implementation class DonateNowPortlet
 * 
 * @author Rajeeva Lochana B R
 * @version 0.1
 * 
 */
public class DonateNowPortlet extends MVCPortlet {
	
	private static Log log = LogFactoryUtil.getLog(DonateNowPortlet.class);
	
	public void addAction(ActionRequest actionRequest, ActionResponse actionResponse) 
			{
		HttpServletRequest request = PortalUtil.getHttpServletRequest(actionRequest);
		log.debug(" ----- User-agent :  " + request.getHeader("User-Agent") +" ----- ");
		long startTime = getStartTime( "addAction");
		
		 DonateNowForm donateNowForm = setArrtibuteValue(actionRequest);
		 actionRequest.setAttribute("donateNow", donateNowForm);
		 
		 try {
			 
			 	checkCaptcha(actionRequest);

			} catch (Exception e) {
				SessionErrors.add(
						actionRequest, CaptchaTextException.class.getName());
				log.error("Captcha Text Verification Exception : " + e);
				return;
			}
		 long strStartTime = getStartTime("stripePayment"); 
	         int chargeStatusReturnValue = stripePayment(actionRequest, actionResponse, donateNowForm);	
	      getEndTime(strStartTime, "stripePayment");
	         
	         actionRequest.setAttribute("success", false);
	         actionRequest.setAttribute("error", false);
	         SessionMessages.add(actionRequest, "donate-now");
				
				if(chargeStatusReturnValue == 0){
					actionRequest.setAttribute("error", true);
				}
				
				if(chargeStatusReturnValue == 1){
					long mailStartTime = getStartTime("notifydonator and notifyadmin");
					notifydonator(donateNowForm,  actionRequest) ;
					notifyadmin(donateNowForm,  actionRequest);
					getEndTime(mailStartTime, "notifydonator and notifyadmin");
					actionRequest.setAttribute("donateNow", null);
					actionRequest.setAttribute("success", true);
				}
				getEndTime(startTime, "addAction");
		
	}

	private void getEndTime(long startTime, String methodName) {
		long endTime   = System.nanoTime();
		int totalTime =(int) ((endTime - startTime)/1000000000);
		log.debug(methodName + " Process finish: " + endTime );		
		calcHMS(totalTime, methodName);
	}

	private long getStartTime(String methodName) {
		long startTime = System.nanoTime();
		log.debug(methodName + " Process start: " + startTime );
		return startTime;
	}
	
	private void calcHMS(int timeInSeconds, String methodName) {
	      int hours, minutes, seconds;
	      hours = timeInSeconds / 3600;
	      timeInSeconds = timeInSeconds - (hours * 3600);
	      minutes = timeInSeconds / 60;
	      timeInSeconds = timeInSeconds - (minutes * 60);
	      seconds = timeInSeconds;
	      log.debug(methodName + " Processing time: " +hours + " hour(s) " + minutes + " minute(s) " + seconds + " second(s)");
	   }
	
	 /**
	  * Serve Resource used for getting Captcha.
	  */
	 public void serveResource(
	            ResourceRequest request, ResourceResponse response) {	
		 
		 response.setContentType("image/png");
		 String cmd = ParamUtil.getString(request, Constants.CMD);

			try {
				if (cmd.equals("captcha")) {
					serveCaptcha(request, response);
				}
				
			}
			catch (Exception e) {
				log.error("captcha other Exception : " + e);
			}
		 
	
		}

	
	 /**
	  * 
	  * @param resourceRequest
	  * @param resourceResponse
	  */
	protected void serveCaptcha(
			ResourceRequest resourceRequest, ResourceResponse resourceResponse){

		try {
			CaptchaUtil.serveImage(resourceRequest, resourceResponse);
		} catch (IOException e) {
			log.error("Captcha IOException :  ", e);
		}
		
	}




	/**
	 * 	 
	 * @param request
	 * @return
	 * @throws IOException 
	 * 
	 */
	private int stripePayment(PortletRequest request, PortletResponse response, DonateNowForm donateNowForm){
				
		int chargeStatusReturnValue = 0;
		
		setCookies(response, chargeStatusReturnValue);			
		try {
			
			PortletPreferences portletPreferences = request.getPreferences();
			
		//	Stripe.apiKey = portletPreferences.getValue("apiKey", StringPool.BLANK);
			setStripeApiKey(portletPreferences);
			
		    String currency = portletPreferences.getValue("currencyId", "USD");
		    
			Map<String, Object> chargeParams = new HashMap<String, Object>();
			Map<String, Object> cardParams = new HashMap<String, Object>();			
			
			cardParams.put("name", donateNowForm.getName());
			cardParams.put("address_line1", donateNowForm.getAddress());
			cardParams.put("address_city", donateNowForm.getCity());
			cardParams.put("address_state", donateNowForm.getState());
			cardParams.put("address_zip", donateNowForm.getZip());
			chargeParams.put("amount", donateNowForm.getTotal());
			chargeParams.put("currency", currency);
			cardParams.put("number", donateNowForm.getCreditCardNumber());
			cardParams.put("exp_month",donateNowForm.getExpirationMonth());
			cardParams.put("exp_year", donateNowForm.getExpirationYear());
			cardParams.put("cvc", donateNowForm.getCvvCode());
			//cardParams.put("type", donateNowForm.getCreditCardType());
			
			chargeParams.put("card", cardParams);
			String genaralFundsNames = getGeneralFundsNamesValues(
					donateNowForm, portletPreferences, false);
			
			chargeParams.put("description", "Email : "+donateNowForm.getEmail()+",\t  PhoneNumber : "+donateNowForm.getPhoneNumber() + genaralFundsNames);

					Charge chargeStatus  = Charge.create(chargeParams);
			if(chargeStatus.getPaid()){
				chargeStatusReturnValue = 1;
				setCookies(response, chargeStatusReturnValue);
			}
			
		} catch (CardException e) { 
			chargeStatusReturnValue = 2; 
			setCookies(response, chargeStatusReturnValue);
			SessionErrors.add(request, e.getCode());
			log.error("CardException : " + e);
		} catch (InvalidRequestException e) { 
			log.error("Invalid parameters were supplied to Stripe's API  : " + e);
		} catch (AuthenticationException e) {			
			log.error(" Authentication with Stripe's API failed  (maybe you changed API keys recently) : " + e);
		} catch (APIConnectionException e) { 
			log.error("Network communication with Stripe failed  : " + e);
		} catch (StripeException e) { 
			log.error("Display a very generic error to the user, and maybe send yourself an email    : " + e);
		} catch (Exception e) { 
			log.error("Something else happened, completely unrelated to Stripe  : " + e);
		}
		
		return chargeStatusReturnValue;
	}

	/**
	 * 
	 * @param portletResponse
	 * @param chargeStatusReturnValue
	 */
	private void setCookies(PortletResponse portletResponse, int chargeStatusReturnValue){
		
            Cookie cookie = new Cookie("DONATE_NOW", chargeStatusReturnValue+StringPool.BLANK);
            cookie.setPath(StringPool.SLASH);
            portletResponse.addProperty(cookie);
            
	}

	/**
	 * 
	 * @param donateNowForm
	 * @param portletPreferences
	 * @param boolValue
	 * @return
	 */
	private String getGeneralFundsNamesValues(
			DonateNowForm donateNowForm, PortletPreferences portletPreferences, boolean boolValue) {
		StringBuffer genaralFundsNames = new StringBuffer();
		String[] generalFundsName = StringUtil.split(portletPreferences.getValue("genaralFundsNames", "General Fund")+StringPool.COMMA+"Other");
		
		Integer[] testing = donateNowForm.getGeneralFund();
		
		for(int i=0; i<generalFundsName.length; i++){
			if(Validator.isNotNull(generalFundsName[i])){
				if(!boolValue){
					genaralFundsNames.append(",\t ");
				}
				genaralFundsNames.append(generalFundsName[i]);
					if(Validator.isNotNull(donateNowForm.getOtherFundName()) && generalFundsName[i].equalsIgnoreCase("other")){
						genaralFundsNames.append("(");
						genaralFundsNames.append(donateNowForm.getOtherFundName());
						genaralFundsNames.append(")");
					}
				genaralFundsNames.append(" : ");
				genaralFundsNames.append(testing[i]);
				if(boolValue){
					genaralFundsNames.append("<br/>");
				}
			}
			
		}
		return genaralFundsNames.toString();
	}
	

	/**
	 * 
	 * @param portletPreferences
	 */	 
	private static void setStripeApiKey(PortletPreferences portletPreferences) {
		Stripe.apiKey = portletPreferences.getValue("apiKey", StringPool.BLANK);
	 }

   /**
     * 
     * @param request
     * @return
     */
	private DonateNowForm setArrtibuteValue(PortletRequest request) {
		DonateNowForm donateNowForm = new DonateNowForm();
		PortletPreferences portletPreferences = request.getPreferences();
		
		String[] generalFunds = StringUtil.split(portletPreferences.getValue("genaralFundsNames", "General Fund")+StringPool.COMMA+"Other");
		
		donateNowForm.setName(ParamUtil.getString(request, "name"));
		donateNowForm.setAddress(ParamUtil.getString(request, "address"));
		donateNowForm.setCity(ParamUtil.getString(request, "city"));
		donateNowForm.setState(ParamUtil.getString(request, "state"));
		donateNowForm.setZip(ParamUtil.getString(request, "zip"));
		donateNowForm.setEmail(ParamUtil.getString(request, "email"));
		donateNowForm.setPhoneNumber(ParamUtil.getString(request, "phoneNumber"));
		donateNowForm.setCreditCardType(ParamUtil.getString(request, "creditCardType"));
		donateNowForm.setCreditCardNumber(ParamUtil.getString(request, "creditCardNumber"));
//		donateNowForm.setExpirationDate(ParamUtil.getString(request, "expirationDate"));
		donateNowForm.setExpirationMonth(ParamUtil.getString(request, "month"));
		donateNowForm.setExpirationYear(ParamUtil.getString(request, "year"));
		donateNowForm.setCvvCode(ParamUtil.getString(request, "cvvCode"));

		Integer[] generalFundArray = new Integer[generalFunds.length];
		
			for(int i =0 ; i < generalFunds.length ; i++){
				generalFundArray[i] = GetterUtil.getInteger(ParamUtil.getString(request, "generalFund"+ i +"-amount"));
			}
			
		donateNowForm.setGeneralFund(generalFundArray);	
		donateNowForm.setOtherFundName(ParamUtil.getString(request, "otherGeneralFundName"));
		donateNowForm.setTotal(ParamUtil.getString(request, "totalAmount"));
		
		
		return donateNowForm;
	}
	
	
	/**
	 * 
	 * @param donateNowForm
	 * @param request
	 */
	protected void notifydonator(
			DonateNowForm donateNowForm, PortletRequest request) 
				{
		
		PortletPreferences preferences = request.getPreferences();
		DonateNowPreferences donateNowPreferences = DonateNowPreferences.getInstance(preferences);
		
		String fromName = donateNowPreferences.getEmailFromName(preferences);
		String fromAddress = donateNowPreferences.getEmailFromAddress(preferences);

		String	subject = donateNowPreferences.getEmailSubject(preferences);
		String	body = donateNowPreferences.getEmailBody(preferences);
		String currencySymbol =getCurrencySymbol(request, preferences, donateNowPreferences);

		body =  StringUtil.replace(body, 
						 new String[]{
						 	"[$TO_NAME$]", 
						 	"[$FROM_NAME$]", 
						 	"[$FROM_ADDRESS$]",
						 	"[$AMOUNT$]",
						 	"[$SYMBOL$]",
						 	"[$SYS_DATE$]",
						 	"[$FUNDS$]"
						 	},
						 new String[]{
						 	donateNowForm.getName(),
						 	fromName, 
						 	fromAddress,
						 	(GetterUtil.getInteger(donateNowForm.getTotal())/100) + StringPool.BLANK,
						 	currencySymbol,
						 	getDateformat(),
						 	getGeneralFundsNamesValues(donateNowForm, preferences, true)
						 	}
					 );
			 
			 MailUtil.sendEmail(fromAddress, donateNowForm.getEmail(), subject, body);
	}

		
	/**
	 * 
	 * @param donateNowForm
	 * @param request
	 * @throws SystemException
	 */
	private void notifyadmin(
			DonateNowForm donateNowForm, PortletRequest request) 
				{
		
		PortletPreferences preferences = request.getPreferences();
		DonateNowPreferences donateNowPreferences = DonateNowPreferences.getInstance(preferences);
		
		String fromName = donateNowPreferences.getEmailFromName(preferences);
		String fromAddress = donateNowPreferences.getEmailFromAddress(preferences);
		String emailAddresses = donateNowPreferences.getAdminEmailToAddress(preferences);
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
			emailAddresses =  emailAddresses +	getEmailAddress(preferences, themeDisplay);
			if (Validator.isNull(emailAddresses)) {
				log.error(
					"The web form email cannot be sent because no email " +
						"address is configured");

				return;
			}

		String	subject = donateNowPreferences.getAdminEmailSubject(preferences);
		String	body = donateNowPreferences.getAdminEmailBody(preferences);
		String currencySymbol =getCurrencySymbol(request, preferences, donateNowPreferences);

		subject = StringUtil.replace(subject, 
						 new String[]{
							"[$SYMBOL$]",
						 	"[$AMOUNT$]" 
					 	},
					 	new String[]{
							currencySymbol,
							(GetterUtil.getInteger(donateNowForm.getTotal())/100) + StringPool.BLANK
						}
					);

			 body =  StringUtil.replace(body, 
						 new String[]{
						 	"[$AMOUNT$]",
						 	"[$SYMBOL$]",
						 	"[$TO_NAME$]",
						 	"[$ADDRESS$]",
						 	"[$TO_ADDRESS$]",
						 	"[$PHONE_NUMBER$]",
						 	"[$SYS_DATE$]",
						 	"[$FROM_NAME$]",
						 	"[$FROM_ADDRESS$]",
						 	"[$FUNDS$]"
						 	},
						 new String[]{
					        (GetterUtil.getInteger(donateNowForm.getTotal())/100) + StringPool.BLANK,
						 	currencySymbol,
						 	donateNowForm.getName(),
						 	donateNowForm.getAddress()+", "+ donateNowForm.getCity() +", "+
						 	donateNowForm.getState() +" - "+donateNowForm.getZip(),
						 	donateNowForm.getEmail(),
						 	donateNowForm.getPhoneNumber(),
						 	getDateformat(),
						 	fromName,
						 	fromAddress,
						 	getGeneralFundsNamesValues(donateNowForm, preferences, true)
						 	}
					 );
			 
			 MailUtil.sendEmail(fromAddress, emailAddresses, subject, body);
	}
	
	
	/**
	 * fetch user email Id based on regular roles.
	 * @param preferences
	 * @return
	 */
	private String getEmailAddress(PortletPreferences preferences, ThemeDisplay themeDisplay) {
		
		 StringBuffer stringBuffer = new StringBuffer();
		 
		try {
			
			
			 String[] rolesList	 = StringUtil.split(preferences.getValue("roles", StringPool.BLANK));
				if(rolesList.length > 0){
					for(int i =0 ; i < rolesList.length ; i++){							
						Role role=RoleLocalServiceUtil.getRole(themeDisplay.getCompanyId(), rolesList[i]);	
						if(Validator.isNotNull(role)){
							List<User> regularRoleUserlList = UserLocalServiceUtil.getRoleUsers(role.getRoleId());					
							
								if (regularRoleUserlList.size() != 0) {
									for (User user : regularRoleUserlList) {
										stringBuffer.append(",");
										stringBuffer.append(user.getEmailAddress());
										
									}
								}
						}							
					}
				}
		}catch(NoSuchRoleException e){ 
			log.error("NoSuchRoleException : " + e);
		}catch (PortalException e) {
			log.error("PortalException : " + e);
		} catch (SystemException e) {
			log.error("SystemException : " + e);
		}
		
		return stringBuffer.toString();
	}

	/**
	 * 
	 * @return
	 */
	private String getDateformat() {
		
		DateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");

		// Get the date today using Calendar object.
		Date today = Calendar.getInstance().getTime();        
		// Using DateFormat format method we can create a string 
		// representation of a date with the defined format.
		String donatedDate = dateFormat.format(today);
		
		return donatedDate;
	}
	
	
	/**
	 * 
	 * @param request 
	 * @param preferences
	 * @param donateNowPrefs
	 * @return
	 */
	private String getCurrencySymbol(PortletRequest request, PortletPreferences preferences,
			DonateNowPreferences donateNowPrefs) {
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		String currencyId = donateNowPrefs.getCurrencyId(preferences) ;		
		Currency currency = Currency.getInstance(currencyId);	
		
		return currency.getSymbol(themeDisplay.getLocale());
	}
	
	
	/**
	 * 
	 * @param request
	 * @throws Exception
	 */
	private void checkCaptcha(PortletRequest request) throws Exception {
        String enteredCaptchaText = ParamUtil.getString(request, "captchaText");

        PortletSession session = request.getPortletSession();
        String captchaText = getCaptchaValueFromSession(session);
        if (Validator.isNull(captchaText)) {
            throw new Exception("Internal Error! Captcha text not found in session");
        }
        if (!StringUtils.equals(captchaText, enteredCaptchaText)) {
            throw new Exception("Invalid captcha text. Please reenter.");
        }
    }

	/**
	 * 
	 * @param session
	 * @return
	 */
    private String getCaptchaValueFromSession(PortletSession session) {
        Enumeration<String> atNames = session.getAttributeNames();
        while (atNames.hasMoreElements()) {
            String name = atNames.nextElement();
            if (name.contains("CAPTCHA_TEXT")) {
                return (String) session.getAttribute(name);
            }
        }
        return null;
    }
    
    /**
     * To by-pass authentication token for non-logged in user. 
	 * Error: Invalid authentication token
     * @return
     */
    protected boolean isCheckMethodOnProcessAction() {
		return CHECK_METHOD_ON_PROCESS_ACTION;
	}

	private static final boolean CHECK_METHOD_ON_PROCESS_ACTION = false;
	
}
