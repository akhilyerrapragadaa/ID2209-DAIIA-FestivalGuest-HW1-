/***
* Name: modelhomework1
* Author: Gunnar
* Description: 
* Tags: Tag1, Tag2, TagN
***/

model Challenge


/* Insert your model definition here */

//characteristics of our world
global {
	int number_of_people <- 10;
	int number_of_informationcenters <- 1;
	
	
	init {
		create FestivalGuest number:number_of_people;
		create InformationCenter number:number_of_informationcenters
		{
			location <- {50,50,0};
		}

		create DrinkStore number:1
		{
			location <- {10,10,0};

		}
		
		create FoodStore number:1
		{
			location <- {90,10,0};
		}
		
			create DrinkStore number:1
		{
			location <- {10,80,0};

		}
		
		create FoodStore number:1
		{
			location <- {90,80,0};
		}
				
	}
}

species FestivalGuest skills:[moving] {

	bool is_hungry <- false;
	bool is_thirsty <- false;
	float hungryProbability <- (rnd(0,5))/100;
	float thirstyProbability <- (rnd(0,5))/100;	
	int food <- 5;
	int drink <-5;
	point foodaddress <- nil ;
	point drinkaddress <- nil ;
	point myaddress <- nil;
	point myaddress2 <- nil;
	int other_agents_range <-10;
	//topology a <- ;
	float distance_counter_without_brain <- 0.0; 
	float distance_counter_with_brain <- 0.0; 
	bool calculateDistanceOnce <- false;
	bool infoCenterCalculateDistanceOnce <- false;
	
	
	
	
	
	
	point initPoint <- {(rnd(0,100)),(rnd(0,100)),0};
	
	point targetPoint <- nil;
	
	
	reflex beIdle when: targetPoint = nil {
		bool see_new_stuff <- flip(0.5);
		
		
		
		if(!is_hungry or !is_thirsty)
		{
			
			self.is_hungry <- flip(hungryProbability);
			if(!is_hungry)
			{
				self.is_thirsty <- flip(thirstyProbability);
			}
			
	 
		do wander;
		 
		}
	 	if(is_hungry and is_thirsty){
			if(targetPoint=nil and food = 0 and drink = 0)
			{
				if(foodaddress != nil and !see_new_stuff){
			//write "HELLOOOO1111";
				targetPoint <- foodaddress;
				}
				
				else{
					if(foodaddress!=nil)
					{
				write self.name + "go through infoCenter, but we have adress in memory---------------------<";
				}			
				targetPoint <- any_location_in(one_of(InformationCenter));
				
				}           
			}
		} 
		
		if(is_hungry and food!=0){
			if(targetPoint=nil)
			{
				      
				food <- food-1;
		
			}
		}
		
		
		if(is_hungry and food = 0){
		if(!is_thirsty){
		//write self.name + "is hungry";
			if(targetPoint=nil)
			{
				if(foodaddress != nil and !see_new_stuff){
				//write "HELLOOOO1111";
				targetPoint <- foodaddress;
				}
				
				else{
					if(foodaddress!=nil)
					{
				write self.name + "go through infoCenter, but we have adress in memory---------------------<";
				}			
				targetPoint <- any_location_in(one_of(InformationCenter));
				}           
			}
			}
		}
		
		if(is_thirsty and drink = 0){
		if(!is_hungry){
		//write self.name + "is thirsty";
		if(targetPoint=nil)
		{
			if(drinkaddress != nil and !see_new_stuff){
				//write "HELLOOOO22222";
				targetPoint <- drinkaddress;
				}
				else{
					if(drinkaddress!=nil)
					{
				write self.name + "go through infoCenter, but we have adress in memory---------------------<";
				}			
			targetPoint <- any_location_in(one_of(InformationCenter));   
			} 
			//write self.name + "sets targetpoint to "+targetPoint;
			
			//self.targetPoint <- any_location_in (one_of(rats);
		}
		}
		}
		
		if(is_thirsty and drink != 0){
		//write self.name + "is thirsty";
		if(targetPoint=nil)
		{
			//targetPoint <- any_location_in(one_of(InformationCenter));    
			drink <- drink-1;
			//write self.name + "sets targetpoint to "+targetPoint;
			
			//self.targetPoint <- any_location_in (one_of(rats);
		}
		}
	}
	
	reflex askAgents when: !empty(FestivalGuest at_distance other_agents_range){
		
		
		ask FestivalGuest at_distance other_agents_range{
			
			
			//
			//
			if(self.foodaddress != nil and myself.foodaddress = nil and myself.is_hungry){
				write myself.name+" gets food adress from other agent"+self.foodaddress;
				myself.foodaddress <- self.foodaddress;
			}
			if(self.drinkaddress != nil and myself.drinkaddress = nil and myself.is_thirsty){
			  write myself.name+" gets drink adress from other agent"+self.drinkaddress;
			  myself.drinkaddress <- self.drinkaddress;
			}
		}
	}
	
	
	//Is done directly when getting a new location
	reflex moveToTarget when: targetPoint != nil
	{
		if(!calculateDistanceOnce)
		{
		calculateDistanceOnce <- true;
		
		//If we go by memory brain		
		if((is_hungry or is_thirsty) and targetPoint!=any_location_in(one_of(InformationCenter) ))
		{
		
		distance_counter_with_brain <- distance_counter_with_brain + distance_to(self,targetPoint);
		
		}
		//If not by memory but through info center
		else{
		distance_counter_without_brain <- distance_counter_without_brain + distance_to(self,targetPoint);
			
		}
		
		}
		
				do goto target:targetPoint;
		
		
	}
	

	
	aspect base {
		draw cube(5) color: (is_hungry) ? #blue : ((is_thirsty) ? #red : #orange);
		//draw cube(5) color: (is_hungry) ? #blue : #orange;
	}
	
	
	
	reflex enterFoodStore when: !empty(FoodStore at_distance 3){
		
			if(self.is_hungry and !is_thirsty){
			ask FoodStore  {	
			myself.food <- 5;
		    myself.myaddress <- any_location_in(one_of(FoodStore));
			myself.is_hungry <- false;
			myself.targetPoint <- myself.initPoint;
			}
			self.foodaddress <- myaddress;
			}
			
            if(self.is_hungry and self.is_thirsty){
            ask FoodStore{
            myself.food <- 5;	
            myself.myaddress <- any_location_in(one_of(FoodStore));
            myself.is_hungry <- false;
            }
            self.foodaddress <- myaddress;
            self.targetPoint <- any_location_in(one_of(DrinkStore));
            }       
	}
	
	
		reflex enterDrinkStore when: !empty(DrinkStore at_distance 3){
		
		  if(self.is_thirsty and !is_hungry){
			ask DrinkStore  {
			myself.drink <- 5;
			myself.myaddress2 <- any_location_in(one_of(DrinkStore));
			myself.is_thirsty <- false;
			myself.targetPoint <- myself.initPoint;
			}
			self.drinkaddress <- myaddress2;
			}
			  if(is_hungry and is_thirsty){
            ask DrinkStore{
            myself.drink <- 5;	
            myself.myaddress2 <- any_location_in(one_of(DrinkStore));
            myself.is_thirsty<- false;
            }
            self.drinkaddress <- myaddress2;
            targetPoint <- any_location_in(one_of(FoodStore));
            } 
		
	}
	
		reflex setRandomPointToNil when: distance_to(self,initPoint)<1{
			if (targetPoint=initPoint)
			{
			//write self.name + "At initpoint";
			write self.name + "Distance with brain: " + distance_counter_with_brain;
			write self.name + "Distance WITHOUT brain: " + distance_counter_without_brain;
						
			self.targetPoint <- nil;
			self.calculateDistanceOnce <- false;
			self.infoCenterCalculateDistanceOnce<-false;
			
			}
		}
	
	
		
}


