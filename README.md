# Numerical Recipes in FORTRAN 77

## Subroutines by Chapter and Section

| sect | program              | description                          | dependencies |
| ---- | -------------------- | ------------------------------------ | -------------|
|  1.0 | [`flmoon`](flmoon.f) | calculate phases of the moon by date |
|  1.1 | [`julday`](julday.f) | Julian Day number from calendar date |
|  1.1 | [`caldat`](caldat.f) | calendar date from Julian day number |

## Demonstration Programs

| sect | program                  | description                           | dependencies                 | input       |
| ---- | ------------------------ | ------------------------------------- | -----------------------------| ----------- |
|  --- | [`flmoon`](flmoon.dem.f) | calculate phases of the moon by date  | `flmoon`, `julday`, `caldat` |             |
|  --- | [`julday`](julday.dem.f) | Julian Day number from calendar date  | `julday`                     | `dates.dat` |
|  1.1 | [`badluk`](badluk.f)     | Friday the 13th when the moon is full | `flmoon`, `julday`           |             |
|  --- | [`caldat`](caldat.dem.f) | calendar date from Julian day number  | `julday`, `caldat`           | `dates.dat` |

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
