hljs.initHighlightingOnLoad();

// Make URLs clickable
document.querySelectorAll('.http').forEach((element) => {
  element.onclick = () => {
    if (element.innerHTML.indexOf('json') > -1) {
      const output = element.innerHTML.match(/^(.*)\n/)[1];
      element.innerHTML = output;
    } else {
      const url = element.innerHTML.match(/>(\/[^<]*)/)[1];
      fetch(url)
        .then((resp) => {
          const host = resp.url.match(/\/\/([^:/]+)/)[1];
          element.insertAdjacentHTML('beforeend', `\nHost: ${host}\nContent-Type: ${resp.headers.get('Content-Type')}\nContent-Length: ${resp.headers.get('Content-Length')}\n\n`);
          return resp.json();
        })
        .then((data) => {
          element.insertAdjacentHTML('beforeend', `${JSON.stringify(data, undefined, 4)}`);
          hljs.highlightBlock(element);
        });
    }
  };
});

// Make the JavaScript examples clickable
document.querySelectorAll('.js').forEach((element) => {
  const code = element.innerHTML.replace(/&gt;/g, '>');
  element.onclick = () => new Function(code)();
});
