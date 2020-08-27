package com.clickatell.api.soap.webservice;

public class PushServerWSPortTypeProxy implements com.clickatell.api.soap.webservice.PushServerWSPortType {
  private String _endpoint = null;
  private com.clickatell.api.soap.webservice.PushServerWSPortType pushServerWSPortType = null;
  
  public PushServerWSPortTypeProxy() {
    _initPushServerWSPortTypeProxy();
  }
  
  public PushServerWSPortTypeProxy(String endpoint) {
    _endpoint = endpoint;
    _initPushServerWSPortTypeProxy();
  }
  
  private void _initPushServerWSPortTypeProxy() {
    try {
      pushServerWSPortType = (new com.clickatell.api.soap.webservice.PushServerWSLocator()).getPushServerWSPort();
      if (pushServerWSPortType != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)pushServerWSPortType)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)pushServerWSPortType)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (pushServerWSPortType != null)
      ((javax.xml.rpc.Stub)pushServerWSPortType)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public com.clickatell.api.soap.webservice.PushServerWSPortType getPushServerWSPortType() {
    if (pushServerWSPortType == null)
      _initPushServerWSPortTypeProxy();
    return pushServerWSPortType;
  }
  
  public java.lang.String auth(int api_id, java.lang.String user, java.lang.String password) throws java.rmi.RemoteException{
    if (pushServerWSPortType == null)
      _initPushServerWSPortTypeProxy();
    return pushServerWSPortType.auth(api_id, user, password);
  }
  
  public java.lang.String ping(java.lang.String session_id) throws java.rmi.RemoteException{
    if (pushServerWSPortType == null)
      _initPushServerWSPortTypeProxy();
    return pushServerWSPortType.ping(session_id);
  }
  
  public java.lang.String[] sendmsg(java.lang.String session_id, int api_id, java.lang.String user, java.lang.String password, java.lang.String[] to, java.lang.String from, java.lang.String text, int concat, int deliv_ack, int callback, int deliv_time, float max_credits, int req_feat, int queue, int escalate, int mo, java.lang.String cliMsgId, int unicode, java.lang.String msg_type, java.lang.String udh, java.lang.String data, int validity) throws java.rmi.RemoteException{
    if (pushServerWSPortType == null)
      _initPushServerWSPortTypeProxy();
    return pushServerWSPortType.sendmsg(session_id, api_id, user, password, to, from, text, concat, deliv_ack, callback, deliv_time, max_credits, req_feat, queue, escalate, mo, cliMsgId, unicode, msg_type, udh, data, validity);
  }
  
  public java.lang.String[] querymsg(java.lang.String session_id, int api_id, java.lang.String user, java.lang.String password, java.lang.String apimsgid, java.lang.String climsgid) throws java.rmi.RemoteException{
    if (pushServerWSPortType == null)
      _initPushServerWSPortTypeProxy();
    return pushServerWSPortType.querymsg(session_id, api_id, user, password, apimsgid, climsgid);
  }
  
  public java.lang.String[] delmsg(java.lang.String session_id, java.lang.String api_id, java.lang.String user, java.lang.String password, java.lang.String apimsgid, java.lang.String climsgid) throws java.rmi.RemoteException{
    if (pushServerWSPortType == null)
      _initPushServerWSPortTypeProxy();
    return pushServerWSPortType.delmsg(session_id, api_id, user, password, apimsgid, climsgid);
  }
  
  public java.lang.String getbalance(java.lang.String session_id, int api_id, java.lang.String user, java.lang.String password) throws java.rmi.RemoteException{
    if (pushServerWSPortType == null)
      _initPushServerWSPortTypeProxy();
    return pushServerWSPortType.getbalance(session_id, api_id, user, password);
  }
  
  public java.lang.String routeCoverage(java.lang.String session_id, int api_id, java.lang.String user, java.lang.String password, java.lang.String msisdn) throws java.rmi.RemoteException{
    if (pushServerWSPortType == null)
      _initPushServerWSPortTypeProxy();
    return pushServerWSPortType.routeCoverage(session_id, api_id, user, password, msisdn);
  }
  
  public java.lang.String[] si_push(java.lang.String session_id, int api_id, java.lang.String user, java.lang.String password, java.lang.String[] to, java.lang.String si_id, java.lang.String si_url, java.lang.String si_text, java.lang.String si_created, java.lang.String si_expires, java.lang.String si_action, java.lang.String from, int concat, int deliv_ack, int callback, int deliv_time, float max_credits, int req_feat, int queue, int escalate, int mo, java.lang.String cliMsgId, int validity) throws java.rmi.RemoteException{
    if (pushServerWSPortType == null)
      _initPushServerWSPortTypeProxy();
    return pushServerWSPortType.si_push(session_id, api_id, user, password, to, si_id, si_url, si_text, si_created, si_expires, si_action, from, concat, deliv_ack, callback, deliv_time, max_credits, req_feat, queue, escalate, mo, cliMsgId, validity);
  }
  
  public java.lang.String[] ind_push(java.lang.String session_id, int api_id, java.lang.String user, java.lang.String password, java.lang.String[] to, java.lang.String mms_subject, java.lang.String mms_class, java.lang.String mms_expire, java.lang.String mms_from, java.lang.String mms_url, java.lang.String from, int concat, int deliv_ack, int callback, int deliv_time, float max_credits, int req_feat, int queue, int escalate, int mo, java.lang.String cliMsgId, int validity) throws java.rmi.RemoteException{
    if (pushServerWSPortType == null)
      _initPushServerWSPortTypeProxy();
    return pushServerWSPortType.ind_push(session_id, api_id, user, password, to, mms_subject, mms_class, mms_expire, mms_from, mms_url, from, concat, deliv_ack, callback, deliv_time, max_credits, req_feat, queue, escalate, mo, cliMsgId, validity);
  }
  
  public java.lang.String token_pay(java.lang.String session_id, int api_id, java.lang.String user, java.lang.String password, java.lang.String token) throws java.rmi.RemoteException{
    if (pushServerWSPortType == null)
      _initPushServerWSPortTypeProxy();
    return pushServerWSPortType.token_pay(session_id, api_id, user, password, token);
  }
  
  public java.lang.String[] startbatch(java.lang.String session_id, int api_id, java.lang.String user, java.lang.String password, java.lang.String from, int concat, java.lang.String template, int deliv_ack, int callback, int deliv_time, float max_credits, int req_feat, int queue, int escalate, int mo, java.lang.String cliMsgId, int unicode, java.lang.String msg_type, java.lang.String udh, java.lang.String data, int validity) throws java.rmi.RemoteException{
    if (pushServerWSPortType == null)
      _initPushServerWSPortTypeProxy();
    return pushServerWSPortType.startbatch(session_id, api_id, user, password, from, concat, template, deliv_ack, callback, deliv_time, max_credits, req_feat, queue, escalate, mo, cliMsgId, unicode, msg_type, udh, data, validity);
  }
  
  public java.lang.String[] senditem(java.lang.String session_id, int api_id, java.lang.String user, java.lang.String password, java.lang.String batch_id, java.lang.String[] to, java.lang.String field1, java.lang.String field2, java.lang.String field3, java.lang.String field4) throws java.rmi.RemoteException{
    if (pushServerWSPortType == null)
      _initPushServerWSPortTypeProxy();
    return pushServerWSPortType.senditem(session_id, api_id, user, password, batch_id, to, field1, field2, field3, field4);
  }
  
  public java.lang.String[] quicksend(java.lang.String session_id, int api_id, java.lang.String user, java.lang.String password, java.lang.String batch_id, java.lang.String[] to) throws java.rmi.RemoteException{
    if (pushServerWSPortType == null)
      _initPushServerWSPortTypeProxy();
    return pushServerWSPortType.quicksend(session_id, api_id, user, password, batch_id, to);
  }
  
  public java.lang.String[] endbatch(java.lang.String session_id, int api_id, java.lang.String user, java.lang.String password, java.lang.String batch_id) throws java.rmi.RemoteException{
    if (pushServerWSPortType == null)
      _initPushServerWSPortTypeProxy();
    return pushServerWSPortType.endbatch(session_id, api_id, user, password, batch_id);
  }
  
  public java.lang.String[] getmsgcharge(java.lang.String session_id, int api_id, java.lang.String user, java.lang.String password, java.lang.String apimsgid) throws java.rmi.RemoteException{
    if (pushServerWSPortType == null)
      _initPushServerWSPortTypeProxy();
    return pushServerWSPortType.getmsgcharge(session_id, api_id, user, password, apimsgid);
  }
  
  
}