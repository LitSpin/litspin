# Systemverilog source code

## Parameters of the project

Parameters are in full caps.
* `*_NB` number of values a signal can take
* `*_WIDTH` number of bits in a signal

## Avalon interfaces

Signals must be named accordingly.
The data type can be removed if useless.
* `{data_type}_{r/w}_addr`
* `{data_type}_{r/w}_data`
* `{data_type}_{r/w}_enable`

Parameters must be named accordingly
* `{DATA_TYPE}_{R/W}_{ADDR/DATA}_WIDTH` width of the associated signal
* `{DATA_TYPE}_{R/W}_{ADDR/DATA}_NB` number of values this signal can take
