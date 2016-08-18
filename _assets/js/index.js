$(document).ready(function() {
  $('#fullpage').fullpage({
    menu: '#navbar-index',
    lockAnchors: false,
    navigation: true,
    navigationPosition: 'right',
    showActiveTooltip: false,
    slidesNavigation: true,
    slidesNavPosition: 'bottom',

    css3: true,
    scrollingSpeed: 700,
    autoScrolling: true,
    fitToSection: true,
    fitToSectionDelay: 1000,
    scrollBar: false,
    easing: 'easeInOutCubic',
    easingcss3: 'ease',
    loopBottom: false,
    loopTop: false,
    loopHorizontal: false,
    continuousVertical: false,
    scrollOverflow: false,
    scrollOverflowOptions: null,
    touchSensitivity: 15,
    normalScrollElementTouchThreshold: 5,
    bigSectionsDestination: null,

    controlArrows: false,
    verticalCentered: true,
    sectionsColor : ['#ccc', '#fff'],
    responsiveWidth: 545,
    responsiveHeight: 651,
  });
  $("#cover").hide();
});
