___INFO___

{
  "type": "TAG",
  "id": "cvt_cookiepass_consent_v2",
  "version": 1,
  "displayName": "Cookiepass – Consent Mode v2",
  "description": "Laedt die Cookiepass-CMP und uebermittelt Entscheidungen an Google Consent Mode v2.",
  "categories": [
    "UTILITY"
  ],
  "containerContexts": [
    "WEB"
  ],
  "securityGroups": []
}

___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "cookiepassId",
    "displayName": "Cookiepass-Kunden-ID (cbid)",
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "help": "Die oeffentliche cbid der Website aus dem Cookiepass-Einbaucode, kein API-Schluessel."
  }
]

___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const injectScript = require('injectScript');
const setDefaultConsentState = require('setDefaultConsentState');
const updateConsentState = require('updateConsentState');
const callInWindow = require('callInWindow');
const setInWindow = require('setInWindow');
const createQueue = require('createQueue');
const encodeUriComponent = require('encodeUriComponent');
const templateStorage = require('templateStorage');

// Zweites Ausloesen setzt eine bestehende Entscheidung nicht auf denied zurueck.
const previous = templateStorage.getItem('cookiepass');
if (previous) {
  if (previous.id === data.cookiepassId && previous.loaded) data.gtmOnSuccess();
  else data.gtmOnFailure();
  return;
}

// Vor Netzwerkzugriff und vor der Entscheidung alles ablehnen.
setDefaultConsentState({
  ad_storage: 'denied',
  analytics_storage: 'denied',
  ad_user_data: 'denied',
  ad_personalization: 'denied',
  wait_for_update: 500
});

if (!data.cookiepassId) {
  data.gtmOnFailure();
  return;
}

const push = createQueue('dataLayer');
const onConsent = function (state) {
  state = state || {};
  // Nur explizite Freigaben durch den Cookiepass-Core akzeptieren.
  updateConsentState({
    ad_storage: state.ad_storage === 'granted' ? 'granted' : 'denied',
    analytics_storage: state.analytics_storage === 'granted' ? 'granted' : 'denied',
    ad_user_data: state.ad_user_data === 'granted' ? 'granted' : 'denied',
    ad_personalization: state.ad_personalization === 'granted' ? 'granted' : 'denied'
  });
  // Consent-Update wird im Container vor dem naechsten Data-Layer-Event verarbeitet.
  push({ event: 'cookiepass_consent_update' });
};

// Callback vor dem Laden registrieren: gespeicherte Entscheidungen gehen nicht verloren.
if (!setInWindow('cookiepassGtmConsentUpdate', onConsent, false)) {
  data.gtmOnFailure();
  return;
}
templateStorage.setItem('cookiepass', { id: data.cookiepassId, loaded: false });

const url = 'https://cdn.cookiepass.io/cp.js?cbid=' +
  encodeUriComponent(data.cookiepassId) + '&consent=gtm&blocking=manual';

injectScript(url, function () {
  // Geladenen Core pruefen; dessen Konfiguration/Consent-Updates sind asynchron.
  if (callInWindow('Cookiepass.googleConsentMode') !== 'gtm') {
    data.gtmOnFailure();
    return;
  }
  templateStorage.setItem('cookiepass', { id: data.cookiepassId, loaded: true });
  data.gtmOnSuccess();
}, data.gtmOnFailure, 'cookiepass-cmp-' + data.cookiepassId);


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "access_consent",
        "versionId": "1"
      },
      "param": [
        {
          "key": "consentTypes",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "ad_storage"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "analytics_storage"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "ad_user_data"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "ad_personalization"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "inject_script",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://cdn.cookiepass.io/cp.js?*"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "cookiepassGtmConsentUpdate"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "Cookiepass.googleConsentMode"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "dataLayer"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_template_storage",
        "versionId": "1"
      },
      "param": []
    },
    "isRequired": true
  }
]

___TESTS___

scenarios:
- name: "Defaults vor dem Laden"
  code: |-
    mock('templateStorage', {getItem: function () {}, setItem: function () {}});
    mock('setInWindow', true);
    mock('createQueue', function () { return function () {}; });
    runCode({cookiepassId: 'cb_test'});
    assertApi('setDefaultConsentState').wasCalledWith({
      ad_storage: 'denied', analytics_storage: 'denied',
      ad_user_data: 'denied', ad_personalization: 'denied', wait_for_update: 500
    });
    assertApi('injectScript').wasCalled();
- name: "Teilzustimmung und Widerruf"
  code: |-
    let callback;
    let events = [];
    mock('templateStorage', {getItem: function () {}, setItem: function () {}});
    mock('setInWindow', function (key, fn) { callback = fn; return true; });
    mock('createQueue', function () { return function (event) { events.push(event); }; });
    runCode({cookiepassId: 'cb_test'});
    callback({analytics_storage: 'granted'});
    assertApi('updateConsentState').wasCalledWith({
      ad_storage: 'denied', analytics_storage: 'granted',
      ad_user_data: 'denied', ad_personalization: 'denied'
    });
    callback({});
    assertApi('updateConsentState').wasCalledWith({
      ad_storage: 'denied', analytics_storage: 'denied',
      ad_user_data: 'denied', ad_personalization: 'denied'
    });
    assertThat(events).isEqualTo([
      {event: 'cookiepass_consent_update'}, {event: 'cookiepass_consent_update'}
    ]);
- name: "Ladefehler beendet das Tag als fehlgeschlagen"
  code: |-
    mock('templateStorage', {getItem: function () {}, setItem: function () {}});
    mock('setInWindow', true);
    mock('createQueue', function () { return function () {}; });
    mock('injectScript', function (url, success, failure) { failure(); });
    runCode({cookiepassId: 'cb_test'});
    assertApi('gtmOnFailure').wasCalled();
    assertApi('gtmOnSuccess').wasNotCalled();
- name: "Doppelausloesung setzt Consent nicht zurueck"
  code: |-
    mock('templateStorage', {
      getItem: function () { return {id: 'cb_test', loaded: true}; },
      setItem: function () {}
    });
    runCode({cookiepassId: 'cb_test'});
    assertApi('setDefaultConsentState').wasNotCalled();
    assertApi('injectScript').wasNotCalled();
    assertApi('gtmOnSuccess').wasCalled();
- name: "Ohne Kunden-ID kein Skript laden"
  code: |-
    mock('templateStorage', {getItem: function () {}, setItem: function () {}});
    runCode({cookiepassId: ''});
    assertApi('injectScript').wasNotCalled();
    assertApi('gtmOnFailure').wasCalled();

___NOTES___

Vor der Gallery-Einreichung im GTM-Editor importieren, testen und exportieren.
Trigger: Consent Initialization - All Pages, einmal pro Seite.
Benoetigt die beigefuegte Cookiepass-Core-Anpassung auf dem CDN.
