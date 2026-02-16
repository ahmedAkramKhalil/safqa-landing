/**
 * Safqa Language Toggle
 * Handles switching between Arabic and English versions
 */

(function() {
    'use strict';

    // Get language from URL or localStorage
    function getCurrentLanguage() {
        const urlParams = new URLSearchParams(window.location.search);
        const urlLang = urlParams.get('lang');

        if (urlLang === 'ar' || urlLang === 'en') {
            localStorage.setItem('safqa_lang', urlLang);
            return urlLang;
        }

        return localStorage.getItem('safqa_lang') || 'ar';
    }

    // Set language
    function setLanguage(lang) {
        localStorage.setItem('safqa_lang', lang);

        // Reload page with language parameter
        const currentPath = window.location.pathname;
        const currentHash = window.location.hash;

        window.location.href = currentPath + '?lang=' + lang + currentHash;
    }

    // Initialize on page load
    document.addEventListener('DOMContentLoaded', function() {
        const currentLang = getCurrentLanguage();

        // Set HTML attributes
        const html = document.documentElement;
        if (currentLang === 'ar') {
            html.setAttribute('lang', 'ar');
            html.setAttribute('dir', 'rtl');
        } else {
            html.setAttribute('lang', 'en');
            html.setAttribute('dir', 'ltr');
        }

        // Update active state on language switcher
        document.querySelectorAll('.lang-switcher a').forEach(function(link) {
            link.classList.remove('active');
            if (link.getAttribute('data-lang') === currentLang) {
                link.classList.add('active');
            }
        });

        // Add click handlers to language switcher
        document.querySelectorAll('.lang-switcher a').forEach(function(link) {
            link.addEventListener('click', function(e) {
                e.preventDefault();
                const lang = this.getAttribute('data-lang');
                if (lang && lang !== currentLang) {
                    setLanguage(lang);
                }
            });
        });

        // Show/hide content based on language
        document.querySelectorAll('[data-lang-content]').forEach(function(element) {
            const elementLang = element.getAttribute('data-lang-content');
            if (elementLang === currentLang) {
                element.style.display = '';
            } else {
                element.style.display = 'none';
            }
        });
    });
})();
