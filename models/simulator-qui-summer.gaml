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
	list temperature_month <- [[19.0,21.0],[24.0,26.0],[24.0,26.0],[26.0,26.0]];
	list<float> RH_month <- [68.65,72.73,69.9,69.9];
	list<float> temperature_range <- [19.0,21.0];
    init {
    	do clear_dir();
    	pigs <- csv_file("../includes/input/pigs.csv", true);
    	speed <- 45;
    	create QuiPig from: pigs;
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
    	T <- rnd(min(temperature_range),max(temperature_range)) with_precision 2;
    }
    action clear_dir {
    	bool delete_folder <- delete_file("../includes/output/qui/summer");
    	file data <- new_folder("../includes/output/qui/summer");
    }
}

experiment Summer type:gui {
	parameter "Experiment ID" var: experiment_id <- "";
	output {
		display Simulator name: "Simulator" {
            grid Background border: #white;
            species QuiPig aspect: base;
        }
        display CFI name: "CFI" refresh: every((60 * 24)#cycles) {
        	chart "CFI" type: series {
        		loop pig over: QuiPig {
        			data string(pig.id) value: pig.cfi;
        		}
        	}
        }
        display Weight name: "Weight" refresh: every((60 * 24)#cycles) {
        	chart "Weight" type: histogram {
        		loop pig over: QuiPig {
        			data string(pig.id) value: pig.weight;
        		}
        	}
        }
        display CFIPig0 name: "CFIPig0" refresh: every((60 * 24)#cycles) {
        	chart "CFI vs Target CFI" type: series {
        		data 'CFI' value: QuiPig[0].cfi;
        		data 'Target CFI' value: QuiPig[0].target_cfi;
        	}
        }
        display DFIPig0 name: "DFIPig0" refresh: every((60 * 24)#cycles) {
        	chart "DFI vs Target DFI" type: series {
        		data 'DFI' value: QuiPig[0].dfi;
        		data 'Target DFI' value: QuiPig[0].target_dfi;
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
    		loop pig over: QuiPig {
    			save [
    				floor(cycle / (24 * 60)),
    				pig.id,
    				pig.target_dfi,
    				pig.dfi,
    				pig.target_cfi,
    				pig.cfi,
    				pig.weight
    			] to: "../includes/output/qui/summer/" + experiment_id + "-" + string(pig.id) + ".csv" rewrite: false format: "csv";	
    		}
		}		
    }
	reflex capture when: mod(cycle, speed) = 0 {
    	ask simulations {
    		save (snapshot(self, "Simulator", {500.0, 500.0})) to: "../includes/output/qui/summer/" + experiment_id + "-simulator-" + string(cycle) + ".png";
    		save (snapshot(self, "CFI", {500.0, 500.0})) to: "../includes/output/qui/summer/" + experiment_id + "-cfi-" + string(cycle) + ".png";
    		save (snapshot(self, "Weight", {500.0, 500.0})) to: "../includes/output/qui/summer/" + experiment_id + "-weight-" + string(cycle) + ".png";
    		save (snapshot(self, "CFIPig0", {500.0, 500.0})) to: "../includes/output/qui/summer/" + experiment_id + "-cfipig0-" + string(cycle) + ".png";
    		save (snapshot(self, "DFIPig0", {500.0, 500.0})) to: "../includes/output/qui/summer/" + experiment_id + "-dfipig0-" + string(cycle) + ".png";
    	}
    }
}
