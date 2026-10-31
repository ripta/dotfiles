// ==UserScript==
// @name         Chat export
// @namespace    https://github.com/ripta/dotfiles
// @version      2.1.0
// @description  Export an AI chat conversation as text or PDF.
// @match        https://www.google.com/*
// @match        https://claude.ai/*
// @match        https://chatgpt.com/*
// @match        https://grok.com/*
// @match        https://gemini.google.com/*
// @grant        GM_registerMenuCommand
// @noframes
// @downloadURL  https://raw.githubusercontent.com/ripta/dotfiles/master/userscripts/chat-export.user.js
// @updateURL    https://raw.githubusercontent.com/ripta/dotfiles/master/userscripts/chat-export.user.js
// ==/UserScript==

// Export the current conversation from an AI chat site.
//
// Tampermonkey's menu gets two entries:
//
//   - Export as text saves each message and each extra panel as a section
//     of a .txt file.
//   - Export as PDF prints only the conversation through the browser's
//     print dialog. Choose "Save as PDF" there.
//
// Each site needs its own selectors in SITES. They depend on the site's
// internal markup, so they break when the site changes. The export then
// stops with an alert that names the site.

(function () {
  'use strict';

  // For each hostname:
  //
  //   - container finds the element that holds the whole conversation.
  //   - messages selects each message inside the container.
  //   - extras select side panels outside the container, such as artifacts
  //     or canvases. Missing ones are skipped.
  const SITES = {
    'www.google.com': {
      container: () => document.querySelector('div[data-xid=aim-mars-turn-root]'),
      messages: 'span[role=heading], div[data-streaming-container]',
      extras: [],
    },
    'claude.ai': {
      container: () => document.querySelector('div[data-test-render-count]')?.parentElement?.parentElement,
      messages: 'div[data-testid="user-message"], div.font-claude-response',
      extras: [
        'div.h-full.top-0 div.font-mono',
        'div#wiggle-file-content>div',
        'div#markdown-artifact>div',
        'div#artifacts-component-root-pdf>div',
      ],
    },
    'chatgpt.com': {
      container: () => document.querySelector('#thread'),
      messages: 'section>div>div>div>div[data-message-author-role]',
      extras: ['section.popover>section'],
    },
    'grok.com': {
      container: () => document.querySelector('div[data-transcript-renderer]'),
      messages: 'div.message-bubble',
      extras: ['aside'],
    },
    'gemini.google.com': {
      container: () => document.querySelector('#chat-history'),
      messages: 'user-query-content, message-content',
      extras: [
        'code-immersive-panel>div.container',
        'deep-research-immersive-panel>div.container',
        'extended-response-panel response-container',
      ],
    },
  };

  const PRINT_ID = 'chat-export-print';

  const site = SITES[location.hostname];
  if (!site) {
    return;
  }

  // Find the conversation on the page. Returns null after alerting when the
  // site's selectors no longer match.
  function findConversation() {
    const container = site.container();
    if (!container) {
      alert(`Chat export could not find the conversation on ${location.hostname}. Its selectors may be out of date.`);
      return null;
    }

    const messages = [...container.querySelectorAll(site.messages)];
    const extras = site.extras.map(s => document.querySelector(s)).filter(Boolean);

    console.group(`Chat export found elements on ${location.hostname}:`);
    console.debug('container', container);
    console.debug('messages', messages);
    console.debug('extras', extras);
    console.groupEnd();

    return {container, messages, extras};
  }

  // A timestamp like 20261030213000, in UTC, for file names.
  function timestamp() {
    return new Date().toISOString().replace(/[-:T.]/g, '').slice(0, 14);
  }

  function exportText() {
    const chat = findConversation();
    if (!chat) {
      return;
    }
    if (chat.messages.length === 0) {
      alert(`Chat export found no messages on ${location.hostname}. Its selectors may be out of date.`);
      return;
    }

    // innerText keeps the line breaks that are visible on screen.
    // textContent would run paragraphs and code lines together.
    const sections = [
      ...chat.messages.map(el => `# Message:\n\n${el.innerText.trim()}\n\n`),
      ...chat.extras.map((el, i) => `# Extra ${i + 1}:\n\n${el.innerText.trim()}\n\n`),
    ];

    // The byte order mark helps some editors detect UTF-8.
    const blob = new Blob(['\uFEFF', ...sections], {type: 'text/plain;charset=utf-8'});
    const href = URL.createObjectURL(blob);
    const link = Object.assign(document.createElement('a'), {href, download: `${timestamp()}.txt`});
    link.click();

    // Revoking right away can cancel the download in some browsers.
    setTimeout(() => URL.revokeObjectURL(href), 10000);
  }

  function exportPdf() {
    const chat = findConversation();
    if (!chat) {
      return;
    }

    // Copy the conversation into one element. A print-only stylesheet then
    // hides everything else on the page.
    const copy = document.createElement('div');
    copy.id = PRINT_ID;
    for (const el of [chat.container, ...chat.extras]) {
      copy.appendChild(el.cloneNode(true));
    }

    const style = document.createElement('style');
    style.textContent = `@media print {
      body > * { display: none !important; }
      #${PRINT_ID} { display: flex !important; flex-direction: column; }
    }`;

    document.head.appendChild(style);
    document.body.appendChild(copy);

    window.addEventListener('afterprint', () => {
      style.remove();
      copy.remove();
    }, {once: true});

    print();
  }

  GM_registerMenuCommand('Export as text', exportText);
  GM_registerMenuCommand('Export as PDF', exportPdf);
})();
