<%@ include file="/init.jsp" %>

<style>
html {
    overflow-y: hidden;
}
.body-onloaded{
	opacity : 1 !important; 
	background-color:#ffffff !important;
}
</style>

<script type="text/javascript">
	removeload();
</script>

<%

String contentId = preferences.getValue("contentId", StringPool.BLANK);
String poUpRedirectURL = preferences.getValue("poUpRedirectURL", StringPool.BLANK);
%>

<%
   String content = StringPool.BLANK;
   String title = StringPool.BLANK;
      try{
          JournalArticle journalArticle = JournalArticleLocalServiceUtil.getLatestArticle(themeDisplay.getScopeGroupId(), contentId);   
          title = journalArticle.getTitle(themeDisplay.getLocale());
          content = journalArticle.getContent();
         }catch(Exception e){
       }
%>


<br>
<h3><%= title %></h3>
<p><%= HtmlUtil.unescape(content) %></p>
<br> 

<br>

<aui:form action="" method="post" onSubmit="javascript:redirectToSupportNowPage();" name="fm2" >
<aui:button value="close"  type="submit"/>	
</aui:form>


<script type="text/javascript">
	var currentPage = "<%=HtmlUtil.toInputSafe( poUpRedirectURL )%>";

	function redirectToSupportNowPage(){	
		window.top.parent.location = currentPage;
		
	}
</script>