/**
* Name: Simulator
* Based on the internal empty template. 
* Author: hungtran
* Tags: 
*/


model Simulator

/* Insert your model definition here */

import './complex-pig.gaml'

global {
	file pigs;
	int speed;
	string experiment_id;
	int month <- 0;
	float temp_max;
	float temp_min;
	list<float> RH_month <- [68.65,72.73,69.9,69.9];
	float vel <- 0.2;
    init {
    	do clear_dir();
    	temp_max <-28.0;
    	temp_min <-24.0;
    	T <- rnd (temp_min,temp_max);
    	pigs <- csv_file("../includes/input/pigs.csv", true);
    	speed <- 45;
    	create RenaPig from: pigs;
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
    }
    
    reflex update_temperature when: mod(cycle, 60*24)=0 {
    	int temp_change <- flip(0.66) ? 1 : -1;
    	float temp_diff <- rnd(0.0,1.0) with_precision 2;
    	T <- T + temp_change*temp_diff;
    	if (T > temp_max) {
    		T <- temp_max;
    	}
    	else if(T < temp_min) {
    		T <- temp_min;
    	}
    }
    action clear_dir {
    	bool delete_folder <- delete_file("../includes/output/rena/summer");
    	file data <- new_folder("../includes/output/summer/summer");
    }
}

experiment Summer type:gui {
	parameter "Experiment ID" var: experiment_id <- "";
	output {
		display Simulator name: "Simulator" {
            grid Background border: #white;
            species RenaPig aspect: base;
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
        	chart "Temperature daily" type: series {
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
    				pig.weight
    			] to: "../includes/output/rena/summer/" + experiment_id + "-" + string(pig.id) + ".csv" rewrite: false format: "csv";	
    		}
		}		
    }
    reflex capture when: mod(cycle, speed) = 0 {
    	ask simulations {
    		save (snapshot(self, "Simulator", {500.0, 500.0})) to: "../includes/output/rena/summer/" + experiment_id + "-simulator-" + string(cycle) + ".png";
    		save (snapshot(self, "CFI", {500.0, 500.0})) to: "../includes/output/rena/summer/" + experiment_id + "-cfi-" + string(cycle) + ".png";
    		save (snapshot(self, "Weight", {500.0, 500.0})) to: "../includes/output/rena/summer/" + experiment_id + "-weight-" + string(cycle) + ".png";
    		save (snapshot(self, "CFIPig0", {500.0, 500.0})) to: "../includes/output/rena/summer/" + experiment_id + "-cfipig0-" + string(cycle) + ".png";
    		save (snapshot(self, "DFIPig0", {500.0, 500.0})) to: "../includes/output/rena/summer/" + experiment_id + "-dfipig0-" + string(cycle) + ".png";
    	}
    }
}
