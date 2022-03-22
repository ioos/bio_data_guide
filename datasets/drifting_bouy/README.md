Dataset from Taiki Sakai at the 2022 BioData Mobilization Workshop.

This dataset is a set of drifting bouys.
Each bouy deployment is treated as an event with a path.
The bouy collects occurrence data from acoustic data recorded along the path recorded by a GPS tracker.

The event Lat/Lon should be the center, and footprintWKT can be used for the full path of the bouy.
The [OBIS maptool](https://obis.org/maptool/) can be helpful here.

In order to script production of the footprint you can use a library or manually convert your GPS data into WKT such that it resembles something like: `LINESTRING (-67.85156 52.90890, -43.94531 45.33670, -27.07031 56.75272)`.

As described this dataset is Event-core using the Occurrence and Location extensions.
