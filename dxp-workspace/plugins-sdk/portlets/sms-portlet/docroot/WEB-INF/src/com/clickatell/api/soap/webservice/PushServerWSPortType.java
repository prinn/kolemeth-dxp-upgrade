/**
 * PushServerWSPortType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.clickatell.api.soap.webservice;

public interface PushServerWSPortType extends java.rmi.Remote {
    public java.lang.String auth(int api_id, java.lang.String user, java.lang.String password) throws java.rmi.RemoteException;
    public java.lang.String ping(java.lang.String session_id) throws java.rmi.RemoteException;
    public java.lang.String[] sendmsg(java.lang.String session_id, int api_id, java.lang.String user, java.lang.String password, java.lang.String[] to, java.lang.String from, java.lang.String text, int concat, int deliv_ack, int callback, int deliv_time, float max_credits, int req_feat, int queue, int escalate, int mo, java.lang.String cliMsgId, int unicode, java.lang.String msg_type, java.lang.String udh, java.lang.String data, int validity) throws java.rmi.RemoteException;
    public java.lang.String[] querymsg(java.lang.String session_id, int api_id, java.lang.String user, java.lang.String password, java.lang.String apimsgid, java.lang.String climsgid) throws java.rmi.RemoteException;
    public java.lang.String[] delmsg(java.lang.String session_id, java.lang.String api_id, java.lang.String user, java.lang.String password, java.lang.String apimsgid, java.lang.String climsgid) throws java.rmi.RemoteException;
    public java.lang.String getbalance(java.lang.String session_id, int api_id, java.lang.String user, java.lang.String password) throws java.rmi.RemoteException;
    public java.lang.String routeCoverage(java.lang.String session_id, int api_id, java.lang.String user, java.lang.String password, java.lang.String msisdn) throws java.rmi.RemoteException;
    public java.lang.String[] si_push(java.lang.String session_id, int api_id, java.lang.String user, java.lang.String password, java.lang.String[] to, java.lang.String si_id, java.lang.String si_url, java.lang.String si_text, java.lang.String si_created, java.lang.String si_expires, java.lang.String si_action, java.lang.String from, int concat, int deliv_ack, int callback, int deliv_time, float max_credits, int req_feat, int queue, int escalate, int mo, java.lang.String cliMsgId, int validity) throws java.rmi.RemoteException;
    public java.lang.String[] ind_push(java.lang.String session_id, int api_id, java.lang.String user, java.lang.String password, java.lang.String[] to, java.lang.String mms_subject, java.lang.String mms_class, java.lang.String mms_expire, java.lang.String mms_from, java.lang.String mms_url, java.lang.String from, int concat, int deliv_ack, int callback, int deliv_time, float max_credits, int req_feat, int queue, int escalate, int mo, java.lang.String cliMsgId, int validity) throws java.rmi.RemoteException;
    public java.lang.String token_pay(java.lang.String session_id, int api_id, java.lang.String user, java.lang.String password, java.lang.String token) throws java.rmi.RemoteException;
    public java.lang.String[] startbatch(java.lang.String session_id, int api_id, java.lang.String user, java.lang.String password, java.lang.String from, int concat, java.lang.String template, int deliv_ack, int callback, int deliv_time, float max_credits, int req_feat, int queue, int escalate, int mo, java.lang.String cliMsgId, int unicode, java.lang.String msg_type, java.lang.String udh, java.lang.String data, int validity) throws java.rmi.RemoteException;
    public java.lang.String[] senditem(java.lang.String session_id, int api_id, java.lang.String user, java.lang.String password, java.lang.String batch_id, java.lang.String[] to, java.lang.String field1, java.lang.String field2, java.lang.String field3, java.lang.String field4) throws java.rmi.RemoteException;
    public java.lang.String[] quicksend(java.lang.String session_id, int api_id, java.lang.String user, java.lang.String password, java.lang.String batch_id, java.lang.String[] to) throws java.rmi.RemoteException;
    public java.lang.String[] endbatch(java.lang.String session_id, int api_id, java.lang.String user, java.lang.String password, java.lang.String batch_id) throws java.rmi.RemoteException;
    public java.lang.String[] getmsgcharge(java.lang.String session_id, int api_id, java.lang.String user, java.lang.String password, java.lang.String apimsgid) throws java.rmi.RemoteException;
}
