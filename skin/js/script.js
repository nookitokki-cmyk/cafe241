/**
 * CEIN. - Site Interactions
 */

(function () {
  'use strict';

  /* ===== Mobile Menu Toggle ===== */
  var mobileMenuBtn = document.getElementById('mobileMenuBtn');
  var mobileMenuOverlay = document.getElementById('mobileMenuOverlay');
  var mobileMenuClose = document.getElementById('mobileMenuClose');

  function openMobileMenu() {
    if (mobileMenuOverlay) {
      mobileMenuOverlay.classList.add('active');
      document.body.style.overflow = 'hidden';
    }
  }

  function closeMobileMenu() {
    if (mobileMenuOverlay) {
      mobileMenuOverlay.classList.remove('active');
      document.body.style.overflow = '';
    }
  }

  if (mobileMenuBtn) {
    mobileMenuBtn.addEventListener('click', openMobileMenu);
  }

  if (mobileMenuClose) {
    mobileMenuClose.addEventListener('click', closeMobileMenu);
  }

  if (mobileMenuOverlay) {
    mobileMenuOverlay.addEventListener('click', function (e) {
      if (e.target === mobileMenuOverlay) {
        closeMobileMenu();
      }
    });
  }

  /* ===== FAQ Accordion ===== */
  var faqQuestions = document.querySelectorAll('.faq-question');

  faqQuestions.forEach(function (btn) {
    btn.addEventListener('click', function () {
      var item = this.closest('.faq-item');
      var isOpen = item.classList.contains('open');

      // Close all other items
      document.querySelectorAll('.faq-item.open').forEach(function (openItem) {
        openItem.classList.remove('open');
      });

      // Toggle current
      if (!isOpen) {
        item.classList.add('open');
      }
    });
  });

  /* ===== Product Detail Accordion ===== */
  var pdAccordionHeaders = document.querySelectorAll('.pd-accordion-header');

  pdAccordionHeaders.forEach(function (header) {
    header.addEventListener('click', function () {
      var accordion = this.closest('.pd-accordion');
      var isOpen = accordion.classList.contains('open');

      // Close all other accordions
      document.querySelectorAll('.pd-accordion.open').forEach(function (openAcc) {
        openAcc.classList.remove('open');
      });

      // Toggle current
      if (!isOpen) {
        accordion.classList.add('open');
      }
    });
  });

  /* ===== Product Image Gallery ===== */
  var thumbs = document.querySelectorAll('.pd-thumb');
  var mainImage = document.getElementById('pdMainImage');

  thumbs.forEach(function (thumb) {
    thumb.addEventListener('click', function () {
      thumbs.forEach(function (t) {
        t.classList.remove('active');
      });
      this.classList.add('active');

      if (mainImage) {
        var thumbImg = this.querySelector('img');
        if (thumbImg) {
          mainImage.src = thumbImg.src.replace('_small', '_big');
          mainImage.alt = thumbImg.alt;
        }
      }
    });
  });

  /* ===== Quantity +/- Buttons ===== */
  function initQuantityButtons(scope) {
    var container = scope || document;
    var qtyBtns = container.querySelectorAll('[data-action="increase"], [data-action="decrease"]');

    qtyBtns.forEach(function (btn) {
      btn.addEventListener('click', function () {
        var wrapper = this.closest('.pd-quantity, .basket-qty');
        if (!wrapper) return;

        var input = wrapper.querySelector('input[type="number"]');
        if (!input) return;

        var currentVal = parseInt(input.value, 10) || 1;
        var min = parseInt(input.min, 10) || 1;
        var max = parseInt(input.max, 10) || 99;

        if (this.dataset.action === 'increase' && currentVal < max) {
          input.value = currentVal + 1;
        } else if (this.dataset.action === 'decrease' && currentVal > min) {
          input.value = currentVal - 1;
        }

        input.dispatchEvent(new Event('change', { bubbles: true }));
      });
    });
  }

  initQuantityButtons();

  /* ===== Product Detail Color/Size Selection ===== */
  var colorSwatches = document.querySelectorAll('.pd-color-swatch');
  colorSwatches.forEach(function (swatch) {
    swatch.addEventListener('click', function () {
      colorSwatches.forEach(function (s) {
        s.classList.remove('active');
      });
      this.classList.add('active');
    });
  });

  var sizeBtns = document.querySelectorAll('.pd-size-btn');
  sizeBtns.forEach(function (btn) {
    btn.addEventListener('click', function () {
      sizeBtns.forEach(function (b) {
        b.classList.remove('active');
      });
      this.classList.add('active');
    });
  });

  /* ===== Gift Message Toggle ===== */
  var giftCheck = document.querySelector('.basket-gift-check');
  var giftTextarea = document.querySelector('.basket-gift-textarea');

  if (giftCheck && giftTextarea) {
    giftTextarea.style.display = 'none';
    giftCheck.addEventListener('change', function () {
      giftTextarea.style.display = this.checked ? 'block' : 'none';
    });
  }

  /* ===== FAQ Sidebar Category Filter ===== */
  var faqCategories = document.querySelectorAll('.faq-category');
  faqCategories.forEach(function (cat) {
    cat.addEventListener('click', function (e) {
      e.preventDefault();
      faqCategories.forEach(function (c) {
        c.classList.remove('active');
      });
      this.classList.add('active');
    });
  });

})();
