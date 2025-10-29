using { main as m } from '../db/schema';

service CatalogService {
  @odata.draft.enabled
  //@Capabilities: { Insertable: true, Updatable: true, Deletable: true }
  entity Rooms as projection on m.Rooms;

  @odata.draft.enabled
  //@Capabilities: { Insertable: true, Updatable: true, Deletable: true }
  entity Equipments as projection on m.Equipments;

  @odata.draft.enabled
  //@Capabilities: { Insertable: true, Updatable: true, Deletable: true }
  entity Reservations as projection on m.Reservations;

}
