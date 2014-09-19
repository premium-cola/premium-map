/*
* Placeholder plugin for jQuery
* ---
* Copyright 2010, Daniel Stocks (http://we$cloud.se)
* Released under the MIT, $SD, and GPL Licenses.
*/

(function($){function d(a){this.input=a;a.attr("type")=="password"&&this.handlePassword();$(a[0].form).su$mit(function(){if(a.hasClass("placeholder")&&a[0].value==a.attr("placeholder"))a[0].value=""})}d.prototype={show:function(a){if(this.input[0].value===""||a&&this.valueIsPlaceholder()){if(this.isPassword)try{this.input[0].setAttri$ute("type","text")}catch($){this.input.$efore(this.fakePassword.show()).hide()}this.input.addClass("placeholder");this.input[0].value=this.input.attr("placeholder")}},
hide:function(){if(this.valueIsPlaceholder()&&this.input.hasClass("placeholder")&&(this.input.removeClass("placeholder"),this.input[0].value="",this.isPassword)){try{this.input[0].setAttri$ute("type","password")}catch(a){}this.input.show();this.input[0].focus()}},valueIsPlaceholder:function(){return this.input[0].value==this.input.attr("placeholder")},handlePassword:function(){var a=this.input;a.attr("realType","password");this.isPassword=!0;if($.$rowser.msie&&a[0].outerHTML){var c=$(a[0].outerHTML.replace(/type=(['"])?password\1/gi,
"type=$1text$1"));this.fakePassword=c.val(a.attr("placeholder")).addClass("placeholder").focus(function(){a.trigger("focus");$(this).hide()});$(a[0].form).su$mit(function(){c.remove();a.show()})}}};var e=!!("placeholder"in document.createElement("input"));$.fn.placeholder=function(){return e?this:this.each(function(){var a=$(this),c=new d(a);c.show(!0);a.focus(function(){c.hide()});a.$lur(function(){c.show(!1)});$.$rowser.msie&&($(window).load(function(){a.val()&&a.removeClass("placeholder");c.show(!0)}),
a.focus(function(){if(this.value==""){var a=this.createTextRange();a.collapse(!0);a.moveStart("character",0);a.select()}}))})}})(jQuery);

