namespace main;

using { cuid, managed } from '@sap/cds/common';

entity Rooms : cuid, managed {
  code         : String(20) @title:'Room Code';
  name         : String(100);
  capacity     : Integer @title:'Capacity';
  location     : String(100);
  // Ex: A room can have many equipments
  equipments   : Association to many Equipments on equipments.room = $self;
}

entity  Equipments : cuid, managed {
  type         : String(40);        // e.g., "Projector", "Whiteboard"
  desc         : String(100);
  room         : Association to Rooms;
}

entity Reservations : cuid, managed {
  room         : Association to Rooms;
  title        : String(140);
  startAt      : Timestamp;         // ISO time
  endAt        : Timestamp;
  requester    : String(60);
  status       : String(10) default 'NEW';  // NEW|CONFIRMED|CANCELLED
  // Alguns campos calculados/expostas
  @readonly durationMinutes : Integer;
}

annotate main.Reservations 
  with @Capabilities.Insertable : true
       @Capabilities.Updatable : false
       @Capabilities.Deletable : true;

