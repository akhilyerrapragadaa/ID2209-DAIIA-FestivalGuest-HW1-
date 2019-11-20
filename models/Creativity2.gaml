/***
* Name: modelhomework1
* Author: Gunnar
* Description: 
* Tags: Tag1, Tag2, TagN
***/

model badagents1


/* Insert your model definition here */

//characteristics of our world
global {
	int number_of_people <- 10;
	int number_of_informationcenters <- 1;
	int number_of_secgards <-2;
	int killdistance <- 10;
	
	
	init {
		create FestivalGuest number:number_of_people;
				
		create SecurityGuard number:1
		{
			location <- {80,50,0};
			initPoint <- {80,50,0};
		}
		
		create SecurityGuard number:1
		{
			location <- {50,20,0};
			initPoint <- {50,20,0};
		}
		
		
		create InformationCenter number:number_of_informationcenters
		{
			location <- {50,50,0};
		}

		create Store number:1
		{
			location <- {10,10,0};
			drinkstore <- true;
		}
		
		create Store number:1
		{
			location <- {90,10,0};
			foodstore <- true;
		}
		
		create Store number:1
		{
			location <- {10,80,0};
			drinkstore <- true;
		}
		
		create Store number:1
		{
			location <- {90,80,0};
			foodstore <- true;
		}
				
	}
}

species FestivalGuest skills:[moving] {
	
	bool is_hungry <- false;
	bool is_thirsty <- false;
	
	bool is_bad <- false;
	bool told_neighbour_im_bad <- false;
	bool find_guard <- false;
	bool told_guard <- false;
	
	bool you_should_die <- false;
	float hungryProbability <- (rnd(0,5))/100;
	float thirstyProbability <- (rnd(0,5))/100;	
	float badProbability <- (rnd(0,5))/100;	
	int food <- 5;
	int drink <-5;
	
	agent badAgent <- nil;
	
	point initPoint <- {(rnd(0,100)),(rnd(0,100)),0};
	
	point badAgentPoint <- nil;	
	
	point targetPoint <- nil;
	
	reflex beIdle when: targetPoint = nil {
		
		if(!is_hungry and !is_thirsty and !find_guard and !is_bad)
		{
			
				if(!is_bad )
			{
				self.is_bad <- flip(badProbability);
				
			}
			
			if (!is_bad)
			{
			
			//write self.name + "says wander";
		    if(food != 0){
		    food <- food-1;	
		    }
		    if(drink != 0){
		    drink <- drink-1;	
		    }
			
			self.is_hungry <- flip(hungryProbability);
			if(!is_hungry)
			{
				self.is_thirsty <- flip(thirstyProbability);
			}
			}
			
		do wander;
		}
		
		
		if(is_hungry){
		write self.name + "is hungry";
			if(targetPoint=nil)
			{
				targetPoint <- any_location_in(one_of(InformationCenter));                
			}
		}
		
		if(is_thirsty and !is_hungry){
		write self.name + "is thirsty";
		if(targetPoint=nil)
		{
			targetPoint <- any_location_in(one_of(InformationCenter));    
		}
		}
		
		
	}
	
		reflex screamIamBad when: !told_neighbour_im_bad and is_bad
	{
		write self.name + "start scream I am BAD -----------------------------";
		list agentsNear <- (self neighbors_at 50) of_species (species (self)); // find neighbours of my own class. 
		if(length(agentsNear)>0)
		{
		FestivalGuest reporter <- one_of(agentsNear);
		write self.name + "scream I am BAD to:"+reporter;
				
		if(reporter.is_hungry=false and reporter.is_thirsty=false and reporter.is_bad=false and reporter.find_guard=false and told_guard=false)
		{
			reporter.targetPoint <- any_location_in(one_of(InformationCenter));
			reporter.find_guard <- true;    
			reporter.badAgentPoint <- self;
			write "I:"+reporter.name+"catch scream from :"+self.name+"i will go to"+reporter.badAgentPoint;
			reporter.badAgent <- self;
			self.told_neighbour_im_bad <- true;
								
		}
		
		}
		
	}
	
	
	reflex moveToTarget when: targetPoint != nil
	{
		do goto target:targetPoint;
	}
	

	
	aspect base {
		draw cube(5) color: (is_hungry) ? #blue : ((is_thirsty) ? #red : ((is_bad) ? #black : ((find_guard) ? #grey : #orange)));
	}
	
	
	
	reflex enterFoodStore when: !empty(Store at_distance 3){
		
			ask Store at_distance 3{
				
				if(myself.is_hungry and self.foodstore)
				{
			//self = FestivalGuest
			//myself = Store
			write self.name + "Welcome to the FoodStore?";
			write myself.name + "I am Hungry";
			write self.name + "Here you get some food.";
			myself.food <- 5;
			myself.is_hungry <- false;
			myself.targetPoint <- myself.initPoint;
			}
			}
		
	}
	
	reflex enterSecurityGuard when: !empty(SecurityGuard at_distance 6) and !self.told_guard and self.find_guard and (targetPoint!=badAgentPoint) and (!is_bad){
		
			write self.name + "Enter Securityguard";
		
			ask SecurityGuard at_distance 6{
			write self.name + "Distance 6";				
				
				if(!self.is_busy) //and targetpoint???
				{
			//self = FestivalGuest
			//myself = Store
			write self.name + "Hello i am secuirity guard";
			write myself.name + "Follow me to bad agent";
			self.is_busy <- true;
			self.targetPoint <- myself.badAgentPoint;
			myself.targetPoint <- myself.badAgentPoint;
			self.been_told <- true;
			myself.told_guard <- true;
			
			
			}
			
			}		
		
	}
	
	reflex afterSecurityGuard when: (self.told_guard) and (targetPoint!=nil){
				
				if((distance_to(self,targetPoint)<killdistance) and targetPoint=badAgentPoint and dead(self.badAgent))
				{
				write self.name + "I am leaving securityguard now";	
				self.find_guard <- false;
				self.badAgentPoint <- nil;	
				self.badAgent <- nil;
				self.told_guard <- false;	
				self.targetPoint <- self.initPoint;
				}
				
				
				
		
	}
	
		reflex enterDrinkStore when: !empty(Store at_distance 3){
		
			ask Store at_distance 3 {
				
			if(myself.is_thirsty and self.drinkstore)
				{
				
			//self = FestivalGuest
			//myself = Store
			write self.name + "Welcome to the Drinkstore?";
			write myself.name + "I am Thirsty";
			write self.name + "Here you get some drinks.";
			myself.is_thirsty <- false;
			myself.drink <- 5;
			myself.targetPoint <- myself.initPoint;
			}
			
			}
					
		
	}

	
		reflex setRandomPointToNil when: distance_to(self,initPoint)<1{
			if(targetPoint=initPoint){
			write self.name + "At initpoint";
			self.targetPoint <- nil;
			}
			
		}
		
		reflex get_killed when: you_should_die{
			do die;
		}
	
	
		
}

