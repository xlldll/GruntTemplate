/*indexCfg跟index.js同级目录*/
/*controller*/
require( [ 'indexCfg' ],function() {
	require( [ 'main-call','knockout' ] );
	requirejs( [ 'app' ],function( app ) {
		app.hello();
	} );
	/*定义了一个angularjs自己的模块 myApp ，以及相应的 MyController 。在后面，通过 angular.bootstrap 方法，把该模块与 document 结合在了一起*/
	require( [ 'angular' ],function( angular ) {
		angular.module( 'myApp',[] )
		       .controller( 'MyController',[ '$scope',function( $scope ) {
			       $scope.name = 'Change the name';
		       } ] );
		angular.element( document ).ready( function() {
			angular.bootstrap( document,[ 'myApp' ] );
		} );
	} );
} );

