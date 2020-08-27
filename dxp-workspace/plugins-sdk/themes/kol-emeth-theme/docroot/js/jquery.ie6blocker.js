var IE6 = (navigator.userAgent.indexOf("MSIE 7")>=0) ? true : false;
if(IE6 || document.documentMode <= 7){

	$(function(){
		
		$("<div>")
			.css({
				'position': 'fixed',
				'top': '0px',
				'left': '0px',
				backgroundColor: 'black',
				'opacity': '0.75',
				'width': '100%',
				'height': $(window).height(),
				zIndex: 5000
			})
			.appendTo("body");
			
		$("<div><img src='/kol-emeth-theme/images/custom/no-ie6.png' alt='' style='float: left;'/><p><br /><strong>Sorry! Sorry! This web page does not support Internet Explorer 7 and lesser version..</strong><br /><br />If you'd like to read our content please <a href='http://www.microsoft.com/en-us/download/internet-explorer-8-details.aspx'>upgrade your browser</a>.</p>")
			.css({
				backgroundColor: 'white',
				'top': '50%',
				'left': '50%',
				marginLeft: -210,
				marginTop: -100,
				width: 410,
				paddingRight: 10,
				height: 200,
				'position': 'fixed',
				zIndex: 6000
			})
			.appendTo("body");
	});		
}