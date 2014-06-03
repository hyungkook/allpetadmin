//var regExp = /^2[0-9][0-9][0-9]-(([0][1-9])|([1][0-2]))-((0[1-9])|([1-2][0-9])|(3[0-1]))$/;

//var rr = /^(2[0-9][0-9][0-9])-?(([0][1-9])|([1][0-2]))-?((0[1-9])|([1-2][0-9])|(3[0-1]))$/;
//31일 (((0[13578])|(10)|(12)(0[1-9])|([1-2][0-9])|(3[0-1]))
//30일 (((0[469])|(11)(0[1-9])|([1-2][0-9])|(30))
//29일 (2(0[1-9])|([1-2][0-9]))

//년월일 정규식 윤년=lf 기타=nm
var lfdexp =  /^(2[0-9][0-9][0-9])((((0[13578])|(1[02]))((0[1-9])|([1-2][0-9])|(3[0-1])))|((((0[469])|(11))((0[1-9])|([1-2][0-9])|(30))))|(02((0[1-9])|([1-2][0-9]))))$/;
var nmdexp =  /^(2[0-9][0-9][0-9])((((0[13578])|(1[02]))((0[1-9])|([1-2][0-9])|(3[0-1])))|((((0[469])|(11))((0[1-9])|([1-2][0-9])|(30))))|(02((0[1-9])|(1[0-9])|(2[0-8]))))$/;

var lfdexp2 =  /^(2[0-9][0-9][0-9])-?((((0[13578])|(1[02]))-?((0[1-9])|([1-2][0-9])|(3[0-1])))|((((0[469])|(11))-?((0[1-9])|([1-2][0-9])|(30))))|(02-((0[1-9])|([1-2][0-9]))))$/;
var nmdexp2 =  /^(2[0-9][0-9][0-9])-?((((0[13578])|(1[02]))-?((0[1-9])|([1-2][0-9])|(3[0-1])))|((((0[469])|(11))-?((0[1-9])|([1-2][0-9])|(30))))|(02-((0[1-9])|(1[0-9])|(2[0-8]))))$/;

var lfdexprp =  /^(2[0-9][0-9][0-9])-?((((0[13578])|(1[02]))-?((0[1-9])|([1-2][0-9])|(3[0-1])))|((((0[469])|(11))-?((0[1-9])|([1-2][0-9])|(30))))|(02-?((0[1-9])|([1-2][0-9]))))$/g;
var nmdexprp =  /^(2[0-9][0-9][0-9])-?((((0[13578])|(1[02]))-?((0[1-9])|([1-2][0-9])|(3[0-1])))|((((0[469])|(11))-?((0[1-9])|([1-2][0-9])|(30))))|(02-?((0[1-9])|(1[0-9])|(2[0-8]))))$/g;

function chkDateYYYYMMDD(obj) {
	
	var y = parseInt(obj.substr(0, 4));
	var exp = nmdexp;
	
	// 윤년일 경우 lmdexp 사용
	if((y % 400 == 0) || (y % 4 == 0 && y % 100 != 0))
		exp = lfdexp;
	
	/* for(var i = 20000000; i < 20010000; i++){
		if (lmdexp.test(i+""))
			console.log(i+"");
	} */
	
	if(!exp.test(obj)) {
		return false;
	}
	return true;
}

//하이픈 포함 년도
function chkDateYYYYMMDD2(obj) {
	
	var y = parseInt(obj.substr(0, 4));
	var exp = nmdexp2;
	
	// 윤년일 경우 lmdexp 사용
	if((y % 400 == 0) || (y % 4 == 0 && y % 100 != 0))
		exp = lfdexp2;
	
  if (!exp.test(obj)) {
      return false;
  }
  return true;
}

// 윤년인가?
function isLeafYear(year){
	
	 return ((year % 400 == 0) || (year % 4 == 0 && year % 100 != 0));
}

// 
function getDayOfYearFromMonth(year, month){
	
	var acc = 0;
	for(var i = 1; i <= 12; i++){
		if(i==month){
			break;
		}
		acc+=getLastDate(year,i);
	}
	return acc;
}

// 특정 달에 마지막 날 (28일 29일 30일 31일)
function getLastDate(year,month){
	
	if(month==1||month==3||month==5||month==7||month==8||month==10||month==12)
		return 31;
	if(month==2)
		if(isLeafYear(year))
			return 29;
		else
			return 28;
	if(month==4||month==6||month==9||month==11)
		return 30;
	return 0;
}

