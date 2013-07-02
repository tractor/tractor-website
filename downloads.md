# Downloads

<div id="download-box">
  <p class="first">The latest version of TractoR is <span id="version"><!--LATEST--></span>.</p>
  <img src="download.png" alt="Download icon" />
  <p>Download <a href="#" onClick="_gaq.push(['_trackEvent', 'Downloads', 'Downloaded', 'tarball']); window.location.href='http://www.tractor-mri.org.uk/tractor.tar.gz'">tractor.tar.gz</a> or <a href="#" onClick="_gaq.push(['_trackEvent', 'Downloads', 'Downloaded', 'zipball']); window.location.href='http://www.tractor-mri.org.uk/tractor.zip'">tractor.zip</a>.</p>
</div>

Full source code is included in the download. TractoR is developed according to good software engineering practice, and release numbering follows a clear and consistent pattern:
  
- Point releases, e.g. from version 1.0.0 to 1.0.1, are for bug fixes and minor tweaks to existing functionality. They should be completely backwards-compatible, and are released as needed.
- Minor releases, e.g. from version 1.0.x to 1.1.0, add new features without fundamentally changing the behaviour of the package's user-visible functions. Substantial effort is made to keep them backwards-compatible, including keeping default behaviour the same, and any deviation from this is explicitly documented in the [changelog](changelog.html). Such releases are typically made every few months.
- Major releases, e.g. from version 1.x.0 to 2.0.0, may include changes which are incompatible with older versions, including different default behaviour, or substantial modifications to the architecture of the package. These are relatively rare: the time between the release of versions 1.0.0 and 2.0.0 was two-and-a-half years.

Earlier released versions of TractoR are available from the project's [GitHub pages](https://github.com/jonclayden/tractor/tags). The very latest version of the code is also available [through GitHub](https://github.com/jonclayden/tractor).

Users who prefer to access the source repository using Git can clone the project using the command

    git clone --recursive git://github.com/jonclayden/tractor.git

Alternatively, the project can be forked on [GitHub](https://github.com/jonclayden/tractor).
