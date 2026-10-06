# Cookiepass CMP – Google Consent Mode v2 Template for Google Tag Manager

**English** · [Deutsch](README.de.md)

[Cookiepass](https://cookiepass.io/) is a Consent Management Platform (CMP)
for cookie banners and website consent management. This Google Tag Manager
(GTM) template connects visitors' Cookiepass choices to **Google Consent Mode v2**
for compatible Google Analytics 4 (GA4) and Google Ads tags.

The template loads the Cookiepass CMP script, initializes denied consent
defaults, and handles full acceptance, custom choices, saved preferences,
and consent withdrawal. The Consent Mode feature must be available in your
Cookiepass plan.

- [Cookiepass CMP and cookie banners](https://cookiepass.io/)
- [Download the GTM template](template.tpl)
- [Report an issue or ask a question](https://github.com/businessLNU/cookiepass-gtm/issues)
- [Installation guide in German](README.de.md)

## Google Consent Mode v2 integration features

- Native GTM consent APIs: `setDefaultConsentState` and `updateConsentState`.
- Four Google consent states denied by default, with a 500 ms update wait.
- Separate analytics and advertising consent, including withdrawal.
- The `cookiepass_consent_update` data layer event for custom GTM triggers.
- A public website ID as the only configuration field; no API key required.
- An embedded Cookiepass icon: 180 × 180 PNG, smaller than 50 kB.
- One initialization per page, preserving any existing consent decision.

## Release and validation status

The compatible Cookiepass core has been available on the CDN since October 6,
2026. Isolated browser checks using the public CDN script and all five local
template test cases have passed. All five tests have also passed in the GTM
Template Editor. The Tag Assistant check identified a missing read permission
for the consent callback; this version grants read and write access to that
specific callback. The template includes the accepted Gallery terms.
With this fix, Tag Assistant shows no permission errors and the Cookiepass bridge runs in GTM mode (checked on 6 October 2026).

This repository contains a template prepared for submission. Gallery inclusion
and Google CMP certification have not been granted as part of this work.

## Install Cookiepass in Google Tag Manager

1. Add your website in Cookiepass and obtain its public `cbid` from the
   installation snippet. The compatible CMP script is served at
   `https://cdn.cookiepass.io/cp.js`.
2. In your **web container**, open **Templates → Tag Templates → New**.
   Select **More Actions → Import** and choose `template.tpl`. Run the tests
   in the **Tests** tab and save the template.
3. Create a tag using this template. Enter your public website ID in
   **Cookiepass website ID (cbid)**. This is the `data-cbid` value from the
   Cookiepass installation snippet, not an API key.
4. Use **Consent Initialization – All Pages** and configure the tag to fire
   once per page. The CMP tag must not require additional consent to run:
   it needs to initialize the consent state before visitors make a choice.
5. Remove the previous direct Cookiepass script when switching to this GTM
   installation. Use either the direct installation or the GTM template;
   do not load both on the same page.
6. In preview mode, test a first visit, rejection, partial acceptance, full
   acceptance, withdrawal, and a page reload. Check the **Consent** tab in
   Tag Assistant and the `cookiepass_consent_update` event.

The default values for `ad_storage`, `analytics_storage`, `ad_user_data`, and
`ad_personalization` are `denied`; `wait_for_update` is 500 milliseconds.
Consent updates use the native GTM sandbox APIs. Saved decisions and new
banner choices use the same callback, registered before the script loads.
Existing Cookiepass plan restrictions still apply. When the Consent Mode
feature is disabled, the default consent state remains in place.

## Consent categories for GA4 and Google Ads

| Cookiepass category | Google Consent Mode v2 state | Granted when |
| --- | --- | --- |
| Statistics (`statistics`) | `analytics_storage` | The visitor accepts statistics |
| Marketing (`marketing`) | `ad_storage` | The visitor accepts marketing |
| Marketing (`marketing`) | `ad_user_data` | The visitor accepts marketing |
| Marketing (`marketing`) | `ad_personalization` | The visitor accepts marketing |

Rejection or withdrawal sets the corresponding states back to `denied`.
The CMP tag runs before a consent decision to establish the initial state.

The GTM integration loads the core asynchronously in manual blocking mode.
Tags in the container must use their built-in or additional consent checks
as appropriate. Scripts outside the container that have already executed
cannot be blocked retroactively by this later GTM installation.

## Template permissions

| API or resource | Access |
| --- | --- |
| Consent | Write the four consent states listed above |
| Script injection | Only `https://cdn.cookiepass.io/cp.js?*` |
| `cookiepassGtmConsentUpdate` | Read and write the consent callback |
| `Cookiepass.googleConsentMode` | Execute the integration mode check |
| `dataLayer` | Read and write for `createQueue` |
| Template storage | Store the per-page initialization status |

## Submit to the GTM Community Template Gallery

1. Import the template into the GTM Template Editor, run the included tests,
   and verify the integration using Tag Assistant. Read and accept the Gallery
   terms as the operator in the **Info** tab. Export the final version as
   `template.tpl`; keep the `UTILITY` category.
2. Use a public GitHub repository with exactly one `template.tpl`, along with
   `metadata.yaml`, `LICENSE` (Apache 2.0), and `README.md` at the root of the
   `main` branch. The additional `README.de.md` provides German documentation.
   Enable GitHub Issues and repository notifications.
3. Commit the final template and obtain its full 40-character commit SHA,
   for example with `git rev-parse HEAD`.
4. Set the documentation URL and version SHA in `metadata.yaml`, then commit
   that metadata change separately. The SHA must identify the commit containing
   the template you intend to release. If you change or re-export the template,
   update the SHA to reference its new commit.
5. Push the repository. Open [the Community Template Gallery](https://tagmanager.google.com/gallery)
   and choose **Submit Template** from the menu. Submit the repository URL:
   `https://github.com/businessLNU/cookiepass-gtm`.
6. For later releases, add the new version SHA and release notes at the top of
   `versions`, retaining previously published versions.

The documented submission process uses the Gallery form and a GitHub repository.
It does not require a pull request to a Google Cloud repository. The bundled metadata references the verified final template commit. Check
that the public `metadata.yaml` uses this SHA before submission. A metadata-only
commit does not change the template version SHA.

## Frequently asked questions

### Do I need to change my existing Cookiepass installation?

When switching to this template, replace the direct installation with the GTM
tag. Websites continuing to use the direct head installation can keep it.
Do not load the CMP through both installation methods at once.

### Can I trigger other GTM tags when consent changes?

Yes. Create a Custom Event trigger for `cookiepass_consent_update`. The tags
triggered by this event must still use the consent checks appropriate to their
purpose.

### Does the template change the cookie banner language?

The template's English labels and documentation are separate from the
Cookiepass banner's language configuration. The integration does not override
the banner language.

### Is the entire Cookiepass platform open source?

This repository provides the GTM integration under [Apache 2.0](LICENSE).
The template loads the CMP core from the Cookiepass CDN. Cookiepass backend
source code is not included in this repository.

## Support and issue reports

For template issues, [open a GitHub issue](https://github.com/businessLNU/cookiepass-gtm/issues)
with the template version, browser, and consent steps affected. For product
information, visit [Cookiepass](https://cookiepass.io/).

## Official Google documentation

- [Consent APIs and execution order](https://developers.google.com/tag-platform/tag-manager/templates/consent-apis)
- [Sandbox APIs](https://developers.google.com/tag-platform/tag-manager/templates/api)
- [Template permissions](https://developers.google.com/tag-platform/tag-manager/templates/permissions)
- [Gallery submission](https://developers.google.com/tag-platform/tag-manager/templates/gallery)