// 해당 연도가 0년을 기준으로 몇 번의 윤년이 있었는가.
function getLeafYearCount(y){
	
	return Math.floor(y / 4) - Math.floor(y / 100) + Math.floor(y / 400);
}

//오늘 요일.
function getTodayWeek(){
	
	var date = new Date();
	var basey = 2000;
	var cury = date.getFullYear();
	var l1 = getLeafYearCount(basey);
	var l2 = getLeafYearCount(cury);
	var ydd = (cury - basey) * 365 + (l2 - l1);
	var d = ydd+getDayOfYearFromMonth(cury,date.getMonth()+1)+date.getDate()-1;
	return (d%7+6)%7;
}

// 올 달의 1일의 요일
function getFirstDateWeekToday(){
	
	var date = new Date();
	return getFirstDateWeek(date.getFullYear(),date.getMonth()+1);
}

// 지정한 달의 1일의 요일
function getFirstDateWeek(year,month){
	
	var basey = 2000;
	var cury = year;
	var l1 = getLeafYearCount(basey);
	var l2 = getLeafYearCount(cury-1);
	var ydd = (cury - basey) * 365 + (l2 - l1);
	var d = ydd+getDayOfYearFromMonth(cury,month);
	//console.log(basey+","+cury+","+l1+","+l2+","+ydd+","+d+","+(d%7+6)%7);
	return (d%7+6)%7;
}

function getDateWeek(year,month,day){
	
	var basey = 2000;
	var cury = year;
	var l1 = getLeafYearCount(basey);
	var l2 = getLeafYearCount(cury);
	var ydd = (cury - basey) * 365 + (l2 - l1);
	var d = ydd+getDayOfYearFromMonth(cury,month);
	return (((d%7+6)%7)+day-1)%7;
}

function twoDigits(num){
	if(num<10) return "0"+num;
	else return ""+(num%100);
}

function getThisYear(){
	var date = new Date();
	return date.getFullYear();
}

function getThisMonth(){
	var date = new Date();
	return date.getMonth()+1;
}

function getToday(){
	var date = new Date();
	return date.getDate();
}



//http://www.codeproject.com/Articles/16010/Extending-JavaScript-Intrinsic-Objects-with-Protot

//VB-like string replicator 
String.prototype.times = function(n)
{
 var s = '';
 for (var i = 0; i < n; i++)
  s += this;

 return s;
};

//Zero-Padding
String.prototype.zp=function(n){return'0'.times(n-this.length)+this;};

//string functions that we want to apply directly to numbers...
Number.prototype.zf = function(n) { return this.toString().zp(n); };

// http://www.codeproject.com/Articles/11011/JavaScript-Date-Format
// start

//a global month names array
var gsMonthNames = new Array(
'January',
'February',
'March',
'April',
'May',
'June',
'July',
'August',
'September',
'October',
'November',
'December'
);
// a global day names array
var gsDayNames = new Array(
'Sunday',
'Monday',
'Tuesday',
'Wednesday',
'Thursday',
'Friday',
'Saturday'
);
// the date format prototype
Date.prototype.format = function(f)
{
    if (!this.valueOf())
        return '&nbsp;';

    var d = this;

    return f.replace(/(yyyy|mmmm|mmm|mm|dddd|ddd|dd|hh|nn|ss|a\/p)/gi,
        function($1)
        {
            switch ($1.toLowerCase())
            {
            case 'yyyy': return d.getFullYear();
            case 'mmmm': return gsMonthNames[d.getMonth()];
            case 'mmm':  return gsMonthNames[d.getMonth()].substr(0, 3);
            case 'mm':   return (d.getMonth() + 1).zf(2);
            case 'dddd': return gsDayNames[d.getDay()];
            case 'ddd':  return gsDayNames[d.getDay()].substr(0, 3);
            case 'dd':   return d.getDate().zf(2);
            case 'hh':   return ((h = d.getHours() % 12) ? h : 12).zf(2);
            case 'nn':   return d.getMinutes().zf(2);
            case 'ss':   return d.getSeconds().zf(2);
            case 'a/p':  return d.getHours() < 12 ? 'a' : 'p';
            }
        }
    );
};

// end