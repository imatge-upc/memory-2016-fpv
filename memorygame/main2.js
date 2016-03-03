angular.module('Challenge', [])
  .controller('MainController', function($scope, $interval) {
	
	 $scope.openFile = function() {
		var input = new String(list_files.txt);
		
		$scope.images = [];
		
		var reader = new FileReader();
		reader.onload = function(){
			$scope.text = reader.result;
			lines = $scope.text.split("\n");
			//$scope.images = text.split("\n");
			for (i = 0; i < $scope.lines.length; i++) { 
    			$scope.images[i] = $scope.lines[i];
			}
			
		}
		
		reader.readAsText(input);
		
		$scope.lines = $scope.text.split("\n");
		//$scope.images = text.split("\n");
		for (i = 0; i < $scope.lines.length; i++) { 
			$scope.images[i] = $scope.lines[i];
		}
		
		// READ ALL LINES OF TXT THAT CONTAINS THE IMAGES
		/*$scope.images[0] = "1.png";
		$scope.images[1] = "2.png";
		$scope.images[2] = "3.png";*/
	
		$scope.images=["1.png", "2.png", "3.png"];
	
		//$scope.image = lines[0];
		$scope.image = $scope.images[0];
	
		$scope.currentImageIndex = 0;
		
		$scope.timer = $interval(function() {
		  $scope.currentImageIndex++;
		  $scope.image = $scope.images[$scope.currentImageIndex % 3];
		}, 1000);
		
		$scope.killTimer = function() {
		  if (angular.isDefined($scope.timer)) {
			$interval.cancel($scope.timer);
			$scope.timer = undefined;
			console.log('Timer has been stopped');
		  }
		
   };*/
	
});