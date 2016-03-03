// JavaScript Document

angular.module('Challenge', [])
  .controller('MainController', function($scope, $interval) {
	 	$scope.images = [];
		$scope.targets = [];
		$scope.fillers = [];
		$scope.line = [];
		$scope.filler_trig = [];
		
		$scope.main_control = [];
		$scope.main_vigilance = [];
	 
	 $scope.openFile = function() {
		
		$scope.valor = document.getElementById("opcio").value;
		
		//console.log($scope.valor);
		//Array for detected images
		$scope.detection;
		$scope.count = 0;
		
		$scope.j = 0;
		
		$scope.num_vig = 0;
		
		var rawFileTargets = new XMLHttpRequest();    
    	//rawFileTargets.open("GET", "http://0.0.0.0:8000/Targets/targets_" + $scope.valor + ".txt", true);
		rawFileTargets.open("GET", "targets.txt", true);
   		rawFileTargets.onreadystatechange = function() {
      		if (rawFileTargets.readyState === 4) {
        		if (rawFileTargets.status === 200 || rawFileTargets.status == 0) {
					lines = rawFileTargets.responseText.split("\n");
          			for (var i = 0; i < lines.length-1; i++) {
						$scope.targets[i] = lines[i]; 
						$scope.images[$scope.j] = lines[$scope.j];
						$scope.j=$scope.j+1;
						//Inicialize each line of the control array
						$scope.line[0]=lines[i];
						$scope.line[1]=0;
						$scope.line[2]=0;
						$scope.line[3]=0;
						$scope.line[4]=0;
          			}
					$scope.num_targets = i;
					
					for(var mm = 0; mm<$scope.num_targets;mm++){
						$scope.main_control[mm]=[$scope.targets[mm],0,0,0,0];
					}
        		}
      		}
    	}
		rawFileTargets.send(null);
		
		var rawFileFillers = new XMLHttpRequest();    
    	//rawFileFillers.open("GET", "http://0.0.0.0:8000/Fillers/fillers_" + $scope.valor + ".txt", true);
		rawFileFillers.open("GET", "fillers/fillers.txt", true);
   		rawFileFillers.onreadystatechange = function() {
      		if (rawFileFillers.readyState === 4) {
        		if (rawFileFillers.status === 200 || rawFileFillers.status == 0) {
					lines = rawFileFillers.responseText.split("\n");
          			for (var k = 0; k < lines.length-1; k++) {
						$scope.fillers[k] = lines[k]; 
						$scope.images[$scope.j] = lines[k];
						$scope.j=$scope.j+1;
          			}
					$scope.num_fillers = k;        
        		}
      		}
    	}  
		rawFileFillers.send(null);
	
		$scope.currentImageIndex = 0;
			
		$scope.busy=0;
		$scope.restF=0;
		
		$scope.finded;
		$scope.randomT;
		$scope.cc;
		
		$scope.iter = 1;
		
		$scope.timer = $interval(function() {
			
			if($scope.boolea==0){
				$scope.image='blank.jpg';
				$scope.boolea=1;
			}
			else {
					
		  	$scope.currentImageIndex++;
			
			//Stop this timer in 4:30 -> 250 images
			if($scope.currentImageIndex==200){
				$interval.cancel($scope.timer);
				$scope.timer = undefined;
				console.log('Timer has been stopped');
				alert("Timeout! Text file downloaded. Please send it! Thanks.");
				
				//Prepare data to save
				for(var vv=0; vv<$scope.main_control.length; vv++){
					$scope.main_control[vv][4]=$scope.main_control[vv][4] + '\n';
				}
				
				var count_pos=0;
				var count_neg=0;
				//Compute vigilance error
				for(var tt=0; tt<$scope.main_vigilance.length; tt++){
					if($scope.main_vigilance[tt][1]==0){
						count_neg++;
					}else{
						count_pos++;
					}
				}
				
				var extra_line = [];
				extra_line[0]=$scope.main_vigilance.length;
				extra_line[1]=count_pos;
				extra_line[2]=count_neg;
				extra_line[3]=count_pos/$scope.main_vigilance.length;
				
				if(extra_line[3]<0.5){
					extra_line[4]=0; //Not valid results
				}else{
					extra_line[4]=1;
				}
				
				//Add statistics
				$scope.main_control[$scope.main_control.length]=extra_line;
				//console.log(extra_line);
				
				var blob = new Blob($scope.main_control, {
					type: "text/plain;charset=utf-8"
				});
				
				var date = new Date();
				
				var hour = date.getHours();
				var minute = date.getMinutes();
				var second = date.getSeconds();
				var year = date.getFullYear();
				var month = date.getMonth()+1;
				var day = date.getDate();
				
				var aux_hour, aux_minute, aux_second, aux_month, aux_day;
				
				if(hour<10){
					aux_hour=0;
				}else{aux_hour="";}
				if(minute<10){
					aux_minute=0;
				}else{aux_minute="";}
				if(second<10){
					aux_second=0;
				}else{aux_second=""}
				if(month<10){
					aux_month=0;
				}else{aux_month=""}
				if(day<10){
					aux_day=0;
				}else{aux_day=""}
				
				saveAs(blob, "results_targets_"+$scope.valor+"_"+year+aux_month+month+aux_day+day+"_"+aux_hour+hour+aux_minute+minute+aux_second+second+".txt" );
				console.log("Saved!");
			} 
			
			if($scope.busy==0){
				var randomF = Math.floor(Math.random()*4);
				$scope.restF=randomF;
				$scope.busy=1;
			}else{
				$scope.restF=$scope.restF-1;
				}
			
			//Show fillers
			if($scope.restF!=0){
				$scope.random_frame = Math.floor(Math.random()*$scope.num_fillers);	 
				//console.log($scope.random_frame);
				//console.log("filler " + $scope.fillers[$scope.random_frame]);	
				//Fill the row of vigilance table
				if($scope.restF==randomF && $scope.iter%2!=0){
					$scope.image=$scope.fillers[$scope.random_frame];
					$scope.filler_trig[0]=$scope.image;
					$scope.filler_trig[1]=0; //Detection
					$scope.main_vigilance[$scope.num_vig]=$scope.filler_trig;
					console.log("VIGILANCE filler: " + $scope.image);	
				}else if($scope.restF==randomF && $scope.iter%2==0){
					$scope.image=$scope.main_vigilance[$scope.num_vig][0];
					$scope.num_vig++;
					console.log("REPEAT VIGILANCE filler: " + $scope.image);	
				}else{
					$scope.image=$scope.fillers[$scope.random_frame];
					console.log("filler " + $scope.image);	
				}
				
				if($scope.restF==1){
					$scope.iter++;
				}
				
			}else{
				$scope.busy=0; //Perquè es puguin tornar a calcular
				//Show targets
				//Run into de list
				$scope.finded = 0;
				$scope.cc = 0;
				//Find for an image that has not appeared in almost 50 last positions
				while($scope.finded==0 && $scope.cc<$scope.num_targets){
					if(($scope.main_control[$scope.cc][1]==1) && (($scope.currentImageIndex-$scope.main_control[$scope.cc][2])>=40) && ($scope.main_control[$scope.cc][3]==0)){
						$scope.image=$scope.main_control[$scope.cc][0];
						$scope.main_control[$scope.cc][3]=$scope.currentImageIndex;
						$scope.finded=1;
						console.log("Finded critical: " + $scope.image);
					}else{
						$scope.cc=$scope.cc+1;
					}
				}
				
				if($scope.finded==0){
					$scope.cc=0;
					while($scope.finded==0 && $scope.cc<10){
						$scope.randomT = Math.floor(Math.random()*$scope.num_targets);
						
						if($scope.main_control[$scope.randomT][1]==0){
							$scope.image=$scope.main_control[$scope.randomT][0]; //Show this target
							$scope.main_control[$scope.randomT][1]=1;
							$scope.main_control[$scope.randomT][2]=$scope.currentImageIndex;
							console.log("not found critical: " + "1st selection random" + $scope.randomT + " " + $scope.main_control[$scope.randomT]);
							
							$scope.finded=1;
						}else if($scope.main_control[$scope.randomT][1]==1 && ($scope.currentImageIndex-$scope.main_control[$scope.randomT][2])>=8 && $scope.main_control[$scope.randomT][3]==0){
								$scope.image=$scope.main_control[$scope.randomT][0]; //Show this target
								$scope.main_control[$scope.randomT][3]=$scope.currentImageIndex;
								console.log("not found critical:  " + "2nd repetition random: " + $scope.randomT + " " + $scope.main_control[$scope.randomT]);
								$scope.finded=1;			
							}else{
								$scope.finded=1;
								for(var rr=1; rr<$scope.main_control.length; rr++){
									if($scope.main_control[rr][4]==0){
										$scope.finded=0;
									}
								}
							}
							$scope.cc=$scope.cc+1;
						} //tanca while
				}//tanca 119
			}	//tanca 101	
			$scope.boolea=0;
			}
			}, 1400);//tanca 76	
	 }
	 
	 $scope.killTimer = function() {
		  if (angular.isDefined($scope.timer)) {
			$interval.cancel($scope.timer);
			$scope.timer = undefined;
			console.log('Timer has been stopped');
			//Prepare data to save
			for(var vv=0; vv<$scope.main_control.length; vv++){
				$scope.main_control[vv][4]=$scope.main_control[vv][4] + '\n';
			}
			
			var count_pos=0;
			var count_neg=0;
			//Compute vigilance error
			for(var tt=0; tt<$scope.main_vigilance.length; tt++){
				if($scope.main_vigilance[tt][1]==0){
					count_neg++;
				}else{
					count_pos++;
				}
			}
			
			var extra_line = [];
			extra_line[0]=$scope.main_vigilance.length;
			extra_line[1]=count_pos;
			extra_line[2]=count_neg;
			extra_line[3]=count_pos/$scope.main_vigilance.length;
			
			if(extra_line[3]<0.75){
				extra_line[4]=0; //Not valid results
			}else{
				extra_line[4]=1;
			}
			
			//Add statistics
			$scope.main_control[$scope.main_control.length]=extra_line;
			console.log(extra_line);
			
			var blob = new Blob($scope.main_control, {
				type: "text/plain;charset=utf-8"
			});
			
			var date = new Date();
			
			var hour = date.getHours();
			var minute = date.getMinutes();
			var second = date.getSeconds();
			var year = date.getFullYear();
			var month = date.getMonth()+1;
			var day = date.getDate();
			
			var aux_hour, aux_minute, aux_second, aux_month, aux_day;
			
			if(hour<10){
				aux_hour=0;
			}else{aux_hour="";}
			if(minute<10){
				aux_minute=0;
			}else{aux_minute="";}
			if(second<10){
				aux_second=0;
			}else{aux_second=""}
			if(month<10){
				aux_month=0;
			}else{aux_month=""}
			if(day<10){
				aux_day=0;
			}else{aux_day=""}
			
			saveAs(blob, "results_"+year+aux_month+month+aux_day+day+"_"+aux_hour+hour+aux_minute+minute+aux_second+second+".txt" );
			console.log("Saved!");
			
			alert("Time stopped! Text file downloaded. Please do NOT send it! Thanks.");
		  }
		}
	
	$scope.tecla = function(event){
		var keyCode
		if(window.event){
			keyCode=window.event.keyCode;
			if(keyCode==100){
				console.log("Pressed 'd' !");
				//Quan hem pulsat la tecla d
				$scope.detection=$scope.image;
				
				//Cercar a la matriu de control de targets
				var found=0;
				var control_len=0;
				var vigilance_len=0;
				while(found==0 && control_len<$scope.main_control.length){
					if($scope.main_control[control_len][0]==$scope.detection && $scope.main_control[control_len][3]!=0){
						$scope.main_control[control_len][4]=1;
						found=1;
					}
					else{
						control_len++;
					}
				}
				
				while(found==0 && vigilance_len<$scope.main_vigilance.length){
					if($scope.main_vigilance[vigilance_len][0]==$scope.detection){
						$scope.main_vigilance[vigilance_len][1]=1; //Detected
						found=1;
					}
					else{
						vigilance_len++;
					}
				} 
					
			}
		}
		else if(e){
			keyCode=e.which;
		}
		}
});