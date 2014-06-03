/**
* @(#)jindo.m.Selectbox.js 2012. 5. 31.
*
* Copyright NHN Corp. All rights Reserved.
* NHN PROPRIETARY/CONFIDENTIAL. Use is subject to license terms.
*/
/**
* @author sculove
* @since 2012. 5. 31.
* @description
*/
jindo.m.Selectbox = jindo.$Class({
    /** @lends jindo.m.Selectbox.prototype */
    /**
     * @description 초기화 함수
     * @constructs
     * @class
     * @param {Varient} el input 엘리먼트 또는 ID
     * @param {HashTable} htUserOption 추가 옵션 (생략가능)
     * @extends jindo.UIComponent
     * @requires jindo.m.CoreScroll
     */
    $init : function(el, htUserOption) {
        this.option({
            bActivateOnload : true,
            sClassPrefix : "select-",
            sPlaceholder : "선택해주세요",
            nHeight : 80,
            sItemTag : "li",
            nDefaultIndex : -1
        });
        this.option(htUserOption || {});
        this._initVar();
        this._setWrapperElement(el);
        this._init();
        if(this.option("bActivateOnload")) {
            this.activate();
            this.select(this.option("nDefaultIndex"));
        }
    },
    /**
     * @description jindo.m.Selectbox 에서 사용하는 모든 인스턴스 변수를 초기화한다.
     */
    _initVar : function() {
        this._isNative = false;
        this._oScroll = null;
        this._sClassPrefix = this.option("sClassPrefix");
        this._aItems = null;
        this._nCurrentIdx = -1;
    },

    /**
     * @description jindo.m.Selectbox 에서 사용하는 모든 엘리먼트의 참조를 가져온다.
     * @param {Varient} el 엘리먼트를 가리키는 문자열이나, HTML엘리먼트
     */
    _setWrapperElement: function(el) {
        this._htWElement = {};
        this._htWElement["base"] = jindo.$Element(el);
        this._htWElement["content"] = jindo.$Element(this._htWElement["base"].query("." + this._sClassPrefix + "content"));
        this._htWElement["arrow"] = jindo.$Element(this._htWElement["base"].query("." + this._sClassPrefix + "arrow"));
        this._htWElement["selectmenu"] = jindo.$Element(this._htWElement["base"].query("." + this._sClassPrefix + "selectmenu"));
    },

    /**
     * @description jindo.m.Selectbox 에서 사용하는 모든 엘리먼트의 속성을 설정한다.
     */
    _init : function() {
        this._isNative = this._htWElement["selectmenu"].$value().tagName == "SELECT" ? true : false;
        this._htWElement["base"].css({
            "position" : "relative",
            "display" : "-webkit-box",
            "-webkit-box-align" : "center",
            "-webkit-box-pack" : "center",
            "-webkit-tap-highlight-color" : "rgba(0,0,0,0)"
        });
        this._htWElement["content"].css({
            "display" : "block",
            "overflow" : "hidden",
            "text-overflow" : "ellipsis",
            "cursor" : "pointer",
            "text-align" : "center",
            "width" : "90%"
        });

        if(this._htWElement["arrow"]) {
            this._htWElement["arrow"].css({
                "position" : "relative",
                "text-align" : "right",
                "display" : "block",
                "text-algn" : "right"
            });
        }
        this._htWElement["selectmenu"].css({
            "position" : "absolute",
            "left" : "0px",
            // "top" : "60px",
            "margin" : "0px",
            "zIndex" : 100
        });

        if(this._isNative) {
            this._htWElement["selectmenu"].css({
                "opacity" : "0",
                "height" : "100%",
                "min-height" : "100%",
                "width" : "100%"
            });
        } else {
            this._htWElement["selectmenu"].css({
                "width" : "100%"
            }).hide();
            this._htWElement["selectmenu"].first().css("width","100%");
            this._oScroll = new jindo.m.CoreScroll(this._htWElement["selectmenu"].$value(), {
                nHeight : this.option("nHeight"),
                bUseMomentum : true,
                bUseHighlight : false,
                bUseBounce : true
            });
        }
        this._refreshItems();
    },


    /**
     * @description jindo.m.Selectbox 컴포넌트를 활성화한다.
     * activate 실행시 호출됨
     */
    _onActivate : function() {
        this._attachEvent();
    },

    /**
     * @description jindo.m.Selectbox 컴포넌트를 비활성화한다.
     * deactivate 실행시 호출됨
     */
    _onDeactivate : function() {
        this._detachEvent();
    },

    /**
     * @description jindo.m.Selectbox 에서 사용하는 모든 이벤트를 바인드한다.
     */
    _attachEvent : function() {
        this._htEvent = {};
        if(this._isNative) {
            this._htWElement["selectmenu"].show();
        } else {
            this._htEvent["selectmenu"] = jindo.$Fn(this._onShow,this).attach(this._htWElement["base"], "click");
            this._htEvent["document"] = jindo.$Fn(this._onDocumentStart, this).attach(document, "touchstart");
        }
        this._htEvent["select"] = jindo.$Fn(this._onSelect,this).attach(this._htWElement["selectmenu"], this._isNative ? "change" : "click");
    },

    /**
     * @description jindo.m.Selectbox 에서 사용하는 모든 이벤트를 해제한다.
     */
    _detachEvent : function(){
        if(this._isNative) {
            this._htWElement["selectmenu"].hide();
        } else {
            this._htEvent["selectmenu"].detach(this._htWElement["base"], "click");
            this._htEvent["document"].detach(document, "touchstart");
        }
        this._htEvent["select"].detach(this._htWElement["selectmenu"], this._isNative ? "change" : "click");
        this._htEvent = null;
    },

    /**
     * @description 메뉴의 아이템 선택시 나타나는 이벤트 핸들러
     * @param  {jindo.$Event} we
     */
    _onShow : function(we) {
        this._showMenuForCustom();
    },

    /**
     * @description 사용자 디자인일 경우, 선택시 메뉴 나타나는 이벤트 핸들러
     * @param  {jindo.$Event} we
     */
    _onSelect : function(we) {
        // console.log("onSelect");
        if(this._isNative) {
           this.select(we.element.selectedIndex);
        } else {
            var welParent = jindo.$Element(we.element).parent();
            this.select(welParent.indexOf(we.element));
        }
        we.stop();
    },

    /**
     * @description 스크롤 도중 scroll 영역 바깥을 선택하였을시, 스크롤을 중지시킴
     * @param {jindo.$Event} we
     */
    _onDocumentStart : function(we) {
        if(this._htWElement["selectmenu"].visible()) {
            if(this._htWElement["selectmenu"].isParentOf(we.element) || this._htWElement["selectmenu"].isEqual(we.element) ) {
                return true;
            } else {
                this._hideMenuForCustom();
            }
        }
    }, 

    /**
     * @description 인덱스에 해당하는 엘리먼트를 선택한다.
     * @param  {Number} nIdx 인덱스
     * @example
     *
     * oSelect.select(nIdx);  // nIdx의 아이템을 선택한다.
     */
    select : function(nIdx) {
        if(0 <= nIdx && nIdx < this._aItems.length) {
            if(nIdx != this._nCurrentIdx) {
                if(this.fireEvent("beforeSelect", {
                    nCurrentIdx : this._nCurrentIdx,
                    sValue : this.getValue()
                })) {
                    if(this._isNative) {
                        this._aItems[nIdx].selected = true;
                        this._setValue(this._aItems[nIdx].value);
                    } else {
                        var wel = jindo.$Element(this._aItems[nIdx]);
                        if(this._aItems[this._nCurrentIdx]) {
                            jindo.$Element(this._aItems[this._nCurrentIdx]).removeClass(this._sClassPrefix + "selected");
                        }
                        wel.addClass(this._sClassPrefix + "selected");
                        this._setValue(wel.text());
                        this._hideMenuForCustom();
                    }
                    var nPrevIdx = this._nCurrentIdx;
                    this._nCurrentIdx = nIdx;
                    this.fireEvent("select", {
                        nPrevIdx : nPrevIdx,
                        sPrevValue : this.getValue(nPrevIdx),
                        nCurrentIdx : this._nCurrentIdx,
                        sValue : this.getValue()
                    });
                }
            }
        } else {
            this._setValue(this.option("sPlaceholder"));
        }
    },

    /**
     * @description custom 셀렉트 메뉴일 경우, 보이게 한다.
     */
    _showMenuForCustom : function() {
        if(!this._isNative && !this._htWElement["selectmenu"].visible()) {
            this._htWElement["selectmenu"].show();
            var nItemHeight = jindo.$Element(this._htWElement["selectmenu"].query(this.option("sItemTag"))).height();
            this._oScroll.refresh();
            this._oScroll.scrollTo(0, this._nCurrentIdx < 0 ? 0 : -this._nCurrentIdx * nItemHeight);
            this._htEvent["selectmenu"].detach(this._htWElement["base"], "click");
        }
    },

    /**
     * @description custom 셀렉트 메뉴일 경우, 보이게 한다.
     */
    _hideMenuForCustom : function() {
        if(!this._isNative && this._htWElement["selectmenu"].visible()) {
            this._htWElement["selectmenu"].hide();
            this._htEvent["selectmenu"].attach(this._htWElement["base"], "click");
        }
    },

    /**
     * @description 아이템 정보를 재갱신한다.
     */
    _refreshItems : function() {
        if(this._isNative) {
            this._aItems = this._htWElement["selectmenu"].$value().options;
        } else {
            this._aItems = this._htWElement["selectmenu"].queryAll(this.option("sItemTag"));
        }
    },

    /**
     * @description 데이터를 갱신하여줌.
     * @param  {Array} aData 실제 데이터 배열
     * @example
     *
     * oSelect.refresh(aData);  // aData로 데이터를 갱신
     */
    refresh : function(aData) {
        var sHTML = "";
        var sItemTag = this._isNative ? "option" : this.option("sItemTag");
        for(var i=0, nLength = aData.length; i < nLength; i++) {
            sHTML += "<";
            sHTML += sItemTag;
            sHTML += ">";
            sHTML += aData[i];
            sHTML += "</";
            sHTML += sItemTag;
            sHTML += ">";
        }
        if(this._isNative) {
            this._htWElement["selectmenu"].html(sHTML);
        } else {
            this._htWElement["selectmenu"].first().html(sHTML);
        }
        this._refreshItems();
        this._nCurrentIdx = -1;
        this.select(this._nCurrentIdx);
    },

    /**
     * @description 값을 설정한다.
     * @param {String} sValue 선택된 내용의 값을 설정한다.
     */
    _setValue : function(sValue) {
        this._htWElement["content"].text(sValue);
    },

    /**
     * @description 현재 인덱스 값을 반환한다.
     * @return {Number}  현재 설정된 인덱스 값
     */
    getCurrentIdx : function() {
        return this._nCurrentIdx;
    },

    /**
     * @description 현재 선택된 아이템의 이름을 반환하거나, 특정 인덱스에 해당하는 아이템의 이름을 반환한다.
     * @param  {Number} nIdx 옵션. 
     * @return {String}      인덱스를 줄경우, 인덱스에 해당하는 아이템의 이름을 반환.
     * @example
     *
     * oSelect.getValue(); // 현재 선택된 아이템의 값을 반환
     * oSelect.getValue(2); // 인덱스2인 아이템의 값을 반환
     */
    getValue : function(nIdx) {
        var sValue = "";
        nIdx = (typeof nIdx === "undefined") ? this._nCurrentIdx : nIdx;
        if(0<= nIdx && nIdx < this._aItems.length) {
            if(this._isNative) {
                sValue = this._aItems[nIdx].value;
            } else {
                sValue = jindo.$Element(this._aItems[nIdx]).text();
            }
        }
        return sValue;
        
    },

    /**
     * @description disable 한다.
     * @example
     *
     * oSelect.disable();
     */
    disable : function() {
        var sClassName = this._sClassPrefix + "disable";
        if(this._htWElement["base"].hasClass(sClassName)) {
            return;
        }
        this._htWElement["base"].addClass(sClassName);
        if(this._isNative) {
            this._htWElement["selectmenu"].hide();
        } else {
            this._htWElement["selectmenu"].hide();
            this._htEvent["selectmenu"].detach(this._htWElement["base"], "click");
        }
    },

    /**
     * @description enable한다.
     * @example
     *
     * oSelect.enable();
     */
    enable : function() {
        var sClassName = this._sClassPrefix + "disable";
        if(!this._htWElement["base"].hasClass(sClassName)) {
            return;
        }
        this._htWElement["base"].removeClass(this._sClassPrefix + "disable");
        if(this._isNative) {
            this._htWElement["selectmenu"].show();
        } else {
            this._htEvent["selectmenu"].attach(this._htWElement["base"], "click");
        }
    },

    /**
     * @description  jindo.m.Selectbox 에서 사용하는 모든 객체를 release 시킨다.
     * @example
     *
     * oSelect.destroy();
     */
    destroy : function() {
        this.deactivate();
        if(this._oScroll) {
            this._oScroll.destroy();
        }
    }
}).extend(jindo.UIComponent);