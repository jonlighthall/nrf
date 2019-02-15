# Numerical Recipes in FORTRAN 77

## Computer Programs by Chapter and Section

| sect | program  | description                          |
| ---- | -------- | ------------------------------------ |
|  1.0 | [`flmoon`](flmoon.f) | calculate phases of the moon by date |
|  1.1 | [`julday`](julday.f) | Julian Day number from calendar date |
|  1.1 | [`badluk`](badluk.f) | Friday the 13th when the moon is full |
|  1.1 | [`caldat`](caldat.f) | calendar date from Julian day number |

## Installation
### Cloning
Clone the reposity with one of the following commands.

`git clone https://github.com/jonlighthall/nrf` (Git HTTPS)

`git clone git@github.com:jonlighthall/nrf.git` (Git SSH)
### Compiling
The demonstration programs can be compiled with the following commands.
````bash
gfortran -std=legacy flmoon.dem.f flmoon.f julday.f caldat.f
gfortran -std=legacy julday.dem.f julday.f
gfortran -std=legacy badluk.f  flmoon.f julday.f
gfortran -std=legacy caldat.dem.f julday.f caldat.f

````