species InformationCenter{
	
	float info_range <- 0.01; 
	int dummy3 <- 0;
	point dummy1 <- nil;
	point dummy2 <- nil;
	reflex redirect when: !empty(FestivalGuest)  {
		
		
			ask FestivalGuest at_distance info_range  {
			
			if(self.is_hungry and !is_thirsty ){
			write myself.name + "Welcome to the center. Are you hungry or thirsty?";
				write self.name + "I am hungry";			
				myself.dummy1 <- any_location_in(one_of(FoodStore));
				self.targetPoint <- any_location_in(one_of(FoodStore));
				if(!self.infoCenterCalculateDistanceOnce)
				{
					self.infoCenterCalculateDistanceOnce<-false;
					self.distance_counter_without_brain <- self.distance_counter_without_brain+distance_to(self,targetPoint);
					
				}
				
			}
			
				if(self.is_thirsty and !is_hungry ){
				write self.name + "I am thirsty";
				myself.dummy2 <- any_location_in(one_of(DrinkStore)); 				
				self.targetPoint <- any_location_in(one_of(DrinkStore));
								if(!self.infoCenterCalculateDistanceOnce)
				{
					self.infoCenterCalculateDistanceOnce<-false;
					self.distance_counter_without_brain <- self.distance_counter_without_brain+distance_to(self,targetPoint);
					
				}
				
			}
			
		 	if(self.is_thirsty and self.is_hungry){
				if(self.is_hungry){
				//point testpoint1 <- 
				myself.dummy1 <- any_location_in(one_of(FoodStore));
				self.targetPoint <- any_location_in(one_of(FoodStore));
								if(!self.infoCenterCalculateDistanceOnce)
				{
					self.infoCenterCalculateDistanceOnce<-false;
					self.distance_counter_without_brain <- self.distance_counter_without_brain+distance_to(self,targetPoint);
					
				}
				
				//break;
				}
				if(self.is_thirsty){
				//point testpoint2 <- 				
				myself.dummy2 <- any_location_in(one_of(DrinkStore));
				self.myaddress2 <- any_location_in(one_of(DrinkStore));	
								if(!self.infoCenterCalculateDistanceOnce)
				{
					self.infoCenterCalculateDistanceOnce<-false;
					self.distance_counter_without_brain <- self.distance_counter_without_brain+distance_to(self,targetPoint);
					
				}
				
				}
				
				
				
			}
		
	}
	
	}
	 
	
		aspect base {
		draw pyramid(8) color: #yellow depth:10;
	}
	
	}

species FoodStore{
	int info_range <- 3; //ask if smaller or equal	
	int totalfood <- 50;
	
	
		aspect base {
		draw rectangle(10,5) color: #purple depth:5;
	}
	
	
}

species DrinkStore{
	int info_range <- 3; //ask if smaller or equal	
 	int totaldrinks <- 50;
 	
	
		aspect base {
		draw rectangle(10,5) color: #green depth:5;
	}
	
	
}
experiment my_experiment type:gui {
	parameter "number of people:" var: number_of_people;
	parameter "number of information centers:" var: number_of_informationcenters;
	output {
		display my_display type:opengl {
			species FestivalGuest aspect:base;
			species InformationCenter aspect:base;	
			species FoodStore aspect:base;	
			species DrinkStore aspect:base;		
				
		}
	}
}



