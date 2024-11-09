/**
* Name: RankPig
* Based on the internal empty template. 
* Author: hungtran
* Tags: 
*/


model RankPig

import './complex-pig.gaml'
import './hierarchy.gaml'

/* Insert your model definition here */
species RankPig parent: BasePig{
	int dom_level <- 1;
	init {
		ask Hierarchy {
			myself.dom_level <- self.get_level(myself.id);
		}
	}
	action eat {
		ask wait_queue {
			if (myself.dom_level >= self.get_prior()) {
				break;
			}
			else {
				return;
			}
		}
		invoke eat();
	}
}
