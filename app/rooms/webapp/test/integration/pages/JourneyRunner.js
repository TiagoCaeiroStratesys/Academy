sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"rooms/test/integration/pages/RoomsList",
	"rooms/test/integration/pages/RoomsObjectPage",
	"rooms/test/integration/pages/EquipmentsObjectPage"
], function (JourneyRunner, RoomsList, RoomsObjectPage, EquipmentsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('rooms') + '/test/flpSandbox.html#rooms-tile',
        pages: {
			onTheRoomsList: RoomsList,
			onTheRoomsObjectPage: RoomsObjectPage,
			onTheEquipmentsObjectPage: EquipmentsObjectPage
        },
        async: true
    });

    return runner;
});

