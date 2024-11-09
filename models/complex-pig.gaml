/**
* Name: complexPig
* Based on the internal empty template. 
* Author: hungtran
* Tags: 
*/


model complexPig

import './pig.gaml'
import './config.gaml'

global {
	float total_space <- 10.0;
	float T <-20.0;
	float RH <- 50.0;
	float ET <- T + get_Ehum() + get_Evel();
	float vel <- 0.2;
	
	reflex get_ET when:mod(cycle,60*24)=0 {
		ET <-  T + get_Ehum() + get_Evel();
		
	}
	float get_Ehum {
		return 0.0015 * (RH-50)*T;
	}
	float get_Evel {
		return -1.0*(42-T)*(vel^0.66 - 0.2^0.66);
	}
}

species BasePig parent:Pig {	
	float target_dfi {
		float temp <- ET;
		float dfi_target <- -1264 + 117*temp - 2.4*(temp^2) + 73.6*weight - 0.26*(weight^2) -0.95*temp*weight;
		dfi_target <- (dfi_target * space_restrict()) /1000 ;
		return dfi_target;
	}
	float space_restrict {
		float space_reduce <- stocking_density()/area();
		if (space_reduce < 0.85) {
			space_reduce <- 0.95;
		}
		else if (space_reduce > 1) {
			space_reduce <- 1.0;
		}
		else {
			space_reduce <- 1 - (1-space_reduce)/3;
		}
		return space_reduce;
	}
	float dfi {
		if(eat_count = 0 and cycle > 0) {
     		return 0.0;
     	}
     	float dfi_target <- target_dfi();
		float dfi_p <- rnd(dfi_target-0.3,dfi_target+0.3);
		return dfi_p with_precision 2;
		
	}
	float stocking_density {
		float space <- total_space;
		int pig_number <- count_pig();
		return space/pig_number with_precision 2;
	}
	float area {
		float temp <- ET;
		float k_value <- exp((-0.6064)*((1/65)^0.6832)*e^(0.0044*temp));
		return k_value * (weight^0.6832);
	}
	// get up critical temperature for thermal zone
	float get_CT {
		return 40.9 - 4.4*ln(1+weight);
		
	}
	
	// get low critical temperature 
	float get_LCT {
		return 37.254 - 5.867*ln(weight);
	}
	int count_pig {
		return length(species(BasePig).subspecies);
	}
	
	float get_init_weight {
		return rnd(35.0,40.0) with_precision 2;
	}
 }

species QuiPig parent: BasePig {
	float target_dfi {
		float temp <- ET;
		float dfi_target <- -1264 + 117*temp - 2.4*(temp^2) + 73.6*weight - 0.26*(weight^2) -0.95*temp*weight;
		dfi_target <- (dfi_target * space_restrict()) /1000 ;
		return dfi_target;
	}
	
//	int count_pig {
//		return length(QuiSummerPig) + length(QuiAutumnPig);
//		return length(QuiPig);
//	}
}
species RenaPig parent: BasePig {
	float target_dfi {
		float temp <- ET;
		float temp_diff <- ET - get_CT();
		float a_temp <- 140 - 3.42*ln(1+exp(temp_diff));
		float dfi_target <- a_temp*(weight^0.69) / 1000;
		return dfi_target;
	}
//	int count_pig {
//		return length(RenaPig);
//	}
}   
species QuiSummerPig parent: QuiPig {
	float get_init_weight {
		return rnd (38.0,42.0) with_precision 2;
	}
}
species QuiAutumnPig parent: QuiPig {
	float get_init_weight {
		return rnd (36.0,40.0) with_precision 2;
	}
}
species RenaSummerPig parent: RenaPig {
	float get_init_weight {
		return rnd (38.0,42.0) with_precision 2;
	}
}
species RenaAutumnPig parent: RenaPig {
	float get_init_weight {
		return rnd (36.0,40.0) with_precision 2;
	}
}