/**
* Name: Simulator
* Based on the internal empty template. 
* Author: hungtran
* Tags: 
*/


model Simulator

/* Insert your model definition here */

import "./complex-pig.gaml"
import "./hierarchy.gaml"
global {
	file pigs;
	int speed;
	string experiment_id;
	int month <- 0;
	list temperature_month <- [[19.0,21.0],[24.0,26.0],[24.0,26.0],[26.0,26.0]];
	list<float> RH_month <- [68.65,72.73,69.9,69.9];
	list<float> temperature_range <- [19.0,21.0];
	float total_space <- 12.0;
	float vel <- 0.15;
    init {
    	do clear_dir();
    	pigs <- csv_file("../includes/input/pigs.csv", true);
    	speed <- 45;
    	create Hierarchy number:1;
    	create wait_queue number:1;
    	create QuiSummerPig from: pigs;
        create Trough number: 5;
        loop i from: 0 to: 4 {
        	Trough[i].location <- trough_locs[i];
        }
    }
    
    
    reflex stop when: cycle = 60 * 24 * 90 {
    	do pause;
    }
    
    reflex update_month when: mod(cycle, 60*24*30)=0 {
    	if (cycle = 0) {
    		month <- 0;
    	}
    	else {
    		month <- month + 1;
    	}
    	RH <- RH_month at month;
    	temperature_range <- temperature_month at month;
    	write(temperature_range);
    }
    
    reflex update_temperature when: mod(cycle, 60*24)=0 {
    	int temp_change <- flip(0.5) ? 1 : -1;
    	float temp_diff <- rnd(0.0,1.0) with_precision 2;
    	T <- T + temp_change*temp_diff;
    	float temp_max <- max(temperature_range);
    	float temp_min <- min(temperature_range);
    	if (T > temp_max) {
    		T <- temp_max;
    	}
    	else if(T < temp_min) {
    		T <- temp_min;
    	}
    	vel <- rnd(0.1,0.2) with_precision 2;
    }
    action clear_dir {
    	bool delete_folder <- delete_file("../includes/output/qui/summer_restrict/" + experiment_id);
    	file data <- new_folder("../includes/output/qui/summer_restrict/" + experiment_id);
    }
    int get_current_day {
    	return int(cycle / (60*24));
    }
}

experiment QS_restrict type:gui {
	parameter "Experiment ID" var: experiment_id <- "9";
	output {
		display Simulator name: "Simulator" {
            grid Background;
            species QuiSummerPig aspect: base;
            overlay position: {2, 2} size: {10, 5} background: #black transparency: 1 {
				draw "Day: " + get_current_day() at: {0, 2} color: #black font: font("Arial", 14, #plain);
				
				draw "Temperature: " + T at: {1, 35} 
					color: #black font: font("Arial", 14, #plain);
					
				draw "Relative Humidity: " + RH at: {1, 65} 
					color: rgb(255, 150, 0) font: font("Arial", 14, #plain);
					
				draw "Air Velocity: " + vel at: {1, 95} 
					color: #red font: font("Arial", 14, #plain);
					
				draw "ET: " + ET at: {1, 125} 
					color: #green font: font("Arial", 14, #plain);
//					
//				draw "Dead: " + dead_pig_count at: {1, 155} 
//					color: #gray font: font("Arial", 14, #plain);
//					
//				if (infected_pig_count > 0 or exposed_pig_count > 0) {
//					draw "DISEASE DETECTED!" at: {2, 185} color: #red font: font("Arial", 12, #bold);
//				}
			}
        }
        display CFI name: "CFI" refresh: every((60 * 24)#cycles) {
        	chart "CFI" type: series {
        		loop pig over: QuiSummerPig {
        			data string(pig.id) value: pig.cfi;
        		}
        	}
        }
        display Weight name: "Weight" refresh: every((60 * 24)#cycles) {
        	chart "Weight" type: histogram {
        		loop pig over: QuiSummerPig {
        			data string(pig.id) value: pig.weight;
        		}
        	}
        }
        display CFIPig0 name: "CFIPig0" refresh: every((60 * 24)#cycles) {
        	chart "CFI vs Target CFI" type: series {
        		data 'CFI' value: QuiSummerPig[0].cfi;
        		data 'Target CFI' value: QuiSummerPig[0].target_cfi;
        	}
        }
        display DFIPig0 name: "DFIPig0" refresh: every((60 * 24)#cycles) {
        	chart "DFI vs Target DFI" type: series {
        		data 'DFI' value: QuiSummerPig[0].dfi;
        		data 'Target DFI' value: QuiSummerPig[0].target_dfi;
        	}
        }
        display Temperature name: "Temperature" refresh: every((60 * 24)#cycles) {
        	chart " Effective Temperature" type: series {
        		data 'temperature' value: ET;
        	}
        }
	}
	reflex log when: mod(cycle, 24 * 60) = 0 {
    	ask simulations {
    		loop pig over: QuiSummerPig {
    			save [
    				floor(cycle / (24 * 60)),
    				pig.id,
    				pig.target_dfi,
    				pig.dfi,
    				pig.target_cfi,
    				pig.cfi,
    				pig.weight,
    				ET
    			] to: "../includes/output/qui/summer_restrict/" + experiment_id + "/" + string(pig.id) + ".csv" rewrite: false format: "csv";	
    		}
		}		
    }
//	reflex capture when: mod(cycle, speed) = 0 {
//    	ask simulations {
//    		save (snapshot(self, "Simulator", {500.0, 500.0})) to: "../includes/output/qui/summer/" + experiment_id + "-simulator-" + string(cycle) + ".png";
//    		save (snapshot(self, "CFI", {500.0, 500.0})) to: "../includes/output/qui/summer/" + experiment_id + "-cfi-" + string(cycle) + ".png";
//    		save (snapshot(self, "Weight", {500.0, 500.0})) to: "../includes/output/qui/summer/" + experiment_id + "-weight-" + string(cycle) + ".png";
//    		save (snapshot(self, "CFIPig0", {500.0, 500.0})) to: "../includes/output/qui/summer/" + experiment_id + "-cfipig0-" + string(cycle) + ".png";
//    		save (snapshot(self, "DFIPig0", {500.0, 500.0})) to: "../includes/output/qui/summer/" + experiment_id + "-dfipig0-" + string(cycle) + ".png";
//    	}
//    }
}
