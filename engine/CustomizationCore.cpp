// [Goal: Enable deep interior customization for Pragmata & Windrose]
void InitializeInteriorCell(ShipID vessel) {
    if (vessel.hasInterior) {
        LoadAssets("Interior_Living_Quarters");
        EnableFurnitureSnapping(true); 
        // Logic: Allows players to place items like in Valheim/Enshrouded
    }
}
