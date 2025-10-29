using { CatalogService } from './service';

annotate CatalogService.Equipments with @(UI: {
  LineItem: [
    { Value: type },
    { Value: desc }
  ],

  Facets: [
    {
      $Type: 'UI.ReferenceFacet',
      Label: '{i18n>Equipamento}',
      Target: '@UI.FieldGroup#Equipments'
    }
  ],

  FieldGroup #Equipments: {
    Data: [
      { Value: type },
      { Value: desc },
    ]
  }
});



annotate CatalogService.Reservations with @(UI: {
  LineItem: [
    { Value: title },
    { Value: startAt },
    { Value: endAt },
    { Value: requester },
    { Value: status },
    { Value: durationMinutes }
  ],

  Facets: [
    {
      $Type: 'UI.ReferenceFacet',
      Label: '{i18n>Reservations}',
      Target: '@UI.FieldGroup#Reservations'
    }
  ],

  FieldGroup #Reservations: {
    Data: [
    { Value: title },
    { Value: startAt },
    { Value: endAt },
    { Value: requester },
    { Value: status },
    { Value: durationMinutes }
    ]
  }
});