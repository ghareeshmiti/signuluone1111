/* Signulu partial includes — one source of truth for header/footer/modals. */
(function () {
  var cache = {};

  function load(url) {
    if (!cache[url]) {
      cache[url] = fetch(url).then(function (r) {
        if (!r.ok) throw new Error('Include failed: ' + url);
        return r.text();
      });
    }
    return cache[url];
  }

  function markActiveNav(root) {
    var path = location.pathname.replace(/\/$/, '/index.html');
    var file = decodeURIComponent(path.split('/').pop() || 'index.html');
    if (!file) file = 'index.html';
    var page = document.body.getAttribute('data-page');
    root.querySelectorAll('[data-nav]').forEach(function (link) {
      var key = link.getAttribute('data-nav');
      var href = (link.getAttribute('href') || '').split('/').pop();
      if (key === page || href === file) {
        link.classList.add('active');
        link.setAttribute('aria-current', 'page');
      }
    });
  }

  function reveal() {
    var items = document.querySelectorAll('.reveal');
    if (!('IntersectionObserver' in window)) {
      items.forEach(function (el) { el.classList.add('is-in'); });
      return;
    }
    var io = new IntersectionObserver(function (entries) {
      entries.forEach(function (e) {
        if (e.isIntersecting) { e.target.classList.add('is-in'); io.unobserve(e.target); }
      });
    }, { rootMargin: '0px 0px -8% 0px', threshold: 0.05 });
    items.forEach(function (el, i) {
      el.style.transitionDelay = (Math.min(i % 4, 3) * 70) + 'ms';
      io.observe(el);
    });
  }

  function hydrate() {
    var targets = Array.prototype.slice.call(
      document.querySelectorAll('[data-include],[data-modal]')
    );
    return Promise.all(targets.map(function (el) {
      var url = el.getAttribute('data-include') || el.getAttribute('data-modal');
      return load(url).then(function (html) {
        el.innerHTML = html;
        markActiveNav(el);
      }).catch(function (err) { console.error(err); });
    }));
  }

  document.addEventListener('DOMContentLoaded', function () {
    hydrate().then(function () {
      document.querySelectorAll('[data-year]').forEach(function (el) {
        el.textContent = new Date().getFullYear();
      });
      document.dispatchEvent(new CustomEvent('partials:ready'));
      reveal();
    });
  });
})();
