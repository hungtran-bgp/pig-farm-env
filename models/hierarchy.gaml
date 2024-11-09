/**
* Name: Hierarchy
* Based on the internal empty template. 
* Author: hungtran
* Tags: 
*/


model Hierarchy

/* Insert your model definition here */
global {
    int pig_count <- 20;  // Total number of pigs
}

species Hierarchy {
    list<int> dominant <- [];
    list<int> intermediate <- [];
    list<int> subordinate <- [];

    init {
        int num_dominant <- rnd(2,4);            // Number of dominant pigs
        int num_subordinate <- rnd(2,4);         // Number of subordinate pigs

        // Assign the first few IDs to dominant pigs
		dominant <- establish_list(0,num_dominant-1);

        // Assign the last few IDs to subordinate pigs
        subordinate <- establish_list(pig_count - num_subordinate,pig_count - 1);

        // Assign remaining IDs to intermediate pigs
        intermediate <- establish_list(num_dominant,pig_count - num_subordinate - 1);
    }
	list<int> establish_list(int first, int last ) {
		list<int> rank_list <- [];
		loop i from: first to: last {
			rank_list <- rank_list+i;
		}
		return rank_list;
	}
	int get_level(int id) {
		if (dominant contains id) {
			return 3;
		}
		else if (intermediate contains id) {
			return 2;
		}
		return 1;
	}
	
    action display_hierarchy {
        write "Dominant: " + string(dominant);
        write "Intermediate: " + string(intermediate);
        write "Subordinate: " + string(subordinate);
    }
}
species wait_queue {
	list<int> dominant;
	list<int> intermediate;
	init {
		dominant <- [];
		intermediate <- [];
	}
	action update(int id, int level){
		if(level = 2) {
			intermediate <- intermediate + id;
		}
		else if(level = 3) {
			dominant <- dominant + id;
		}
	}
	int get_prior {
		if(length(dominant) > 0) {
			return 3;
		}
		else if(length(intermediate) > 0) {
			return 2;
		}
	}
	bool remove_pig(int id) {
		if (dominant contains id) {
			remove item: id from: dominant;
		}
		else if (intermediate contains id) {
			remove item: id from: intermediate;
		}
		return true;
	}
}
