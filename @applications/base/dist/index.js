(function(){var t=document.createElement("link").relList;if(t&&t.supports&&t.supports("modulepreload"))return;var n=!0,f=!1,d=void 0;try{for(var o=document.querySelectorAll('link[rel="modulepreload"]')[Symbol.iterator](),y;!(n=(y=o.next()).done);n=!0){var L=y.value;v(L)}}catch(e){f=!0,d=e}finally{try{!n&&o.return!=null&&o.return()}finally{if(f)throw d}}new MutationObserver(function(e){var r=!0,m=!1,b=void 0;try{for(var a=e[Symbol.iterator](),h;!(r=(h=a.next()).done);r=!0){var p=h.value;if(p.type==="childList"){var u=!0,g=!1,C=void 0;try{for(var s=p.addedNodes[Symbol.iterator](),N;!(u=(N=s.next()).done);u=!0){var l=N.value;l.tagName==="LINK"&&l.rel==="modulepreload"&&v(l)}}catch(c){g=!0,C=c}finally{try{!u&&s.return!=null&&s.return()}finally{if(g)throw C}}}}}catch(c){m=!0,b=c}finally{try{!r&&a.return!=null&&a.return()}finally{if(m)throw b}}}).observe(document,{childList:!0,subtree:!0});function O(e){var r={};return e.integrity&&(r.integrity=e.integrity),e.referrerPolicy&&(r.referrerPolicy=e.referrerPolicy),e.crossOrigin==="use-credentials"?r.credentials="include":e.crossOrigin==="anonymous"?r.credentials="omit":r.credentials="same-origin",r}function v(e){if(!e.ep){e.ep=!0;var r=O(e);fetch(e.href,r)}}})();const w="_button_s7q39_1",P={button:w};var S=function(i){var t=i.className,n=t===void 0?"":t;return'<button class="'.concat(P.button+(n?" ".concat(n):""),'">Carousel Button</button>')};const _="_teaser_1tcbm_1",x="_teaserCarouselButton_1tcbm_8",B={teaser:_,teaserCarouselButton:x};var E=function(){return`
    <div class="`.concat(B.teaser,`">
      <h2>Teaser Component</h2>
      `).concat(S({className:B.teaserCarouselButton}),`
    </div>
  `)};document.body.innerHTML=E();