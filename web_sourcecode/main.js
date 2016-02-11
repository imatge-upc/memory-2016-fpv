// JavaScript Document

angular.module('Challenge', [])
  .controller('MainController', function($scope, $interval) {
	 	$scope.images = [];
		$scope.targets = [];
		$scope.fillers = [];
		//$scope.line = new Array(5);
		$scope.line = [];
		
		$scope.main_control = [];
	 
	 $scope.openFile = function() {
		
		
		//Array for detected images
		$scope.detection;
		$scope.count = 0;
		
		$scope.j = 0;
		
		var rawFileTargets = new XMLHttpRequest();    
    	rawFileTargets.open("GET", "http://0.0.0.0:8000/targets_resize.txt", true);
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
						//$scope.main_control[i]=new Array(5);
						//$scope.main_control[i]=$scope.line;
						//console.log($scope.main_control[i] + " " + i);
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
    	rawFileFillers.open("GET", "http://0.0.0.0:8000/fillers_resize.txt", true);
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
	
		//$scope.image = $scope.images[0];
	
		$scope.currentImageIndex = 0;
		
		//$scope.target = 0;
			
		$scope.busy=0;
		$scope.restF=0;
		
		$scope.finded;
		$scope.randomT;
		$scope.cc;
		
		$scope.timer = $interval(function() {
				
		  	$scope.currentImageIndex++;
			
			//Stop this timer in 4:30 -> 250 images
			if($scope.currentImageIndex==250){
				$interval.cancel($scope.timer);
				$scope.timer = undefined;
				console.log('Timer has been stopped');
				
				//Prepare data to save
				for(var vv=0; vv<$scope.main_control.length; vv++){
					$scope.main_control[vv][4]=$scope.main_control[vv][4] + '\n';
				}
				
				var blob = new Blob($scope.main_control, {
					type: "text/plain;charset=utf-8"
				});
				
				saveAs(blob, "results.txt");
				console.log("Saved!");
				
				alert("Timeout! Text file downloaded. Please send it! Thanks.");
			} 
			
			if($scope.busy==0){
				var randomF = Math.floor(Math.random()*10);
				$scope.restF=randomF;
				$scope.busy=1;
			}else{
				$scope.restF=$scope.restF-1;
				}
			
			//Show fillers
			if($scope.restF!=0){
				$scope.random_frame = Math.floor(Math.random()*$scope.num_fillers);	 
				$scope.image=$scope.fillers[$scope.random_frame];
				console.log("filler " + $scope.fillers[$scope.random_frame]);
				//console.log($scope.restF);	
			}else{
				$scope.busy=0; //Perquè es puguin tornar a calcular
				//Show targets
				//Run into de list
				$scope.finded = 0;
				$scope.cc = 0;
				//console.log($scope.main_control[0][0]);
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
							//console.log("not found");
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
			
			var blob = new Blob($scope.main_control, {
				type: "text/plain;charset=utf-8"
			});
			
			saveAs(blob, "results.txt");
			console.log("Saved!");
			
			alert("Time stopped! Text file downloaded. Please NOT send it! Thanks.");
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
				
				//Cercar a la matriu de control
				var found=0;
				var control_len=0
				while(found==0 && control_len<$scope.main_control.length){
					if($scope.main_control[control_len][0]==$scope.detection && $scope.main_control[control_len][3]!=0){
						$scope.main_control[control_len][4]=1;
						found=1;
					}
					else{
						control_len++;
					}
				}
				
			}
			//Ens hem de quedar amb el nom de la imatge
		}
		else if(e){
			keyCode=e.which;
		}
		}
});