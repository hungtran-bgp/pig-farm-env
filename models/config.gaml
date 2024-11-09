/**
* Name: Config
* Author: Lê Đức Toàn
*/


model Config


global {
	float e;
	float TNZ_low;
	float TNZ_up;
	float pi;
	init {
		e <- 2.72;
		TNZ_low <- 18.0;
		TNZ_up <- 21.0;
		pi <- 3.14;
	}
}