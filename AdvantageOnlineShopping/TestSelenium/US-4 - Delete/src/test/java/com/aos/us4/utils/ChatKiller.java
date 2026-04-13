package com.aos.us4.utils;

import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;

public final class ChatKiller {

    private static final String KILL_SCRIPT =
            "if(!window.lpTag){window.lpTag={site:'',section:'',autoStart:false};"
            + "window.lpTag.newPage=function(){};window.lpTag.sdes=window.lpTag.sdes||[];}"

            + "document.querySelectorAll("
            + "'iframe[src*=\"chat\"],iframe[id*=\"lp\"],iframe[name*=\"lp\"],"
            + "div[id*=\"lpChat\"],div[class*=\"lp_\"],div[id*=\"LP\"],"
            + "div[class*=\"LPM\"],div[id*=\"lpm\"],div[id*=\"lp-\"],"
            + "div[class*=\"liveperson\"],div[class*=\"chat-container\"],"
            + "div[class*=\"chat-window\"],[id*=\"lpBut498\"],[id*=\"lp_\"],"
            + "script[src*=\"liveperson\"],script[src*=\"lpsnmedia\"],script[src*=\"lptag\"]'"
            + ").forEach(function(el){el.remove()});"

            + "if(!document.getElementById('__ck')){"
            + "var s=document.createElement('style');s.id='__ck';"
            + "s.textContent='iframe[src*=chat],div[id*=lpChat],div[class*=LPM],"
            + "div[id*=LP],div[class*=lp_],[id*=lpBut498],[id*=lp_]"
            + "{display:none!important;pointer-events:none!important;"
            + "width:0!important;height:0!important;position:fixed!important;top:-9999px!important}';"
            + "document.head.appendChild(s)}"

            + "if(!window.__ckObs){"
            + "window.__ckObs=new MutationObserver(function(ms){ms.forEach(function(m){"
            + "m.addedNodes.forEach(function(n){if(n.nodeType===1){"
            + "var s=(n.src||'').toLowerCase(),i=(n.id||'').toLowerCase(),"
            + "c=(n.className||'').toString().toLowerCase();"
            + "if(s.indexOf('liveperson')>-1||s.indexOf('lpsnmedia')>-1||s.indexOf('lptag')>-1"
            + "||i.indexOf('lpchat')>-1||i.indexOf('lpbut')>-1"
            + "||c.indexOf('lpm')>-1||c.indexOf('liveperson')>-1)n.remove();"
            + "}})})});"
            + "window.__ckObs.observe(document.documentElement,{childList:true,subtree:true})}";

    private ChatKiller() {}

    public static void kill(WebDriver driver) {
        try {
            ((JavascriptExecutor) driver).executeScript(KILL_SCRIPT);
        } catch (Exception ignored) {}
    }
}
