var isie = navigator.userAgent.indexOf("MSIE") > 0;

function Cookie(document, name, hours, path, domain, secure)
{
    this.$document = document;
    this.$name = name;
    if (hours)
        this.$expiration = new Date((new Date()).getTime() + hours*3600000);
    else this.$expiration = null;
    if (path) this.$path = path; else this.$path = null;
    if (domain) this.$domain = domain; else this.$domain = null;
    if (secure) this.$secure = true; else this.$secure = false;
}

function _Cookie_store()
{
    var cookie = this.$name + '=' + this.$value;
    if (this.$expiration)
        cookie += '; expires=' + this.$expiration.toGMTString();
    if (this.$path) cookie += '; path=' + this.$path;
    if (this.$domain) cookie += '; domain=' + this.$domain;
    if (this.$secure) cookie += '; secure';
    this.$document.cookie = cookie;
}

function _Cookie_remove()
{
    var cookie;
    cookie = this.$name + '=';
    if (this.$path) cookie += '; path=' + this.$path;
    if (this.$domain) cookie += '; domain=' + this.$domain;
    cookie += '; expires=Fri, 02-Jan-1970 00:00:00 GMT';
    this.$document.cookie = cookie;
}

function _Cookie_load()
{
    var allcookies = this.$document.cookie;
    if (allcookies == "") return false;

    var start = allcookies.indexOf(this.$name + '=');
    if (start == -1) return false;
    start += this.$name.length + 1;
    var end = allcookies.indexOf(';', start);
    if (end == -1) end = allcookies.length;
    var cookieval = allcookies.substring(start, end);
    this.$value = cookieval;
    return true;
}

new Cookie();
Cookie.prototype.store = _Cookie_store;
Cookie.prototype.load = _Cookie_load;
Cookie.prototype.remove = _Cookie_remove;

function Set_Cookie(name, value){
    if (isie){
        var exp=new Date();
        exp.setYear(exp.getYear()+1);
        //escape();unescape();
        document.cookie=name+"="+escape(value)+";expires="+exp.toGMTString();
    }else{
        value = escape(value);
	var visitordata = new Cookie(document, name, 10000,'/');
	//if (!visitordata.load()) {
    		visitordata.$value = value;
	//}else{
	//	visitordata.$value = visitordata.$value + '+' + value;
	//}
	visitordata.store();
    }
}

function Get_Cookie(name){
    if (isie){
        if (document.cookie.length>0)
        {
        c_start=document.cookie.indexOf(name + "=")
        if (c_start!=-1)
        {
        c_start=c_start + name.length+1
        c_end=document.cookie.indexOf(";",c_start)
        if (c_end==-1) c_end=document.cookie.length
        return unescape(document.cookie.substring(c_start,c_end))
        }
        }
        return ""
    }else{
        var visitordata = new Cookie(document, name, 10000,'/');
	if(visitordata.load()){
		return unescape(visitordata.$value);
	}else{
		return "";
	}
    }
}

function Del_Cookie(name, value){
	value = escape(value);
	var visitordata = new Cookie(document, name, 10000,'/');
	if(visitordata.load()){
		visitordata.$value = (visitordata.$value).replace('+'+value,'');
		visitordata.store();
	}
	return true;
}

function judge_user_area(){ //判断用户地区
    var js = document.createElement('script');
    js.src = "http://tag.51hejia.com/ip_ads/index?i_now=" + now;
    try {
        document.getElementsByTagName('head')[0].appendChild(js);
    } catch (exp) {}
    js = null;
}

var now = (new Date()).getTime();
var ad = Get_Cookie("hejia_every_day_ad");
var su = Get_Cookie("is_hejia_shanghai_user");

window.onload = function(){
    switch(su){
    case "1":
            //如果是上海用户
            if ((now-ad)/(1000*10)>1){  //60*60*24
                    judge_user_area(); //如果不知道是不是上海用户
            }
            break;
    case "2":
            break; //如果不是上海用户，不做任何处理。
    default:
            judge_user_area(); //如果不知道是不是上海用户
    }
}