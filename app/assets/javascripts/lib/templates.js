// <li>
//   <div class='pf-list-top'>
//     <div class='pf-list-header'>
//       {{company}}
//       {{#products}}
//         <small>- {{products}}</small>
//       {{/products}}
//     </div>
//     <div class='pf-list-address'>
//       {{street}}<br />
//       {{zipcode}} {{city}}
//       <br />
//       {{country}}
//     </div>
//     <div class='pf-list-add'>
//       {{#telephone}}
//       <p>
//         Tel.: {{telephone}}
//       </p>
//       {{/telephone}}
//       {{#web}}
//       <p>
//         <a href='{{web}}' target='_blank'>{{web}}</a>
//       </p>
//       {{/web}}
//       {{#email}}
//       <p>
//         <a href='mailto:{{email}}'>{{email}}</a>
//       </p>
//       {{/email}}
//     </div>
//   </div>
//   <div class='pf-list-footer'>
//     <a target='_blank' href='http://maps.google.com/maps?daddr={{street}},+{{zipcode}}+{{city}},+{{country}}&hl=de&ie=UTF8'>Route hierher berechnen (Google Maps)</a>
//     {{#distance}}
//       <div class='pf-distance'>{{distance}}</div>
//     {{/distance}}
//   </div>
// </li>

  var PFListItemTemplate = '<li><div class="pf-list-top"><div class="pf-list-header">{{company}} {{#products}}<small>- {{products}}</small>{{/products}}</div>{{#street}}<div class="pf-list-address">{{street}}<br />{{zipcode}} {{city}}<br />{{country}}</div>{{/street}}<div class="pf-list-add">{{#telephone}}<p>Tel.: {{telephone}}</p>{{/telephone}}{{#web}}<p><a href="{{web}}" target="_blank">{{web}}</a></p>{{/web}}{{#email}}<p><a href="mailto:{{email}}">{{email}}</a></p>{{/email}}</div></div><div class="pf-list-footer"><a target="_blank" href="{{routeUrl}}">Route (via Google Maps)</a>{{#distance}}<div class="pf-distance">{{distance}}</div>{{/distance}}</div></li>';

  // <h4>{{company}}</h4>
  // {{#products}}
  //  <em>{{products}}</em>
  //  <br/>
  // {{/products}}
  // <p>
  //   {{street}}<br/>
  //   {{zipcode}} {{city}}
  //   <br/> {{country}}
  // </p>
  // <p>
  //   {{#telephone}}
  //     Tel.: {{telephone}} <br/>
  //   {{/telephone}}
  //   {{#web}}
  //     <a target="_blank" href="{{web}}">{{web}}</a> <br/>
  //   {{/web}}
  //   {{#email}}
  //     <a href="mailto:{{email}}">{{email}}</a>
  //   {{/email}}
  // </p>

  var PFPopupTemplate = '<h4>{{company}}</h4>{{#products}}<em>{{products}}</em><br/>{{/products}}{{#street}}<p>{{street}}<br/>{{zipcode}} {{city}}<br/> {{country}}</p>{{/street}}<p>{{#telephone}}Tel.: {{telephone}} <br/>{{/telephone}}{{#web}}<a target="_blank" href="/{{web}}">{{web}}</a> <br/>{{/web}}{{#email}}<a href="mailto:{{email}}">{{email}}</a>{{/email}}</p>';



