"use strict";(self.webpackChunksandbox_phone=self.webpackChunksandbox_phone||[]).push([[2980,8422],{92980:(t,e,r)=>{r.r(e),r.d(e,{default:()=>A});var n=r(67294),o=r(86706),i=r(76446),a=r(56036),c=r(5305),l=r(3460),u=r(94235),s=r(69042),f=r(68174),p=r(45525),d=r(28422);function h(t){return h="function"==typeof Symbol&&"symbol"==typeof Symbol.iterator?function(t){return typeof t}:function(t){return t&&"function"==typeof Symbol&&t.constructor===Symbol&&t!==Symbol.prototype?"symbol":typeof t},h(t)}function v(){v=function(){return t};var t={},e=Object.prototype,r=e.hasOwnProperty,n=Object.defineProperty||function(t,e,r){t[e]=r.value},o="function"==typeof Symbol?Symbol:{},i=o.iterator||"@@iterator",a=o.asyncIterator||"@@asyncIterator",c=o.toStringTag||"@@toStringTag";function l(t,e,r){return Object.defineProperty(t,e,{value:r,enumerable:!0,configurable:!0,writable:!0}),t[e]}try{l({},"")}catch(t){l=function(t,e,r){return t[e]=r}}function u(t,e,r,o){var i=e&&e.prototype instanceof p?e:p,a=Object.create(i.prototype),c=new L(o||[]);return n(a,"_invoke",{value:O(t,r,c)}),a}function s(t,e,r){try{return{type:"normal",arg:t.call(e,r)}}catch(t){return{type:"throw",arg:t}}}t.wrap=u;var f={};function p(){}function d(){}function m(){}var y={};l(y,i,(function(){return this}));var g=Object.getPrototypeOf,b=g&&g(g(S([])));b&&b!==e&&r.call(b,i)&&(y=b);var w=m.prototype=p.prototype=Object.create(y);function x(t){["next","throw","return"].forEach((function(e){l(t,e,(function(t){return this._invoke(e,t)}))}))}function E(t,e){function o(n,i,a,c){var l=s(t[n],t,i);if("throw"!==l.type){var u=l.arg,f=u.value;return f&&"object"==h(f)&&r.call(f,"__await")?e.resolve(f.__await).then((function(t){o("next",t,a,c)}),(function(t){o("throw",t,a,c)})):e.resolve(f).then((function(t){u.value=t,a(u)}),(function(t){return o("throw",t,a,c)}))}c(l.arg)}var i;n(this,"_invoke",{value:function(t,r){function n(){return new e((function(e,n){o(t,r,e,n)}))}return i=i?i.then(n,n):n()}})}function O(t,e,r){var n="suspendedStart";return function(o,i){if("executing"===n)throw new Error("Generator is already running");if("completed"===n){if("throw"===o)throw i;return P()}for(r.method=o,r.arg=i;;){var a=r.delegate;if(a){var c=A(a,r);if(c){if(c===f)continue;return c}}if("next"===r.method)r.sent=r._sent=r.arg;else if("throw"===r.method){if("suspendedStart"===n)throw n="completed",r.arg;r.dispatchException(r.arg)}else"return"===r.method&&r.abrupt("return",r.arg);n="executing";var l=s(t,e,r);if("normal"===l.type){if(n=r.done?"completed":"suspendedYield",l.arg===f)continue;return{value:l.arg,done:r.done}}"throw"===l.type&&(n="completed",r.method="throw",r.arg=l.arg)}}}function A(t,e){var r=e.method,n=t.iterator[r];if(void 0===n)return e.delegate=null,"throw"===r&&t.iterator.return&&(e.method="return",e.arg=void 0,A(t,e),"throw"===e.method)||"return"!==r&&(e.method="throw",e.arg=new TypeError("The iterator does not provide a '"+r+"' method")),f;var o=s(n,t.iterator,e.arg);if("throw"===o.type)return e.method="throw",e.arg=o.arg,e.delegate=null,f;var i=o.arg;return i?i.done?(e[t.resultName]=i.value,e.next=t.nextLoc,"return"!==e.method&&(e.method="next",e.arg=void 0),e.delegate=null,f):i:(e.method="throw",e.arg=new TypeError("iterator result is not an object"),e.delegate=null,f)}function j(t){var e={tryLoc:t[0]};1 in t&&(e.catchLoc=t[1]),2 in t&&(e.finallyLoc=t[2],e.afterLoc=t[3]),this.tryEntries.push(e)}function k(t){var e=t.completion||{};e.type="normal",delete e.arg,t.completion=e}function L(t){this.tryEntries=[{tryLoc:"root"}],t.forEach(j,this),this.reset(!0)}function S(t){if(t){var e=t[i];if(e)return e.call(t);if("function"==typeof t.next)return t;if(!isNaN(t.length)){var n=-1,o=function e(){for(;++n<t.length;)if(r.call(t,n))return e.value=t[n],e.done=!1,e;return e.value=void 0,e.done=!0,e};return o.next=o}}return{next:P}}function P(){return{value:void 0,done:!0}}return d.prototype=m,n(w,"constructor",{value:m,configurable:!0}),n(m,"constructor",{value:d,configurable:!0}),d.displayName=l(m,c,"GeneratorFunction"),t.isGeneratorFunction=function(t){var e="function"==typeof t&&t.constructor;return!!e&&(e===d||"GeneratorFunction"===(e.displayName||e.name))},t.mark=function(t){return Object.setPrototypeOf?Object.setPrototypeOf(t,m):(t.__proto__=m,l(t,c,"GeneratorFunction")),t.prototype=Object.create(w),t},t.awrap=function(t){return{__await:t}},x(E.prototype),l(E.prototype,a,(function(){return this})),t.AsyncIterator=E,t.async=function(e,r,n,o,i){void 0===i&&(i=Promise);var a=new E(u(e,r,n,o),i);return t.isGeneratorFunction(r)?a:a.next().then((function(t){return t.done?t.value:a.next()}))},x(w),l(w,c,"Generator"),l(w,i,(function(){return this})),l(w,"toString",(function(){return"[object Generator]"})),t.keys=function(t){var e=Object(t),r=[];for(var n in e)r.push(n);return r.reverse(),function t(){for(;r.length;){var n=r.pop();if(n in e)return t.value=n,t.done=!1,t}return t.done=!0,t}},t.values=S,L.prototype={constructor:L,reset:function(t){if(this.prev=0,this.next=0,this.sent=this._sent=void 0,this.done=!1,this.delegate=null,this.method="next",this.arg=void 0,this.tryEntries.forEach(k),!t)for(var e in this)"t"===e.charAt(0)&&r.call(this,e)&&!isNaN(+e.slice(1))&&(this[e]=void 0)},stop:function(){this.done=!0;var t=this.tryEntries[0].completion;if("throw"===t.type)throw t.arg;return this.rval},dispatchException:function(t){if(this.done)throw t;var e=this;function n(r,n){return a.type="throw",a.arg=t,e.next=r,n&&(e.method="next",e.arg=void 0),!!n}for(var o=this.tryEntries.length-1;o>=0;--o){var i=this.tryEntries[o],a=i.completion;if("root"===i.tryLoc)return n("end");if(i.tryLoc<=this.prev){var c=r.call(i,"catchLoc"),l=r.call(i,"finallyLoc");if(c&&l){if(this.prev<i.catchLoc)return n(i.catchLoc,!0);if(this.prev<i.finallyLoc)return n(i.finallyLoc)}else if(c){if(this.prev<i.catchLoc)return n(i.catchLoc,!0)}else{if(!l)throw new Error("try statement without catch or finally");if(this.prev<i.finallyLoc)return n(i.finallyLoc)}}}},abrupt:function(t,e){for(var n=this.tryEntries.length-1;n>=0;--n){var o=this.tryEntries[n];if(o.tryLoc<=this.prev&&r.call(o,"finallyLoc")&&this.prev<o.finallyLoc){var i=o;break}}i&&("break"===t||"continue"===t)&&i.tryLoc<=e&&e<=i.finallyLoc&&(i=null);var a=i?i.completion:{};return a.type=t,a.arg=e,i?(this.method="next",this.next=i.finallyLoc,f):this.complete(a)},complete:function(t,e){if("throw"===t.type)throw t.arg;return"break"===t.type||"continue"===t.type?this.next=t.arg:"return"===t.type?(this.rval=this.arg=t.arg,this.method="return",this.next="end"):"normal"===t.type&&e&&(this.next=e),f},finish:function(t){for(var e=this.tryEntries.length-1;e>=0;--e){var r=this.tryEntries[e];if(r.finallyLoc===t)return this.complete(r.completion,r.afterLoc),k(r),f}},catch:function(t){for(var e=this.tryEntries.length-1;e>=0;--e){var r=this.tryEntries[e];if(r.tryLoc===t){var n=r.completion;if("throw"===n.type){var o=n.arg;k(r)}return o}}throw new Error("illegal catch attempt")},delegateYield:function(t,e,r){return this.delegate={iterator:S(t),resultName:e,nextLoc:r},"next"===this.method&&(this.arg=void 0),f}},t}function m(t,e,r,n,o,i,a){try{var c=t[i](a),l=c.value}catch(t){return void r(t)}c.done?e(l):Promise.resolve(l).then(n,o)}function y(t){return function(){var e=this,r=arguments;return new Promise((function(n,o){var i=t.apply(e,r);function a(t){m(i,n,o,a,c,"next",t)}function c(t){m(i,n,o,a,c,"throw",t)}a(void 0)}))}}function g(t,e){var r=Object.keys(t);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(t);e&&(n=n.filter((function(e){return Object.getOwnPropertyDescriptor(t,e).enumerable}))),r.push.apply(r,n)}return r}function b(t){for(var e=1;e<arguments.length;e++){var r=null!=arguments[e]?arguments[e]:{};e%2?g(Object(r),!0).forEach((function(e){w(t,e,r[e])})):Object.getOwnPropertyDescriptors?Object.defineProperties(t,Object.getOwnPropertyDescriptors(r)):g(Object(r)).forEach((function(e){Object.defineProperty(t,e,Object.getOwnPropertyDescriptor(r,e))}))}return t}function w(t,e,r){return(e=function(t){var e=function(t,e){if("object"!==h(t)||null===t)return t;var r=t[Symbol.toPrimitive];if(void 0!==r){var n=r.call(t,e||"default");if("object"!==h(n))return n;throw new TypeError("@@toPrimitive must return a primitive value.")}return("string"===e?String:Number)(t)}(t,"string");return"symbol"===h(e)?e:String(e)}(e))in t?Object.defineProperty(t,e,{value:r,enumerable:!0,configurable:!0,writable:!0}):t[e]=r,t}function x(t,e){return function(t){if(Array.isArray(t))return t}(t)||function(t,e){var r=null==t?null:"undefined"!=typeof Symbol&&t[Symbol.iterator]||t["@@iterator"];if(null!=r){var n,o,i,a,c=[],l=!0,u=!1;try{if(i=(r=r.call(t)).next,0===e){if(Object(r)!==r)return;l=!1}else for(;!(l=(n=i.call(r)).done)&&(c.push(n.value),c.length!==e);l=!0);}catch(t){u=!0,o=t}finally{try{if(!l&&null!=r.return&&(a=r.return(),Object(a)!==a))return}finally{if(u)throw o}}return c}}(t,e)||function(t,e){if(!t)return;if("string"==typeof t)return E(t,e);var r=Object.prototype.toString.call(t).slice(8,-1);"Object"===r&&t.constructor&&(r=t.constructor.name);if("Map"===r||"Set"===r)return Array.from(t);if("Arguments"===r||/^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(r))return E(t,e)}(t,e)||function(){throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.")}()}function E(t,e){(null==e||e>t.length)&&(e=t.length);for(var r=0,n=new Array(e);r<e;r++)n[r]=t[r];return n}var O=(0,u.Z)((function(t){return{wrapper:{height:"100%",background:t.palette.secondary.main},emptyMsg:{color:t.palette.text.alt,height:"fit-content",width:"fit-content",fontSize:20,fontWeight:"bold",position:"absolute",top:0,bottom:0,left:0,right:0,margin:"auto"},editField:{marginBottom:20,width:"100%"}}}));const A=function(t){var e,r=t.setLoading,u=t.refreshAccounts,h=O(),m=(0,f.VY)(),g=(0,o.v9)((function(t){return t.data.data.bankAccounts})),E=null==g?void 0:g.accounts,A=null==g?void 0:g.pendingBills,j=E&&E.filter((function(t){return"personal"==t.Type}))[0],k=x((0,n.useState)(!1),2),L=k[0],S=k[1],P=x((0,n.useState)({bill:0,withAccount:j.Account}),2),N=P[0],B=P[1],D=function(){var t=y(v().mark((function t(e){var n,o;return v().wrap((function(t){for(;;)switch(t.prev=t.next){case 0:if(e.preventDefault(),r("Accepting Bill"),!((n=E&&E.filter((function(t){return t.Account==N.withAccount}))[0])&&n.Balance>=(null==N?void 0:N.billData.Amount))){t.next=22;break}return t.prev=4,t.next=7,s.Z.send("Banking:AcceptBill",{bill:N.billId,account:N.withAccount});case 7:return t.next=9,t.sent.json();case 9:o=t.sent,m(o?"Bill Has Been Paid":"Error Paying Bill"),setTimeout((function(){return u()}),750),t.next=18;break;case 14:t.prev=14,t.t0=t.catch(4),m("Error Paying Bill"),r(!1);case 18:S(!1),B({bill:0,withAccount:j.Account}),t.next=24;break;case 22:m("Insufficient Funds to Pay Bill"),r(!1);case 24:case"end":return t.stop()}}),t,null,[[4,14]])})));return function(e){return t.apply(this,arguments)}}(),_=function(){var t=y(v().mark((function t(e){return v().wrap((function(t){for(;;)switch(t.prev=t.next){case 0:return r("Dismissing Bill"),t.prev=1,t.next=4,s.Z.send("Banking:DismissBill",{bill:e.Id});case 4:return t.next=6,t.sent.json();case 6:t.sent?(m("Bill Has Been Dismissed"),setTimeout((function(){u()}),750)):(m("Error Dismissing Bill"),r(!1)),t.next=14;break;case 10:t.prev=10,t.t0=t.catch(1),m("Error Dismissing Bill"),r(!1);case 14:case"end":return t.stop()}}),t,null,[[1,10]])})));return function(e){return t.apply(this,arguments)}}();return A.length>0?n.createElement("div",{className:h.wrapper},n.createElement("div",null,A.sort((function(t,e){return e.Timestamp-t.Timestamp})).map((function(t){return n.createElement(d.default,{key:"bill-".concat(t.Id),bill:t,onPay:function(){return function(t){B({billData:t,billId:t.Id,withAccount:j.Account}),S(!0)}(t)},onDecline:function(){return _(t)}})}))),n.createElement(p.u_,{form:!0,open:L,title:"Accept Bill of $".concat(null===(e=N.billData)||void 0===e?void 0:e.Amount),submitLang:"Accept Bill",onAccept:D,onClose:function(){return S(!1)}},n.createElement(i.Z,{className:h.editField},n.createElement(a.Z,{id:"withAccount",name:"withAccount",value:N.withAccount,onChange:function(t){B(b(b({},N),{},w({},t.target.name,t.target.value)))}},E.map((function(t){var e;return n.createElement(c.Z,{key:t.Account,value:t.Account,disabled:!(null!==(e=t.Permissions)&&void 0!==e&&e.WITHDRAW)},"".concat(function(t){switch(t.Type){case"personal":return"Personal Account";case"personal_savings":return"Personal Savings Account";default:return t.Name}}(t)," - ").concat(t.Account))}))),n.createElement(l.Z,null,"Select the account that you wish to pay with.")))):n.createElement("div",{className:h.wrapper},n.createElement("div",{className:h.emptyMsg},"No Pending Bills"))}},28422:(t,e,r)=>{r.r(e),r.d(e,{default:()=>f});var n=r(67294),o=r(94235),i=r(6867),a=r(67814),c=r(94803),l=r.n(c),u=r(68174),s=(0,o.Z)((function(t){return{container:{zIndex:1,background:"".concat(t.palette.secondary.dark,"d1"),backdropFilter:"blur(10px)",border:"1px solid ".concat(t.palette.border.divider),borderLeft:function(t){return"2px solid ".concat(t.color)},transition:"border ease-in 0.15s",userSelect:"none","&:not(:last-of-type)":{marginBottom:16}},detailsContainer:{lineHeight:"25px",display:"flex",padding:5},accIcon:{display:"inline-block",fontSize:18,padding:5,textAlign:"center",borderLeft:"1px solid ".concat(t.palette.border.divider),lineHeight:"70px","& .positive":{color:t.palette.success.main},"& .negative":{color:t.palette.error.main}},details:{padding:5,paddingTop:15,flexGrow:1},detail:{lineHeight:"35px",fontSize:18,whiteSpace:"nowrap",overflow:"hidden",textOverflow:"ellipsis",maxWidth:"100%","& .currency":{color:t.palette.success.main,"&::before":{content:'"$"'},"&::after":{borderRight:"1px solid ".concat(t.palette.border.divider),content:'" "',marginRight:4}}},description:{padding:8,borderTop:"1px solid ".concat(t.palette.border.divider)},timestamp:{fontSize:12,color:t.palette.text.alt}}}));const f=function(t){var e=t.bill,r=t.onPay,o=t.onDecline,c=(0,u.Ov)("bank"),f=s(c);return n.createElement("div",{className:f.container},n.createElement("div",{className:f.detailsContainer},n.createElement("div",{className:f.details},n.createElement("div",{className:f.detail},n.createElement("span",{className:"currency"},e.Amount),e.Name),n.createElement("div",{className:f.timestamp},"Received ",n.createElement(l(),{unix:!0,date:e.Timestamp,fromNow:!0}))),n.createElement("div",{className:f.accIcon},n.createElement(i.Z,{className:"positive",onClick:r},n.createElement(a.G,{icon:"check"})),n.createElement(i.Z,{className:"negative",onClick:o},n.createElement(a.G,{icon:"x"})))),n.createElement("div",{className:f.description},Boolean(e.Description)?e.Description:"Bill Has No Description"))}}}]);