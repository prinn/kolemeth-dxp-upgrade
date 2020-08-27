package com.kol.emeth.donatenow.model;

import java.util.Arrays;

import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.Validator;

/**
 * @author Rajeeva Lochana B R
 * @version 0.1
 * 
 */

public class DonateNowForm {
	

	private String total = StringPool.NULL;
	private String name = StringPool.NULL;
	private String address = StringPool.NULL;
	private String city = StringPool.NULL;
	private String state = StringPool.NULL;
	private String zip = StringPool.NULL;
	private String email = StringPool.NULL;
	private String phoneNumber = StringPool.NULL;
	private String creditCardType = StringPool.NULL;
	private String creditCardNumber = StringPool.NULL;
	private String expirationDate = StringPool.NULL;
	private String expirationMonth = StringPool.NULL;
	private String expirationYear = StringPool.NULL;
	private String cvvCode = StringPool.NULL;	
	private Integer[] generalFund = new Integer[0]; 
	private String OtherFundName = StringPool.NULL;
	
	
	public static DonateNowForm getInstance() {
		
		return new DonateNowForm(); 
		 
	}
	
	
	public String getTotal() {
		return total;
	}
	public void setTotal(String total) {
		this.total = total;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getCity() {
		return city;
	}
	public void setCity(String city) {
		this.city = city;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	public String getZip() {
		return zip;
	}
	public void setZip(String zip) {
		this.zip = zip;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getPhoneNumber() {
		return phoneNumber;
	}
	public void setPhoneNumber(String phoneNumber) {
		this.phoneNumber = phoneNumber;
	}
	public String getCreditCardType() {
		return creditCardType;
	}
	public void setCreditCardType(String creditCardType) {
		this.creditCardType = creditCardType;
	}
	public String getCreditCardNumber() {
		return creditCardNumber;
	}
	public void setCreditCardNumber(String creditCardNumber) {
		this.creditCardNumber = creditCardNumber;
	}
	public String getExpirationDate() {
		return expirationDate;
	}
	public void setExpirationDate(String expirationDate) {
		this.expirationDate = expirationDate;
	}
	public String getExpirationMonth() {
		return expirationMonth;
	}


	public void setExpirationMonth(String expirationMonth) {
		this.expirationMonth = expirationMonth;
	}


	public String getExpirationYear() {
		return expirationYear;
	}


	public void setExpirationYear(String expirationYear) {
		this.expirationYear = expirationYear;
	}


	public String getCvvCode() {
		return cvvCode;
	}
	public void setCvvCode(String cvvCode) {
		this.cvvCode = cvvCode;
	}
	
	public Integer[] getGeneralFund() {
		
		return (Integer[])generalFund.clone();
		
	}


	public void setGeneralFund(Integer[] newGeneralFund) {

		if(Validator.isNull(newGeneralFund)) {
		    this.generalFund = new Integer[0];
		  } else {
		   this.generalFund = Arrays.copyOf(newGeneralFund, newGeneralFund.length);
		  }

	}


	public String getOtherFundName() {
		return OtherFundName;
	}


	public void setOtherFundName(String otherFundName) {
		OtherFundName = otherFundName;
	}
	
	
	

}
