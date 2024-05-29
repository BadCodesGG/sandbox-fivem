"use strict";(self.webpackChunksandbox_phone=self.webpackChunksandbox_phone||[]).push([[8795,8254,4919,6087,8753,8633,6593,4734],{88795:(e,t,n)=>{n.r(t),n.d(t,{AppNotifications:()=>a.default,Colors:()=>c.default,GlobalNotifications:()=>r.default,Sounds:()=>o.default,Volume:()=>i.default,Wallpapers:()=>s.default,Zoom:()=>l.default});var r=n(46087),a=n(58254),i=n(58633),o=n(38753),l=n(84734),c=n(24919),s=n(66593)},58254:(e,t,n)=>{n.r(t),n.d(t,{default:()=>s});var r=n(67294),a=n(15725),i=n(94235),o=n(67814),l=n(89250),c=(0,i.Z)((function(e){return{container:{display:"flex",padding:5,background:e.palette.secondary.dark,transition:"background ease-in 0.15s",borderBottom:"1px solid ".concat(e.palette.border.divider),"&:hover":{background:e.palette.secondary.main,cursor:"pointer"}},label:{flexGrow:1,fontSize:18,lineHeight:"38px"},icon:{width:45,textAlign:"center",lineHeight:"38px"},action:{textAlign:"center",lineHeight:"38px",fontSize:20,marginRight:20},arrow:{fontSize:20}}}));const s=function(){var e=c(),t=(0,l.s0)();return r.createElement(a.ZP,{item:!0,xs:12,className:e.container,onClick:function(){t("/apps/settings/app_notifs")}},r.createElement("div",{className:e.icon},r.createElement(o.G,{icon:["fas","bell-on"]})),r.createElement("div",{className:e.label},"Application Notifications"),r.createElement("div",{className:e.action},r.createElement(o.G,{className:e.arrow,icon:["fas","chevron-right"]})))}},24919:(e,t,n)=>{n.r(t),n.d(t,{default:()=>s});var r=n(67294),a=n(15725),i=n(94235),o=n(67814),l=n(89250),c=(0,i.Z)((function(e){return{container:{display:"flex",padding:5,background:e.palette.secondary.dark,transition:"background ease-in 0.15s",borderBottom:"1px solid ".concat(e.palette.border.divider),"&:hover":{background:e.palette.secondary.main,cursor:"pointer"}},label:{flexGrow:1,fontSize:18,lineHeight:"38px"},icon:{width:45,textAlign:"center",lineHeight:"38px"},action:{textAlign:"center",lineHeight:"38px",fontSize:20,marginRight:20},arrow:{fontSize:20}}}));const s=function(){var e=c(),t=(0,l.s0)();return r.createElement(a.ZP,{item:!0,xs:12,className:e.container,onClick:function(){t("/apps/settings/colors")}},r.createElement("div",{className:e.icon},r.createElement(o.G,{icon:["fas","swatchbook"]})),r.createElement("div",{className:e.label},"Colors"),r.createElement("div",{className:e.action},r.createElement(o.G,{className:e.arrow,icon:["fas","chevron-right"]})))}},46087:(e,t,n)=>{n.r(t),n.d(t,{default:()=>d});var r=n(67294),a=n(86706),i=n(15725),o=n(89149),l=(n(64680),n(94235)),c=n(67814);function s(e,t){return function(e){if(Array.isArray(e))return e}(e)||function(e,t){var n=null==e?null:"undefined"!=typeof Symbol&&e[Symbol.iterator]||e["@@iterator"];if(null!=n){var r,a,i,o,l=[],c=!0,s=!1;try{if(i=(n=n.call(e)).next,0===t){if(Object(n)!==n)return;c=!1}else for(;!(c=(r=i.call(n)).done)&&(l.push(r.value),l.length!==t);c=!0);}catch(e){s=!0,a=e}finally{try{if(!c&&null!=n.return&&(o=n.return(),Object(o)!==o))return}finally{if(s)throw a}}return l}}(e,t)||function(e,t){if(!e)return;if("string"==typeof e)return u(e,t);var n=Object.prototype.toString.call(e).slice(8,-1);"Object"===n&&e.constructor&&(n=e.constructor.name);if("Map"===n||"Set"===n)return Array.from(e);if("Arguments"===n||/^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n))return u(e,t)}(e,t)||function(){throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.")}()}function u(e,t){(null==t||t>e.length)&&(t=e.length);for(var n=0,r=new Array(t);n<t;n++)r[n]=e[n];return r}var m=(0,l.Z)((function(e){return{container:{display:"flex",padding:5,background:e.palette.secondary.dark,transition:"background ease-in 0.15s",borderBottom:"1px solid ".concat(e.palette.border.divider),"&:hover":{background:e.palette.secondary.main,cursor:"pointer"}},label:{flexGrow:1,fontSize:18,lineHeight:"38px"},icon:{width:45,textAlign:"center",lineHeight:"38px"},arrow:{fontSize:20}}}));const d=function(e){var t=e.UpdateSetting,n=m(),l=(0,a.v9)((function(e){return e.data.data.player.PhoneSettings.notifications})),u=s((0,r.useState)(l),2),d=u[0],f=u[1],p=function(){t("notifications",!d),f(!d)};return r.createElement(i.ZP,{item:!0,xs:12,className:n.container,onClick:p},r.createElement("div",{className:n.icon},r.createElement(c.G,{icon:["fas","bell-on"]})),r.createElement("div",{className:n.label},"Notifications"),r.createElement("div",{className:n.action},r.createElement(o.Z,{className:n.arrow,checked:d,color:"primary"})))}},38753:(e,t,n)=>{n.r(t),n.d(t,{default:()=>s});var r=n(67294),a=n(15725),i=n(94235),o=n(67814),l=n(89250),c=(0,i.Z)((function(e){return{container:{display:"flex",padding:5,background:e.palette.secondary.dark,transition:"background ease-in 0.15s",borderBottom:"1px solid ".concat(e.palette.border.divider),"&:hover":{background:e.palette.secondary.main,cursor:"pointer"}},label:{flexGrow:1,fontSize:18,lineHeight:"38px"},icon:{width:45,textAlign:"center",lineHeight:"38px"},action:{textAlign:"center",lineHeight:"38px",fontSize:20,marginRight:20},arrow:{fontSize:20}}}));const s=function(){var e=c(),t=(0,l.s0)();return r.createElement(a.ZP,{item:!0,xs:12,className:e.container,onClick:function(){t("/apps/settings/sounds")}},r.createElement("div",{className:e.icon},r.createElement(o.G,{icon:["fas","waveform-lines"]})),r.createElement("div",{className:e.label},"Sounds"),r.createElement("div",{className:e.action},r.createElement(o.G,{className:e.arrow,icon:["fas","chevron-right"]})))}},58633:(e,t,n)=>{n.r(t),n.d(t,{default:()=>f});var r=n(67294),a=n(86706),i=n(15725),o=n(6867),l=n(60195),c=n(94235),s=n(67814);function u(e,t){return function(e){if(Array.isArray(e))return e}(e)||function(e,t){var n=null==e?null:"undefined"!=typeof Symbol&&e[Symbol.iterator]||e["@@iterator"];if(null!=n){var r,a,i,o,l=[],c=!0,s=!1;try{if(i=(n=n.call(e)).next,0===t){if(Object(n)!==n)return;c=!1}else for(;!(c=(r=i.call(n)).done)&&(l.push(r.value),l.length!==t);c=!0);}catch(e){s=!0,a=e}finally{try{if(!c&&null!=n.return&&(o=n.return(),Object(o)!==o))return}finally{if(s)throw a}}return l}}(e,t)||function(e,t){if(!e)return;if("string"==typeof e)return m(e,t);var n=Object.prototype.toString.call(e).slice(8,-1);"Object"===n&&e.constructor&&(n=e.constructor.name);if("Map"===n||"Set"===n)return Array.from(e);if("Arguments"===n||/^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n))return m(e,t)}(e,t)||function(){throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.")}()}function m(e,t){(null==t||t>e.length)&&(t=e.length);for(var n=0,r=new Array(t);n<t;n++)r[n]=e[n];return r}var d=(0,c.Z)((function(e){return{container:{display:"flex",padding:5,background:e.palette.secondary.dark,transition:"background ease-in 0.15s",borderBottom:"1px solid ".concat(e.palette.border.divider)},label:{flexGrow:1,fontSize:18,lineHeight:"38px"},icon:{width:45,textAlign:"center",lineHeight:"38px"},action:{width:226,marginRight:12,display:"flex","& svg":{fontSize:18,lineHeight:"38px"}},arrow:{fontSize:20},mute:{color:e.palette.error.main},unmute:{color:e.palette.error.main},actionBtn:{width:30,height:30,"&.mute":{marginRight:8,color:e.palette.error.main},"&.unmute":{marginRight:8,color:e.palette.success.main},"&:not(.unmute):not(.mute)":{marginLeft:8}}}}));const f=function(e){var t=e.UpdateSetting,n=d(),c=(0,a.v9)((function(e){return e.data.data.player.PhoneSettings.volume})),m=u((0,r.useState)(c),2),f=m[0],p=m[1];(0,r.useEffect)((function(){p(c)}),[c]);return r.createElement(i.ZP,{item:!0,xs:12,className:n.container},r.createElement("div",{className:n.icon},r.createElement(s.G,{icon:["fas","volume-high"]})),r.createElement("div",{className:n.label},"Volume"),r.createElement("div",{className:n.action},r.createElement(o.Z,{onClick:function(e){e.preventDefault(),t("volume",0===c?100:0)},className:"".concat(n.actionBtn," ").concat(0==c?"unmute":"mute")},0==c?r.createElement(s.G,{icon:["far","volume"]}):r.createElement(s.G,{icon:["far","volume-xmark"]})),r.createElement(l.ZP,{value:f,onChange:function(e,t){e.preventDefault(),p(t)},step:1,min:0,max:100}),r.createElement(o.Z,{disabled:f==c,onClick:function(){t("volume",f)},className:n.actionBtn},r.createElement(s.G,{icon:["far","save"]}))))}},66593:(e,t,n)=>{n.r(t),n.d(t,{default:()=>s});var r=n(67294),a=n(15725),i=n(94235),o=n(67814),l=n(89250),c=(0,i.Z)((function(e){return{container:{display:"flex",padding:5,background:e.palette.secondary.dark,transition:"background ease-in 0.15s",borderBottom:"1px solid ".concat(e.palette.border.divider),"&:hover":{background:e.palette.secondary.main,cursor:"pointer"}},label:{flexGrow:1,fontSize:18,lineHeight:"38px"},icon:{width:45,textAlign:"center",lineHeight:"38px"},action:{textAlign:"center",lineHeight:"38px",fontSize:20,marginRight:20},arrow:{fontSize:20}}}));const s=function(){var e=c(),t=(0,l.s0)();return r.createElement(a.ZP,{item:!0,xs:12,className:e.container,onClick:function(){t("/apps/settings/wallpaper")}},r.createElement("div",{className:e.icon},r.createElement(o.G,{icon:["fas","image-polaroid"]})),r.createElement("div",{className:e.label},"Wallpaper"),r.createElement("div",{className:e.action},r.createElement(o.G,{className:e.arrow,icon:["fas","chevron-right"]})))}},84734:(e,t,n)=>{n.r(t),n.d(t,{default:()=>p});var r=n(67294),a=n(86706),i=n(15725),o=n(6867),l=n(60195),c=n(94235),s=n(67814),u=n(45525);function m(e,t){return function(e){if(Array.isArray(e))return e}(e)||function(e,t){var n=null==e?null:"undefined"!=typeof Symbol&&e[Symbol.iterator]||e["@@iterator"];if(null!=n){var r,a,i,o,l=[],c=!0,s=!1;try{if(i=(n=n.call(e)).next,0===t){if(Object(n)!==n)return;c=!1}else for(;!(c=(r=i.call(n)).done)&&(l.push(r.value),l.length!==t);c=!0);}catch(e){s=!0,a=e}finally{try{if(!c&&null!=n.return&&(o=n.return(),Object(o)!==o))return}finally{if(s)throw a}}return l}}(e,t)||function(e,t){if(!e)return;if("string"==typeof e)return d(e,t);var n=Object.prototype.toString.call(e).slice(8,-1);"Object"===n&&e.constructor&&(n=e.constructor.name);if("Map"===n||"Set"===n)return Array.from(e);if("Arguments"===n||/^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n))return d(e,t)}(e,t)||function(){throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.")}()}function d(e,t){(null==t||t>e.length)&&(t=e.length);for(var n=0,r=new Array(t);n<t;n++)r[n]=e[n];return r}var f=(0,c.Z)((function(e){return{container:{display:"flex",padding:5,background:e.palette.secondary.dark,transition:"background ease-in 0.15s",borderBottom:"1px solid ".concat(e.palette.border.divider)},label:{flexGrow:1,fontSize:18,lineHeight:"38px"},icon:{width:45,textAlign:"center",lineHeight:"38px"},action:{width:226,marginRight:12,display:"flex","& svg":{fontSize:18,lineHeight:"38px"}},arrow:{fontSize:20},mute:{color:e.palette.error.main},unmute:{color:e.palette.error.main},actionBtn:{width:30,height:30,marginLeft:8,"&.left":{marginRight:8},"&.right":{marginLeft:8}}}}));const p=function(e){var t=e.UpdateSetting,n=f(),c=(0,a.v9)((function(e){return e.data.data.player.PhoneSettings.zoom})),d=m((0,r.useState)(c),2),p=d[0],g=d[1],h=m((0,r.useState)(!1),2),v=h[0],b=h[1];(0,r.useEffect)((function(){g(c)}),[c]);return r.createElement(i.ZP,{item:!0,xs:12,className:n.container},r.createElement("div",{className:n.icon},r.createElement(s.G,{icon:["fas","magnifying-glass"]})),r.createElement("div",{className:n.label},"Zoom"),r.createElement("div",{className:n.action},r.createElement(o.Z,{onClick:function(){return b(!0)},className:"".concat(n.actionBtn," left")},r.createElement(s.G,{icon:["far","question"]})),r.createElement(l.ZP,{value:p,onChange:function(e,t){e.preventDefault(),g(t)},step:1,min:80,max:100}),r.createElement(o.Z,{disabled:p==c,onClick:function(){t("zoom",p)},className:"".concat(n.actionBtn," right")},r.createElement(s.G,{icon:["far","save"]}))),r.createElement(u.u_,{open:v,title:"Phone Zoom",onClose:function(){return b(!1)}},r.createElement("p",null,"Zooming only works when the phone is minimized."),r.createElement("p",null,"Zooming may have adverse effects on some features, things like hover tooltips may not work correctly (or at all on lower zooms). ",r.createElement("b",null,"You've been warned"),".")))}}}]);