/**
* Name: Simulator
* Based on the internal empty template. 
* Author: hungtran
* Tags: 
*/


model Simulator

/* Insert your model definition here */

import './complex-pig.gaml'
import './hierarchy.gaml'
global {
	file pigs;
	int speed;
	string experiment_id;
	int month <- 0;
	float temp_max;
	float temp_min;
	float RH_max <- 85.0;
	float RH_min <- 75.0;
	float total_space <- 12.0;
	float vel <- 0.15;
    init {
    	do clear_dir();
    	temp_max <-28.0;
    	temp_min <-24.0;
    	T <- rnd (temp_min,temp_max);
    	pigs <- csv_file("../includes/input/pigs.csv", true);
    	speed <- 45;
    	create Hierarchy number:1;
    	create wait_queue number:1;
    	create RenaPig from: pigs;
        create Trough number: 5;
        loop i from: 0 to: 4 {
        	Trough[i].location <- trough_locs[i];
        }
    }
    
    
    reflex stop when: cycle = 60 * 24 * 90 {
    	do pause;
    }
    
 
    
    reflex update_climate when: mod(cycle, 60*24)=0 {
    	int T_increase <- flip(0.5) ? 1 : -1;
    	float T_change <- rnd(0.0,1.0) with_precision 2;
    	T <- T + T_increase*T_change;
    	if (T > temp_max) {
    		T <- temp_max;
    	}
    	else if(T < temp_min) {
    		T <- temp_min;
    	}
    	RH <- get_rnd_RH();
    	vel <- rnd(0.1,0.2) with_precision 2;
    }
    float get_rnd_RH {
    	int RH_increase <- flip(0.5) ? 1: -1;
    	float RH_change <- rnd(0.0,3.0);
    	float rh <- RH + RH_increase*RH_change;
    	if (rh > RH_max) {
    		rh <- RH_max;
    	}
    	else if(rh < RH_min) {
    		rh <- RH_min;
    	}
    	return rh with_precision 2;
    }
    int get_current_day {
    	return int(cycle / (60*24));
    }
    action clear_dir {
    	bool delete_folder <- delete_file("../includes/output/vn_rena/summer/"+experiment_id);
    	file data <- new_folder("../includes/output/vn_rena/summer/"+experiment_id);
    }
}

experiment RS_VN type:gui {
	parameter "Experiment ID" var: experiment_id <- "9";
	output {
		display Simulator name: "Simulator" {
            grid Background;
            species RenaPig aspect: base;
            overlay position: {2, 2} size: {10, 5} background: #black transparency: 1 {
				draw "Day: " + get_current_day() at: {0, 2} color: #black font: font("Arial", 14, #plain);
				
				draw "Temperature: " + T with_precision 2 at: {1, 35} 
					color: #black font: font("Arial", 14, #plain);
					
				draw "Relative Humidity: " + RH with_precision 2 at: {1, 65} 
					color: rgb(255, 150, 0) font: font("Arial", 14, #plain);
					
				draw "Air Velocity: " + vel with_precision 2 at: {1, 95} 
					color: #red font: font("Arial", 14, #plain);
					
				draw "ET: " + ET with_precision 2 at: {1, 125} 
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
        		loop pig over: RenaPig {
        			data string(pig.id) value: pig.cfi;
        		}
        	}
        }
        display Weight name: "Weight" refresh: every((60 * 24)#cycles) {
        	chart "Weight" type: histogram {
        		loop pig over: RenaPig {
        			data string(pig.id) value: pig.weight;
        		}
        	}
        }
        display CFIPig0 name: "CFIPig0" refresh: every((60 * 24)#cycles) {
        	chart "CFI vs Target CFI" type: series {
        		data 'CFI' value: RenaPig[0].cfi;
        		data 'Target CFI' value: RenaPig[0].target_cfi;
        	}
        }
        display DFIPig0 name: "DFIPig0" refresh: every((60 * 24)#cycles) {
        	chart "DFI vs Target DFI" type: series {
        		data 'DFI' value: RenaPig[0].dfi;
        		data 'Target DFI' value: RenaPig[0].target_dfi;
        	}
        }
        display Temperature name: "Temperature" refresh: every((60 * 24)#cycles) {
        	chart "Effective temperature" type: series {
        		data 'temperature' value: ET;
        	}
        }
	}
	reflex log when: mod(cycle, 24 * 60) = 0 {
    	ask simulations {
    		loop pig over: RenaPig {
    			save [
    				floor(cycle / (24 * 60)),
    				pig.id,
    				pig.target_dfi,
    				pig.dfi,
    				pig.target_cfi,
    				pig.cfi,
    				pig.weight,
    				ET
    			] to: "../includes/output/vn_rena/summer/" + experiment_id + "/" + string(pig.id) + ".csv" rewrite: false format: "csv";	
    		}
		}		
    }
//    reflex capture when: mod(cycle, speed) = 0 {
//    	ask simulations {
//    		save (snapshot(self, "Simulator", {500.0, 500.0})) to: "../includes/output/rena/summer/" + experiment_id + "-simulator-" + string(cycle) + ".png";
//    		save (snapshot(self, "CFI", {500.0, 500.0})) to: "../includes/output/rena/summer/" + experiment_id + "-cfi-" + string(cycle) + ".png";
//    		save (snapshot(self, "Weight", {500.0, 500.0})) to: "../includes/output/rena/summer/" + experiment_id + "-weight-" + string(cycle) + ".png";
//    		save (snapshot(self, "CFIPig0", {500.0, 500.0})) to: "../includes/output/rena/summer/" + experiment_id + "-cfipig0-" + string(cycle) + ".png";
//    		save (snapshot(self, "DFIPig0", {500.0, 500.0})) to: "../includes/output/rena/summer/" + experiment_id + "-dfipig0-" + string(cycle) + ".png";
//    	}
//    }
}
