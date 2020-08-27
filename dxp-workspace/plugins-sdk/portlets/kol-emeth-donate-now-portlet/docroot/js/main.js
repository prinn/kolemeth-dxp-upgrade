$( function()
{
    var targets = $( '[rel~=tooltip]' ),
        target  = false,
        tooltip = false;
       // title   = false;
 
    targets.bind( 'mouseenter', function()
    {
        target  = $( this );
        tip     = target.attr('title');
        tooltip = $( '<div id="tooltip"></div>' );
 
        if( !tip || tip == '' )
            return false;
        
        target.data('title', target.attr('title')).removeAttr('title');
        target.removeAttr('title');
        tooltip.css( 'opacity', 0 )
               .html( tip )
               .appendTo( 'body' );
 
        var init_tooltip = function()
        {
            if( $( window ).width() < tooltip.outerWidth() * 1.5 )
                tooltip.css( 'max-width', $( window ).width() / 2 );
            else
                tooltip.css( 'max-width', 340 );
 
            var pos_left = target.offset().left + ( target.outerWidth() / 2 ) - ( tooltip.outerWidth() / 2 ),
                pos_top  = target.offset().top - tooltip.outerHeight() - 20;
 
            if( pos_left < 0 )
            {
                pos_left = target.offset().left + target.outerWidth() / 2 - 20;
                tooltip.addClass( 'left' );
            }
            else
                tooltip.removeClass( 'left' );
 
            if( pos_left + tooltip.outerWidth() > $( window ).width() )
            {
                pos_left = target.offset().left - tooltip.outerWidth() + target.outerWidth() / 2 + 20;
                tooltip.addClass( 'right' );
            }
            else
                tooltip.removeClass( 'right' );
 
            if( pos_top < 0 )
            {
                pos_top  = target.offset().top + target.outerHeight();
                tooltip.addClass( 'top' );
            }
            else
                tooltip.removeClass( 'top' );
 
            tooltip.css( { left: pos_left, top: pos_top } )
                   .animate( { top: '+=10', opacity: 1 }, 50 );
        };
 
        init_tooltip();
        $( window ).resize( init_tooltip );
        
        var remove_tooltip = function()
        {
            tooltip.animate( { top: '-=10', opacity: 0 }, 50, function()
            {
                $( this ).remove();
            });
 
            target.attr( 'title', tip );
        };
        
        $('body').bind( 'touchstart', remove_tooltip );
        target.bind( 'mouseleave', remove_tooltip );
        tooltip.bind( 'click', remove_tooltip );
        
    });
});

function removeload(){
	jQuery(document.body).removeClass("body-onloaded");
	jQuery(window.parent.document.body).removeClass("body-onloaded");
}


function showLoad(){
	document.body.setAttribute("class", "body-onloaded");
}


function getCookie(){
var name = "DONATE_NOW=";
var ca = document.cookie.split(';');
for(var i=0; i<ca.length; i++)
  {
  var c = ca[i].trim();
  if (c.indexOf(name)==0) 
	  
	  return c.substring(name.length,c.length);
  }
return "";
} 


function setCookie(cname,cvalue,exdays)
{
	document.cookie = cname + "=" + cvalue + "; path=/ ";
} 



function loadPageLoadMask(){
		
		$("<div class='sampleCss'>")
			.css({
				'position': 'fixed',
				'top': '0px',
				'left': '0px',
				'backgroundColor':'black',
				'opacity': '0.75',
				'width': '100%',
				'height': $(window).height(),
				'zIndex': '5000'
			})
			.appendTo("body");
			
		$("<div class='sampleText'><p><br /><div class='aui-loadingmask-message-content'><strong>Loading, please wait... </strong></div></p></div>")
			.css({
				'top': '50%',
				'left': '50%',
				'marginLeft': '-210',
				'marginTop': '-100',
				'width': 'auto',
				'paddingRight': '10',
				'height': 'auto',
				'position': 'fixed',
				'zIndex': '6000'
			})
			.appendTo("body");
}

function removePageLoadMask(){
	$('.sampleCss').remove();
	$('.sampleText').remove();
}
