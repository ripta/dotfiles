// ==UserScript==
// @name         Chat export
// @namespace    https://github.com/ripta/dotfiles
// @version      1.0.0
// @description  Export an AI chat conversation as text or PDF.
// @match        https://www.google.com/*
// @match        https://claude.ai/*
// @match        https://chatgpt.com/*
// @match        https://grok.com/*
// @match        https://gemini.google.com/*
// @require      https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.12.1/html2pdf.bundle.min.js#sha256=603aa7917180619f9ea2c5fc555169dd9e59f9461d3e67e1142f274cf02b30be
// @grant        GM_registerMenuCommand
// @downloadURL  https://raw.githubusercontent.com/ripta/dotfiles/master/userscripts/chat-export.user.js
// @updateURL    https://raw.githubusercontent.com/ripta/dotfiles/master/userscripts/chat-export.user.js
// ==/UserScript==

// Export the current conversation from an AI chat site.
//
// Tampermonkey's menu gets two entries: one for text and one for PDF. Text
// export saves each message and each extra panel as a section of a .txt
// file. PDF export asks whether the PDF should be searchable. A searchable
// PDF goes through the browser's print dialog. Otherwise html2pdf renders
// the page into an image-based PDF. Sites marked csp always use the print
// dialog.
//
// Each site needs its own selectors. They depend on the site's internal
// markup, so they break when the site changes.

(function () {
  'use strict';

  function exportChat(asPdf) {
    let dialog, events = [], extras = [], csp = false;

    switch (location.hostname) {
      case 'www.google.com':
        dialog = document.querySelector('div[data-xid=aim-mars-turn-root]');
        events = dialog.querySelectorAll('span[role=heading], div[data-streaming-container]');
        break;
      case 'claude.ai':
        dialog = document.querySelector('div[data-test-render-count]').parentElement.parentElement;
        events = dialog.querySelectorAll('div[data-testid="user-message"], div.font-claude-response');
        extras.push(document.querySelector('div.h-full.top-0 div.font-mono'));
        extras.push(document.querySelector('div#wiggle-file-content>div'));
        extras.push(document.querySelector('div#markdown-artifact>div'));
        extras.push(document.querySelector('div#artifacts-component-root-pdf>div'));
        break;
      case 'chatgpt.com':
        dialog = document.querySelector('#thread');
        events = dialog.querySelectorAll('section>div>div>div>div[data-message-author-role]');
        extras.push(document.querySelector('section.popover>section'));
        csp = true;
        break;
      case 'grok.com':
        dialog = document.querySelector('div#last-reply-container').parentElement;
        events = dialog.querySelectorAll('div.message-bubble');
        extras.push(document.querySelector('aside'));
        csp = true;
        break;
      case 'gemini.google.com':
        dialog = document.querySelector('#chat-history');
        events = dialog.querySelectorAll('user-query-content, message-content');
        extras.push(document.querySelector('code-immersive-panel>div.container'));
        extras.push(document.querySelector('deep-research-immersive-panel>div.container'));
        extras.push(document.querySelector('extended-response-panel response-container'));
        csp = true;
        break;
      default:
        return alert(location.hostname + ' is not supported');
    }

    events = [...events].filter(Boolean);
    extras = [...extras].filter(Boolean);

    console.group(`Found elements at ${location.hostname}:`);
    console.debug('dialog', dialog);
    console.debug('events', events);
    console.debug('extras', extras);
    console.groupEnd();

    let blocks = [dialog, ...extras];
    let ts = new Date().toISOString().replace(/[-:T.]/g, '').slice(0, 14);

    if (asPdf) {
      if (csp || confirm('Confirm if the PDF should be searchable')) {
        let temp = document.createElement('div');
        temp.id = 'id-' + Math.random().toString(36).slice(2, 9);
        blocks.forEach(el => temp.appendChild(el.cloneNode(true)));

        let style = document.createElement('style');
        style.textContent = `@media print{body>*{display:none!important}#${temp.id}{display:flex!important;flex-direction:column}}`;
        document.head.appendChild(style);
        document.body.appendChild(temp);

        print();

        setTimeout(() => {
          document.head.removeChild(style);
          document.body.removeChild(temp);
        }, 1000);
      } else {
        let pdf = html2pdf().set({
          margin: 5,
          filename: `${ts}.pdf`,
          html2canvas: {scale: 2, logging: false},
        }).from(blocks.shift());
        blocks.forEach(el => pdf = pdf.toPdf().get('pdf').then(pdfObj => pdfObj.addPage()).from(el).toContainer().toCanvas().toPdf());
        pdf.save();
      }
    } else {
      let txt = events.map(e => `# Message:\n\n${e.textContent.trim()}\n\n`).join('');
      txt += extras.map((e, i) => `# Extra ${i + 1}:\n\n${e.textContent.trim()}\n\n`).join('');

      let href = URL.createObjectURL(new Blob(['\uFEFF', txt], {type: 'text/plain;charset=utf-8'}));
      let link = Object.assign(document.createElement('a'), {href: href, download: `${ts}.txt`});
      link.click();
      URL.revokeObjectURL(link.href);
    }
  }

  GM_registerMenuCommand('Export as text', () => exportChat(false));
  GM_registerMenuCommand('Export as PDF', () => exportChat(true));
})();
