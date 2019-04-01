# Numerical Recipes in FORTRAN 77

## Subroutines by Chapter and Section

| sect | program              | description                           | dependencies |
| ---- | -------------------- | ------------------------------------  | -------------|
|  1.0 | [`flmoon`](flmoon.f) | calculate phases of the moon by date  |
|  1.1 | [`julday`](julday.f) | Julian Day number from calendar date  |
|  1.1 | [`caldat`](caldat.f) | calendar date from Julian day number  |
|  8.1 | [`piksrt`](piksrt.f) | sort an array by straight insertion   | 
|  8.1 | [`piksr2`](piksr2.f) | sort two arrays by straight insertion |

## Demonstration Programs

| sect | program                  | description                           | dependencies                 | input       |
| ---- | ------------------------ | ------------------------------------- | -----------------------------| ----------- |
|  --- | [`flmoon`](flmoon.dem.f) | calculate phases of the moon by date  | `flmoon`, `julday`, `caldat` |             |
|  --- | [`julday`](julday.dem.f) | Julian Day number from calendar date  | `julday`                     | `dates.dat` |
|  1.1 | [`badluk`](badluk.f)     | Friday the 13th when the moon is full | `flmoon`, `julday`           |             |
|  --- | [`caldat`](caldat.dem.f) | calendar date from Julian day number  | `julday`, `caldat`           | `dates.dat` |
|  --- | [`piksrt`](piksrt.dem.f) | sort an array by straight insertion   | `piksrt`                     | `tarray.dat`|
|  --- | [`piksr2`](piksr2.dem.f) | sort two arrays by straight insertion | `piksr2`                     | `tarray.dat`|

## Additional subroutines

| program                  | description                           | input       |
| ------------------------ | ------------------------------------- | ----------- |
| [`piksr3`](piksr3.f) | sort three arrays by straight insertion   | `tarray.dat`|
| [`piksr3_122`](piksr3_122.f) | sort an array and two matricies by straight insertion | `tarray.dat`|

## Installation
### Cloning
Clone the reposity with one of the following commands.

`git clone https://github.com/jonlighthall/nrf` (Git HTTPS)

`git clone git@github.com:jonlighthall/nrf.git` (Git SSH)
### Compiling
The demonstration programs can be compiled using the [`makefile`](makefile). Alternatively, the following commands my be used.
````bash
gfortran -std=legacy flmoon.dem.f flmoon.f julday.f caldat.f
gfortran -std=legacy julday.dem.f julday.f
gfortran -std=legacy badluk.f  flmoon.f julday.f piksr3_122.f
gfortran -std=legacy caldat.dem.f julday.f caldat.f

````
