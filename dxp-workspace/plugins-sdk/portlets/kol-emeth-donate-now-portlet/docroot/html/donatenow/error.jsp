<!-- 
/**
 * @author Rajeeva Lochana B R
 * @version 0.1
 * 
 */
 -->

<%@ include file="/html/donatenow/init.jsp" %>

<style>
	html { overflow-y: visible; }
	.body-onloaded{opacity : 1 !important; background-color:#ffffff !important;}
</style>

<script type="text/javascript">
	removeload();
</script>

<%
   String content = StringPool.BLANK;
   String title = StringPool.BLANK;
      try{
          JournalArticle journalArticle = JournalArticleLocalServiceUtil.getLatestArticle(themeDisplay.getScopeGroupId(), "DONATE-NOW-ERROR-CONTENT");   
          title = journalArticle.getTitle(themeDisplay.getLocale());
          content = journalArticle.getContent();
         }catch(Exception e){
       }
%>

<p><b><%= title %></b></p>
<p><%= HtmlUtil.unescape(content) %></p>


<aui:form action="" method="post" onSubmit="javascript:redirectToSupportNowPage();" name="fm2" >
<aui:button value="Retry"  type="submit"/>	
</aui:form>