namespace main;

using { cuid, managed } from '@sap/cds/common';

entity Rooms : cuid, managed {
  @title: '{i18n>Rooms-code}'
  code         : String(20)  @mandatory; 
  @title: '{i18n>Rooms-name}'
  name         : String(100) @mandatory; 
  @title: '{i18n>Rooms-capacity}'
  capacity     : Integer  @mandatory; 
  @title: '{i18n>Rooms-location}'
  location     : String(100) @mandatory; 
  @title: '{i18n>Rooms-equipments}'
  equipments   : Association to many Equipments on equipments.room = $self;
}

entity  Equipments : cuid, managed {
  @title: '{i18n>Equipments-type}'
  type         : String(40) @mandatory;       // e.g., "Projector", "Whiteboard"
  @title: '{i18n>Equipments-desc}'
  desc         : String(100) @mandatory;
  room         : Association to Rooms;
}

entity Reservations : cuid, managed {
  @title: '{i18n>Reservations-room}'
  room         : Association to Rooms @mandatory; 
  @title: '{i18n>Reservations-title}'
  title        : String(140) @mandatory; 
  @title: '{i18n>Reservations-startAt}'
  startAt      : Timestamp @mandatory;      
  @title: '{i18n>Reservations-endAt}'   
  endAt        : Timestamp @mandatory; 
  @title: '{i18n>Reservations-requester}'
  requester    : String(60) @mandatory; 
  @title: '{i18n>Reservations-status}'
  //fazer readonly
  status       : String(10) default 'NEW' @mandatory;   // NEW|CONFIRMED|CANCELLED
  // Alguns campos calculados/expostas
  @title: '{i18n>Reservations-durationMinutes}'
  durationMinutes : Integer @readonly; 
}

annotate main.Reservations 
  with @Capabilities.Insertable : true
       @Capabilities.Updatable : true
       @Capabilities.Deletable : true;

