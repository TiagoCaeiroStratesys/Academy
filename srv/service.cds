using { main as m } from '../db/schema';

service CatalogService {

  //@Capabilities: { Insertable: true, Updatable: true, Deletable: true }
  entity Rooms as projection on m.Rooms;

  @Capabilities: { Insertable: true, Updatable: true, Deletable: true }
  entity Equipments as projection on m.Equipments;

  @Capabilities: { Insertable: true, Updatable: true, Deletable: true }
  entity Reservations as projection on m.Reservations;

}
