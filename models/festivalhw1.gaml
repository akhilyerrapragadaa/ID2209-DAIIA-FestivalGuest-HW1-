/***
* Name: modelhomework1
* Author: Gunnar
* Description: 
* Tags: Tag1, Tag2, TagN
***/

model festivalhw1


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
	float distance_counter <- 0.0; 
	point initPoint <- {(rnd(0,100)),(rnd(0,100)),0};
	
	point targetPoint <- nil;
	
	reflex beIdle when: targetPoint = nil {
		//write self.name + "distance: "+distance_to(self,initPoint);
		
		if(!is_hungry or !is_thirsty)
		{
			write self.name + "says wander";
			self.is_hungry <- flip(hungryProbability);
			if(!is_hungry)
			{
				self.is_thirsty <- flip(thirstyProbability);
			}
			
	    if(food != 0){
	    food <- food-1;	
	    }
	    if(drink != 0){
	    drink <- drink-1;	
	    }
	    
	    write "Food!"+ self.name + food;
	    write "Drink!"+ self.name + drink;
		do wander;
		 
		}
		
		
		if(is_hungry and food = 0){
		write self.name + "is hungry";
			if(targetPoint=nil)
			{
				targetPoint <- any_location_in(one_of(InformationCenter));                
				//write self.name + "sets targetpoint to "+targetPoint;
				
				//self.targetPoint <- any_location_in (one_of(rats);
			}
		}
		
		if(is_thirsty and !is_hungry and drink = 0){
		write self.name + "is thirsty";
		if(targetPoint=nil)
		{
			targetPoint <- any_location_in(one_of(InformationCenter));    
			//write self.name + "sets targetpoint to "+targetPoint;
			
			//self.targetPoint <- any_location_in (one_of(rats);
		}
		}
		
	}
	
	reflex moveToTarget when: targetPoint != nil
	{
		distance_counter <- distance_counter + distance_to(self,targetPoint);
		write self.name + "moveToTarget function:"+distance_counter;
		do goto target:targetPoint;
	}
	

	
	aspect base {
		draw cube(5) color: (is_hungry) ? #blue : ((is_thirsty) ? #red : #orange);
	}
	
	
	
	reflex enterFoodStore when: !empty(FoodStore at_distance 3){
		
			ask FoodStore  {
				
				if(myself.is_hungry)
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

			
			
			if(!self.is_hungry){
				//do goto target:{(rnd(0,100))/100,(rnd(0,100))/100,0};   
				
				//do goto target:{30,55,0};                     
			}
			
		
	}
	
		reflex enterDrinkStore when: !empty(DrinkStore at_distance 3){
		
			ask DrinkStore  {
			//self = FestivalGuest
			//myself = Store
			write self.name + "Welcome to the Drinkstore?";
			write myself.name + "I am Thirsty";
			write self.name + "Here you get some drinks.";
			myself.is_thirsty <- false;
			myself.drink <- 5;
			myself.targetPoint <- myself.initPoint;
			
			
			}
			
			if(!self.is_thirsty){
				//do goto target:{(rnd(0,100))/100,(rnd(0,100))/100,0};    
				//do goto target:{30,55,0};                     
				        
			}
			
						
			
		
	}
	 	//point test <- {2,3,0};
	
		reflex setRandomPointToNil when: distance_to(self,initPoint)<1{
			write self.name + "At initpoint";
			self.targetPoint <- nil;
		}
	
	
		
}

species InformationCenter{
	//bool is_infected <- flip(0.5);
	int info_range <- 3; //ask if smaller or equal	
		

	//at distance returns a list of people
	reflex redirect when: !empty(FestivalGuest at_distance info_range){
		ask FestivalGuest at_distance info_range {
			//self = FestivalGuest
			//myself = InformationCenter
			write myself.name + "Welcome to the center. Are you hungry or thirsty?";
			
			if (self.is_hungry){
				write self.name + "I am hungry";
				point testpoint2 <- any_location_in(one_of(FoodStore));				
				self.targetPoint <- testpoint2;
				write myself.name + "Okay "+self.name+" "+"Then you should go to "+" "+testpoint2;
			}
			
				if (self.is_thirsty){
				write self.name + "I am thirsty";
				point testpoint2 <- any_location_in(one_of(DrinkStore));				
				self.targetPoint <- testpoint2;
				write myself.name + "Okay "+self.name+" "+"Then you should go to "+" "+testpoint2;
			}
		}
	} 
	
		aspect base {
		//draw circle(1) color: (is_infected) ? #red : #green depth:5;
		draw pyramid(8) color: #yellow depth:10;
	}
	
	
}

species FoodStore{
	int info_range <- 3; //ask if smaller or equal	
	int totalfood <- 50;
	//bool food_store <- flip(0.5); //should be flip later
	//bool drink_store <- !food_store ? true : false;
 
	
		aspect base {
		draw rectangle(10,5) color: #purple depth:5;
	}
	
	
}

species DrinkStore{
	int info_range <- 3; //ask if smaller or equal	
	//bool food_store <- flip(0.5); //should be flip later
	//bool drink_store <- !food_store ? true : false;
 	int totaldrinks <- 50;
 	
	
		aspect base {
		draw rectangle(10,5) color: #green depth:5;
	}
	
	
}

//define species that will populate our world
//inputs and outputs of our simulation

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
		/*display my_chart {
			chart "number_of_infected_people"{
				data "infected people" value: length (people where (each.is_infected = true));
			}
		}*/
	}
}
