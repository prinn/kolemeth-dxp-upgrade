function removeload(){
	jQuery(document.body).removeClass("body-onloaded");
	jQuery(window.parent.document.body).removeClass("body-onloaded");
}

function showLoad(){
	document.body.setAttribute("class", "body-onloaded");
}