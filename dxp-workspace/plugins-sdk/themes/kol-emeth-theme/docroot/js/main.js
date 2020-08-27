AUI().ready(
	'liferay-hudcrumbs', 'liferay-navigation-interaction',
	function(A) {
		var navigation = A.one('#navigation');

		if (navigation) {
			navigation.plug(Liferay.NavigationInteraction);
		}

		var siteBreadcrumbs = A.one('.site-breadcrumbs');

		if (siteBreadcrumbs) {
			siteBreadcrumbs.plug(A.Hudcrumbs);
		}
	}
);


$(document).ready(function(){
	$('#toggle').off('click');
	var menuCount = 0;
	$('#toggle').on('click', function(){
		hideAllchildPagesLink();
	   $('#responsive_nav').toggle('fast');
		if(menuCount == 0){   
			jQuery("#toggle-menu-image").attr("src","/kol-emeth-theme/images/custom/toggle-close.png");	
			var src = $('img[alt="search"]').attr('src');
			if(src == '/kol-emeth-theme/images/custom/toggle-close.png'){
				jQuery('#search').toggle('hide');
				jQuery("#toggle-search-image").attr("src","/kol-emeth-theme/images/custom/toggle-search.png");
				searchCount = 0;
			}
			menuCount = menuCount + 1;
		}else{
			jQuery("#toggle-menu-image").attr("src","/kol-emeth-theme/images/custom/toggle-menu.png");
			menuCount = 0;
		}
	});
	
	var searchCount = 0;
		 jQuery('#toggle-search').on('click', function() {   
		
			if(searchCount == 0){    
				jQuery('#search').toggle('fast');
				jQuery("#toggle-search-image").attr("src","/kol-emeth-theme/images/custom/toggle-close.png");					
				var src = $('img[alt="Menu"]').attr('src');
				if(src == '/kol-emeth-theme/images/custom/toggle-close.png'){
					jQuery('#responsive_nav').toggle('hide');
					jQuery("#toggle-menu-image").attr("src","/kol-emeth-theme/images/custom/toggle-menu.png");
					menuCount = 0;
				}
				searchCount = searchCount + 1;
			}else{         			
				jQuery('#search').toggle('hide');
				jQuery("#toggle-search-image").attr("src","/kol-emeth-theme/images/custom/toggle-search.png");
				searchCount = 0;
			}
    });

		 
});


function childDisplay(navIdV){
	var navCss = $('#'+navIdV+'-child').attr('class');
	hideAllchildPagesLink();
	if(navCss == "nav-hide"){
		$('#'+navIdV+'-child').removeClass('nav-hide');
		$('#'+navIdV+'-child').addClass('nav-show');
		$("#icon"+navIdV+'-child').attr("src","/kol-emeth-theme/images/custom/minus.png");
	}else{
		$('#'+navIdV+'-child').removeClass('nav-show');	
		$('#'+navIdV+'-child').addClass('nav-hide');
		$("#icon"+navIdV+'-child').attr("src","/kol-emeth-theme/images/custom/plus.png");
		
	}
}

function hideAllchildPagesLink(){
	$('.nav-show').each(function () {
		 var ar = this.id;
		$('#'+ar).removeClass('nav-show');	
		$('#'+ar).addClass('nav-hide');
		$("#icon"+ar).attr("src","/kol-emeth-theme/images/custom/plus.png");
	});
}


function ctem_3_search() {
	var keywords = document.ctem_3_fm._3_keywords.value;

	keywords = keywords.replace(/^\s+|\s+$/, '');

	if (keywords != '') {
		document.ctem_3_fm.submit();
	}
}

function removeload(){
	jQuery(document.body).removeClass("body-onloaded");
	jQuery(window.parent.document.body).removeClass("body-onloaded");
}


function showLoad(){
	document.body.setAttribute("class", "body-onloaded");
}

jQuery(document).ready(function(){
	if((document.cookie.indexOf("DONATE_NOW=1") != -1 || document.cookie.indexOf("DONATE_NOW=0") != -1)){
			showLoad();
			setCookie("DONATE_NOW","2");
	}
	
	if(document.cookie.indexOf("WEB_FORM=1") != -1){
		showLoad();
		setCookie("WEB_FORM","2");
}
}); 

function setCookie(cname,cvalue)
{
	document.cookie = cname + "=" + cvalue + "; path=/ ";
} 