species SecurityGuard skills:[moving] {

	bool is_busy <- false;
	bool been_told <- false;

	
	point initPoint <- nil;
	
	point targetPoint <- nil;
	
	reflex beIdle when: targetPoint = nil {
		//write self.name + "distance: "+distance_to(self,initPoint);
		
		if(!is_busy)
		{
			//write self.name + "says wander";
			//do wander;
		}
		
		
		
	}
	
	reflex moveToTarget when: targetPoint != nil
	{
		//write self.name + "moveToTarget function:"+targetPoint;
		do goto target:targetPoint;
		
	}
	

	
	aspect base {
		draw cube(8) color: #black;
	}
	
	
	
	reflex killBadAgent when: !empty(FestivalGuest at_distance killdistance) and is_busy {
		
		if (distance_to(self,targetPoint)<killdistance and is_busy)
		{
			
			ask FestivalGuest at_distance killdistance {
				//write "ask FestivalGuest Killing agent"+FestivalGuest.name;
				
				if(self.is_bad)
				{
					write "Killing agent";
					self.you_should_die <- true;
					myself.targetPoint <- myself.initPoint;
					myself.been_told <- false;
				
				}
			}

					
		}		
	}
	
	
		reflex backToInitPoint when: ((distance_to(self,initPoint)<5) and is_busy){
			 if(!been_told)
			 {
			write self.name + "At initpoint";
			self.targetPoint <- nil;
			self.is_busy <- false;
			}
			
		}
		
}

species InformationCenter{
	
	int info_range <- 3; //ask if smaller or equal	
		

	//at distance returns a list of people
	reflex redirect when: !empty(FestivalGuest at_distance info_range){
		ask FestivalGuest at_distance info_range {
			//self = FestivalGuest
			//myself = InformationCenter
			write myself.name + "Welcome to the center. Are you hungry or thirsty? or Want to report?";
			
			if (self.is_hungry){
				write self.name + "I am hungry";
				point testpoint2 <- any_location_in(one_of(Store where (each.foodstore=true)));	
				self.targetPoint <- testpoint2;
				write myself.name + "Okay "+self.name+" "+"Then you should go to "+" "+testpoint2;
			}
			
				if (self.is_thirsty){
				write self.name + "I am thirsty";
				point testpoint2 <- any_location_in(one_of(Store where (each.drinkstore=true)));	
				self.targetPoint <- testpoint2;
				write myself.name + "Okay "+self.name+" "+"Then you should go to "+" "+testpoint2;
			}
			
				if (self.find_guard){
				write self.name + "I want to report ";
				point testpoint3 <- {999,999,999}; 
				point testpoint2 <- any_location_in(one_of(SecurityGuard where (each.is_busy=false)));	
				
				if(testpoint2 != testpoint3)
				{
					self.targetPoint <- testpoint2;
					write myself.name + "Okay "+self.name+" "+"Then you should go to "+" "+testpoint2;
				}		
				else
				{
					write "is null";	
				}
			}
			
		}
	} 
	
		aspect base {
		draw pyramid(8) color: #yellow depth:10;
	}
	
	
}

species Store{
	int info_range <- 3; //ask if smaller or equal	
	int totalfood <- 50;
	int totaldrinks <- 50;
	bool foodstore <- false;
	bool drinkstore <- false;
	 
	
		aspect base {
		draw rectangle(10,5) color: (foodstore) ? #purple : #green depth:5;
	}
	
	
}

//define species that will populate our world
//inputs and outputs of our simulation

experiment my_experiment type:gui {

	output {
		display my_display type:opengl {
			species FestivalGuest aspect:base;
			species InformationCenter aspect:base;	
			species Store aspect:base;	
			species SecurityGuard aspect:base;
			}
				
		}
	}
